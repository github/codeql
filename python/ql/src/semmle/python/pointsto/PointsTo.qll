import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.Filters
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO
private import semmle.python.types.Builtins
private import semmle.python.types.Extensions

/* Use this version for speed */
//library class CfgOrigin extends @py_object {
//
//    string toString() {
//        /* Not to be displayed */
//        none()
//    }
//
//    /** Get a `ControlFlowNode` from `this` or `here`.
//     * If `this` is a ControlFlowNode then use that, otherwise fall back on `here`
//     */
//    pragma[inline]
//    ControlFlowNode asCfgNodeOrHere(ControlFlowNode here) {
//        result = this
//        or
//        not this instanceof ControlFlowNode and result = here
//    }
//
//    ControlFlowNode toCfgNode() {
//        result = this
//    }
//
//    pragma[inline]
//    CfgOrigin fix(ControlFlowNode here) {
//        if this = Builtin::unknown() then
//            result = here
//        else
//            result = this
//    }
//
//}
//
//module CfgOrigin {
//
//    CfgOrigin fromCfgNode(ControlFlowNode f) {
//        result = f
//    }
//
//    CfgOrigin unknown() {
//        result = Builtin::unknown()
//    }
//
//    CfgOrigin fromObject(ObjectInternal obj) {
//        obj.isBuiltin() and result = unknown()
//        or
//        result = obj.getOrigin()
//    }
//
//}

/* Use this version for stronger type-checking */
private newtype TCfgOrigin =
    TUnknownOrigin()
    or
    TFlowNodeOrigin(ControlFlowNode f)

library class CfgOrigin extends TCfgOrigin {

    string toString() {
        /* Not to be displayed */
        none()
    }

    /** Get a `ControlFlowNode` from `this` or `here`.
     * If `this` is a ControlFlowNode then use that, otherwise fall back on `here`
     */
    pragma[inline]
    ControlFlowNode asCfgNodeOrHere(ControlFlowNode here) {
        this = TUnknownOrigin() and result = here
        or
        this = TFlowNodeOrigin(result)
    }

    ControlFlowNode toCfgNode() {
        this = TFlowNodeOrigin(result)
    }

    pragma[inline]
    CfgOrigin fix(ControlFlowNode here) {
        this = TUnknownOrigin() and result = TFlowNodeOrigin(here)
        or
        not this = TUnknownOrigin() and result = this
    }

}

module CfgOrigin {

    CfgOrigin fromCfgNode(ControlFlowNode f) {
        result = TFlowNodeOrigin(f)
    }

    CfgOrigin unknown() {
        result = TUnknownOrigin()
    }

    CfgOrigin fromObject(ObjectInternal obj) {
        obj.isBuiltin() and result = unknown()
        or
        result = fromCfgNode(obj.getOrigin())
    }

}

/* The API */
module PointsTo {

    predicate pointsTo(ControlFlowNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        PointsToInternal::pointsTo(f, context, value, origin)
    }

    predicate variablePointsTo(EssaVariable var, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        PointsToInternal::variablePointsTo(var, context, value, origin)
    }

    /* Backwards compatibility */
    deprecated predicate
    points_to(ControlFlowNode f, PointsToContext context, Object obj, ClassObject cls, ControlFlowNode origin) {
        exists(ObjectInternal value |
            PointsToInternal::pointsTo(f, context, value, origin) and
            cls = value.getClass().getSource() |
            obj = value.getSource() or
            not exists(value.getSource()) and obj = origin
        )
        or
        /* Backwards compatibility for *args and **kwargs */
        exists(Function func |
            obj = f and origin = f and context.isRuntime() |
            func.getVararg() = f.getNode() and cls = theTupleType() or
            func.getKwarg() = f.getNode() and cls = theDictType()
        )
        or
        not f.isParameter() and
        exists(Value value |
            PointsToInternal::pointsTo(f.(DefinitionNode).getValue(), context, value, origin) and
            cls = value.getClass().getSource() |
            obj = value.getSource() or
            not exists(value.getSource()) and obj = origin
        )
    }

    deprecated predicate
    ssa_variable_points_to(EssaVariable var, PointsToContext context, Object obj, ClassObject cls, CfgOrigin origin) {
        exists(Value value |
            PointsToInternal::variablePointsTo(var, context, value, origin) and
            cls = value.getClass().getSource() |
            obj = value.getSource()
        )
    }

    deprecated
    CallNode get_a_call(Object func, PointsToContext context) {
        exists(Value value |
            result = value.getACall(context) and
            func = value.getSource()
        )
    }

}

cached module PointsToInternal {

    /** INTERNAL -- Use `f.refersTo(value, origin)` instead. */
    cached predicate pointsTo(ControlFlowNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        points_to_candidate(f, context, value, origin) and
        reachableBlock(f.getBasicBlock(), context)
    }

    cached predicate pointsToString(ControlFlowNode f, PointsToContext context, string value) {
        exists(ObjectInternal str |
            PointsToInternal::pointsTo(f, context, str, _) and
            str.strValue() = value
        )
    }

    private predicate points_to_candidate(ControlFlowNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        use_points_to(f, context, value, origin)
        or
        attribute_load_points_to(f, context, value, origin)
        or
        Expressions::pointsTo(f, context, value, origin, _, _)
        or
        if_exp_points_to(f, context, value, origin)
        or
        origin = f and value.introduced(f, context)
        or
        InterModulePointsTo::import_points_to(f, context, value, origin)
        or
        InterModulePointsTo::from_import_points_to(f, context, value, origin)
        or
        InterProceduralPointsTo::call_points_to(f, context, value, origin)
        or
        AttributePointsTo::pointsTo(f, context, value, origin)
        or
        f.(PointsToExtension).pointsTo(context, value, origin)
    }

    /** Holds if the attribute `name` is required for `obj` */
    cached predicate attributeRequired(ObjectInternal obj, string name) {
        pointsTo(any(AttrNode a).getObject(name), _, obj, _)
        or
        Expressions::getattr_call(_, _, _, obj, name)
    }

    /* Holds if BasicBlock `b` is reachable, given the context `context`. */
    cached predicate reachableBlock(BasicBlock b, PointsToContext context) {
        context.appliesToScope(b.getScope()) and not exists(ConditionBlock guard | guard.controls(b, _))
        or
        exists(ConditionBlock guard |
            guard = b.getImmediatelyControllingBlock() and
            reachableBlock(guard, context)
            |
            allowsFlow(guard, b, context)
            or
            /* Assume the true edge of an assert is reachable (except for assert 0/False) */
            guard.controls(b, true) and
            exists(Assert a, Expr test |
                a.getTest() = test and
                guard.getLastNode().getNode() = test and
                not test instanceof ImmutableLiteral
            )
        )
    }

    pragma [noopt]
    private predicate allowsFlow(ConditionBlock guard, BasicBlock b, PointsToContext context) {
        exists(ObjectInternal value, boolean sense, ControlFlowNode test |
            test = guard.getLastNode() and
            pointsTo(test, context, value, _) and
            sense = value.booleanValue() and
            guard.controls(b, sense)
        )
    }

    /* Holds if the edge `pred` -> `succ` is reachable, given the context `context`.
     */
    pragma [noopt]
    cached predicate controlledReachableEdge(BasicBlock pred, BasicBlock succ, PointsToContext context) {
        exists(ConditionBlock guard, ObjectInternal value, boolean sense, ControlFlowNode test |
            test = guard.getLastNode() and
            pointsTo(test, context, value, _) and
            sense = value.booleanValue() and
            guard.controlsEdge(pred, succ, sense)
        )
    }

    /** Gets an object pointed to by a use (of a variable). */
    pragma [noinline]
    private predicate use_points_to(NameNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(CfgOrigin origin_or_obj |
            value != ObjectInternal::undefined() and
            use_points_to_maybe_origin(f, context, value, origin_or_obj) |
            origin = origin_or_obj.asCfgNodeOrHere(f)
        )
    }

    pragma [noinline]
    private predicate use_points_to_maybe_origin(NameNode f, PointsToContext context, ObjectInternal value, CfgOrigin origin_or_obj) {
        variablePointsTo(fast_local_variable(f), context, value,  origin_or_obj)
        or
        name_lookup_points_to_maybe_origin(f, context, value, origin_or_obj)
        or
        not exists(fast_local_variable(f)) and not exists(name_local_variable(f)) and
        global_lookup_points_to_maybe_origin(f, context, value, origin_or_obj)
    }

    /** Holds if `var` refers to `(value, origin)` given the context `context`. */
    pragma [noinline]
    cached predicate variablePointsTo(EssaVariable var, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        ssa_definition_points_to(var.getDefinition(), context, value, origin)
        or
        exists(EssaVariable prev |
            ssaShortCut(prev, var) and
            variablePointsTo(prev, context, value, origin)
        )
    }

    private predicate ssaShortCut(EssaVariable start, EssaVariable end) {
        end.getDefinition().(PhiFunction).getShortCircuitInput() = start
        or
        /* Attribute assignments have no effect as far as value tracking is concerned, except for `__class__`. */
        exists(AttributeAssignment def |
            not def.getName() = "__class__" and
            start = def.getInput() and
            end.getDefinition() = def
        )
        or
        /* Ignore the effects of calls on their arguments. PointsTo is an approximation, 
         * but attempting to improve accuracy would be very expensive for very little gain. */
        exists(ArgumentRefinement def |
            start = def.getInput() and
            end.getDefinition() = def
        )
        or
        exists(EssaVariable mid |
            ssaShortCut(start, mid) and ssaShortCut(mid, end)
        )
    }

    pragma [noinline]
    private predicate name_lookup_points_to_maybe_origin(NameNode f, PointsToContext context, ObjectInternal value, CfgOrigin origin_or_obj) {
        exists(EssaVariable var | var = name_local_variable(f) |
            variablePointsTo(var, context, value, origin_or_obj)
        )
        or
        local_variable_undefined(f, context) and
        global_lookup_points_to_maybe_origin(f, context, value, origin_or_obj)
    }

    pragma [noinline]
    private predicate local_variable_undefined(NameNode f, PointsToContext context) {
        variablePointsTo(name_local_variable(f), context, ObjectInternal::undefined(), _)
    }

    pragma [noinline]
    private predicate global_lookup_points_to_maybe_origin(NameNode f, PointsToContext context, ObjectInternal value, CfgOrigin origin_or_obj) {
        variablePointsTo(global_variable(f), context, value, origin_or_obj)
        or
        exists(ControlFlowNode origin |
            origin_or_obj = CfgOrigin::fromCfgNode(origin)
            |
            variablePointsTo(global_variable(f), context, ObjectInternal::undefined(), _) and
            potential_builtin_points_to(f, value, origin)
            or
            not exists(global_variable(f)) and context.appliesToScope(f.getScope()) and
            potential_builtin_points_to(f, value, origin)
        )
    }

    /** The ESSA variable with fast-local lookup (LOAD_FAST bytecode). */
    private EssaVariable fast_local_variable(NameNode n) {
        n.isLoad() and
        result.getASourceUse() = n and
        result.getSourceVariable() instanceof FastLocalVariable
    }

    /** The ESSA variable with name-local lookup (LOAD_NAME bytecode). */
    private EssaVariable name_local_variable(NameNode n) {
        n.isLoad() and
        result.getASourceUse() = n and
        result.getSourceVariable() instanceof NameLocalVariable
    }

    /** The ESSA variable for the global variable lookup. */
    private EssaVariable global_variable(NameNode n) {
        n.isLoad() and
        result.getASourceUse() = n and
        result.getSourceVariable() instanceof GlobalVariable
    }

    /** Holds if `f` is an attribute `x.attr` and points to `(value, cls, origin)`. */
    pragma [noinline]
    private predicate attribute_load_points_to(AttrNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        none()
        // TO DO -- Support CustomPointsToAttribute
        //or
        //exists(CustomPointsToAttribute object, string name |
        //    pointsTo(f.getObject(name), context, object, _, _) and
        //    object.attributePointsTo(name, value, cls, origin)
        //)
    }

    /** Holds if the ESSA definition `def`  refers to `(value, origin)` given the context `context`. */
    private predicate ssa_definition_points_to(EssaDefinition def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        ssa_phi_points_to(def, context, value, origin)
        or
        exists(ControlFlowNode orig |
            ssa_node_definition_points_to(def, context, value, orig) and
            origin = CfgOrigin::fromCfgNode(orig)
        )
        or
        ssa_filter_definition_points_to(def, context, value, origin)
        or
        ssa_node_refinement_points_to(def, context, value, origin)
    }

    pragma [noinline]
    private predicate ssa_node_definition_points_to(EssaNodeDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        reachableBlock(def.getDefiningNode().getBasicBlock(), context) and
        ssa_node_definition_points_to_unpruned(def, context, value, origin)
    }

    pragma [nomagic]
    private predicate ssa_node_definition_points_to_unpruned(EssaNodeDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        InterProceduralPointsTo::parameter_points_to(def, context, value, origin)
        or
        assignment_points_to(def, context, value, origin)
        or
        self_parameter_points_to(def, context, value, origin)
        or
        delete_points_to(def, context, value, origin)
        or
        module_name_points_to(def, context, value, origin)
        or
        scope_entry_points_to(def, context, value, origin)
        or
        InterModulePointsTo::implicit_submodule_points_to(def, context, value, origin)
        or
        iteration_definition_points_to(def, context, value, origin)
        /*
         * No points-to for non-local function entry definitions yet.
         */
    }

    pragma [noinline]
    private predicate ssa_node_refinement_points_to(EssaNodeRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        method_callsite_points_to(def, context, value, origin)
        or
        InterModulePointsTo::import_star_points_to(def, context, value, origin)
        or
        attribute_assignment_points_to(def, context, value, origin)
        or
        InterProceduralPointsTo::callsite_points_to(def, context, value, origin)
        or
        attribute_delete_points_to(def, context, value, origin)
        or
        uni_edged_phi_points_to(def, context, value, origin)
    }

    /** Pass through for `self` for the implicit re-definition of `self` in `self.foo()`. */
    private predicate method_callsite_points_to(MethodCallsiteRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        /* The value of self remains the same, only the attributes may change */
        variablePointsTo(def.getInput(), context, value, origin)
    }

    /** Attribute deletions have no effect as far as value tracking is concerned. */
    pragma [noinline]
    private predicate attribute_delete_points_to(EssaAttributeDeletion def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        variablePointsTo(def.getInput(), context, value, origin)
    }

    /** Attribute assignments have no effect as far as value tracking is concerned, except for `__class__`. */
    pragma [noinline]
    private predicate attribute_assignment_points_to(AttributeAssignment def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        def.getName() = "__class__" and
        exists(ObjectInternal cls |
            pointsTo(def.getValue(), context, cls, _) and
            value = TUnknownInstance(cls) and
            origin = CfgOrigin::fromCfgNode(def.getDefiningNode())
        )
    }

    private predicate self_parameter_points_to(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        origin = def.getDefiningNode() and
        value.(SelfInstanceInternal).parameterAndContext(def, context)
    }

    /** Holds if ESSA edge refinement, `def`, refers to `(value, cls, origin)`. */
    private predicate ssa_filter_definition_points_to(PyEdgeRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(ControlFlowNode orig |
            def.getSense() = ssa_filter_definition_bool(def, context, value, orig) and
            origin = CfgOrigin::fromCfgNode(orig)
        )
    }

    private boolean ssa_filter_definition_bool(PyEdgeRefinement def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        result = Conditionals::testEvaluates(def.getTest(), def.getInput().getASourceUse(), context, value, origin)
    }

    /** Holds if ESSA definition, `uniphi`, refers to `(value, origin)`. */
    pragma [noinline]
    private predicate uni_edged_phi_points_to(SingleSuccessorGuard uniphi, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(ControlFlowNode test, ControlFlowNode use |
            /* Because calls such as `len` may create a new variable, we need to go via the source variable
             * That is perfectly safe as we are only dealing with calls that do not mutate their arguments.
             */
            use = uniphi.getInput().getASourceUse() and
            test = uniphi.getTest() and
            uniphi.getSense() = Conditionals::testEvaluates(test, use, context, value, origin.toCfgNode())
        )
    }

    /** Points-to for normal assignments `def = ...`. */
    pragma [noinline]
    private predicate assignment_points_to(AssignmentDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pointsTo(def.getValue(), context, value, origin)
    }

    /** Points-to for deletion: `del name`. */
    pragma [noinline]
    private predicate delete_points_to(DeletionDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        value = ObjectInternal::undefined() and origin = def.getDefiningNode() and context.appliesToScope(def.getScope())
    }

    /** Implicit "definition" of `__name__` at the start of a module. */
    pragma [noinline]
    private predicate module_name_points_to(ScopeEntryDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        def.getVariable().getName() = "__name__" and
        exists(Module m |
            m = def.getScope()
            |
            value = module_dunder_name(m) and context.isImport()
            or
            value.strValue() = "__main__" and context.isMain() and context.appliesToScope(m)
        ) and
        origin = def.getDefiningNode()
    }

    private ObjectInternal module_dunder_name(Module m) {
        exists(string name |
            result.strValue() = name |
            if m.isPackageInit() then
                name = m.getPackage().getName()
            else
                name = m.getName()
        )
    }

    /** Holds if the phi-function `phi` refers to `(value, origin)` given the context `context`. */
    pragma [nomagic]
    private predicate ssa_phi_points_to(PhiFunction phi, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(EssaVariable input, BasicBlock pred |
            input = phi.getInput(pred) and
            variablePointsTo(input, context, value, origin)
            |
            controlledReachableEdge(pred, phi.getBasicBlock(), context)
            or
            not exists(ConditionBlock guard | guard.controlsEdge(pred, phi.getBasicBlock(), _))
        )
    }

    /** Points-to for implicit variable declarations at scope-entry. */
    pragma [noinline]
    private predicate scope_entry_points_to(ScopeEntryDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        /* Transfer from another scope */
        exists(EssaVariable var, PointsToContext outer, CfgOrigin orig |
            InterProceduralPointsTo::scope_entry_value_transfer(var, outer, def, context) and
            variablePointsTo(var, outer, value, orig) and
            origin = orig.asCfgNodeOrHere(def.getDefiningNode())
        )
        or
        /* Undefined variable */
        exists(Scope scope |
            not def.getVariable().getName() = "__name__" and
            not def.getVariable().getName() = "$" and
            def.getScope() = scope and context.appliesToScope(scope) |
            def.getSourceVariable() instanceof GlobalVariable and scope instanceof Module
            or
            def.getSourceVariable() instanceof LocalVariable and (context.isImport() or context.isRuntime() or context.isMain())
        ) and
        value = ObjectInternal::undefined() and origin = def.getDefiningNode()
        or
        /* Builtin not defined in outer scope */
        exists(Module mod, GlobalVariable var |
            var = def.getSourceVariable() and
            mod = def.getScope().getEnclosingModule() and
            context.appliesToScope(def.getScope()) and
            not exists(EssaVariable v | v.getSourceVariable() = var and v.getScope() = mod) and
            value = ObjectInternal::builtin(var.getId()) and origin = def.getDefiningNode()
        )
    }

    private predicate iteration_definition_points_to(IterationDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pointsTo(def.getSequence(), context, ObjectInternal::unknown(), _) and
        value = ObjectInternal::unknown() and origin = def.getDefiningNode()
    }

    /** Holds if `f` is an expression node `tval if cond else fval` and points to `(value, origin)`. */
    private predicate if_exp_points_to(IfExprNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pointsTo(f.getAnOperand(), context, value, origin)
    }

}

module InterModulePointsTo {

    pragma [noinline]
    predicate import_points_to(ControlFlowNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(string name, ImportExpr i |
            i.getAFlowNode() = f and i.getImportedModuleName() = name and
            module_imported_as(value, name) and
            origin = f and
            context.appliesTo(f)
        )
    }

    predicate from_import_points_to(ImportMemberNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        from_self_import_points_to(f, context, value, origin)
        or
        from_other_import_points_to(f, context, value, origin)
    }

    pragma [noinline]
    predicate from_self_import_points_to(ImportMemberNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(EssaVariable var, CfgOrigin orig |
            var = ssa_variable_for_module_attribute(f, context) and
            PointsToInternal::variablePointsTo(var, context, value, orig) and
            origin = orig.asCfgNodeOrHere(f)
        )
    }

    pragma [noinline]
    predicate from_other_import_points_to(ImportMemberNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(string name, ModuleObjectInternal mod, CfgOrigin orig |
            from_import_imports(f, context, mod, name) and
            (mod.getSourceModule() != f.getEnclosingModule() or mod.isBuiltin()) and
            mod.attribute(name, value, orig) and
            origin = orig.asCfgNodeOrHere(f)
        )
        or
        PointsToInternal::pointsTo(f.getModule(_), context, ObjectInternal::unknown(), _) and
        value = ObjectInternal::unknown() and origin = f
    }

    private predicate from_import_imports(ImportMemberNode f, PointsToContext context, ModuleObjectInternal mod, string name) {
        PointsToInternal::pointsTo(f.getModule(name), context, mod, _)
    }

    pragma [noinline]
    private EssaVariable ssa_variable_for_module_attribute(ImportMemberNode f, PointsToContext context) {
        exists(string name, ModuleObjectInternal mod, Module m |
            mod.getSourceModule() = m and m = f.getEnclosingModule() and m = result.getScope() and
            PointsToInternal::pointsTo(f.getModule(name), context, mod, _) and
            result.getSourceVariable().getName() = name and result.getAUse() = f
        )
    }

    /* Holds if `import name` will import the module `m`. */
    predicate module_imported_as(ModuleObjectInternal m, string name) {
        /* Normal imports */
        m.getName() = name
        or
        /* sys.modules['name'] = m */
        exists(ControlFlowNode sys_modules_flow, ControlFlowNode n, ControlFlowNode mod |
          /* Use previous points-to here to avoid slowing down the recursion too much */
          exists(SubscriptNode sub |
              sub.getValue() = sys_modules_flow and
              PointsToInternal::pointsTo(sys_modules_flow, _, ObjectInternal::sysModules(), _) and
              sub.getIndex() = n and
              n.getNode().(StrConst).getText() = name and
              sub.(DefinitionNode).getValue() = mod and
              PointsToInternal::pointsTo(mod, _, m, _)
          )
        )
    }

    /** Implicit "definition" of the names of submodules at the start of an `__init__.py` file.
     *
     * PointsTo isn't exactly how the interpreter works, but is the best approximation we can manage statically.
     */
    pragma [noinline]
    predicate implicit_submodule_points_to(ImplicitSubModuleDefinition def, PointsToContext context, ModuleObjectInternal value, ControlFlowNode origin) {
        exists(PackageObjectInternal package |
            package.getSourceModule() = def.getDefiningNode().getScope() |
            value = package.submodule(def.getSourceVariable().getName()) and
            origin = CfgOrigin::fromObject(value).asCfgNodeOrHere(def.getDefiningNode()) and
            context.isImport()
        )
    }

    /** Points-to for `from ... import *`. */
    predicate import_star_points_to(ImportStarRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        /* Attribute from imported module */
        exists(CfgOrigin orig, ImportStarNode imp, ModuleObjectInternal mod, string name |
            imp = def.getDefiningNode() and
            PointsToInternal::pointsTo(imp.getModule(), context, mod, _) and
            name = def.getSourceVariable().getName() and
            moduleExportsBoolean(mod, name) = true and
            mod.attribute(name, value, orig) and
            origin = orig.fix(imp)
        )
        or
        /* Retain value held before import */
        exists(EssaVariable var |
            variable_not_redefined_by_import_star(var, context, def) and
            PointsToInternal::variablePointsTo(var, context, value, origin)
        )
    }


    /** Holds if `def` is technically a definition of `var`, but the `from ... import *` does not in fact define `var`. */
    cached predicate variable_not_redefined_by_import_star(EssaVariable var, PointsToContext context, ImportStarRefinement def) {
        var = def.getInput() and
        exists(ModuleObjectInternal mod |
            PointsToInternal::pointsTo(def.getDefiningNode().(ImportStarNode).getModule(), context, mod, _) |
            moduleExportsBoolean(mod, var.getSourceVariable().getName()) = false
            or
            var.getSourceVariable().getName().charAt(0) = "_"
            or
            exists(Module m, string name |
                m = mod.getSourceModule() and name = var.getSourceVariable().getName() |
                not m.declaredInAll(_) and name.charAt(0) = "_"
            )
        )
    }

    private predicate importsByImportStar(ModuleObjectInternal mod, ModuleObjectInternal imported) {
        exists(ImportStarNode isn |
            PointsToInternal::pointsTo(isn.getModule(), _, imported, _) and
            isn.getScope() = mod.getSourceModule()
        )
        or exists(ModuleObjectInternal mid |
            importsByImportStar(mod, mid) and importsByImportStar(mid, imported)
        )
    }

    predicate ofInterestInExports(ModuleObjectInternal mod, string name) {
        exists(ImportStarNode imp, ImportStarRefinement def |
            imp = def.getDefiningNode() and
            PointsToInternal::pointsTo(imp.getModule(), any(Context ctx | ctx.isImport()), mod, _) |
            def.getVariable().getName() = "$" and
            ModuleAttributes::attributePointsTo(def.getInput().getDefinition(), name, _, _)
            or
            def.getVariable().getName() = name and not name = "$" and not name = "*"
        )
        or
        exists(PackageObjectInternal package |
            ofInterestInExports(package, name) and
            package.getInitModule() = mod
        )
    }

    private boolean pythonModuleExportsBoolean(PythonModuleObjectInternal mod, string name) {
        exists(Module src |
            src = mod.getSourceModule()
            |
            src.declaredInAll(name) and result = true
            or
            src.declaredInAll(_) and not src.declaredInAll(name) and
            ofInterestInExports(mod, name) and result = false
            or
            not src.declaredInAll(_) and
            exists(ObjectInternal val |
                ModuleAttributes::pointsToAtExit(src, name, val, _) |
                val = ObjectInternal::undefined() and result = false
                or
                val != ObjectInternal::undefined() and result = true
            )
        )
    }

    private boolean packageExportsBoolean(PackageObjectInternal mod, string name) {
        exists(Folder folder |
            folder = mod.getFolder() |
            exportsSubmodule(folder, name) and result = true
            or
            not exportsSubmodule(folder, name) and result = moduleExportsBoolean(mod.getInitModule(), name)
            or
            mod.hasNoInitModule() and not exportsSubmodule(folder, name) and
            ofInterestInExports(mod, name) and result = false
        )
    }

    private predicate exportsSubmodule(Folder folder, string name) {
        name.regexpMatch("\\p{L}(\\p{L}|\\d|_)*") and
        (
            exists(Folder child | child = folder.getChildContainer(name))
            or
            exists(folder.getFile(name + ".py"))
        )
    }

    boolean builtinModuleExportsBoolean(BuiltinModuleObjectInternal mod, string name) {
        exists(Builtin bltn |
            bltn = mod.getBuiltin() |
            exists(bltn.getMember(name)) and result = true
            or
            ofInterestInExports(mod, name) and not exists(bltn.getMember(name)) and result = false
        )
    }

    boolean moduleExportsBoolean(ModuleObjectInternal mod, string name) {
        not name.charAt(0) = "_" and
        (
            result = pythonModuleExportsBoolean(mod, name)
            or
            result = packageExportsBoolean(mod, name)
            or
            result = builtinModuleExportsBoolean(mod, name)
        )
    }

}

module InterProceduralPointsTo {

    cached predicate call(CallNode call, PointsToContext caller, ObjectInternal value) {
        PointsToInternal::pointsTo(call.getFunction(), caller, value, _)
    }

    cached predicate callWithContext(CallNode call, PointsToContext caller, ObjectInternal value, PointsToContext callee) {
        callee.fromCall(call, caller) and
        PointsToInternal::pointsTo(call.getFunction(), caller, value, _)
    }

    pragma [noinline]
    private predicate call_points_to_simple(CallNode f, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(ObjectInternal func |
            call(f, context, func)
            |
            exists(PointsToContext callee |
                callee.fromCall(f, context) and
                func.callResult(callee, value, origin)
            )
            or
            context.untrackableCall(f) and
            value = ObjectInternal::unknown() and origin = CfgOrigin::unknown()
            or
            func.callResult(value, origin) and
            context.appliesTo(f)
        )
    }

    pragma [noinline]
    predicate call_points_to(CallNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(ObjectInternal returnValue, CfgOrigin resultOrigin |
            call_points_to_simple(f, context, returnValue, resultOrigin)
            |
            /* Either not a decorator, or we understand the return value */
            (returnValue != ObjectInternal::unknown() or not f.isDecoratorCall()) and
            value = returnValue and origin = resultOrigin.asCfgNodeOrHere(f)
            or
            /* A decorator and we don't understand it. Use the original, undecorated value */
            f.isDecoratorCall() and returnValue = ObjectInternal::unknown() and
            PointsToInternal::pointsTo(f.getArg(0), context, value, origin)
            or
            Types::six_add_metaclass(f, value, _) and
            PointsToInternal::pointsTo(f.getArg(0), context, value, origin)
        )
        or
        Expressions::typeCallPointsTo(f, context, value, origin, _, _)
        or
        Types::six_add_metaclass(f, value, _) and
        PointsToInternal::pointsTo(f.getArg(0), context, value, origin)
    }

    /** Points-to for parameter. `def foo(param): ...`. */
    pragma [noinline]
    predicate parameter_points_to(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        self_parameter_points_to(def, context, value, origin)
        or
        positional_parameter_points_to(def, context, value, origin)
        or
        named_parameter_points_to(def, context, value, origin)
        or
        default_parameter_points_to(def, context, value, origin)
        or
        special_parameter_points_to(def, context, value, origin)
    }

    /** Helper for `parameter_points_to` */
    pragma [noinline]
    private predicate positional_parameter_points_to(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(PointsToContext caller, ControlFlowNode arg |
            PointsToInternal::pointsTo(arg, caller, value, origin) and
            callsite_argument_transfer(arg, caller, def, context)
        )
        or
        not def.isSelf() and not def.isVarargs() and not def.isKwargs() and
        context.isRuntime() and value = ObjectInternal::unknown() and origin = def.getDefiningNode()
    }

    pragma [noinline]
    private predicate self_parameter_points_to(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        def.isSelf() and
        exists(CallNode call, BoundMethodObjectInternal method, Function func, PointsToContext caller |
            callWithContext(call, caller, method, context) and
            func = method.getScope() and
            def.getScope() = func and
            value = method.getSelf() and
            origin = value.getOrigin()
        )
    }

    predicate selfMethodCall(SelfCallsiteRefinement def, PointsToContext caller, Function func, PointsToContext callee) {
        def.getInput().getSourceVariable().(Variable).isSelf() and
        exists(PythonFunctionObjectInternal method, CallNode call |
            method.getScope() = func and
            call = method.getACall() and
            call = def.getDefiningNode() and
            callee.fromCall(call, caller)
        )
    }

    /** Helper for `parameter_points_to` */
    pragma [noinline]
    private predicate named_parameter_points_to(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(CallNode call, PointsToContext caller, PythonFunctionObjectInternal func, string name |
            context.fromCall(call, func, caller) and
            def.getParameter() = func.getScope().getArgByName(name) and
            PointsToInternal::pointsTo(call.getArgByName(name), caller, value, origin)
        )
    }

    /** Helper for parameter_points_to */
    pragma [noinline]
    private predicate default_parameter_points_to(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(PointsToContext imp | imp.isImport() | PointsToInternal::pointsTo(def.getDefault(), imp, value, origin)) and
        context_for_default_value(def, context)
    }

    /** Helper for default_parameter_points_to */
    pragma [noinline]
    private predicate context_for_default_value(ParameterDefinition def, PointsToContext context) {
        context.isRuntime()
        or
        exists(PointsToContext caller, CallNode call, PythonFunctionObjectInternal func, int n |
            context.fromCall(call, func, caller) and
            func.getScope().getArg(n) = def.getParameter() and
            not exists(call.getArg(n)) and
            not exists(call.getArgByName(def.getVariable().getName())) and
            not exists(call.getNode().getKwargs()) and
            not exists(call.getNode().getStarargs())
        )
    }

    /** Helper for parameter_points_to */
    pragma [noinline]
    private predicate special_parameter_points_to(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        (
            def.isVarargs() and value = TUnknownInstance(ObjectInternal::builtin("tuple"))
            or
            def.isKwargs() and value = TUnknownInstance(ObjectInternal::builtin("dict"))
        )
        and
        (
            context.isRuntime()
            or
            exists(PointsToContext caller, CallNode call, Parameter p |
                context.fromCall(call, caller) and
                context.appliesToScope(def.getScope()) and
                p = def.getParameter() and
                not exists(call.getArg(p.getPosition())) and
                not exists(call.getArgByName(p.getName()))
            )
        ) and
        origin = def.getDefiningNode()
    }

    /** Holds if the `(argument, caller)` pair matches up with `(param, callee)` pair across call. */
    cached predicate callsite_argument_transfer(ControlFlowNode argument, PointsToContext caller, ParameterDefinition param, PointsToContext callee) {
        exists(CallNode call, Function func, int n, int offset |
            callsite_calls_function(call, caller, func, callee, offset) and
            argument = call.getArg(n) and
            param.getParameter() = func.getArg(n+offset)
        )
    }

    cached predicate callsite_calls_function(CallNode call, PointsToContext caller, Function scope, PointsToContext callee, int parameter_offset) {
        exists(ObjectInternal func |
            callWithContext(call, caller, func, callee) and
            func.calleeAndOffset(scope, parameter_offset)
        )
    }

    /** Model the transfer of values at scope-entry points. Transfer from `(pred_var, pred_context)` to `(succ_def, succ_context)`. */
    cached predicate scope_entry_value_transfer(EssaVariable pred_var, PointsToContext pred_context, ScopeEntryDefinition succ_def, PointsToContext succ_context) {
        scope_entry_value_transfer_from_earlier(pred_var, pred_context, succ_def, succ_context)
        or
        callsite_entry_value_transfer(pred_var, pred_context, succ_def, succ_context)
        or
        pred_context.isImport() and pred_context = succ_context and
        class_entry_value_transfer(pred_var, succ_def)
    }

    /** Helper for `scope_entry_value_transfer`. Transfer of values from a temporally earlier scope to later scope.
     * Earlier and later scopes are, for example, a module and functions in that module, or an __init__ method and another method. */
    pragma [noinline]
    private predicate scope_entry_value_transfer_from_earlier(EssaVariable pred_var, PointsToContext pred_context, ScopeEntryDefinition succ_def, PointsToContext succ_context) {
        exists(Scope pred_scope, Scope succ_scope |
            BaseFlow::scope_entry_value_transfer_from_earlier(pred_var, pred_scope, succ_def, succ_scope) and
            succ_context.appliesToScope(succ_scope)
            |
            succ_context.isRuntime() and succ_context = pred_context
            or
            pred_context.isImport() and pred_scope instanceof ImportTimeScope and
            (succ_context.fromRuntime() or
            /* A call made at import time, but from another module. Assume this module has been fully imported. */
            succ_context.isCall() and exists(CallNode call | succ_context.fromCall(call, _) and call.getEnclosingModule() != pred_scope))
            or
            /* If predecessor scope is main, then we assume that any global defined exactly once
             * is available to all functions. Although not strictly true, this gives less surprising
             * results in practice. */
            pred_context.isMain() and pred_scope instanceof Module and succ_context.fromRuntime() and
            exists(Variable v |
                v = pred_var.getSourceVariable() and
                not strictcount(v.getAStore()) > 1
            )
        )
        or
        exists(NonEscapingGlobalVariable var |
            var = pred_var.getSourceVariable() and var = succ_def.getSourceVariable() and
            pred_var.getAUse() = succ_context.getRootCall() and pred_context.isImport() and
            succ_context.appliesToScope(succ_def.getScope())
        )
    }

    /** Helper for `scope_entry_value_transfer`.
     * Transfer of values from the callsite to the callee, for enclosing variables, but not arguments/parameters. */
    pragma [noinline]
    private predicate callsite_entry_value_transfer(EssaVariable caller_var, PointsToContext caller, ScopeEntryDefinition entry_def, PointsToContext callee) {
        entry_def.getSourceVariable() = caller_var.getSourceVariable() and
        callsite_calls_function(caller_var.getAUse(), caller, entry_def.getScope(), callee, _)
    }

    /** Helper for `scope_entry_value_transfer`. */
    private predicate class_entry_value_transfer(EssaVariable pred_var, ScopeEntryDefinition succ_def) {
        exists(ImportTimeScope scope, ControlFlowNode class_def |
            class_def = pred_var.getAUse() and
            scope.entryEdge(class_def, succ_def.getDefiningNode()) and
            pred_var.getSourceVariable() = succ_def.getSourceVariable()
        )
    }

    /** Points-to for a variable (possibly) redefined by a call:
     * `var = ...; foo(); use(var)`
     * Where var may be redefined in call to `foo` if `var` escapes (is global or non-local).
     */
    pragma [noinline]
    predicate callsite_points_to(CallsiteRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(SsaSourceVariable srcvar |
            srcvar = def.getSourceVariable() |
            if srcvar instanceof EscapingAssignmentGlobalVariable then (
                /* If global variable can be reassigned, we need to track it through calls */
                exists(EssaVariable var, Function func, PointsToContext callee |
                    callsite_calls_function(def.getCall(), context, func, callee, _) and
                    var_at_exit(srcvar, func, var) and
                    PointsToInternal::variablePointsTo(var, callee, value, origin)
                )
                or
                exists(ObjectInternal callable |
                    PointsToInternal::pointsTo(def.getCall().getFunction(), context, callable, _) and
                    exists(callable.getBuiltin()) and
                    PointsToInternal::variablePointsTo(def.getInput(), context, value, origin)
                )
            ) else (
                /* Otherwise we can assume its value (but not those of its attributes or members) has not changed. */
                PointsToInternal::variablePointsTo(def.getInput(), context, value, origin)
            )
        )
    }

    /* Helper for computing ESSA variables at scoepe exit. */
    private predicate var_at_exit(Variable var, Scope scope, EssaVariable evar) {
        not var instanceof LocalVariable and
        evar.getSourceVariable() = var and
        evar.getScope() = scope and
        BaseFlow::reaches_exit(evar)
    }

    /** INTERNAL -- Use `FunctionObject.neverReturns()` instead.
     *  Whether function `func` never returns. Slightly conservative approximation, this predicate may be false
     * for a function that can never return. */
    cached predicate neverReturns(Function f) {
        /* A Python function never returns if it has no normal exits that are not dominated by a
         * call to a function which itself never returns.
         */
        forall(BasicBlock exit |
            exit = f.getANormalExit().getBasicBlock() |
            exists(FunctionObject callee, BasicBlock call  |
                callee.getACall().getBasicBlock() = call and
                callee.neverReturns() and
                call.dominates(exit)
            )
        )
    }

}

/** Gets the `value, origin` that `f` would refer to if it has not been assigned some other value */
pragma [noinline]
private predicate potential_builtin_points_to(NameNode f, ObjectInternal value, ControlFlowNode origin) {
    f.isGlobal() and f.isLoad() and origin = f and
    (
        value = ObjectInternal::builtin(f.getId())
        or
        not exists(Builtin::builtin(f.getId())) and value = ObjectInternal::unknown()
    )
}


module Expressions {

    pragma [noinline]
    private predicate attributeObjectPointsto(AttrNode attr, PointsToContext context, string name, ControlFlowNode obj, ObjectInternal objvalue) {
        attr.isLoad() and attr.getObject(name) = obj and
        PointsToInternal::pointsTo(obj, context, objvalue, _)
    }

    pragma [noinline]
    predicate attributePointsTo(AttrNode attr, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode obj, ObjectInternal objvalue) {
        exists(string name |
            attributeObjectPointsto(attr, context, name, obj, objvalue)
            |
            exists(CfgOrigin orig |
                objvalue.attribute(name, value, orig) and
                origin = orig.asCfgNodeOrHere(attr)
            )
            or
            objvalue.attributesUnknown() and
            origin = attr and
            value = ObjectInternal::unknown()
        )
    }

    pragma [noinline]
    predicate subscriptPointsTo(SubscriptNode subscr, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode obj, ObjectInternal objvalue) {
        exists(ControlFlowNode index |
            subscriptObjectAndIndex(subscr, context,  obj, objvalue, index)
            |
            objvalue.subscriptUnknown() and
            value = ObjectInternal::unknown()
            or
            exists(int n |
                PointsToInternal::pointsTo(index, context, TInt(n), _) and
                value = objvalue.(SequenceObjectInternal).getItem(n)
            )
        ) and
        origin = subscr
    }

    pragma [noinline]
    private predicate subscriptObjectAndIndex(SubscriptNode subscr, PointsToContext context, ControlFlowNode obj, ObjectInternal objvalue, ControlFlowNode index) {
        subscr.isLoad() and
        obj = subscr.getObject() and
        PointsToInternal::pointsTo(obj, context, objvalue, _) and
        index = subscr.getIndex()
    }

    /** Track bitwise expressions so we can handle integer flags and enums.
     * Tracking too many binary expressions is likely to kill performance.
     */
    pragma [noinline]
    predicate binaryPointsTo(BinaryExprNode b, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode operand, ObjectInternal opvalue) {
        origin = b and
        exists(ControlFlowNode left, Operator op, ControlFlowNode right |
            b.operands(left, op, right)
            |
            not op instanceof BitOr and
            (operand = left or operand = right) and
            PointsToInternal::pointsTo(operand, context, opvalue, _) and
            value = ObjectInternal::unknown()
            or
            op instanceof BitOr and
            exists(ObjectInternal lobj, ObjectInternal robj |
                PointsToInternal::pointsTo(left, context, lobj, _) and
                PointsToInternal::pointsTo(right, context, robj, _) and
                value = TInt(lobj.intValue().bitOr(robj.intValue()))
                |
                left = operand and opvalue = lobj
                or
                right = operand and opvalue = robj
            )
        )
    }

    pragma [noinline]
    predicate unaryPointsTo(UnaryExprNode u, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode operand, ObjectInternal opvalue) {
        exists(Unaryop op |
            op = u.getNode().getOp() and
            operand = u.getOperand() and
            PointsToInternal::pointsTo(operand, context, opvalue, _)
            |
            op instanceof Not and value = ObjectInternal::bool(opvalue.booleanValue().booleanNot())
            or
            op instanceof USub and value = ObjectInternal::fromInt(-opvalue.intValue())
            or
            opvalue = ObjectInternal::unknown() and value = opvalue
        ) and
        origin = u
    }

    pragma [noinline]
    predicate builtinCallPointsTo(CallNode call, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode arg, ObjectInternal argvalue) {
        PointsToInternal::pointsTo(arg, context, argvalue, _) and
        arg = call.getArg(0) and
        exists(BuiltinFunctionObjectInternal callable |
            PointsToInternal::pointsTo(call.getFunction(), context, callable, _) |
            callable != ObjectInternal::builtin("len") and
            callable != ObjectInternal::builtin("callable") and
            callable != ObjectInternal::builtin("isinstance") and
            callable != ObjectInternal::builtin("issubclass") and
            callable != ObjectInternal::builtin("hasattr") and
            callable.isClass() = false and
            value = ObjectInternal::unknown()
        ) and
        origin = call
    }

    pragma [noinline]
    predicate typeCallPointsTo(CallNode call, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode arg, ObjectInternal argvalue) {
        not exists(call.getArg(1)) and
        arg = call.getArg(0) and
        InterProceduralPointsTo::call(call, context, ObjectInternal::builtin("type")) and
        PointsToInternal::pointsTo(arg, context, argvalue, _) and
        value = argvalue.getClass() and
        origin = CfgOrigin::fromObject(value).asCfgNodeOrHere(call)
    }

    pragma [noinline]
    private predicate lenCallPointsTo(CallNode call, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode arg, ObjectInternal argvalue) {
        len_call(call, arg, context, argvalue) and
        origin = call and
        exists(int len | 
            len = argvalue.length()
            |
            value = TInt(len) and len >= 0
            or
            len < 0 and value = TUnknownInstance(ObjectInternal::builtin("int"))
        )
    }

    pragma [noinline]
    private predicate getattrPointsTo(CallNode call, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode arg, ObjectInternal argvalue) {
        exists(string name |
            getattr_call(call, arg, context, argvalue, name)
            |
            argvalue.attributesUnknown() and value = ObjectInternal::unknown() and origin = call
            or
            exists(CfgOrigin valOrigin |
                argvalue.attribute(name, value, valOrigin) and origin = valOrigin.asCfgNodeOrHere(call)
            )
        )
    }

    pragma [noinline]
    predicate getattr_call(CallNode call, ControlFlowNode use, PointsToContext context, ObjectInternal val, string name) {
        exists(ControlFlowNode arg1 |
            call_to_getattr(call, context, use, arg1) and
            PointsToInternal::pointsTo(use, context, val, _) and
            PointsToInternal::pointsToString(arg1, context, name)
        )
    }

    pragma [noinline]
    predicate setattr_call(CallNode call, PointsToContext context, ControlFlowNode obj, string name, ObjectInternal val, ControlFlowNode origin) {
        exists(ControlFlowNode arg1, ControlFlowNode arg2 |
            call_to_setattr(call, context, obj, arg1, arg2) and
            PointsToInternal::pointsTo(arg2, context, val, origin) and
            PointsToInternal::pointsToString(arg1, context, name)
        )
    }

    pragma[noinline]
    private predicate call_to_getattr(ControlFlowNode call, PointsToContext context, ControlFlowNode arg0, ControlFlowNode arg1) {
        exists(ControlFlowNode func |
            call2(call, func, arg0, arg1) and
            PointsToInternal::pointsTo(func, context, ObjectInternal::builtin("getattr"), _)
        )
    }

    pragma[noinline]
    private predicate call_to_setattr(ControlFlowNode call, PointsToContext context, ControlFlowNode arg0, ControlFlowNode arg1, ControlFlowNode arg2) {
        exists(ControlFlowNode func |
            call3(call, func, arg0, arg1, arg2) and
            PointsToInternal::pointsTo(func, context, ObjectInternal::builtin("setattr"), _)
        )
    }

    pragma [noinline]
    private boolean otherComparisonEvaluatesTo(CompareNode comp, PointsToContext context, ControlFlowNode operand, ObjectInternal opvalue) {
        exists(Cmpop op |
            comp.operands(operand, op, _) or
            comp.operands(_, op, operand)
            |
            (op instanceof In or op instanceof NotIn) and
            PointsToInternal::pointsTo(operand, context, opvalue, _)
        ) and result = maybe()
    }

    pragma [noinline]
    private boolean equalityEvaluatesTo(CompareNode comp, PointsToContext context, ControlFlowNode operand, ObjectInternal opvalue) {
        exists(ObjectInternal other, boolean sense |
            equalityTest(comp, context, operand, opvalue, other, sense)
            |
            opvalue.isComparable() = true and other.isComparable() = true and
            (
                other = opvalue and result = sense
                or
                other != opvalue and result = sense.booleanNot()
            )
            or
            opvalue.isComparable() = false and result = maybe()
            or
            other.isComparable() = false and result = maybe()
        )
    }

    pragma [noinline]
    private predicate equalityTest(CompareNode comp, PointsToContext context, ControlFlowNode operand, ObjectInternal opvalue, ObjectInternal other, boolean sense) {
        exists(ControlFlowNode r |
            equality_test(comp, operand, sense, r) and
            PointsToInternal::pointsTo(operand, context, opvalue, _) and
            PointsToInternal::pointsTo(r, context, other, _)
        )
    }

    pragma [noinline]
    private boolean inequalityEvaluatesTo(CompareNode comp, PointsToContext context, ControlFlowNode use, ObjectInternal val) {
        exists(boolean strict, boolean sense, ObjectInternal other |
            inequalityTest(comp, context, use, val, other, strict, sense)
            |
            compare(val, other) = -1 and result = sense
            or
            compare(val, other) = 0 and result = strict.booleanNot()
            or
            compare(val, other) = 1 and result = sense.booleanNot()
            or
            val.isComparable() = false and result = maybe()
            or
            other.isComparable() = false and result = maybe()
        )
    }

    private int compare(ObjectInternal val, ObjectInternal other) {
        inequalityTest(_, _, _, val, other, _, _) and
        result = compare_unbound(val, other)
        or
        result = compare_sequence(val, other, 0)
    }

    bindingset[val, other]
    private int compare_unbound(ObjectInternal val, ObjectInternal other) {
        val.intValue() < other.intValue() and result = -1
        or
        val.intValue() > other.intValue() and result = 1
        or
        val.intValue() = other.intValue() and result = 0
        or
        val.strValue() < other.strValue() and result = -1
        or
        val.strValue() > other.strValue() and result = 0
        or
        val.strValue() = other.strValue() and result = 1
    }

    private int compare_sequence(SequenceObjectInternal val, SequenceObjectInternal other, int n) {
        inequalityTest(_, _, _, val, other, _, _) and
        (
            n = val.length() and other.length() > n and result = -1
            or
            n = other.length() and val.length() > n and result = 1
            or
            n = other.length() and n = val.length() and result = 0
            or
            result != 0 and result = compare_unbound(val.getItem(n), val.getItem(n))
            or
            compare_unbound(val.getItem(n), val.getItem(n)) = 0 and result = compare_sequence(val, other, n+1)
        )
    }

    pragma [noinline]
    private predicate inequalityTest(CompareNode comp, PointsToContext context, ControlFlowNode operand, ObjectInternal opvalue, ObjectInternal other, boolean strict, boolean sense) {
        exists(ControlFlowNode r |
            inequality(comp, operand, r, strict) and sense = true
            or
            inequality(comp, r, operand, strict) and sense = false
            |
            PointsToInternal::pointsTo(operand, context, opvalue, _) and
            PointsToInternal::pointsTo(r, context, other, _)
        )
    }

    /** Helper for comparisons. */
    pragma [noinline]
    private predicate inequality(CompareNode cmp, ControlFlowNode lesser, ControlFlowNode greater, boolean strict) {
        exists(Cmpop op |
            cmp.operands(lesser, op, greater) and op.getSymbol() = "<" and strict = true
            or
            cmp.operands(lesser, op, greater) and op.getSymbol() = "<=" and strict = false
            or
            cmp.operands(greater, op, lesser) and op.getSymbol() = ">" and strict = true
            or
            cmp.operands(greater, op, lesser) and op.getSymbol() = ">=" and strict = false
        )
    }

    predicate pointsTo(ControlFlowNode expr, PointsToContext context, ObjectInternal value, ControlFlowNode origin, ControlFlowNode subexpr, ObjectInternal subvalue) {
        attributePointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        subscriptPointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        binaryPointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        unaryPointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        builtinCallPointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        lenCallPointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        typeCallPointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        getattrPointsTo(expr, context, value, origin, subexpr, subvalue)
        or
        value = ObjectInternal::bool(evaluatesTo(expr, context, subexpr, subvalue)) and origin = expr
    }

    pragma [noinline]
    boolean evaluatesTo(ControlFlowNode expr, PointsToContext context, ControlFlowNode subexpr, ObjectInternal subvalue) {
        result = equalityEvaluatesTo(expr, context, subexpr, subvalue)
        or
        result = inequalityEvaluatesTo(expr, context, subexpr, subvalue)
        or
        result = otherComparisonEvaluatesTo(expr, context, subexpr, subvalue)
        or
        result = isinstanceEvaluatesTo(expr, context, subexpr, subvalue)
        or
        result = issubclassEvaluatesTo(expr, context, subexpr, subvalue)
        or
        result = callableEvaluatesTo(expr, context, subexpr, subvalue)
        or
        result = hasattrEvaluatesTo(expr, context, subexpr, subvalue)
    }

    pragma [nomagic]
    private boolean isinstanceEvaluatesTo(CallNode call, PointsToContext context, ControlFlowNode use, ObjectInternal val) {
        exists(ObjectInternal cls |
            isinstance_call(call, use, context, val, cls) |
            result = Types::improperSubclass(val.getClass(), cls)
            or
            val = ObjectInternal::unknown() and result = maybe()
            or
            cls = ObjectInternal::unknown() and result = maybe()
            or
            cls = ObjectInternal::unknownClass() and result = maybe()
        )
    }

    private
    predicate isinstance_call(CallNode call, ControlFlowNode use, PointsToContext context, ObjectInternal val, ObjectInternal cls) {
        exists(ControlFlowNode func, ControlFlowNode arg1 |
            call2(call, func, use, arg1) and
            points_to_isinstance(func, context) and
            PointsToInternal::pointsTo(use, context, val, _) and
            PointsToInternal::pointsTo(arg1, context, cls, _)
        )
    }

    private
    predicate issubclass_call(CallNode call, ControlFlowNode use, PointsToContext context, ObjectInternal val, ObjectInternal cls) {
        exists(ControlFlowNode func, ControlFlowNode arg1 |
            call2(call, func, use, arg1) and
            points_to_issubclass(func, context) and
            PointsToInternal::pointsTo(use, context, val, _) and
            PointsToInternal::pointsTo(arg1, context, cls, _)
        )
    }

    pragma[noinline]
    private predicate points_to_isinstance(ControlFlowNode func, PointsToContext context) {
        PointsToInternal::pointsTo(func, context, ObjectInternal::builtin("isinstance"), _)
    }

    pragma[noinline]
    private predicate points_to_issubclass(ControlFlowNode func, PointsToContext context) {
        PointsToInternal::pointsTo(func, context, ObjectInternal::builtin("issubclass"), _)
    }

    private predicate callable_call(CallNode call, ControlFlowNode use, PointsToContext context, ObjectInternal val) {
        PointsToInternal::pointsTo(call.getFunction(), context, ObjectInternal::builtin("callable"), _) and
        use = call.getArg(0) and
        PointsToInternal::pointsTo(use, context, val, _)
    }

    private predicate len_call(CallNode call, ControlFlowNode use, PointsToContext context, ObjectInternal val) {
        PointsToInternal::pointsTo(call.getFunction(), context, ObjectInternal::builtin("len"), _) and
        use = call.getArg(0) and
        PointsToInternal::pointsTo(use, context, val, _)
    }

    private predicate hasattr_call(CallNode call, ControlFlowNode use, PointsToContext context, ObjectInternal val, string name) {
        exists(ControlFlowNode arg1 |
            call_to_hasattr(call, context, use, arg1) and
            PointsToInternal::pointsTo(use, context, val, _) and
            PointsToInternal::pointsToString(arg1, context, name)
        )
    }

    pragma[noinline]
    private predicate call_to_hasattr(ControlFlowNode call, PointsToContext context, ControlFlowNode arg0, ControlFlowNode arg1) {
        exists(ControlFlowNode func |
            call2(call, func, arg0, arg1) and
            PointsToInternal::pointsTo(func, context, ObjectInternal::builtin("hasattr"), _)
        )
    }

    pragma [nomagic]
    private boolean issubclassEvaluatesTo(CallNode call, PointsToContext context, ControlFlowNode use, ObjectInternal val) {
        exists(ObjectInternal cls |
            issubclass_call(call, use, context, val, cls) |
            result = Types::improperSubclass(val, cls)
            or
            val = ObjectInternal::unknownClass() and result = maybe()
            or
            val = ObjectInternal::unknown() and result = maybe()
            or
            cls = ObjectInternal::unknown() and result = maybe()
            or
            cls = ObjectInternal::unknownClass() and result = maybe()
        )
    }

    pragma [noinline]
    private boolean callableEvaluatesTo(CallNode call, PointsToContext context, ControlFlowNode use, ObjectInternal val) {
        callable_call(call, use, context, val) and
        (
            val = ObjectInternal::unknown() and result = maybe()
            or
            val = ObjectInternal::unknownClass() and result = maybe()
            or
            result = Types::hasAttr(val.getClass(), "__call__")
        )
    }

    pragma [noinline]
    private boolean hasattrEvaluatesTo(CallNode call, PointsToContext context, ControlFlowNode use, ObjectInternal val) {
        exists(string name |
            hasattr_call(call, use, context, val, name)
            |
            val = ObjectInternal::unknown() and result = maybe()
            or
            val = ObjectInternal::unknownClass() and result = maybe()
            or
            result = Types::hasAttr(val.getClass(), name)
        )
    }

    predicate requireSubClass(ObjectInternal sub, ObjectInternal sup) {
        sup != ObjectInternal::unknownClass() and
        sub != ObjectInternal::unknownClass() and
        exists(ObjectInternal sup_or_tuple |
            issubclass_call(_, _, _, sub, sup_or_tuple) and sub.isClass() = true
            or
            exists(ObjectInternal val |
                isinstance_call(_, _, _, val, sup_or_tuple) and
                sub = val.getClass()
            )
            |
            sup = sup_or_tuple
            or
            sup = sup_or_tuple.(TupleObjectInternal).getItem(_)
        )
    }

    predicate requireHasAttr(ClassObjectInternal cls, string name) {
        cls != ObjectInternal::unknownClass() and
        exists(ObjectInternal val |
            val.getClass() = cls |
            name = "__call__" and callable_call(_, _, _, val)
            or
            hasattr_call(_, _, _, val, name)
        )
    }

}


module Conditionals {

    boolean testEvaluates(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pinode_test(expr, use) and
        result = evaluates(expr, use, context, value, origin).booleanValue()
    }

    pragma [noinline]
    ObjectInternal evaluates(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, ObjectInternal val, ControlFlowNode origin) {
        PointsToInternal::pointsTo(use, context, val, origin) and
        pinode_test(_, use) and expr = use and result = val
        or
        exists(ControlFlowNode part, ObjectInternal partval |
            pinode_test_part(expr, part) and
            partval = evaluates(part, use, context, val, origin) and
            Expressions::pointsTo(expr, context, result, _, part, partval)
        )
    }

    private predicate pinode_test(ControlFlowNode test, NameNode use) {
        exists(PyEdgeRefinement pi |
            pi.getInput().getASourceUse() = use and
            pi.getTest() = test and
            test.getAChild*() = use
        )
        or
        exists(SingleSuccessorGuard unipi |
            unipi.getInput().getASourceUse() = use and
            unipi.getTest() = test and
            test.getAChild*() = use
        )
    }

    private predicate pinode_test_part(ControlFlowNode outer, ControlFlowNode inner) {
        exists(ControlFlowNode test, NameNode use |
            pinode_test(test, use) and
            test.getAChild*() = outer and
            outer.getAChild+() = inner and
            inner.getAChild*() = use
        )
    }

}

cached module Types {

    cached int base_count(ClassObjectInternal cls) {
        cls = ObjectInternal::builtin("object") and result = 0
        or
        exists(cls.getBuiltin()) and cls != ObjectInternal::builtin("object") and result = 1
        or
        exists(Class pycls |
            pycls = cls.(PythonClassObjectInternal).getScope() |
            result = strictcount(pycls.getABase())
            or
            isNewStyle(cls) and not exists(pycls.getABase()) and result = 1
            or
            isOldStyle(cls) and not exists(pycls.getABase()) and result = 0
        )
    }

    cached ObjectInternal getBase(ClassObjectInternal cls, int n) {
        result.getBuiltin() = cls.getBuiltin().getBaseClass() and n = 0
        or
        exists(Class pycls |
            pycls = cls.(PythonClassObjectInternal).getScope()
            |
            exists(ObjectInternal base |
                PointsToInternal::pointsTo(pycls.getBase(n).getAFlowNode(), _, base, _)
                |
                result = base and base != ObjectInternal::unknown()
                or
                base = ObjectInternal::unknown() and result = ObjectInternal::unknownClass()
            )
            or
            not exists(pycls.getABase()) and n = 0 and
            isNewStyle(cls) and result = ObjectInternal::builtin("object")
        )
        or
        cls = ObjectInternal::unknownClass() and n = 0 and
        result = ObjectInternal::builtin("object")
    }

    cached predicate isOldStyle(ClassObjectInternal cls) {
        newStylePython2(cls, 0) = false
    }

    cached predicate isNewStyle(ClassObjectInternal cls) {
        major_version() = 3
        or
        cls.isBuiltin()
        or
        newStylePython2(cls, 0) = true
    }

    private boolean newStylePython2(ClassObjectInternal cls, int n) {
        major_version() = 2 and
        (
            hasDeclaredMetaclass(cls) = false and
            exists(Class pycls |
                pycls = cls.getClassDeclaration().getClass() and
                n = count(pycls.getABase()) and result = false
            )
            or
            exists(ClassObjectInternal base |
                base = getBase(cls, n) |
                hasDeclaredMetaclass(cls) = false and
                isOldStyle(base) and result = newStylePython2(cls, n+1)
                or
                isNewStyle(base) and result = true
            )
            or
            getMro(declaredMetaClass(cls)).contains(ObjectInternal::type()) and
            n = 0 and result = true
        )
    }

    cached ClassList getMro(ClassObjectInternal cls) {
        isNewStyle(cls) and
        result = Mro::newStyleMro(cls)
        or
        isOldStyle(cls) and
        result = Mro::oldStyleMro(cls)
    }

    cached predicate declaredAttribute(ClassObjectInternal cls, string name, ObjectInternal value, CfgOrigin origin) {
        value = ObjectInternal::fromBuiltin(cls.getBuiltin().getMember(name)) and origin = CfgOrigin::unknown()
        or
        value != ObjectInternal::undefined() and
        exists(EssaVariable var |
            name = var.getName() and
            var.getAUse() = cls.(PythonClassObjectInternal).getScope().getANormalExit() and
            PointsToInternal::variablePointsTo(var, _, value, origin)
        )
    }

    cached ClassObjectInternal getMetaClass(PythonClassObjectInternal cls) {
            result = declaredMetaClass(cls)
            or
            hasDeclaredMetaclass(cls) = false and result = getInheritedMetaclass(cls)
    }

    private ClassObjectInternal declaredMetaClass(PythonClassObjectInternal cls) {
        exists(ObjectInternal obj |
            PointsToInternal::variablePointsTo(metaclass_var(cls.getScope()), _, obj, _) |
            result = obj
            or
            obj = ObjectInternal::unknown() and result = ObjectInternal::unknownClass()
        )
        or
        exists(ControlFlowNode meta |
            six_add_metaclass(_, cls, meta) and
            PointsToInternal::pointsTo(meta, _, result, _)
        )
    }

    private boolean hasDeclaredMetaclass(PythonClassObjectInternal cls) {
        result = has_six_add_metaclass(cls).booleanOr(has_metaclass_var_metaclass(cls))
    }

    private ControlFlowNode decorator_call_callee(PythonClassObjectInternal cls) {
        result = cls.getScope().getADecorator().getAFlowNode().(CallNode).getFunction()
    }

    private boolean has_six_add_metaclass(PythonClassObjectInternal cls) {
        exists(ControlFlowNode callee, ObjectInternal func |
            callee = decorator_call_callee(cls) and
            PointsToInternal::pointsTo(callee, _, func, _)
            |
            func = six_add_metaclass_function() and result = true
            or
            func != six_add_metaclass_function() and result = false
        )
        or
        not exists(Module m | m.getName() = "six") and result = false
        or
        exists(Class pycls |
            pycls = cls.getScope() and
            not exists(pycls.getADecorator()) and
            result = false
        )
    }

    private boolean has_metaclass_var_metaclass(PythonClassObjectInternal cls) {
        exists(ObjectInternal obj |
            PointsToInternal::variablePointsTo(metaclass_var(cls.getScope()), _, obj, _) |
            obj = ObjectInternal::undefined() and result = false
            or
            obj != ObjectInternal::undefined() and result = true
        )
        or
        exists(Class pycls |
            pycls = cls.getScope() and
            not exists(metaclass_var(pycls)) and result = false
        )
    }

    private EssaVariable metaclass_var(Class cls) {
        result.getASourceUse() = cls.getMetaClass().getAFlowNode()
        or
        major_version() = 2 and not exists(cls.getMetaClass()) and
        result.getName() = "__metaclass__" and
        cls.(ImportTimeScope).entryEdge(result.getAUse(), _)
    }

    cached predicate six_add_metaclass(CallNode decorator_call, ClassObjectInternal decorated, ControlFlowNode metaclass) {
        exists(CallNode decorator |
            PointsToInternal::pointsTo(decorator_call.getArg(0), _, decorated, _) and
            decorator = decorator_call.getFunction() and
            decorator.getArg(0) = metaclass |
            PointsToInternal::pointsTo(decorator.getFunction(), _, six_add_metaclass_function(), _)
            or
            exists(ModuleObjectInternal six |
               six.getName() = "six" and
               PointsToInternal::pointsTo(decorator.getFunction().(AttrNode).getObject("add_metaclass"), _, six, _)
           )
        )
    }

    private ObjectInternal six_add_metaclass_function() {
        exists(ModuleObjectInternal six |
            six.getName() = "six" and
            six.attribute("add_metaclass", result, _)
        )
    }

    private ClassObjectInternal getInheritedMetaclass(ClassObjectInternal cls) {
        result = getInheritedMetaclass(cls, 0)
        or
        // Best guess if base is not a known class
        exists(ObjectInternal base |
            base = getBase(cls, _) and
            result = ObjectInternal::unknownClass() |
            base.isClass() = false
            or
            base = ObjectInternal::unknownClass()
        )
    }

    private ClassObjectInternal getInheritedMetaclass(ClassObjectInternal cls, int n) {
        exists(Class c |
            c = cls.(PythonClassObjectInternal).getScope() and
            n = count(c.getABase())
            |
            result = ObjectInternal::builtin("type")
        )
        or
        exists(ClassObjectInternal meta1, ClassObjectInternal meta2 |
            meta1 = getBase(cls, n).getClass() and
            meta2 = getInheritedMetaclass(cls, n+1)
            |
            /* Choose sub-class */
            improperSuperType(meta1) = meta2 and result = meta1
            or
            improperSuperType(meta2) = meta1 and result = meta2
            or
            /* Make sure we have a metaclass, even if base is unknown */
            meta1 = ObjectInternal::unknownClass() and result = ObjectInternal::builtin("type")
            or
            meta2 = ObjectInternal::unknownClass() and result = meta1
        )
    }

    private ClassObjectInternal improperSuperType(ClassObjectInternal cls) {
        result = cls
        or
        result = improperSuperType(getBase(cls, _))
    }

    /* Holds if type inference failed to compute the full class hierarchy for this class for the reason given. */
    cached predicate failedInference(ClassObjectInternal cls, string reason) {
        strictcount(cls.(PythonClassObjectInternal).getScope().getADecorator()) > 1 and reason = "Multiple decorators"
        or
        exists(cls.(PythonClassObjectInternal).getScope().getADecorator()) and not six_add_metaclass(_, cls, _) and reason = "Decorator not understood"
        or
        reason = "Missing base " + missingBase(cls)
        or
        not exists(ObjectInternal meta | meta = cls.getClass() and not meta = ObjectInternal::unknownClass()) and reason = "Failed to infer metaclass"
        or
        exists(int i, ObjectInternal base1, ObjectInternal base2 |
            base1 = getBase(cls, i) and
            base2 = getBase(cls, i) and
            base1 != base2 and
            reason = "Multiple bases at position " + i
        )
        or
        duplicateBase(cls) and reason = "Duplicate bases classes"
        or
        not exists(getMro(cls)) and reason = "Failed to compute MRO" and not exists(missingBase(cls)) and not duplicateBase(cls)
        or
        exists(int i | failedInference(getBase(cls, i), _) and reason = "Failed inference for base class at position " + i)
    }

    private int missingBase(ClassObjectInternal cls) {
        exists(cls.(PythonClassObjectInternal).getScope().getBase(result))
        and
        not exists(ObjectInternal base | base = getBase(cls, result) and not base = ObjectInternal::unknownClass())
    }

    private predicate duplicateBase(ClassObjectInternal cls) {
        exists(int i, int j, ClassObjectInternal dup | 
            dup = getBase(cls, i) and dup != ObjectInternal::unknownClass() and
            dup = getBase(cls, j) and i != j
        )
    }

    cached boolean improperSubclass(ObjectInternal sub, ObjectInternal sup) {
        sub = sup and result = true
        or
        result = true and mroContains(Types::getMro(sub), sup)
        or
        result = false and mroDoesnotContain(Types::getMro(sub), sup, 0)
        or
        result = tupleSubclass(sub, sup, 0)
    }

    private boolean tupleSubclass(ObjectInternal cls, TupleObjectInternal tpl, int n) {
        Expressions::requireSubClass(cls, tpl) and
        (
            n = tpl.length() and result = false
            or
            result = improperSubclass(cls, tpl.getItem(n)).booleanOr(tupleSubclass(cls, tpl, n+1))
        )
    }

    private predicate mroContains(ClassList mro, ClassObjectInternal sup) {
        mro.contains(sup)
        or
        exists(ClassDecl item, ClassDecl sdecl |
            item = mro.getAnItem().getClassDeclaration() and
            sdecl = sup.getClassDeclaration() and
            is_abstract_subclass(item, sdecl)
        )
    }

    private predicate mroDoesnotContain(ClassList mro, ClassObjectInternal sup, int n) {
        exists(ClassObjectInternal cls |
            Expressions::requireSubClass(cls, sup) and
            mro = getMro(cls)
        )
        and
        (
            n = mro.length()
            or
            mroDoesnotContain(mro, sup, n+1) and
            mro.getItem(n) != sup and
            exists(ClassDecl item, ClassDecl sdecl |
                item = mro.getItem(n).getClassDeclaration() and
                sdecl = sup.getClassDeclaration() and
                not is_abstract_subclass(item, sdecl)
            )
        )
    }

    private predicate is_abstract_subclass(ClassDecl cls, ClassDecl sup) {
        cls = Builtin::builtin("list") and sup.isAbstractBaseClass("Sequence")
        or
        cls = Builtin::builtin("set") and sup.isAbstractBaseClass("Set")
        or
        cls = Builtin::builtin("dict") and sup.isAbstractBaseClass("Mapping")
        or
        cls = Builtin::builtin("list") and sup.isAbstractBaseClass("Iterable")
        or
        cls = Builtin::builtin("set") and sup.isAbstractBaseClass("Iterable")
        or
        cls = Builtin::builtin("dict") and sup.isAbstractBaseClass("Iterable")
    }

    cached boolean hasAttr(ObjectInternal cls, string name) {
        result = mroHasAttr(Types::getMro(cls), name, 0)
    }

    private boolean mroHasAttr(ClassList mro, string name, int n) {
        exists(ClassObjectInternal cls |
            Expressions::requireHasAttr(cls, name) and
            mro = getMro(cls)
        )
        and
        (
            n = mro.length() and result = false
            or
            exists(ClassDecl decl |
                decl = mro.getItem(n).getClassDeclaration() |
                if decl.declaresAttribute(name) then
                    result = true
                else
                    result = mroHasAttr(mro, name, n+1)
            )
        )
    }

}


module AttributePointsTo {

    predicate pointsTo(ControlFlowNode f, Context context, ObjectInternal value, ControlFlowNode origin) {
        exists(EssaVariable var, string name, CfgOrigin orig |
            f.isLoad() and
            var.getASourceUse() = f.(AttrNode).getObject(name)
            or
            Expressions::getattr_call(f, var.getASourceUse(), context, _, name)
            |
            variableAttributePointsTo(var, context, name, value, orig) and
            origin = orig.asCfgNodeOrHere(f)
        )
    }

    predicate variableAttributePointsTo(EssaVariable var, Context context, string name, ObjectInternal value, CfgOrigin origin) {
        definitionAttributePointsTo(var.getDefinition(), context, name, value, origin)
        or
        exists(EssaVariable prev |
            var.getDefinition().(PhiFunction).getShortCircuitInput() = prev and
            variableAttributePointsTo(prev, context, name, value, origin)
        )
    }

    predicate definitionAttributePointsTo(EssaDefinition def, Context context, string name, ObjectInternal value, CfgOrigin origin) {
        variableAttributePointsTo(def.(PhiFunction).getAnInput(), context, name, value, origin)
        or
        piNodeAttributePointsTo(def, context, name, value, origin)
        or
        refinementAttributePointsTo(def, context, name, value, origin)
        or
        selfParameterAttributePointsTo(def, context, name, value, origin)
        or
        selfMethodCallsitePointsTo(def, context, name, value, origin)
        or
        argumentRefinementPointsTo(def, context, name, value, origin)
    }

    pragma [noinline]
    private predicate refinementAttributePointsTo(EssaNodeRefinement def, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        attributeAssignmentAttributePointsTo(def, context, name, value, origin)
        or
        attributeDeleteAttributePointsTo(def, context, name, value, origin)
        or
        uniEdgedPhiAttributePointsTo(def, context, name, value, origin)
    }


    /** Attribute deletions have no effect as far as value tracking is concerned. */
    pragma [noinline]
    private predicate attributeAssignmentAttributePointsTo(AttributeAssignment def, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        def.getName() != name and
        variableAttributePointsTo(def.getInput(), context, name, value, origin)
        or
        def.getName() = name and
        exists(ControlFlowNode cfgnode |
            PointsToInternal::pointsTo(def.getValue(), context, value, cfgnode) and
            origin = CfgOrigin::fromCfgNode(cfgnode)
        )
    }

    /** Attribute deletions have no effect as far as value tracking is concerned. */
    pragma [noinline]
    private predicate attributeDeleteAttributePointsTo(EssaAttributeDeletion def, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        def.getName() != name and
        variableAttributePointsTo(def.getInput(), context, name, value, origin)
    }

    private predicate uniEdgedPhiAttributePointsTo(SingleSuccessorGuard uniphi, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        variableAttributePointsTo(uniphi.getInput(), context, name, value, origin)
    }

    private predicate piNodeAttributePointsTo(PyEdgeRefinement pi, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        variableAttributePointsTo(pi.getInput(), context, name, value, origin)
    }

    private predicate selfParameterAttributePointsTo(ParameterDefinition def, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        exists(SelfCallsiteRefinement call, Function func, PointsToContext caller |
            InterProceduralPointsTo::selfMethodCall(call, caller, func, context) and
            def.isSelf() and def.getScope() = func and
            variableAttributePointsTo(call.getInput(), caller, name, value, origin)
        )
    }

    /** Pass through for `self` for the implicit re-definition of `self` in `self.foo()`. */
    private predicate selfMethodCallsitePointsTo(SelfCallsiteRefinement def, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        /* The value of self remains the same, only the attributes may change */
        exists(Function func, PointsToContext callee, EssaVariable exit_self |
            InterProceduralPointsTo::selfMethodCall(def, context, func, callee) and
            exit_self.getSourceVariable().(Variable).isSelf() and
            exit_self.getScope() = func and 
            BaseFlow::reaches_exit(exit_self) and
            variableAttributePointsTo(exit_self, callee, name, value, origin)
        )
    }

    private predicate argumentRefinementPointsTo(ArgumentRefinement def, PointsToContext context, string name, ObjectInternal value, CfgOrigin origin) {
        exists(ObjectInternal callable |
            PointsToInternal::pointsTo(def.getCall().getFunction(), context, callable, _) and
            callable != ObjectInternal::builtin("setattr")
        ) and
        variableAttributePointsTo(def.getInput(), context, name, value, origin)
        or
        exists(string othername |
            Expressions::setattr_call(def.getCall(), context, def.getInput().getASourceUse(), othername, _, _) and
            not othername = name
        ) and
        variableAttributePointsTo(def.getInput(), context, name, value, origin)
        or
        exists(ControlFlowNode orig |
            Expressions::setattr_call(def.getCall(), context, def.getInput().getASourceUse(), name, value, orig) and
            origin = CfgOrigin::fromCfgNode(orig)
        )
    }

}

module ModuleAttributes {

    private EssaVariable varAtExit(Module mod, string name) {
        result.getName() = name and result.getAUse() = mod.getANormalExit()
    }

    EssaVariable moduleStateVariable(ControlFlowNode use) {
        result.getName() = "$" and result.getAUse() = use
    }

    private EssaVariable moduleStateVarAtExit(Module mod) {
        result = moduleStateVariable(mod.getANormalExit())
    }

    predicate pointsToAtExit(Module mod, string name, ObjectInternal value, CfgOrigin origin) {
        if exists(varAtExit(mod, name)) then (
            PointsToInternal::variablePointsTo(varAtExit(mod, name), any(Context c | c.isImport()), value, origin)
        ) else (
            attributePointsTo(moduleStateVarAtExit(mod), name, value, origin)
        )
    }

    predicate attributePointsTo(EssaVariable var, string name, ObjectInternal value, CfgOrigin origin) {
        importStarPointsTo(var.getDefinition(), name, value, origin)
        or
        callsitePointsTo(var.getDefinition(), name, value, origin)
        or
        scopeEntryPointsTo(var.getDefinition(), name, value, origin)
    }

    pragma [nomagic]
    private predicate importStarPointsTo(ImportStarRefinement def, string name, ObjectInternal value, CfgOrigin origin) {
        def.getVariable().getName() = "$" and
        exists(ImportStarNode imp, ModuleObjectInternal mod |
            imp = def.getDefiningNode() and
            PointsToInternal::pointsTo(imp.getModule(), any(Context ctx | ctx.isImport()), mod, _)
            |
            /* Attribute from imported module */
            exists(CfgOrigin orig |
                InterModulePointsTo::moduleExportsBoolean(mod, name) = true and
                mod.attribute(name, value, orig) and origin = orig.fix(imp) and
                not exists(Variable v | v.getId() = name and v.getScope() = imp.getScope())
            )
            or
            /* Retain value held before import */
            (InterModulePointsTo::moduleExportsBoolean(mod, name) = false or name.charAt(0) = "_")
            and
            attributePointsTo(def.getInput(), name, value, origin)
        )
    }

    /** Points-to for a variable (possibly) redefined by a call:
     * `var = ...; foo(); use(var)`
     * Where var may be redefined in call to `foo` if `var` escapes (is global or non-local).
     */
    pragma [noinline]
    predicate callsitePointsTo(CallsiteRefinement def, string name, ObjectInternal value, CfgOrigin origin) {
        def.getVariable().getName() = "$" and
        exists(EssaVariable var, Function func, PointsToContext callee |
            InterProceduralPointsTo::callsite_calls_function(def.getCall(), _, func, callee, _) and
            var = moduleStateVariable(func.getANormalExit()) and
            attributePointsTo(var, name, value, origin)
        )
    }

    /** Holds if the attribute name of the implicit '$' variable refers to `value` at the start of the scope.
     * Since it cannot refer to any actual value, it is set to "undefined" for sub module names.
     */
    pragma [noinline]
    predicate scopeEntryPointsTo(ScopeEntryDefinition def, string name, ObjectInternal value, CfgOrigin origin) {
        def.getVariable().getName() = "$" and
        exists(Module m |
            def.getScope() = m and
            not exists(EssaVariable named | named.getName() = name and named.getScope() = m) and
            not name = "$" and not name = "*" and
            value = ObjectInternal::undefined() and
            origin = CfgOrigin::unknown()
            |
            m.isPackageInit() and exists(m.getPackage().getSubModule(name))
            or
            not m.declaredInAll(_) and
            exists(PythonModuleObjectInternal mod |
                mod.getSourceModule() = m and
                InterModulePointsTo::ofInterestInExports(mod, name)
            )
        )
    }

}

