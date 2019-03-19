import python

private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.Filters
private import semmle.python.pointsto.PointsToContext2

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
        if this = unknownValue() then
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
        result = unknownValue()
    }

}

module PointsTo2 {

    /** INTERNAL -- Use `f.refersTo(value, origin)` instead. */
    predicate points_to(ControlFlowNode f, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        points_to_candidate(f, context, value, origin) and
        reachableBlock(f.getBasicBlock(), context)
    }

    predicate points_to_candidate(ControlFlowNode f, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        use_points_to(f, context, value, origin)
        or
        subscript_points_to(f, context, value, origin)
        or
        binary_expr_points_to(f, context, value, origin)
        or
        origin = f and compare_expr_points_to(f, context, value)
        or
        origin = f and unary_points_to(f, context, value)
        or
        origin = f and value.introduced(f, context)
        or
        InterModulePointsTo::import_points_to(f, context, value, origin)
        or
        InterModulePointsTo::from_import_points_to(f, context, value, origin)
        or
        InterProceduralPointsTo::call_points_to(f, context, value, origin)
        // To do... More stuff here :)
        // or
        // f.(CustomPointsToFact).pointsTo(context, value, origin)
    }

    cached CallNode get_a_call(ObjectInternal func, PointsToContext2 context) {
        points_to(result.getFunction(), context, func, _)
    }

    /* Holds if BasicBlock `b` is reachable, given the context `context`. */
    predicate reachableBlock(BasicBlock b, PointsToContext2 context) {
        context.appliesToScope(b.getScope()) and not exists(ConditionBlock guard | guard.controls(b, _))
        or
        exists(ConditionBlock guard |
            guard = b.getImmediatelyControllingBlock() and
            reachableBlock(guard, context)
            |
            exists(ObjectInternal value |
                points_to(guard.getLastNode(), context, value, _)
                |
                guard.controls(b, _) and value.maybe()
                or
                guard.controls(b, true) and value.booleanValue() = true
                or
                guard.controls(b, false) and value.booleanValue() = false
            )
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

    /* Holds if the edge `pred` -> `succ` is reachable, given the context `context`.
     */
    predicate controlledReachableEdge(BasicBlock pred, BasicBlock succ, PointsToContext2 context) {
        exists(ConditionBlock guard, ObjectInternal value |
            points_to(guard.getLastNode(), context, value, _)
            |
            guard.controlsEdge(pred, succ, _) and value.maybe()
            or
            guard.controlsEdge(pred, succ, true) and value.booleanValue() = true
            or
            guard.controlsEdge(pred, succ, false) and value.booleanValue() = false
        )
    }

    /** Gets an object pointed to by a use (of a variable). */
    private predicate use_points_to(NameNode f, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        exists(CfgOrigin origin_or_obj |
            value != ObjectInternal::undefined() and
            use_points_to_maybe_origin(f, context, value, origin_or_obj) |
            origin = origin_or_obj.asCfgNodeOrHere(f)
        )
    }

    private predicate use_points_to_maybe_origin(NameNode f, PointsToContext2 context, ObjectInternal value, CfgOrigin origin_or_obj) {
        ssa_variable_points_to(fast_local_variable(f), context, value,  origin_or_obj)
        or
        name_lookup_points_to_maybe_origin(f, context, value, origin_or_obj)
        or
        not exists(fast_local_variable(f)) and not exists(name_local_variable(f)) and
        global_lookup_points_to_maybe_origin(f, context, value, origin_or_obj)
    }

    /** Holds if `var` refers to `(value, origin)` given the context `context`. */
    predicate ssa_variable_points_to(EssaVariable var, PointsToContext2 context, ObjectInternal value, CfgOrigin origin) {
        ssa_definition_points_to(var.getDefinition(), context, value, origin)
    }

    private predicate name_lookup_points_to_maybe_origin(NameNode f, PointsToContext2 context, ObjectInternal value, CfgOrigin origin_or_obj) {
        exists(EssaVariable var | var = name_local_variable(f) |
            ssa_variable_points_to(var, context, value, origin_or_obj)
        )
        or
        local_variable_undefined(f, context) and
        global_lookup_points_to_maybe_origin(f, context, value, origin_or_obj)
    }

    pragma [noinline]
    private predicate local_variable_undefined(NameNode f, PointsToContext2 context) {
        ssa_variable_points_to(name_local_variable(f), context, ObjectInternal::undefined(), _)
    }

    private predicate global_lookup_points_to_maybe_origin(NameNode f, PointsToContext2 context, ObjectInternal value, CfgOrigin origin_or_obj) {
        ssa_variable_points_to(global_variable(f), context, value, origin_or_obj)
        or
        exists(ControlFlowNode origin |
            origin_or_obj = CfgOrigin::fromCfgNode(origin)
            |
            ssa_variable_points_to(global_variable(f), context, ObjectInternal::undefined(), _) and
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

    /** Holds if the ESSA definition `def`  refers to `(value, origin)` given the context `context`. */
    predicate ssa_definition_points_to(EssaDefinition def, PointsToContext2 context, ObjectInternal value, CfgOrigin origin) {
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
    private predicate ssa_node_definition_points_to(EssaNodeDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        reachableBlock(def.getDefiningNode().getBasicBlock(), _) and
        ssa_node_definition_points_to_unpruned(def, context, value, origin)
    }

    pragma [nomagic]
    private predicate ssa_node_definition_points_to_unpruned(EssaNodeDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        InterProceduralPointsTo::parameter_points_to(def, context, value, origin)
        or
        assignment_points_to(def, context, value, origin)
        //// TO DO...
        // or
        // self_parameter_points_to(def, context, value, origin)
        // or
        // delete_points_to(def, context, value, origin)
        // or
        // module_name_points_to(def, context, value, origin)
        or
        scope_entry_points_to(def, context, value, origin)
        // or
        // implicit_submodule_points_to(def, context, value, origin)
        // or
        // iteration_definition_points_to(def, context, value, origin)
        /*
         * No points-to for non-local function entry definitions yet.
         */
    }

    pragma [noinline]
    private predicate ssa_node_refinement_points_to(EssaNodeRefinement def, PointsToContext2 context, ObjectInternal value, CfgOrigin origin) {
        //method_callsite_points_to(def, context, value, origin)
        //or
        //import_star_points_to(def, context, value, origin)
        //or
        //attribute_assignment_points_to(def, context, value, origin)
        //or
        //callsite_points_to(def, context, value, origin)
        //or
        //argument_points_to(def, context, value, origin)
        //or
        //attribute_delete_points_to(def, context, value, origin)
        //or
        uni_edged_phi_points_to(def, context, value, origin)
    }

    /** Holds if ESSA edge refinement, `def`, refers to `(value, cls, origin)`. */
    predicate ssa_filter_definition_points_to(PyEdgeRefinement def, PointsToContext2 context, ObjectInternal value, CfgOrigin origin) {
        exists(ControlFlowNode test, ControlFlowNode use |
            refinement_test(test, use, Conditionals::evaluatesTo(test, use, context, value, origin.toCfgNode()), def)
        )
    }

    /** Holds if ESSA definition, `uniphi`, refers to `(value, origin)`. */
    pragma [noinline]
    predicate uni_edged_phi_points_to(SingleSuccessorGuard uniphi, PointsToContext2 context, ObjectInternal value, CfgOrigin origin) {
        exists(ControlFlowNode test, ControlFlowNode use |
            /* Because calls such as `len` may create a new variable, we need to go via the source variable
             * That is perfectly safe as we are only dealing with calls that do not mutate their arguments.
             */
            use = uniphi.getInput().getSourceVariable().(Variable).getAUse() and
            test = uniphi.getDefiningNode() and
            uniphi.getSense() = Conditionals::evaluatesTo(test, use, context, value, origin.toCfgNode())
        )
    }

    /** Points-to for normal assignments `def = ...`. */
    pragma [noinline]
    private predicate assignment_points_to(AssignmentDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        points_to(def.getValue(), context, value, origin)
    }


    /** Holds if the phi-function `phi` refers to `(value, origin)` given the context `context`. */
    pragma [nomagic]
    private predicate ssa_phi_points_to(PhiFunction phi, PointsToContext2 context, ObjectInternal value, CfgOrigin origin) {
        exists(EssaVariable input, BasicBlock pred |
            input = phi.getInput(pred) and
            ssa_variable_points_to(input, context, value, origin)
            |
            controlledReachableEdge(pred, phi.getBasicBlock(), context)
            or
            not exists(ConditionBlock guard | guard.controlsEdge(pred, phi.getBasicBlock(), _))
        )
        or
        ssa_variable_points_to(phi.getShortCircuitInput(), context, value, origin)
    }

    /** Points-to for implicit variable declarations at scope-entry. */
    pragma [noinline]
    private predicate scope_entry_points_to(ScopeEntryDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        /* Transfer from another scope */
        exists(EssaVariable var, PointsToContext2 outer, CfgOrigin orig |
            InterProceduralPointsTo::scope_entry_value_transfer(var, outer, def, context) and
            ssa_variable_points_to(var, outer, value, orig) and
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

    private predicate subscript_points_to(SubscriptNode sub, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        points_to(sub.getValue(), context, ObjectInternal::unknown(), _) and
        value = ObjectInternal::unknown() and origin = sub
    }

    /** Track bitwise expressions so we can handle integer flags and enums.
     * Tracking too many binary expressions is likely to kill performance.
     */
    private predicate binary_expr_points_to(BinaryExprNode b, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        // TO DO...
        // Track some integer values through `|` and the types of some objects
        none()
    }


    private predicate compare_expr_points_to(CompareNode cmp, PointsToContext2 context, ObjectInternal value) {
        exists(ControlFlowNode a, ControlFlowNode b, ObjectInternal o1, ObjectInternal o2 |
            exists(boolean is |
                equality_test(cmp, a, is, b) and
                points_to(a, context, o1, _) and
                points_to(b, context, o2, _) |
                (o1.isComparable() and o2.isComparable()) and
                (
                    o1 = o2 and value = ObjectInternal::bool(is)
                    or
                    o1 != o2 and value = ObjectInternal::bool(is.booleanNot())
                )
                or
                (o1.notComparable() or o2.notComparable()) and
                value = ObjectInternal::bool(_)
            )
            or
            exists(boolean strict |
                inequality(cmp, a, b, strict) and
                points_to(a, context, o1, _) and
                points_to(b, context, o2, _) |
                o1.intValue() < o2.intValue() and value = ObjectInternal::bool(true)
                or 
                o1.intValue() > o2.intValue() and value = ObjectInternal::bool(false)
                or
                o1.intValue() = o2.intValue() and value = ObjectInternal::bool(strict.booleanNot())
                or
                o1.strValue() < o2.strValue() and value = ObjectInternal::bool(true)
                or 
                o1.strValue() > o2.strValue() and value = ObjectInternal::bool(false)
                or
                o1.strValue() = o2.strValue() and value = ObjectInternal::bool(strict.booleanNot())
            )
           // or
           // value = version_tuple_compare(cmp, context)
        )
    }

    /** Helper for comparisons. */
    predicate inequality(CompareNode cmp, ControlFlowNode lesser, ControlFlowNode greater, boolean strict) {
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

    private predicate unary_points_to(UnaryExprNode f, PointsToContext2 context, ObjectInternal value) {
        exists(Unaryop op, ObjectInternal operand |
            op = f.getNode().getOp() and
            points_to(f.getOperand(), context, operand, _)
            |
            op instanceof Not and operand.maybe() and value = ObjectInternal::bool(_)
            or
            op instanceof Not and operand.booleanValue() = false and value = ObjectInternal::bool(true)
            or
            op instanceof Not and operand.booleanValue() = true and value = ObjectInternal::bool(false)
            or
            op instanceof USub and value = ObjectInternal::fromInt(-operand.intValue())
            or
            operand = ObjectInternal::unknown() and value = operand
        )
    }

}

module InterModulePointsTo {

    predicate import_points_to(ControlFlowNode f, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        exists(string name, ImportExpr i |
            i.getAFlowNode() = f and i.getImportedModuleName() = name and
            module_imported_as(value, name) and
            origin = f and
            context.appliesTo(f)
        )
    }

    predicate from_import_points_to(ImportMemberNode f, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        exists(string name, ModuleObjectInternal mod, CfgOrigin orig |
            PointsTo2::points_to(f.getModule(name), context, mod, _) and
            origin = orig.asCfgNodeOrHere(f)
            |
            // TO DO... $ variables.
            //mod.getSourceModule() = f.getEnclosingModule() and
            //not exists(EssaVariable var | var.getSourceVariable().getName() = name and var.getAUse() = f) and
            //exists(EssaVariable dollar |
            //    isModuleStateVariable(dollar) and dollar.getAUse() = f and
            //    SSA::ssa_variable_named_attribute_points_to(dollar, context, name, value, orig)
            //)
            //or
            (mod.getSourceModule() != f.getEnclosingModule() or mod.isBuiltin()) and
            module_attribute_points_to(mod, name, value, orig)
        )
        or
        exists(EssaVariable var, CfgOrigin orig |
            var = ssa_variable_for_module_attribute(f, context) and
            PointsTo2::ssa_variable_points_to(var, context, value, orig) and
            origin = orig.asCfgNodeOrHere(f)
        )
    }

    private EssaVariable ssa_variable_for_module_attribute(ImportMemberNode f, PointsToContext2 context) {
        exists(string name, ModuleObjectInternal mod, Module m |
            mod.getSourceModule() = m and m = f.getEnclosingModule() and m = result.getScope() and
            PointsTo2::points_to(f.getModule(name), context, mod, _) and
            result.getSourceVariable().getName() = name and result.getAUse() = f
        )
    }

    /* Holds if `import name` will import the module `m`. */
    private predicate module_imported_as(ModuleObjectInternal m, string name) {
        /* Normal imports */
        m.getName() = name
        or
        /* sys.modules['name'] = m */
        exists(ControlFlowNode sys_modules_flow, ControlFlowNode n, ControlFlowNode mod |
          /* Use previous points-to here to avoid slowing down the recursion too much */
          exists(SubscriptNode sub |
              sub.getValue() = sys_modules_flow and
              PointsTo2::points_to(sys_modules_flow, _, ObjectInternal::sysModules(), _) and
              sub.getIndex() = n and
              n.getNode().(StrConst).getText() = name and
              sub.(DefinitionNode).getValue() = mod and
              PointsTo2::points_to(mod, _, m, _)
          )
        )
    }

    /** Holds if `mod.name` points to `(value, origin)`, where `mod` is a module object. */
    predicate module_attribute_points_to(ModuleObjectInternal mod, string name, ObjectInternal value, CfgOrigin origin) {
        py_module_attributes(mod.getSourceModule(), name, value, origin)
        or
        package_attribute_points_to(mod, name, value, origin)
        or
        value.getBuiltin() = mod.getBuiltin().getMember(name) and
        origin = CfgOrigin::unknown()
    }

    /** Holds if `m.name` points to `(value, origin)`, where `m` is a (source) module. */
    cached predicate py_module_attributes(Module m, string name, ObjectInternal obj, CfgOrigin origin) {
        exists(EssaVariable var, ControlFlowNode exit, PointsToContext2 imp |
            exit =  m.getANormalExit() and var.getAUse() = exit and
            var.getSourceVariable().getName() = name and
            PointsTo2::ssa_variable_points_to(var, imp, obj, origin) and
            imp.isImport() and
            obj != ObjectInternal::undefined()
        )
        // TO DO, dollar variable...
        //or
        //not exists(EssaVariable var | var.getAUse() = m.getANormalExit() and var.getSourceVariable().getName() = name) and
        //exists(EssaVariable var, PointsToContext2 imp |
        //    var.getAUse() = m.getANormalExit() and isModuleStateVariable(var) |
        //    PointsTo2::ssa_variable_named_attribute_points_to(var, imp, name, obj, origin) and
        //    imp.isImport() and obj != ObjectInternal::undefined()
        //)
    }

    /** Holds if `package.name` points to `(value, origin)`, where `package` is a package object. */
    cached predicate package_attribute_points_to(PackageObjectInternal package, string name, ObjectInternal value, CfgOrigin origin) {
        py_module_attributes(package.getInitModule().getSourceModule(), name, value, origin)
        or
        // TO DO
        //exists(Module init |
        //    init = package.getInitModule().getModule() and
        //    not exists(EssaVariable var | var.getAUse() = init.getANormalExit() and var.getSourceVariable().getName() = name) and
        //    exists(EssaVariable var, Context context |
        //        isModuleStateVariable(var) and var.getAUse() = init.getANormalExit() and
        //        context.isImport() and
        //        SSA::ssa_variable_named_attribute_points_to(var, context, name, undefinedVariable(), _, _) and
        //        origin = value and
        //        value = package.submodule(name)
        //    )
        //)
        //or
        package.hasNoInitModule() and
        exists(ModuleObjectInternal mod |
            mod = package.submodule(name) and
            value = mod |
            origin = CfgOrigin::fromCfgNode(mod.getSourceModule().getEntryNode())
            or
            mod.isBuiltin() and origin = CfgOrigin::unknown()
        )
    }

}

module InterProceduralPointsTo {

    predicate call_points_to(CallNode f, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        exists(ObjectInternal func,  PointsToContext2 callee, CfgOrigin resultOrigin |
            callee.fromCall(f, context) and
            PointsTo2::points_to(f.getFunction(), context, func, _) and
            func.callResult(callee, value, resultOrigin) and
            origin = resultOrigin.fix(f)
        )
    }

    /** Points-to for parameter. `def foo(param): ...`. */
    pragma [noinline]
    predicate parameter_points_to(ParameterDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        positional_parameter_points_to(def, context, value, origin)
        or
        named_parameter_points_to(def, context, value, origin)
        or
        default_parameter_points_to(def, context, value, origin)
        // or
        // special_parameter_points_to(def, context, value, origin)
    }

    /** Helper for `parameter_points_to` */
    pragma [noinline]
    private predicate positional_parameter_points_to(ParameterDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        exists(PointsToContext2 caller, ControlFlowNode arg |
            PointsTo2::points_to(arg, caller, value, origin) and
            callsite_argument_transfer(arg, caller, def, context)
        )
        or
        not def.isSelf() and not def.getParameter().isVarargs() and not def.getParameter().isKwargs() and
        context.isRuntime() and value = ObjectInternal::unknown() and origin = def.getDefiningNode()
    }


    /** Helper for `parameter_points_to` */
    pragma [noinline]
    private predicate named_parameter_points_to(ParameterDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        exists(CallNode call, PointsToContext2 caller, PythonFunctionObjectInternal func, string name |
            context.fromCall(call, func, caller) and
            def.getParameter() = func.getScope().getArgByName(name) and
            PointsTo2::points_to(call.getArgByName(name), caller, value, origin)
        )
    }

    /** Helper for parameter_points_to */
    private predicate default_parameter_points_to(ParameterDefinition def, PointsToContext2 context, ObjectInternal value, ControlFlowNode origin) {
        exists(PointsToContext2 imp | imp.isImport() | PointsTo2::points_to(def.getDefault(), imp, value, origin)) and
        context_for_default_value(def, context)
    }

    /** Helper for default_parameter_points_to */
    pragma [noinline]
    private predicate context_for_default_value(ParameterDefinition def, PointsToContext2 context) {
        context.isRuntime()
        or
        exists(PointsToContext2 caller, CallNode call, PythonFunctionObjectInternal func, int n |
            context.fromCall(call, func, caller) and
            func.getScope().getArg(n) = def.getParameter() and
            not exists(call.getArg(n)) and
            not exists(call.getArgByName(def.getParameter().asName().getId())) and
            not exists(call.getNode().getKwargs()) and
            not exists(call.getNode().getStarargs())
        )
    }

    /** Holds if the `(argument, caller)` pair matches up with `(param, callee)` pair across call. */
    cached predicate callsite_argument_transfer(ControlFlowNode argument, PointsToContext2 caller, ParameterDefinition param, PointsToContext2 callee) {
        exists(CallNode call, Function func, int n, int offset |
            callsite_calls_function(call, caller, func, callee, offset) and
            argument = call.getArg(n) and
            param.getParameter() = func.getArg(n+offset)
        )
    }

    cached predicate callsite_calls_function(CallNode call, PointsToContext2 caller, Function scope, PointsToContext2 callee, int parameter_offset) {
        callee.fromCall(call, caller) and
        exists(ObjectInternal func |
            PointsTo2::points_to(call.getFunction(), caller, func, _) and
            func.calleeAndOffset(scope, parameter_offset)
        )
    }

    /** Model the transfer of values at scope-entry points. Transfer from `(pred_var, pred_context)` to `(succ_def, succ_context)`. */
    cached predicate scope_entry_value_transfer(EssaVariable pred_var, PointsToContext2 pred_context, ScopeEntryDefinition succ_def, PointsToContext2 succ_context) {
        scope_entry_value_transfer_from_earlier(pred_var, pred_context, succ_def, succ_context)
        // TO DO...
        //or
        //callsite_entry_value_transfer(pred_var, pred_context, succ_def, succ_context)
        //or
        //pred_context.isImport() and pred_context = succ_context and
        //class_entry_value_transfer(pred_var, succ_def)
    }

    /** Helper for `scope_entry_value_transfer`. Transfer of values from a temporally earlier scope to later scope.
     * Earlier and later scopes are, for example, a module and functions in that module, or an __init__ method and another method. */
    pragma [noinline]
    private predicate scope_entry_value_transfer_from_earlier(EssaVariable pred_var, PointsToContext2 pred_context, ScopeEntryDefinition succ_def, PointsToContext2 succ_context) {
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

}

/** Gets the `value, origin` that `f` would refer to if it has not been assigned some other value */
pragma [noinline]
private predicate potential_builtin_points_to(NameNode f, ObjectInternal value, ControlFlowNode origin) {
    f.isGlobal() and f.isLoad() and origin = f and
    (
        value = ObjectInternal::builtin(f.getId())
        or
        not exists(Object::builtin(f.getId())) and value = ObjectInternal::unknown()
    )
}

/** Get the ESSA pseudo-variable used to retain module state
 * during module initialization. Module attributes are handled 
 * as attributes of this variable, allowing the SSA form to track 
 * mutations of the module during its creation.
 */
private predicate isModuleStateVariable(EssaVariable var) {
    var.getName() = "$" and var.getScope() instanceof Module
}

module Conditionals {

    /** Holds if `expr` is the operand of a unary `not` expression. */
    private ControlFlowNode not_operand(ControlFlowNode expr) {
        expr.(UnaryExprNode).getNode().getOp() instanceof Not and
        result = expr.(UnaryExprNode).getOperand()
    }

    private boolean maybe() {
        result = true or result = false
    }

    boolean evaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext2 context, ObjectInternal val, ControlFlowNode origin) {
        //result = isinstance_test_evaluates_boolean(expr, use, context, val, origin)
        //or
        //result = issubclass_test_evaluates_boolean(expr, use, context, val, origin)
        //or
        result = equalityEvaluatesTo(expr, use, context, val, origin)
        or
        result = inequalityEvaluatesTo(expr, use, context, val, origin)
        or
        //result = callable_test_evaluates_boolean(expr, use, context, val, origin)
        //or
        //result = hasattr_test_evaluates_boolean(expr, use, context, val, origin)
        //or
        result = evaluatesTo(not_operand(expr), use, context, val, origin).booleanNot()
        or
        //result = true and evaluates_int(expr, use, context, val, origin) != 0
        //or
        //result = false and evaluates_int(expr, use, context, val, origin) = 0
        //or
        result = boolEvaluatesTo(expr, use, context, val, origin)
    }

    pragma [noinline]
    private boolean boolEvaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext2 context, ObjectInternal val, ControlFlowNode origin) {
        contains_interesting_expression_within_test(expr, use) and
        PointsTo2::points_to(use, context, val, origin) and
        expr = use and
        (
            val.booleanValue() = result
            or
            val.maybe() and result = maybe()
        )
    }

    pragma [noinline]
    private boolean equalityEvaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext2 context, ObjectInternal val, ControlFlowNode origin) {
        exists(ControlFlowNode r, boolean sense |
            contains_interesting_expression_within_test(expr, use) |
            equality_test(expr, use, sense, r) and
            exists(ObjectInternal other |
                PointsTo2::points_to(use, context, val, origin) and
                PointsTo2::points_to(r, context, other, _) |
                val.isComparable() and other.isComparable() and
                (
                    other = val and result = sense
                    or
                    other != val and result = sense.booleanNot()
                )
                or
                val.notComparable() and result = maybe()
                or
                other.notComparable() and result = maybe()
            )
        )
    }

    pragma [noinline]
    private boolean inequalityEvaluatesTo(ControlFlowNode expr, ControlFlowNode use, PointsToContext2 context, ObjectInternal val, ControlFlowNode origin) {
        exists(ControlFlowNode r, boolean sense |
            contains_interesting_expression_within_test(expr, use) |
            exists(boolean strict, ObjectInternal other |
                (
                    PointsTo2::inequality(expr, use, r, strict) and sense = true
                    or
                    PointsTo2::inequality(expr, r, use, strict) and sense = false
                ) and
                PointsTo2::points_to(use, context, val, origin) and
                PointsTo2::points_to(r, context, other, _) 
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
            )

        )
    }

}
