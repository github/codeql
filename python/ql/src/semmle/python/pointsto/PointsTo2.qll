import python

private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.Filters
private import semmle.python.pointsto.PointsToContext
private import semmle.python.pointsto.MRO2
private import semmle.python.types.Builtins

/* Use this version for speed */
library class CfgOrigin extends @py_object {

    string toString() {
        /* Not to be displayed */
        none()
    }

    /** Get a `ControlFlowNode` from `this` or `here`.
     * If `this` is a ControlFlowNode then use that, otherwise fall back on `here`
     */
    pragma[inline]
    ControlFlowNode asCfgNodeOrHere(ControlFlowNode here) {
        result = this
        or
        not this instanceof ControlFlowNode and result = here
    }

    ControlFlowNode toCfgNode() {
        result = this
    }

    pragma[inline]
    CfgOrigin fix(ControlFlowNode here) {
        if this = Builtin::unknown() then
            result = here
        else
            result = this
    }

}

/* Use this version for stronger type-checking */
//private newtype TCfgOrigin =
//    TUnknownOrigin()
//    or
//    TCfgOrigin(ControlFlowNode f)
//
//library class CfgOrigin extends TCfgOrigin {
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
//        this = TUnknownOrigin() and result = here
//        or
//        this = TCfgOrigin(result)
//    }
//
//    ControlFlowNode toCfgNode() {
//        this = TCfgOrigin(result)
//    }
//
//    CfgOrigin fix(ControlFlowNode here) {
//        this = TUnknownOrigin() and result = TCfgOrigin(here)
//        or
//        not this = TUnknownOrigin() and result = this
//    }
//}
//


module CfgOrigin {

    CfgOrigin fromCfgNode(ControlFlowNode f) {
        result = f
    }

    CfgOrigin unknown() {
        result = Builtin::unknown()
    }

    CfgOrigin fromModule(ModuleObjectInternal mod) {
        mod.isBuiltin() and result = unknown()
        or
        result = mod.getSourceModule().getEntryNode()
    }

}

cached module PointsTo2 {

    /** INTERNAL -- Use `f.refersTo(value, origin)` instead. */
    cached predicate pointsTo(ControlFlowNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pointsTo_candidate(f, context, value, origin) and
        reachableBlock(f.getBasicBlock(), context)
    }

    private predicate pointsTo_candidate(ControlFlowNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        use_pointsTo(f, context, value, origin)
        or
        /* Not necessary, but for backwards compatibility */
        def_pointsTo(f, context, value, origin)
        or
        attribute_load_pointsTo(f, context, value, origin)
        or
        subscript_pointsTo(f, context, value, origin)
        or
        binary_expr_pointsTo(f, context, value, origin)
        or
        origin = f and compare_expr_pointsTo(f, context, value)
        or
        origin = f and unary_pointsTo(f, context, value)
        or
        origin = f and value.introduced(f, context)
        or
        InterModulePointsTo::import_pointsTo(f, context, value, origin)
        or
        InterModulePointsTo::from_import_pointsTo(f, context, value, origin)
        or
        InterProceduralPointsTo::call_pointsTo(f, context, value, origin)
        // To do... More stuff here :)
        // or
        // f.(CustomPointsToFact).pointsTo(context, value, origin)
    }

    /** Holds if the attribute `name` is required for `obj` */
    cached predicate attributeRequired(ObjectInternal obj, string name) {
        pointsTo(any(AttrNode a).getObject(name), _, obj, _)
        or
        exists(CallNode call, PointsToContext ctx, StringObjectInternal nameobj |
            pointsTo(call.getFunction(), ctx, ObjectInternal::builtin("getattr"), _) and
            pointsTo(call.getArg(0), ctx, obj, _) and
            pointsTo(call.getArg(1), ctx, nameobj, _) and
            nameobj.strValue() = name
        )
    }

    cached CallNode get_a_call(ObjectInternal func, PointsToContext context) {
        pointsTo(result.getFunction(), context, func, _)
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
    private predicate use_pointsTo(NameNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(CfgOrigin origin_or_obj |
            value != ObjectInternal::undefined() and
            use_pointsTo_maybe_origin(f, context, value, origin_or_obj) |
            origin = origin_or_obj.asCfgNodeOrHere(f)
        )
    }

    /** Gets an object pointed to by the definition of an ESSA variable. */
    pragma [noinline]
    private predicate def_pointsTo(DefinitionNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pointsTo(f.getValue(), context, value, origin)
    }

    pragma [noinline]
    private predicate use_pointsTo_maybe_origin(NameNode f, PointsToContext context, ObjectInternal value, CfgOrigin origin_or_obj) {
        ssa_variable_pointsTo(fast_local_variable(f), context, value,  origin_or_obj)
        or
        name_lookup_pointsTo_maybe_origin(f, context, value, origin_or_obj)
        or
        not exists(fast_local_variable(f)) and not exists(name_local_variable(f)) and
        global_lookup_pointsTo_maybe_origin(f, context, value, origin_or_obj)
    }

    /** Holds if `var` refers to `(value, origin)` given the context `context`. */
    pragma [noinline]
    cached predicate ssa_variable_pointsTo(EssaVariable var, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        ssa_definition_pointsTo(var.getDefinition(), context, value, origin)
    }

    pragma [noinline]
    private predicate name_lookup_pointsTo_maybe_origin(NameNode f, PointsToContext context, ObjectInternal value, CfgOrigin origin_or_obj) {
        exists(EssaVariable var | var = name_local_variable(f) |
            ssa_variable_pointsTo(var, context, value, origin_or_obj)
        )
        or
        local_variable_undefined(f, context) and
        global_lookup_pointsTo_maybe_origin(f, context, value, origin_or_obj)
    }

    pragma [noinline]
    private predicate local_variable_undefined(NameNode f, PointsToContext context) {
        ssa_variable_pointsTo(name_local_variable(f), context, ObjectInternal::undefined(), _)
    }

    pragma [noinline]
    private predicate global_lookup_pointsTo_maybe_origin(NameNode f, PointsToContext context, ObjectInternal value, CfgOrigin origin_or_obj) {
        ssa_variable_pointsTo(global_variable(f), context, value, origin_or_obj)
        or
        exists(ControlFlowNode origin |
            origin_or_obj = CfgOrigin::fromCfgNode(origin)
            |
            ssa_variable_pointsTo(global_variable(f), context, ObjectInternal::undefined(), _) and
            potential_builtin_pointsTo(f, value, origin)
            or
            not exists(global_variable(f)) and context.appliesToScope(f.getScope()) and
            potential_builtin_pointsTo(f, value, origin)
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
    private predicate attribute_load_pointsTo(AttrNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        f.isLoad() and
        exists(ObjectInternal object, string name, CfgOrigin orig |
            pointsTo(f.getObject(name), context, object, _) |
            object.attribute(name, value, orig) and
            origin = orig.fix(f)
            or
            object.attributesUnknown() and
            origin = f and value = ObjectInternal::unknown()
        )
        // TO DO -- Support CustomPointsToAttribute
        //or
        //exists(CustomPointsToAttribute object, string name |
        //    pointsTo(f.getObject(name), context, object, _, _) and
        //    object.attributePointsTo(name, value, cls, origin)
        //)
    }

    /** Holds if the ESSA definition `def`  refers to `(value, origin)` given the context `context`. */
    private predicate ssa_definition_pointsTo(EssaDefinition def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        ssa_phi_pointsTo(def, context, value, origin)
        or
        exists(ControlFlowNode orig |
            ssa_node_definition_pointsTo(def, context, value, orig) and
            origin = CfgOrigin::fromCfgNode(orig)
        )
        or
        ssa_filter_definition_pointsTo(def, context, value, origin)
        or
        ssa_node_refinement_pointsTo(def, context, value, origin)
    }

    pragma [noinline]
    private predicate ssa_node_definition_pointsTo(EssaNodeDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        reachableBlock(def.getDefiningNode().getBasicBlock(), _) and
        ssa_node_definition_pointsTo_unpruned(def, context, value, origin)
    }

    pragma [nomagic]
    private predicate ssa_node_definition_pointsTo_unpruned(EssaNodeDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        InterProceduralPointsTo::parameter_pointsTo(def, context, value, origin)
        or
        assignment_pointsTo(def, context, value, origin)
        //// TO DO...
        or
        self_parameter_pointsTo(def, context, value, origin)
        or
        delete_pointsTo(def, context, value, origin)
        or
        module_name_pointsTo(def, context, value, origin)
        or
        scope_entry_pointsTo(def, context, value, origin)
        or
        InterModulePointsTo::implicit_submodule_pointsTo(def, context, value, origin)
        // or
        // iteration_definition_pointsTo(def, context, value, origin)
        /*
         * No points-to for non-local function entry definitions yet.
         */
    }

    pragma [noinline]
    private predicate ssa_node_refinement_pointsTo(EssaNodeRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        //method_callsite_pointsTo(def, context, value, origin)
        //or
        InterModulePointsTo::import_star_pointsTo(def, context, value, origin)
        or
        //attribute_assignment_pointsTo(def, context, value, origin)
        //or
        InterProceduralPointsTo::callsite_pointsTo(def, context, value, origin)
        or
        argument_pointsTo(def, context, value, origin)
        //or
        //attribute_delete_pointsTo(def, context, value, origin)
        or
        uni_edged_phi_pointsTo(def, context, value, origin)
    }

    /** Ignore the effects of calls on their arguments. PointsTo is an approximation, but attempting to improve accuracy would be very expensive for very little gain. */
    private predicate argument_pointsTo(ArgumentRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        ssa_variable_pointsTo(def.getInput(), context, value, origin)
    }

    private predicate self_parameter_pointsTo(ParameterDefinition def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        origin = CfgOrigin::fromCfgNode(def.getDefiningNode()) and
        value.(SelfInstanceInternal).parameterAndContext(def, context)
    }

    /** Holds if ESSA edge refinement, `def`, refers to `(value, cls, origin)`. */
    private predicate ssa_filter_definition_pointsTo(PyEdgeRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(ControlFlowNode test, ControlFlowNode use |
            refinement_test(test, use, Conditionals::branchEvaluatesTo(test, use, context, value, origin.toCfgNode()), def)
        )
    }

    /** Holds if ESSA definition, `uniphi`, refers to `(value, origin)`. */
    pragma [noinline]
    private predicate uni_edged_phi_pointsTo(SingleSuccessorGuard uniphi, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(ControlFlowNode test, ControlFlowNode use |
            /* Because calls such as `len` may create a new variable, we need to go via the source variable
             * That is perfectly safe as we are only dealing with calls that do not mutate their arguments.
             */
            use = uniphi.getInput().getSourceVariable().(Variable).getAUse() and
            test = uniphi.getDefiningNode() and
            uniphi.getSense() = Conditionals::branchEvaluatesTo(test, use, context, value, origin.toCfgNode())
        )
    }

    /** Points-to for normal assignments `def = ...`. */
    pragma [noinline]
    private predicate assignment_pointsTo(AssignmentDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pointsTo(def.getValue(), context, value, origin)
    }

    /** Points-to for deletion: `del name`. */
    pragma [noinline]
    private predicate delete_pointsTo(DeletionDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        value = ObjectInternal::undefined() and origin = def.getDefiningNode() and context.appliesToScope(def.getScope())
    }

    /** Implicit "definition" of `__name__` at the start of a module. */
    pragma [noinline]
    private predicate module_name_pointsTo(ScopeEntryDefinition def, PointsToContext context, StringObjectInternal value, ControlFlowNode origin) {
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

    private StringObjectInternal module_dunder_name(Module m) {
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
    private predicate ssa_phi_pointsTo(PhiFunction phi, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(EssaVariable input, BasicBlock pred |
            input = phi.getInput(pred) and
            ssa_variable_pointsTo(input, context, value, origin)
            |
            controlledReachableEdge(pred, phi.getBasicBlock(), context)
            or
            not exists(ConditionBlock guard | guard.controlsEdge(pred, phi.getBasicBlock(), _))
        )
        or
        ssa_variable_pointsTo(phi.getShortCircuitInput(), context, value, origin)
    }

    /** Points-to for implicit variable declarations at scope-entry. */
    pragma [noinline]
    private predicate scope_entry_pointsTo(ScopeEntryDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        /* Transfer from another scope */
        exists(EssaVariable var, PointsToContext outer, CfgOrigin orig |
            InterProceduralPointsTo::scope_entry_value_transfer(var, outer, def, context) and
            ssa_variable_pointsTo(var, outer, value, orig) and
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

    private predicate subscript_pointsTo(SubscriptNode sub, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        pointsTo(sub.getValue(), context, ObjectInternal::unknown(), _) and
        value = ObjectInternal::unknown() and origin = sub
    }

    /** Track bitwise expressions so we can handle integer flags and enums.
     * Tracking too many binary expressions is likely to kill performance.
     */
    private predicate binary_expr_pointsTo(BinaryExprNode b, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        // TO DO...
        // Track some integer values through `|` and the types of some objects
        none()
    }

    pragma [noinline]
    private predicate compare_expr_pointsTo(CompareNode cmp, PointsToContext context, ObjectInternal value) {
        value = ObjectInternal::bool(Conditionals::comparisonEvaluatesTo(cmp, _, context, _, _))
        // or
        // value = version_tuple_compare(cmp, context)
    }

    pragma [noinline]
    private predicate unary_pointsTo(UnaryExprNode f, PointsToContext context, ObjectInternal value) {
        exists(Unaryop op, ObjectInternal operand |
            op = f.getNode().getOp() and
            pointsTo(f.getOperand(), context, operand, _)
            |
            op instanceof Not and value = ObjectInternal::bool(operand.booleanValue().booleanNot())
            or
            op instanceof USub and value = ObjectInternal::fromInt(-operand.intValue())
            or
            operand = ObjectInternal::unknown() and value = operand
        )
    }

}

module InterModulePointsTo {

    pragma [noinline]
    predicate import_pointsTo(ControlFlowNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(string name, ImportExpr i |
            i.getAFlowNode() = f and i.getImportedModuleName() = name and
            module_imported_as(value, name) and
            origin = f and
            context.appliesTo(f)
        )
    }

    predicate from_import_pointsTo(ImportMemberNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        from_self_import_pointsTo(f, context, value, origin)
        or
        from_other_import_pointsTo(f, context, value, origin)
    }

    pragma [noinline]
    predicate from_self_import_pointsTo(ImportMemberNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(EssaVariable var, CfgOrigin orig |
            var = ssa_variable_for_module_attribute(f, context) and
            PointsTo2::ssa_variable_pointsTo(var, context, value, orig) and
            origin = orig.asCfgNodeOrHere(f)
        )
    }

    pragma [noinline]
    predicate from_other_import_pointsTo(ImportMemberNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(string name, ModuleObjectInternal mod, CfgOrigin orig |
            from_import_imports(f, context, mod, name) and
            (mod.getSourceModule() != f.getEnclosingModule() or mod.isBuiltin()) and
            mod.attribute(name, value, orig) and
            origin = orig.asCfgNodeOrHere(f)
            // TO DO... $ variables.
            //mod.getSourceModule() = f.getEnclosingModule() and
            //not exists(EssaVariable var | var.getSourceVariable().getName() = name and var.getAUse() = f) and
            //exists(EssaVariable dollar |
            //    isModuleStateVariable(dollar) and dollar.getAUse() = f and
            //    SSA::ssa_variable_named_attribute_pointsTo(dollar, context, name, value, orig)
            //)
        )
    }

    private predicate from_import_imports(ImportMemberNode f, PointsToContext context, ModuleObjectInternal mod, string name) {
        PointsTo2::pointsTo(f.getModule(name), context, mod, _)
    }

    pragma [noinline]
    private EssaVariable ssa_variable_for_module_attribute(ImportMemberNode f, PointsToContext context) {
        exists(string name, ModuleObjectInternal mod, Module m |
            mod.getSourceModule() = m and m = f.getEnclosingModule() and m = result.getScope() and
            PointsTo2::pointsTo(f.getModule(name), context, mod, _) and
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
              PointsTo2::pointsTo(sys_modules_flow, _, ObjectInternal::sysModules(), _) and
              sub.getIndex() = n and
              n.getNode().(StrConst).getText() = name and
              sub.(DefinitionNode).getValue() = mod and
              PointsTo2::pointsTo(mod, _, m, _)
          )
        )
    }

    /** Implicit "definition" of the names of submodules at the start of an `__init__.py` file.
     *
     * PointsTo isn't exactly how the interpreter works, but is the best approximation we can manage statically.
     */
    pragma [noinline]
    predicate implicit_submodule_pointsTo(ImplicitSubModuleDefinition def, PointsToContext context, ModuleObjectInternal value, ControlFlowNode origin) {
        exists(PackageObjectInternal package |
            package.getSourceModule() = def.getDefiningNode().getScope() |
            value = package.submodule(def.getSourceVariable().getName()) and
            origin = CfgOrigin::fromModule(value).fix(def.getDefiningNode()) and
            context.isImport()
        )
    }

    /** Points-to for `from ... import *`. */
    predicate import_star_pointsTo(ImportStarRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(CfgOrigin orig |
            origin = orig.fix(def.getDefiningNode())
            |
            exists(ModuleObjectInternal mod, string name |
                PointsTo2::pointsTo(def.getDefiningNode().(ImportStarNode).getModule(), context, mod, _) and
                name = def.getSourceVariable().getName() |
                /* Attribute from imported module */
                module_exports_boolean(mod, name) = true and
                mod.attribute(name, value, origin)
            )
            or
            exists(EssaVariable var |
                /* Retain value held before import */
                variable_not_redefined_by_import_star(var, context, def) and
                PointsTo2::ssa_variable_pointsTo(var, context, value,orig)
            )
        )
    }


    /** Holds if `def` is technically a definition of `var`, but the `from ... import *` does not in fact define `var`. */
    cached predicate variable_not_redefined_by_import_star(EssaVariable var, PointsToContext context, ImportStarRefinement def) {
        var = def.getInput() and
        exists(ModuleObjectInternal mod |
            PointsTo2::pointsTo(def.getDefiningNode().(ImportStarNode).getModule(), context, mod, _) |
            module_exports_boolean(mod, var.getSourceVariable().getName()) = false
            or
            exists(Module m, string name |
                m = mod.getSourceModule() and name = var.getSourceVariable().getName() |
                not m.declaredInAll(_) and name.charAt(0) = "_"
            )
        )
    }

    private predicate importsByImportStar(ModuleObjectInternal mod, ModuleObjectInternal imported) {
        exists(ImportStarNode isn |
            PointsTo2::pointsTo(isn.getModule(), _, imported, _) and
            isn.getScope() = mod.getSourceModule()
        )
        or exists(ModuleObjectInternal mid |
            importsByImportStar(mod, mid) and importsByImportStar(mid, imported)
        )
    }

    private predicate ofInterestInModule(ModuleObjectInternal mod, string name) {
        exists(ImportStarNode isn, Module m |
            m = mod.getSourceModule() and
            isn.getScope() = m and
            exists(EssaVariable var | var.getAUse() = isn and var.getName() = name)
        )
    }

    private predicate ofInterestInExports(ModuleObjectInternal mod, string name) {
        exists(ModuleObjectInternal importer |
            importsByImportStar(importer, mod) and
            ofInterestInModule(importer, name)
        )
    }

    private boolean module_exports_boolean(ModuleObjectInternal mod, string name) {
        ofInterestInExports(mod, name) and
        exists(Module src |
            src = mod.getSourceModule()
            |
            if exists(SsaVariable var | name = var.getId() and var.getAUse() = src.getANormalExit()) then
                result = true
            else (
                exists(ImportStarNode isn, ModuleObjectInternal imported |
                    isn.getScope() = src and
                    PointsTo2::pointsTo(isn.getModule(), _, imported, _) and
                    result = module_exports_boolean(imported, name)
                )
                or
                not exists(ImportStarNode isn |isn.getScope() = src) and result = false
            )
        )
        or
        ofInterestInExports(mod, name) and
        exists(Folder folder |
            mod.(PackageObjectInternal).hasNoInitModule() and
            folder = mod.(PackageObjectInternal).getFolder() |
            if (exists(folder.getChildContainer(name)) or exists(folder.getFile(name + ".py"))) then
                result = true
            else
                result = false
        )
        or
        name = "__name__" and result = true
    }

}

module InterProceduralPointsTo {

    pragma [noinline]
    predicate call_pointsTo(CallNode f, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(ObjectInternal func, CfgOrigin resultOrigin |
            PointsTo2::pointsTo(f.getFunction(), context, func, _) and
            origin = resultOrigin.fix(f)
            |
            exists(PointsToContext callee |
                callee.fromCall(f, context) and
                func.callResult(callee, value, resultOrigin)
            )
            or
            func.callResult(value, resultOrigin)
        )
    }

    /** Points-to for parameter. `def foo(param): ...`. */
    pragma [noinline]
    predicate parameter_pointsTo(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        positional_parameter_pointsTo(def, context, value, origin)
        or
        named_parameter_pointsTo(def, context, value, origin)
        or
        default_parameter_pointsTo(def, context, value, origin)
        or
        special_parameter_pointsTo(def, context, value, origin)
    }

    /** Helper for `parameter_pointsTo` */
    pragma [noinline]
    private predicate positional_parameter_pointsTo(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(PointsToContext caller, ControlFlowNode arg |
            PointsTo2::pointsTo(arg, caller, value, origin) and
            callsite_argument_transfer(arg, caller, def, context)
        )
        or
        not def.isSelf() and not def.getParameter().isVarargs() and not def.getParameter().isKwargs() and
        context.isRuntime() and value = ObjectInternal::unknown() and origin = def.getDefiningNode()
    }


    /** Helper for `parameter_pointsTo` */
    pragma [noinline]
    private predicate named_parameter_pointsTo(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(CallNode call, PointsToContext caller, PythonFunctionObjectInternal func, string name |
            context.fromCall(call, func, caller) and
            def.getParameter() = func.getScope().getArgByName(name) and
            PointsTo2::pointsTo(call.getArgByName(name), caller, value, origin)
        )
    }

    /** Helper for parameter_pointsTo */
    private predicate default_parameter_pointsTo(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        exists(PointsToContext imp | imp.isImport() | PointsTo2::pointsTo(def.getDefault(), imp, value, origin)) and
        context_for_default_value(def, context)
    }

    /** Helper for default_parameter_pointsTo */
    pragma [noinline]
    private predicate context_for_default_value(ParameterDefinition def, PointsToContext context) {
        context.isRuntime()
        or
        exists(PointsToContext caller, CallNode call, PythonFunctionObjectInternal func, int n |
            context.fromCall(call, func, caller) and
            func.getScope().getArg(n) = def.getParameter() and
            not exists(call.getArg(n)) and
            not exists(call.getArgByName(def.getParameter().asName().getId())) and
            not exists(call.getNode().getKwargs()) and
            not exists(call.getNode().getStarargs())
        )
    }

    /** Helper for parameter_pointsTo */
    pragma [noinline]
    private predicate special_parameter_pointsTo(ParameterDefinition def, PointsToContext context, ObjectInternal value, ControlFlowNode origin) {
        context.isRuntime() and
        origin = def.getDefiningNode() and
        exists(ControlFlowNode param |
            param = def.getDefiningNode() |
            exists(Function func | func.getVararg() = param.getNode()) and value = TUnknownInstance(ObjectInternal::builtin("tuple"))
            or
            exists(Function func | func.getKwarg() = param.getNode()) and value = TUnknownInstance(ObjectInternal::builtin("dict"))
        )
        or
        exists(PointsToContext caller, CallNode call, Function f, Parameter p |
            context.fromCall(call, caller) and
            context.appliesToScope(f) and
            f.getAnArg() = p and p = def.getParameter() and
            not p.isSelf() and
            not exists(call.getArg(p.getPosition())) and
            not exists(call.getArgByName(p.getName())) and
            (exists(call.getNode().getKwargs()) or exists(call.getNode().getStarargs())) and
            value = ObjectInternal::unknown() and origin = def.getDefiningNode()
        )
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
        callee.fromCall(call, caller) and
        exists(ObjectInternal func |
            PointsTo2::pointsTo(call.getFunction(), caller, func, _) and
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
    predicate callsite_pointsTo(CallsiteRefinement def, PointsToContext context, ObjectInternal value, CfgOrigin origin) {
        exists(SsaSourceVariable srcvar |
            srcvar = def.getSourceVariable() |
            if srcvar instanceof EscapingAssignmentGlobalVariable then (
                /* If global variable can be reassigned, we need to track it through calls */
                exists(EssaVariable var, Function func, PointsToContext callee |
                    callsite_calls_function(def.getCall(), context, func, callee, _) and
                    var_at_exit(srcvar, func, var) and
                    PointsTo2::ssa_variable_pointsTo(var, callee, value, origin)
                )
                or
                exists(ObjectInternal callable |
                    PointsTo2::pointsTo(def.getCall().getFunction(), context, callable, _) and
                    exists(callable.getBuiltin()) and
                    PointsTo2::ssa_variable_pointsTo(def.getInput(), context, value, origin)
                )
            ) else (
                /* Otherwise we can assume its value (but not those of its attributes or members) has not changed. */
                PointsTo2::ssa_variable_pointsTo(def.getInput(), context, value, origin)
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

}

/** Gets the `value, origin` that `f` would refer to if it has not been assigned some other value */
pragma [noinline]
private predicate potential_builtin_pointsTo(NameNode f, ObjectInternal value, ControlFlowNode origin) {
    f.isGlobal() and f.isLoad() and origin = f and
    (
        value = ObjectInternal::builtin(f.getId())
        or
        not exists(Builtin::builtin(f.getId())) and value = ObjectInternal::unknown()
    )
}

private module Conditionals {

    /** Holds if `expr` is the operand of a unary `not` expression. */
    private ControlFlowNode not_operand(ControlFlowNode expr) {
        expr.(UnaryExprNode).getNode().getOp() instanceof Not and
        result = expr.(UnaryExprNode).getOperand()
    }

    boolean branchEvaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, ObjectInternal val, ControlFlowNode origin) {
        contains_interesting_expression_within_test(expr, use) and
        PointsTo2::pointsTo(use, context, val, origin) and
        expr = use and
        val.booleanValue() = result
        or
        result = comparisonEvaluatesTo(expr, use, context, val, origin)
        or
        result = branchEvaluatesTo(not_operand(expr), use, context, val, origin).booleanNot()
    }

    boolean comparisonEvaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, ObjectInternal val, ControlFlowNode origin) {
        result = equalityEvaluatesTo(expr, use, context, val, origin)
        or
        result = inequalityEvaluatesTo(expr, use, context, val, origin)
        // or
        //result = isinstance_test_evaluates_boolean(expr, use, context, val, origin)
        //or
        //result = issubclass_test_evaluates_boolean(expr, use, context, val, origin)
        //or
        //result = callable_test_evaluates_boolean(expr, use, context, val, origin)
        //or
        //result = hasattr_test_evaluates_boolean(expr, use, context, val, origin)
    }

    pragma [noinline]
    private boolean equalityEvaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, ObjectInternal val, ControlFlowNode origin) {
        exists(ControlFlowNode r, boolean sense |
            equality_test(expr, use, sense, r) and
            exists(ObjectInternal other |
                PointsTo2::pointsTo(use, context, val, origin) and
                PointsTo2::pointsTo(r, context, other, _) |
                val.isComparable() = true and other.isComparable() = true and
                (
                    other = val and result = sense
                    or
                    other != val and result = sense.booleanNot()
                )
                or
                val.isComparable() = false and result = maybe()
                or
                other.isComparable() = false and result = maybe()
            )
        )
    }

    pragma [noinline]
    private boolean inequalityEvaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, ObjectInternal val, ControlFlowNode origin) {
        exists(ControlFlowNode r, boolean sense |
            exists(boolean strict, ObjectInternal other |
                (
                    inequality(expr, use, r, strict) and sense = true
                    or
                    inequality(expr, r, use, strict) and sense = false
                ) and
                PointsTo2::pointsTo(use, context, val, origin) and
                PointsTo2::pointsTo(r, context, other, _)
                |
                val.intValue() < other.intValue() and result = sense
                or 
                val.intValue() > other.intValue() and result = sense.booleanNot()
                or
                val.intValue() = other.intValue() and result = strict.booleanXor(sense)
                or
                val.strValue() < other.strValue() and result = sense
                or 
                val.strValue() > other.strValue() and result = sense.booleanNot()
                or
                val.strValue() = other.strValue() and result = strict.booleanXor(sense)
                or
                val.isComparable() = false and result = maybe()
                or
                other.isComparable() = false and result = maybe()
            )

        )
    }

    /** Helper for comparisons. */
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

    cached ClassObjectInternal getBase(ClassObjectInternal cls, int n) {
        result.getBuiltin() = cls.getBuiltin().getBaseClass() and n = 0
        or
        exists(Class pycls |
            pycls = cls.(PythonClassObjectInternal).getScope() |
            PointsTo2::pointsTo(pycls.getBase(n).getAFlowNode(), _, result, _)
            or
            not exists(pycls.getABase()) and n = 0 and
            isNewStyle(cls) and result = ObjectInternal::builtin("object")
        )
        or
        cls = ObjectInternal::unknownClass() and n = 0 and
        result = ObjectInternal::builtin("object")
    }

    cached predicate isOldStyle(ClassObjectInternal cls) {
        //To do...
        none()
    }

    cached predicate isNewStyle(ClassObjectInternal cls) {
        //To do...
        any()
    }

    cached ClassList getMro(ClassObjectInternal cls) {
        isNewStyle(cls) and
        result = Mro::newStyleMro(cls)
        or
        // To do, old-style
        none()
    }

    cached predicate declaredAttribute(ClassObjectInternal cls, string name, ObjectInternal value, CfgOrigin origin) {
        value = ObjectInternal::fromBuiltin(cls.getBuiltin().getMember(name)) and origin = CfgOrigin::unknown()
        or
        value != ObjectInternal::undefined() and
        exists(EssaVariable var |
            name = var.getName() and
            var.getAUse() = cls.(PythonClassObjectInternal).getScope().getANormalExit() and
            PointsTo2::ssa_variable_pointsTo(var, _, value, origin)
        )
    }

    cached ClassObjectInternal getMetaClass(PythonClassObjectInternal cls) {
            result = declaredMetaClass(cls)
            or
            hasDeclaredMetaclass(cls) = false and result = getInheritedMetaclass(cls)
    }

    private ClassObjectInternal declaredMetaClass(PythonClassObjectInternal cls) {
        exists(ObjectInternal obj |
            PointsTo2::ssa_variable_pointsTo(metaclass_var(cls.getScope()), _, obj, _) |
            result = obj
            or
            obj = ObjectInternal::unknown() and result = ObjectInternal::unknownClass()
        )
        or
        exists(ControlFlowNode meta |
            six_add_metaclass(_, cls, meta) and
            PointsTo2::pointsTo(meta, _, result, _)
        )
    }

    private boolean hasDeclaredMetaclass(PythonClassObjectInternal cls) {
        result = has_six_add_metaclass(cls).booleanOr(has_metaclass_var_metaclass(cls))
    }

    private boolean has_six_add_metaclass(PythonClassObjectInternal cls) {
        // TO DO...
        result = false
    }

    private boolean has_metaclass_var_metaclass(PythonClassObjectInternal cls) {
        exists(ObjectInternal obj |
            PointsTo2::ssa_variable_pointsTo(metaclass_var(cls.getScope()), _, obj, _) |
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

    /** INTERNAL -- Do not use */
    cached predicate six_add_metaclass(CallNode decorator_call, ClassObjectInternal decorated, ControlFlowNode metaclass) {
        //TO DO...
        none()
        //exists(CallNode decorator |
        //    decorator_call.getArg(0) = decorated and
        //    decorator = decorator_call.getFunction() and
        //    decorator.getArg(0) = metaclass |
        //    PointsTo2::pointsTo(decorator.getFunction(), _, six_add_metaclass_function(), _)
        //    or
        //    exists(ModuleObjectInternal six |
        //       six.getName() = "six" and
        //       PointsTo2::pointsTo(decorator.getFunction().(AttrNode).getObject("add_metaclass"), _, six, _)
        //   )
        //)
    }

    private ObjectInternal six_add_metaclass_function() {
        exists(Module six, FunctionExpr add_metaclass |
            add_metaclass.getInnerScope().getName() = "add_metaclass" and
            add_metaclass.getScope() = six and
            result.getOrigin() = add_metaclass.getAFlowNode()
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
        exists(int i |
            exists(cls.(PythonClassObjectInternal).getScope().getBase(i)) and reason = "Missing base " + i
            |
            not exists(getBase(cls, i))
        )
        or
        exists(cls.(PythonClassObjectInternal).getScope().getMetaClass()) and not exists(cls.getClass()) and reason = "Failed to infer metaclass"
        or
        exists(int i | failedInference(getBase(cls, i), _) and reason = "Failed inference for base class at position " + i)
        or
        exists(int i, ObjectInternal base1, ObjectInternal base2 |
            base1 = getBase(cls, i) and
            base2 = getBase(cls, i) and
            base1 != base2 and
            reason = "Multiple bases at position " + i
        )
        or
        exists(int i, int j | getBase(cls, i) = getBase(cls, j) and i != j and reason = "Duplicate bases classes")
    }

}



