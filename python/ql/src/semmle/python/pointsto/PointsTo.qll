/**
 * Part of the combined points-to, call-graph and type-inference library.
 * The main relation `points_to(node, context, object, cls, origin)` relates a control flow node
 * to the possible objects it points-to the inferred types of those objects and the 'origin'
 * of those objects. The 'origin' is the point in source code that the object can be traced
 * back to.
 *
 * The predicates provided are not intended to be used directly (although they are available to the advanced user), but are exposed in the user API as methods on key classes.
 *
 * For example, the most important predicate in the points-to relation is:
 * ```ql
 * predicate PointsTo::points_to(ControlFlowNode f, PointsToContext ctx, Object value, ClassObject cls, ControlFlowNode origin)
 * ```
 * Where `f` is the control flow node representing something that might hold a value. `ctx` is the context in which `f` "points-to" `value` and may be "general" or from a specific call-site.
 * `value` is a static approximation to a value, such as a number, a class, or an object instantiation.
 * `cls` is the class of this value if known, or `theUnknownType()` which is an internal `ClassObject` and should not be exposed to the general QL user.
 * `origin` is the point in the source from where `value` originates and is useful when presenting query results.
 *
 * The `PointsTo::points_to` relation is exposed at the user API level as
 * ```ql
 * ControlFlowNode.refersTo(Context context, Object value, ClassObject cls, ControlFlowNode origin)
 * ```
 *
 */

import python
private import PointsToContext
private import Base
private import semmle.python.types.Extensions
private import Filters as BaseFilters
import semmle.dataflow.SSA
private import MRO

/** Get a `ControlFlowNode` from an object or `here`.
 * If the object is a ControlFlowNode then use that, otherwise fall back on `here`
 */
pragma[inline]
private ControlFlowNode origin_from_object_or_here(ObjectOrCfg object, ControlFlowNode here) {
    result = object
    or
    not object instanceof ControlFlowNode and result = here
}

module PointsTo {

    cached module API {

        /** INTERNAL -- Use `FunctionObject.getACall()`.
         *
         * Gets a call to `func` with the given context. */
        cached CallNode get_a_call(FunctionObject func, PointsToContext context) {
            function_call(func, context, result)
            or
            method_call(func, context, result)
        }

        /** INTERNAL -- Use `FunctionObject.getAFunctionCall()`.
         *
         * Holds if `call` is a function call to `func` with the given context. */
        cached predicate function_call(FunctionObject func, PointsToContext context, CallNode call) {
            points_to(call.getFunction(), context, func, _, _)
        }

        /** INTERNAL -- Use `FunctionObject.getAMethodCall()`.
         *
         * Holds if `call` is a method call to `func` with the given context.  */
        cached predicate method_call(FunctionObject func, PointsToContext context, CallNode call) {
            Calls::plain_method_call(func, context, call)
            or
            Calls::super_method_call(context, call, _, func)
            or
            class_method_call(_, _, func, context, call)
        }

        /** INTERNAL -- Use `ClassMethod.getACall()` instead */
        cached predicate class_method_call(Object cls_method, ControlFlowNode attr, FunctionObject func, PointsToContext context, CallNode call) {
            exists(ClassObject cls, string name |
                attr = call.getFunction() and
                Types::class_attribute_lookup(cls, name, cls_method, _, _) |
                Calls::receiver_type_for(cls, name, attr, context)
                or
                points_to(attr.(AttrNode).getObject(name), context, cls, _, _)
            ) and
            class_method(cls_method, func)
        }

        /** INTERNAL -- Use `ClassMethod` instead */
        cached predicate class_method(Object cls_method, FunctionObject method) {
            decorator_call(cls_method, theClassMethodType(), method)
        }

        pragma [nomagic]
        private predicate decorator_call(Object method, ClassObject decorator, FunctionObject func) {
            exists(CallNode f, PointsToContext imp |
                method = f and imp.isImport() and
                points_to(f.getFunction(), imp, decorator, _, _) and
                points_to(f.getArg(0), imp, func, _, _)
            )
        }

        /** INTERNAL -- Use `f.refersTo(value, cls, origin)` instead. */
        cached predicate points_to(ControlFlowNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            points_to_candidate(f, context, value, cls, origin) and
            Layer::reachableBlock(f.getBasicBlock(), context)
        }

        /** Gets the value that `expr` evaluates to (when converted to a boolean) when `use` refers to `(val, cls, origin)`
         * and `expr` is a test (a branch) and contains `use`. */
        cached boolean test_evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            test_contains(expr, use) and
            result = Filters::evaluates(expr, use, context, val, cls, origin)
        }

        /** INTERNAL -- Do not use.
         *
         * Holds if `package.name` points to `(value, cls, origin)`, where `package` is a package object. */
        cached predicate package_attribute_points_to(PackageObject package, string name, Object value, ClassObject cls, ObjectOrCfg origin) {
            py_module_attributes(package.getInitModule().getModule(), name, value, cls, origin)
            or
            exists(Module init |
                init = package.getInitModule().getModule() and
                not exists(EssaVariable var | var.getAUse() = init.getANormalExit() and var.getSourceVariable().getName() = name) and
                exists(EssaVariable var, Context context |
                    isModuleStateVariable(var) and var.getAUse() = init.getANormalExit() and
                    context.isImport() and
                    SSA::ssa_variable_named_attribute_points_to(var, context, name, undefinedVariable(), _, _) and
                    origin = value and
                    value = package.submodule(name) and
                    cls = theModuleType()
                )
            )
            or
            package.hasNoInitModule() and
            value = package.submodule(name) and cls = theModuleType() and origin = value
        }

        /** INTERNAL -- `Use m.attributeRefersTo(name, obj, origin)` instead.
         *
         * Holds if `m.name` points to `(value, cls, origin)`, where `m` is a (source) module. */
        cached predicate py_module_attributes(Module m, string name, Object obj, ClassObject cls, ControlFlowNode origin) {
            exists(EssaVariable var, ControlFlowNode exit, ObjectOrCfg orig, PointsToContext imp |
                exit =  m.getANormalExit() and var.getAUse() = exit and
                var.getSourceVariable().getName() = name and
                ssa_variable_points_to(var, imp, obj, cls, orig) and
                imp.isImport() and
                obj != undefinedVariable() |
                origin = origin_from_object_or_here(orig, exit)
            )
            or
            not exists(EssaVariable var | var.getAUse() = m.getANormalExit() and var.getSourceVariable().getName() = name) and
            exists(EssaVariable var, PointsToContext imp |
                var.getAUse() = m.getANormalExit() and isModuleStateVariable(var) |
                SSA::ssa_variable_named_attribute_points_to(var, imp, name, obj, cls, origin) and
                imp.isImport() and obj != undefinedVariable()
            )
        }

        /** INTERNAL -- Use `ModuleObject.hasAttribute(name)`
         *
         *  Whether the module defines name. */
        cached predicate module_defines_name(Module mod, string name) {
            module_defines_name_boolean(mod, name) = true
        }

        /** INTERNAL -- Use `Version.isTrue()` instead.
         *
         * Holds if `cmp` points to a test on version that is `value`.
         * For example, if `cmp` is `sys.version[0] < "3"` then for, Python 2, `value` would be `true`. */
        cached predicate version_const(CompareNode cmp, PointsToContext context, boolean value) {
            exists(ControlFlowNode fv, ControlFlowNode fc, Object val |
                comparison(cmp, fv, fc, _) and
                points_to(cmp, context, val, _, _) and
                value = val.booleanValue()
                |
                sys_version_info_slice(fv, context, _)
                or
                sys_version_info_index(fv, context, _, _)
                or
                sys_version_string_char0(fv, context, _, _)
                or
                points_to(fv, context, theSysHexVersionNumber(), _, _)
            )
            or
            value = version_tuple_compare(cmp, context).booleanValue()
        }

        /** INTERNAL -- Use `FunctionObject.getArgumentForCall(call, position)` instead.  */
        cached ControlFlowNode get_positional_argument_for_call(FunctionObject func, PointsToContext context, CallNode call, int position) {
            result = Calls::get_argument_for_call_by_position(func, context, call, position)
            or
            exists(string name |
                result = Calls::get_argument_for_call_by_name(func, context, call, name) and
                func.getFunction().getArg(position).asName().getId() = name
            )
        }

        /** INTERNAL -- Use `FunctionObject.getNamedArgumentForCall(call, name)` instead.  */
        cached ControlFlowNode get_named_argument_for_call(FunctionObject func, PointsToContext context, CallNode call, string name) {
          (
            result = Calls::get_argument_for_call_by_name(func, context, call, name)
            or
            exists(int position |
                result = Calls::get_argument_for_call_by_position(func, context, call, position) and
                func.getFunction().getArg(position).asName().getId() = name
            )
          )
        }

        /** INTERNAL -- Use `FunctionObject.neverReturns()` instead.
         *  Whether function `func` never returns. Slightly conservative approximation, this predicate may be false
         * for a function that can never return. */
        cached predicate function_never_returns(FunctionObject func) {
            /* A Python function never returns if it has no normal exits that are not dominated by a
             * call to a function which itself never returns.
             */
            function_can_never_return(func)
            or
            exists(Function f |
                f = func.getFunction()
                |
                forall(BasicBlock exit |
                    exit = f.getANormalExit().getBasicBlock() |
                    exists(FunctionObject callee, BasicBlock call  |
                        get_a_call(callee, _).getBasicBlock() = call and
                        function_never_returns(callee) and
                        call.dominates(exit)
                    )
                )
            )
        }

        /** INTERNAL -- Use `m.importedAs(name)` instead.
         *
         * Holds if `import name` will import the module `m`. */
        cached predicate module_imported_as(ModuleObject m, string name) {
            /* Normal imports */
            m.getName() = name
            or
            /* sys.modules['name'] = m */
            exists(ControlFlowNode sys_modules_flow, ControlFlowNode n, ControlFlowNode mod |
              /* Use previous points-to here to avoid slowing down the recursion too much */
              exists(SubscriptNode sub, Object sys_modules |
                  sub.getValue() = sys_modules_flow and
                  points_to(sys_modules_flow, _, sys_modules, _, _) and
                  builtin_module_attribute(theSysModuleObject(), "modules", sys_modules, _) and
                  sub.getIndex() = n and
                  n.getNode().(StrConst).getText() = name and
                  sub.(DefinitionNode).getValue() = mod and
                  points_to(mod, _, m, _, _)
              )
            )
        }

        /** Holds if `call` is of the form `getattr(arg, "name")`. */
        cached predicate getattr(CallNode call, ControlFlowNode arg, string name) {
            points_to(call.getFunction(), _, builtin_object("getattr"), _, _) and
            call.getArg(1).getNode().(StrConst).getText() = name and
            arg = call.getArg(0)
        }

        /** Holds if `f` is the instantiation of an object, `cls(...)`.  */
        cached predicate instantiation(CallNode f, PointsToContext context, ClassObject cls) {
            points_to(f.getFunction(), context, cls, _, _) and
            cls != theTypeType() and
            Types::callToClassWillReturnInstance(cls)
        }

        /** Holds if `var` refers to `(value, cls, origin)` given the context `context`. */
        cached predicate ssa_variable_points_to(EssaVariable var, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            SSA::ssa_definition_points_to(var.getDefinition(), context, value, cls, origin)
        }

    }

    predicate name_maybe_imported_from(ModuleObject mod, string name) {
        exists(Module m, ImportStar s |
            has_import_star(m, s, mod) |
            exists(Variable var | name = var.getId() and var.getScope() = s.getScope())
            or
            exists(ModuleObject other |
                name_maybe_imported_from(other, name) and other.getModule() = m
            )
        )
        or
        exists(ImportMemberNode imp |
            points_to(imp.getModule(name), _, mod, _, _)
        )
        or
        exists(PackageObject pack |
            pack.getInitModule() = mod |
            name_maybe_imported_from(pack, name)
        )
        or
        exists(mod.(PackageObject).submodule(name))
        or
        exists(PackageObject package |
            package.getInitModule() = mod and
            exists(package.submodule(name))
        )
        or
        module_exports(mod, name)
        or
        name = "__name__"
    }

    private boolean module_defines_name_boolean(Module m, string name) {
        exists(ModuleObject mod |
            m = mod.getModule() |
            exists(SsaVariable var | name = var.getId() and var.getAUse() = m.getANormalExit()) and result = true
            or
            name_maybe_imported_from(mod, name) and not any(ImportStar i).getScope() = m and result = false and
            not exists(SsaVariable var | name = var.getId() and var.getAUse() = m.getANormalExit()) and
            not exists(PackageObject pack |
                pack.getInitModule() = mod and
                exists(pack.submodule(name))
            )
            or
            exists(Object obj |
                obj != undefinedVariable() and
                py_module_attributes(mod.getModule(), name, obj, _, _)
            ) and result = true
            or
            exists(ImportStarNode isn, ModuleObject imported |
                isn.getScope() = m and
                points_to(isn.getModule(), _, imported, _, _) and
                module_exports(imported, name)
            ) and result = true
        )
        or
        name = "__name__" and result = true
    }

    private boolean py_module_exports_boolean(ModuleObject mod, string name) {
        exists(Module m |
            m = mod.getModule() |
            /* Explicitly declared in __all__ */
            m.declaredInAll(name) and result = true
            or
            /* No __all__ and name is defined and public */
            not m.declaredInAll(_) and name.charAt(0) != "_" and
            result = module_defines_name_boolean(m, name)
            or
            /* May be imported from this module, but not declared in __all__ */
            name_maybe_imported_from(mod, name) and m.declaredInAll(_) and not m.declaredInAll(name) and
            result = false
        )
    }

    private boolean package_exports_boolean(PackageObject pack, string name) {
        explicitly_imported(pack.submodule(name)) and
        (
            pack.hasNoInitModule()
            or
            exists(ModuleObject init |
                pack.getInitModule() = init |
                not init.getModule().declaredInAll(_) and name.charAt(0) != "_"
            )
        ) and result = true
        or
        result = module_exports_boolean(pack.getInitModule(), name)
    }

    /** INTERNAL -- Use `m.exports(name)` instead. */
    cached predicate module_exports(ModuleObject mod, string name) {
        module_exports_boolean(mod, name) = true
    }

    private boolean module_exports_boolean(ModuleObject mod, string name) {
        py_cmembers_versioned(mod, name, _, major_version().toString()) and
        name.charAt(0) != "_" and result = true
        or
        result = package_exports_boolean(mod, name)
        or
        result = py_module_exports_boolean(mod, name)
    }

    /** Predicates in this layer need to visible to the next layer, but not otherwise */
    private module Layer {

        /* Holds if BasicBlock `b` is reachable, given the context `context`. */
       predicate reachableBlock(BasicBlock b, PointsToContext context) {
            context.appliesToScope(b.getScope()) and
            forall(ConditionBlock guard |
                guard.controls(b, _) |
                exists(Object value |
                    points_to(guard.getLastNode(), context, value, _, _)
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
        predicate controlledReachableEdge(BasicBlock pred, BasicBlock succ, PointsToContext context) {
            exists(ConditionBlock guard, Object value |
                points_to(guard.getLastNode(), context, value, _, _)
                |
                guard.controlsEdge(pred, succ, _) and value.maybe()
                or
                guard.controlsEdge(pred, succ, true) and value.booleanValue() = true
                or
                guard.controlsEdge(pred, succ, false) and value.booleanValue() = false
            )
        }

        /** Holds if `mod.name` points to `(value, cls, origin)`, where `mod` is a module object. */
        predicate module_attribute_points_to(ModuleObject mod, string name, Object value, ClassObject cls, ObjectOrCfg origin) {
            py_module_attributes(mod.getModule(), name, value, cls, origin)
            or
            package_attribute_points_to(mod, name, value, cls, origin)
            or
            builtin_module_attribute(mod, name, value, cls) and origin = value
        }

    }

    import API

    /* Holds if `f` points to a test on the OS that is `value`.
     * For example, if `f` is `sys.platform == "win32"` then, for Windows, `value` would be `true`.
     */
    private predicate os_const(ControlFlowNode f, PointsToContext context, boolean value) {
        exists(string os |
            os_test(f, os, context) |
            value = true and py_flags_versioned("sys.platform", os, major_version().toString())
            or
            value = false and not py_flags_versioned("sys.platform", os, major_version().toString())
        )
    }

    /** Points-to before pruning. */
    pragma [nomagic]
    private predicate points_to_candidate(ControlFlowNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        simple_points_to(f, value, cls, origin) and context.appliesToScope(f.getScope())
        or
        f.isClass() and value = f  and origin = f and context.appliesToScope(f.getScope()) and
        cls = Types::class_get_meta_class(value)
        or
        exists(boolean b |
            os_const(f, context, b)
            |
            value = theTrueObject() and b = true
            or
            value = theFalseObject() and b = false
        ) and cls = theBoolType() and origin = f
        or
        import_points_to(f, value, origin) and cls = theModuleType() and context.appliesToScope(f.getScope())
        or
        attribute_load_points_to(f, context, value, cls, origin)
        or
        getattr_points_to(f, context, value, cls, origin)
        or
        if_exp_points_to(f, context, value, cls, origin)
        or
        from_import_points_to(f, context, value, cls, origin)
        or
        use_points_to(f, context, value, cls, origin)
        or
        def_points_to(f, context, value, cls, origin)
        or
        Calls::call_points_to(f, context, value, cls, origin)
        or
        subscript_points_to(f, context, value, cls, origin)
        or
        sys_version_info_slice(f, context, cls) and value = theSysVersionInfoTuple() and origin = f
        or
        sys_version_info_index(f, context, value, cls) and origin = f
        or
        sys_version_string_char0(f, context, value, cls) and origin = f
        or
        six_metaclass_points_to(f, context, value, cls, origin)
        or
        binary_expr_points_to(f, context, value, cls, origin)
        or
        compare_expr_points_to(f, context, value, cls, origin)
        or
        not_points_to(f, context, value, cls, origin)
        or
        value.(SuperCall).instantiation(context, f) and f = origin and cls = theSuperType()
        or
        value.(SuperBoundMethod).instantiation(context, f) and f = origin and cls = theBoundMethodType()
        or
        exists(boolean b |
            b = Filters::evaluates_boolean(f, _, context, _, _, _)
            |
            value = theTrueObject() and b = true
            or
            value = theFalseObject() and b = false
        ) and cls = theBoolType() and origin = f
        or
        f.(CustomPointsToFact).pointsTo(context, value, cls, origin)
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

    private predicate use_points_to_maybe_origin(NameNode f, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin_or_obj) {
        ssa_variable_points_to(fast_local_variable(f), context, value, cls, origin_or_obj)
        or
        name_lookup_points_to_maybe_origin(f, context, value, cls, origin_or_obj)
        or
        not exists(fast_local_variable(f)) and not exists(name_local_variable(f)) and
        global_lookup_points_to_maybe_origin(f, context, value, cls, origin_or_obj)
    }

    pragma [noinline]
    private predicate local_variable_undefined(NameNode f, PointsToContext context) {
        ssa_variable_points_to(name_local_variable(f), context, undefinedVariable(), _, _)
    }

    private predicate name_lookup_points_to_maybe_origin(NameNode f, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin_or_obj) {
        exists(EssaVariable var | var = name_local_variable(f) |
            ssa_variable_points_to(var, context, value, cls, origin_or_obj)
        )
        or
        local_variable_undefined(f, context) and
        global_lookup_points_to_maybe_origin(f, context, value, cls, origin_or_obj)
    }

    private predicate global_lookup_points_to_maybe_origin(NameNode f, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin_or_obj) {
        ssa_variable_points_to(global_variable(f), context, value, cls, origin_or_obj)
        or
        ssa_variable_points_to(global_variable(f), context, undefinedVariable(), _, _) and
        potential_builtin_points_to(f, value, cls, origin_or_obj)
        or
        not exists(global_variable(f)) and context.appliesToScope(f.getScope()) and
        potential_builtin_points_to(f, value, cls, origin_or_obj)
    }

    /** Gets an object pointed to by a use (of a variable). */
    private predicate use_points_to(NameNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(ObjectOrCfg origin_or_obj |
            value != undefinedVariable() and
            use_points_to_maybe_origin(f, context, value, cls, origin_or_obj) |
            origin = origin_from_object_or_here(origin_or_obj, f)
        )
    }

    /** Gets an object pointed to by the definition of an ESSA variable. */
    private predicate def_points_to(DefinitionNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        points_to(f.getValue(), context, value, cls, origin)
    }

    /** Holds if `f` points to `@six.add_metaclass(cls)\nclass ...`. */
    private predicate six_metaclass_points_to(ControlFlowNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(ControlFlowNode meta |
            Types::six_add_metaclass(f, value, meta) and
            points_to(meta, context, cls, _, _)
        ) and
        origin = value
    }

    /** Holds if `obj.name` points to `(value, cls, orig)`. */
    pragma [noinline]
    private predicate class_or_module_attribute(Object obj, string name, Object value, ClassObject cls, ObjectOrCfg orig) {
        /* Normal class attributes */
        Types::class_attribute_lookup(obj, name, value, cls, orig) and cls != theStaticMethodType() and cls != theClassMethodType()
        or
        /* Static methods of the class */
        exists(CallNode sm | Types::class_attribute_lookup(obj, name, sm, theStaticMethodType(), _) and sm.getArg(0) = value and cls = thePyFunctionType() and orig = value)
        or
        /* Module attributes */
        Layer::module_attribute_points_to(obj, name, value, cls, orig)
    }

    /** Holds if `f` points to `(value, cls, origin)` where `f` is an instance attribute, `x.attr`. */
    pragma [nomagic]
    private predicate instance_attribute_load_points_to(AttrNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        f.isLoad() and
        exists(string name |
            named_attribute_points_to(f.getObject(name), context, name, value, cls, origin)
            or
            /* Static methods on the class of the instance */
            exists(CallNode sm, ClassObject icls |
                points_to(f.getObject(name), context, _, icls, _) and
                Types::class_attribute_lookup(icls, name, sm, theStaticMethodType(), _) and sm.getArg(0) = value and cls = thePyFunctionType() and origin = value
            )
            or
            /* Unknown instance attributes */
            exists(Object x, ClassObject icls, ControlFlowNode obj_node |
                obj_node = f.getObject(name) and
                not obj_node.(NameNode).isSelf() and
                points_to(obj_node, context, x, icls, _) and
                (not x instanceof ModuleObject and not x instanceof ClassObject) and
                not icls.isBuiltin() and
                value = unknownValue() and cls = theUnknownType() and origin = f
            )
        )
    }

    pragma[noinline]
    private predicate receiver_object(AttrNode  f, PointsToContext context, Object cls_or_mod, string name) {
        f.isLoad() and
        exists(ControlFlowNode fval|
            fval = f.getObject(name) and
            points_to(fval, context, cls_or_mod, _, _) |
            cls_or_mod instanceof ClassObject or
            cls_or_mod instanceof ModuleObject
        )
    }

    /** Holds if `f` is an attribute `x.attr` and points to `(value, cls, origin)`. */
    private predicate attribute_load_points_to(AttrNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        instance_attribute_load_points_to(f, context, value, cls, origin)
        or
        exists(Object cls_or_mod, string name, ObjectOrCfg orig |
            receiver_object(f, context, cls_or_mod, name) and
            class_or_module_attribute(cls_or_mod, name, value, cls, orig) and
            origin = origin_from_object_or_here(orig, f)
        )
        or
        points_to(f.getObject(), context, unknownValue(), theUnknownType(), origin) and value = unknownValue() and cls = theUnknownType()
        or
        exists(CustomPointsToAttribute object, string name |
            points_to(f.getObject(name), context, object, _, _) and
            object.attributePointsTo(name, value, cls, origin)
        )
    }

    /** Holds if `f` is an expression node `tval if cond else fval` and points to `(value, cls, origin)`. */
    private predicate if_exp_points_to(IfExprNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        points_to(f.getAnOperand(), context, value, cls, origin)
    }

    /** Holds if `f` is an import expression, `import mod` and points to `(value, cls, origin)`. */
    private predicate import_points_to(ControlFlowNode f, ModuleObject value, ControlFlowNode origin) {
        exists(string name, ImportExpr i |
            i.getAFlowNode() = f and i.getImportedModuleName() = name and
            module_imported_as(value, name) and
            origin = f
        )
    }

    /** Holds if `f` is a "from import" expression, `from mod import x` and points to `(value, cls, origin)`. */
    pragma [nomagic]
    private predicate from_import_points_to(ImportMemberNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(string name, ModuleObject mod, ObjectOrCfg orig |
            points_to(f.getModule(name), context, mod, _, _) and
            origin = origin_from_object_or_here(orig, f)
            |
            mod.getSourceModule() = f.getEnclosingModule() and
            exists(EssaVariable var |
                var.getSourceVariable().getName() = name and var.getAUse() = f and
                ssa_variable_points_to(var, context, value, cls, orig)
            )
            or
            mod.getSourceModule() = f.getEnclosingModule() and
            not exists(EssaVariable var | var.getSourceVariable().getName() = name and var.getAUse() = f) and
            exists(EssaVariable dollar |
                isModuleStateVariable(dollar) and dollar.getAUse() = f and
                SSA::ssa_variable_named_attribute_points_to(dollar, context, name, value, cls, orig)
            )
            or
            not mod.getSourceModule() = f.getEnclosingModule() and
            Layer::module_attribute_points_to(mod, name, value, cls, orig)
        )
    }

    /** Holds if `f`  is of the form `getattr(x, "name")` and x.name points to `(value, cls, origin)`. */
    private predicate getattr_points_to(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(ControlFlowNode arg, string name |
            named_attribute_points_to(arg, context, name, value, cls, origin) and
            getattr(f, arg, name)
        )
    }

    /** Whether the module is explicitly imported somewhere. */
    private predicate explicitly_imported(ModuleObject mod) {
        exists(ImportExpr ie | module_imported_as(mod, ie.getAnImportedModuleName()))
        or
        exists(ImportMember im | module_imported_as(mod, im.getImportedModuleName()))
    }

    /** Holds if an import star exists in the module m that imports the module `imported_module`, such that the flow from the import reaches the module exit. */
    private predicate has_import_star(Module m, ImportStar im, ModuleObject imported_module) {
        exists(string name |
            module_imported_as(imported_module, name) and
            name = im.getImportedModuleName() and
            im.getScope() = m and
            im.getAFlowNode().getBasicBlock().reachesExit()
        )
    }

    /** Track bitwise expressions so we can handle integer flags and enums.
     * Tracking too many binary expressions is likely to kill performance.
     */
    private predicate binary_expr_points_to(BinaryExprNode b, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        cls = theIntType() and
        exists(ControlFlowNode left, ControlFlowNode right |
            bitwise_expression_node(b, left, right) and
            points_to(left, context, _, cls, _) and
            points_to(right, context, _, cls, _)
        ) and
        value = origin and origin = b
    }

    pragma [noinline]
    private predicate incomparable_values(CompareNode cmp, PointsToContext context) {
        exists(ControlFlowNode left, ControlFlowNode right |
            cmp.operands(left, _, right) and
            exists(Object lobj, Object robj |
                points_to(left, context, lobj, _, _) and
                points_to(right, context, robj, _, _) |
                not Filters::comparable_value(lobj)
                or
                not Filters::comparable_value(robj)
            )
        )
    }

    pragma [noinline]
    private Object in_tuple(CompareNode cmp, PointsToContext context) {
        exists(ControlFlowNode left, ControlFlowNode right |
            cmp.operands(left, any(In i), right) and
            exists(Object lobj, TupleObject tuple |
                points_to(left, context, lobj, _, _) and
                points_to(right, context, tuple, _, _)
                |
                lobj = tuple.getBuiltinElement(_) and result = theTrueObject()
                or
                not lobj = tuple.getBuiltinElement(_) and result = theFalseObject()
            )
        )
    }

    pragma [noinline]
    private predicate const_compare(CompareNode cmp, PointsToContext context, int comp, boolean strict) {
        exists(ControlFlowNode left, ControlFlowNode right |
            inequality(cmp, left, right, strict) and
            (
                exists(NumericObject n1, NumericObject n2 |
                    points_to(left, context, n1, _, _) and
                    points_to(right, context, n2, _, _) and
                    comp = int_compare(n1, n2)
                )
                or
                exists(StringObject s1, StringObject s2|
                    points_to(left, context, s1, _, _) and
                    points_to(right, context, s2, _, _) and
                    comp = string_compare(s1, s2)
                )
            )
        )
    }

    pragma [noinline]
    private Object version_tuple_compare(CompareNode cmp, PointsToContext context) {
        exists(ControlFlowNode lesser, ControlFlowNode greater, boolean strict |
            inequality(cmp, lesser, greater, strict) and
            exists(TupleObject tuple, int comp |
                points_to(lesser, context, tuple, _, _) and
                points_to(greater, context, theSysVersionInfoTuple(), _, _) and
                comp = version_tuple_compare(tuple)
                or
                points_to(lesser, context, theSysVersionInfoTuple(), _, _) and
                points_to(greater, context, tuple, _, _) and
                comp = version_tuple_compare(tuple)*-1
                |
                comp = -1 and result = theTrueObject()
                or
                comp = 0 and strict = false and result = theTrueObject()
                or
                comp = 0 and strict = true and result = theFalseObject()
                or
                comp = 1 and result = theFalseObject()
            )
        )
    }

    /** Holds if `cls` is an element of the tuple referred to by `f`.
     * Helper for relevant_subclass_relation
     */
    private predicate element_of_points_to_tuple(ControlFlowNode f, PointsToContext context, ClassObject cls) {
        exists(TupleObject t |
            points_to(f, context, t, _, _) |
            cls = t.getBuiltinElement(_)
            or
            points_to(t.getSourceElement(_), _, cls, _, _)
        )
    }

    private predicate compare_expr_points_to(CompareNode cmp, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        equality_expr_points_to(cmp, context, value, cls, origin)
        or
        cls = theBoolType() and origin = cmp and
        (
            incomparable_values(cmp, context) and
            (value = theFalseObject() or value = theTrueObject())
            or
            value = in_tuple(cmp, context)
            or
            exists(int comp, boolean strict |
                const_compare(cmp, context, comp, strict)
                |
                comp = -1 and value = theTrueObject()
                or
                comp = 0 and strict = false and value = theTrueObject()
                or
                comp = 0 and strict = true and value = theFalseObject()
                or
                comp = 1 and value = theFalseObject()
            )
            or
            value = version_tuple_compare(cmp, context)
        )
    }

    pragma[inline]
    private int int_compare(NumericObject n1, NumericObject n2) {
        exists(int i1, int i2 |
            i1 = n1.intValue() and i2 = n2.intValue() |
            i1 = i2 and result = 0
            or
            i1 < i2 and result = -1
            or
            i1 > i2 and result = 1
        )
    }

    pragma[inline]
    private int string_compare(StringObject s1, StringObject s2) {
        exists(string a, string b |
            a = s1.getText() and b = s2.getText() |
            a = b and result = 0
            or
            a < b and result = -1
            or
            a > b and result = 1
        )
    }

    private predicate not_points_to(UnaryExprNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        f.getNode().getOp() instanceof Not and
        cls = theBoolType() and origin = f and
        exists(Object operand |
            points_to(f.getOperand(), context, operand, _, _)
            |
            operand.maybe() and value = theTrueObject()
            or
            operand.maybe() and value = theFalseObject()
            or
            operand.booleanValue() = false and value = theTrueObject()
            or
            operand.booleanValue() = true and value = theFalseObject()
        )
    }

    private predicate equality_expr_points_to(CompareNode cmp, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        cls = theBoolType() and origin = cmp and
        exists(ControlFlowNode x, ControlFlowNode y, Object xobj, Object yobj, boolean is |
            BaseFilters::equality_test(cmp, x, is, y) and
            points_to(x, context, xobj, _, _) and
            points_to(y, context, yobj, _, _) and
            Filters::equatable_value(xobj) and Filters::equatable_value(yobj)
            |
            xobj = yobj and is = true and value = theTrueObject()
            or
            xobj != yobj and is = true and value = theFalseObject()
            or
            xobj = yobj and is = false and value = theFalseObject()
            or
            xobj != yobj and is = false and value = theTrueObject()
        )
    }

    private predicate subscript_points_to(SubscriptNode sub, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(Object unknownCollection |
            varargs_points_to(unknownCollection, _) or
            kwargs_points_to(unknownCollection, _)
            |
            sub.isLoad() and
            points_to(sub.getValue(), context, unknownCollection, _, _) and
            value = unknownValue() and cls = theUnknownType() and origin = sub
        )
        or
        points_to(sub.getValue(), context, unknownValue(), _, _) and
        value = unknownValue() and cls = theUnknownType() and origin = sub
    }

    /* **************
     * VERSION INFO *
     ****************/

    /** Holds if `s` points to `sys.version_info[0]`. */
    private predicate sys_version_info_index(SubscriptNode s, PointsToContext context, NumericObject value, ClassObject cls) {
        points_to(s.getValue(), context, theSysVersionInfoTuple(), _, _) and
        exists(NumericObject zero |
            zero.intValue() = 0 |
            points_to(s.getIndex(), context, zero, _, _)
        ) and
        value.intValue() = major_version() and
        cls = theIntType()
    }

    /** Holds if `s` points to `sys.version_info[:x]` or `sys.version_info[:]`. */
    private predicate sys_version_info_slice(SubscriptNode s, PointsToContext context, ClassObject cls) {
        points_to(s.getValue(), context, theSysVersionInfoTuple(), cls, _) and
        exists(Slice index | index = s.getIndex().getNode() |
            not exists(index.getStart())
        )
    }

    /** Holds if `s` points to `sys.version[0]`. */
    private predicate sys_version_string_char0(SubscriptNode s, PointsToContext context, Object value, ClassObject cls) {
        points_to(s.getValue(), context, theSysVersionString(), cls, _) and
        exists(NumericObject zero |
            zero.intValue() = 0 |
            points_to(s.getIndex(), context, zero, _, _)
        )
        and
        value = object_for_string(major_version().toString())
    }

    /* Version tests. Ignore micro and release parts. Treat major, minor as a single version major*10+minor
     * Currently cover versions 0.9 to 4.0
     */

    /** Helper for `version_const`. */
    private predicate comparison(CompareNode cmp, ControlFlowNode fv, ControlFlowNode fc, string opname) {
        exists(Cmpop op |
            cmp.operands(fv, op, fc) and opname = op.getSymbol()
            or
            cmp.operands(fc, op, fv) and opname = reversed(op)
        )
    }

    /** Helper for `version_const`. */
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

    /** Holds if `f` is a test for the O/S. */
    private predicate os_test(ControlFlowNode f, string os, PointsToContext context) {
        exists(ControlFlowNode c |
             os_compare(c, os) and
             points_to(f, context, _, _, c)
        )
    }

    predicate named_attribute_points_to(ControlFlowNode f, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
        exists(EssaVariable var |
            var.getAUse() = f |
            SSA::ssa_variable_named_attribute_points_to(var, context, name, value, cls, origin)
        )
        or
        exists(ClassObject c, EssaVariable self, Function init |
            instantiation(f, context, c) and
            init = c.getPyClass().getInitMethod() and
            self.getAUse() = init.getANormalExit() and
            SSA::ssa_variable_named_attribute_points_to(self, context, name, value, cls, origin)
        )
    }

    private module Calls {

         /** Holds if `f` is a call to type() with a single argument `arg` */
         private predicate call_to_type(CallNode f, ControlFlowNode arg, PointsToContext context) {
             points_to(f.getFunction(), context, theTypeType(), _, _) and not exists(f.getArg(1)) and arg = f.getArg(0)
         }

         pragma [noinline]
         predicate call_to_type_known_python_class_points_to(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             exists(ControlFlowNode arg |
                 call_to_type(f, arg, context) and
                 points_to(arg, context, _, value, _)
             ) and
             origin.getNode() = value.getOrigin() and
             cls = theTypeType()
         }

         pragma [noinline]
         predicate call_to_type_known_builtin_class_points_to(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             exists(ControlFlowNode arg |
                 call_to_type(f, arg, context) |
                 points_to(arg, context, _, value, _)
             ) and
             not exists(value.getOrigin()) and
             origin = f and cls = theTypeType()
         }

         pragma [noinline]
         predicate call_points_to_builtin_function(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             exists(BuiltinCallable b |
                 b != builtin_object("isinstance") and
                 b != builtin_object("issubclass") and
                 b != builtin_object("callable") and
                 f = get_a_call(b, context) and
                 cls = b.getAReturnType()
             ) and
             f = origin and
             (
                cls = theNoneType() and value = theNoneObject()
                or
                cls != theNoneType() and value = f
             )
         }

         /** Holds if call is to an object that always returns its first argument.
          * Typically, this is for known decorators and the like.
          * The current implementation only accounts for instances of `zope.interface.declarations.implementer` and
          * calls to `functools.wraps(fn)`.
          */
        private predicate annotation_call(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            points_to(f.getArg(0), context, value, cls, origin) and
            (
                points_to(f.getFunction(), context, _, zopeInterfaceImplementer(), _)
                or
                points_to(f.getFunction().(CallNode).getFunction(), context, functoolsWraps(), _, _)
            )
         }

         private ClassObject zopeInterfaceImplementer() {
             result.getName() = "implementer" and
             result.getPyClass().getEnclosingModule().getName() = "zope.interface.declarations"
         }

         private PyFunctionObject functoolsWraps() {
             result.getName() = "wraps" and
             result.getFunction().getEnclosingModule().getName() = "functools"
         }

         pragma [noinline]
         predicate call_to_procedure_points_to(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             exists(PyFunctionObject func |
                 f = get_a_call(func, context) and
                 implicitly_returns(func, value, cls) and origin.getNode() = func.getOrigin()
             )
         }

        predicate call_to_unknown(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            value = unknownValue() and cls = theUnknownType() and origin = f
            and
            exists(ControlFlowNode callable |
                callable = f.getFunction() or
                callable = f.getFunction().(AttrNode).getObject()
                |
                points_to(callable, context, unknownValue(), _, _)
            )
        }

        predicate call_to_type_new(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            points_to(f.getFunction(), context, theTypeNewMethod(), _, _) and
            value = theUnknownType() and cls = theUnknownType() and origin = f
        }

         predicate call_to_generator_points_to(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             exists(PyFunctionObject func |
                 f = get_a_call(func, context) |
                 func.getFunction().isGenerator() and origin = f and value = f and cls = theGeneratorType()
             )
         }

         /* Helper for call_points_to_python_function */
         predicate return_val_points_to(PyFunctionObject func, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             exists(ControlFlowNode rval |
                 rval = func.getAReturnedNode() and
                 points_to(rval, context, value, cls, origin)
             )
         }

         pragma [noinline]
         predicate call_points_to_python_function(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             exists(PyFunctionObject func, PointsToContext callee |
                 return_val_points_to(func, callee, value, cls, origin) and
                 callee.fromCall(f, func, context)
             )
         }

         /** A call, including calls to `type(arg)`, functions and classes.
          *
          * Call analysis logic
          * ===================
          *  There are five possibilities (that we currently account for) here.
          * 1. `type(known_type)` where we know the class of `known_type` and we know its origin
          * 2. `type(known_type)` where we know the class of `known_type`,
          *        but we don't know its origin (because it is a builtin type)
          * 3. `Class(...)` where Class is any class except type (with one argument) and calls to that class return instances of that class
          * 4. `func(...)` where we know the return type of func (because it is a builtin function)
          * 5. `func(...)` where we know the returned object and origin of func (because it is a Python function)
          */
         predicate call_points_to(CallNode f, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
             /* Case 1 */
             call_to_type_known_python_class_points_to(f, context, value, cls, origin)
             or
             /* Case 2 */
             call_to_type_known_builtin_class_points_to(f, context, value, cls, origin)
             or
             /* Case 3 */
             instantiation(f, context, cls) and value = f and f = origin
             or
             /* Case 4 */
             call_points_to_builtin_function(f, context, value, cls, origin)
             or
             /* Case 5a */
             call_points_to_python_function(f, context, value, cls, origin)
             or
             /* Case 5b */
             call_to_generator_points_to(f, context, value, cls, origin)
             or
             /* Case 5c */
             call_to_procedure_points_to(f, context, value, cls, origin)
             or
             call_to_unknown(f, context, value, cls, origin)
             or
             call_to_type_new(f, context, value, cls, origin)
             or
             annotation_call(f, context, value, cls, origin)
         }

         /** INTERNAL -- Public for testing only.
          * Whether `call` is a call to `method` of the form `super(...).method(...)`
          */
         predicate super_method_call(PointsToContext context, CallNode call, EssaVariable self, FunctionObject method) {
             exists(ControlFlowNode func, SuperBoundMethod bound_method |
                 call.getFunction() = func and
                 points_to(func, context, bound_method, _, _) and
                 method = bound_method.getFunction(context) and
                 self = bound_method.getSelf()
             )
         }

         /** INTERNAL -- Use `FunctionObject.getAMethodCall()`. */
         pragma [nomagic]
         predicate plain_method_call(FunctionObject func, PointsToContext context, CallNode call) {
             exists(ControlFlowNode attr, ClassObject cls, string name |
                 attr = call.getFunction() and
                 receiver_type_for(cls, name, attr, context) and
                 Types::class_attribute_lookup(cls, name, func, _, _)
             )
         }

         /** INTERNAL -- Do not use; part of the internal API.
          *
          * Whether cls `cls` is the receiver type of an attribute access `n`.
          *  Also bind the name of the attribute.
          */
         predicate receiver_type_for(ClassObject cls, string name, ControlFlowNode n, PointsToContext context) {
             /* `super().meth()` is not a method on `super` */
             cls != theSuperType() and
             exists(Object o |
                 /* list.__init__() is not a call to type.__init__() */
                 o.notClass() |
                 points_to(n.(AttrNode).getObject(name), context, o, cls, _)
             )
             or
             exists(PlaceHolder p, Variable v |
                 n.getNode() = p and n.(NameNode).uses(v) and name = v.getId() and
                 p.getScope().getScope() = cls.getPyClass() and context.appliesTo(n)
             )
         }

         /** Gets the argument for the parameter at `position` where `call` is a call to `func`.
          * Handles method calls, such that for a call `x.foo()` with `position equal to 0, the result is `x`.
          */
         pragma [nomagic]
         ControlFlowNode get_argument_for_call_by_position(FunctionObject func, PointsToContext context, CallNode call, int position) {
             method_call(func, context, call) and
             (
                 result = call.getArg(position-1)
                 or
                 position = 0 and result = call.getFunction().(AttrNode).getObject()
             )
             or
             function_call(func, context, call) and
             result = call.getArg(position)
         }

         /** Holds if `value` is the value attached to the keyword argument `name` in `call`. */
         predicate keyword_value_for_call(CallNode call, string name, ControlFlowNode value) {
             exists(Keyword kw |
                 call.getNode().getAKeyword() = kw |
                 kw.getArg() = name and kw.getValue() = value.getNode() and
                 value.getBasicBlock().dominates(call.getBasicBlock())
             )
         }

         /** Gets the value for the keyword argument `name` in `call`, where `call` calls `func` in context. */
         ControlFlowNode get_argument_for_call_by_name(FunctionObject func, PointsToContext context, CallNode call, string name) {
             call = get_a_call(func, context) and
             keyword_value_for_call(call, name, result)
         }

         /** Holds if `func` implicitly returns the `None` object */
         predicate implicitly_returns(PyFunctionObject func, Object none_, ClassObject noneType) {
             noneType = theNoneType() and none_ = theNoneObject() and
             exists(Function f |
                 f = func.getFunction() and not f.isGenerator()
                 |
                 not exists(Return ret | ret.getScope() = f) and exists(f.getANormalExit())
                 or
                 exists(Return ret | ret.getScope() = f and not exists(ret.getValue()))
             )
         }

    }

    cached module Flow {

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
        private predicate callsite_entry_value_transfer(EssaVariable caller_var, PointsToContext caller_context, ScopeEntryDefinition entry_def, PointsToContext callee_context) {
            exists(CallNode callsite, FunctionObject f, Variable var |
                scope_entry_function_and_variable(entry_def, f, var) and
                callee_context.fromCall(callsite, f, caller_context) and
                caller_var.getSourceVariable() = var and
                caller_var.getAUse() = callsite
            )
        }

        /** Helper for callsite_entry_value_transfer to improve join-order */
        private predicate scope_entry_function_and_variable(ScopeEntryDefinition entry_def, FunctionObject f, Variable var) {
            exists(Function func |
                func = f.getFunction() |
                entry_def.getDefiningNode() = func.getEntryNode() and
                not var.getScope() = func and
                entry_def.getSourceVariable() = var
            )
        }

        /** Helper for `scope_entry_value_transfer`. */
        private predicate class_entry_value_transfer(EssaVariable pred_var, ScopeEntryDefinition succ_def) {
            exists(ImportTimeScope scope, ControlFlowNode class_def |
                class_def = pred_var.getAUse() and
                scope.entryEdge(class_def, succ_def.getDefiningNode()) and
                pred_var.getSourceVariable() = succ_def.getSourceVariable()
            )
        }

        /**  Gets the ESSA variable from which `def` acquires its value, when a call occurs.
         * Helper for `callsite_points_to`. */
        cached predicate callsite_exit_value_transfer(EssaVariable callee_var, PointsToContext callee_context, CallsiteRefinement def, PointsToContext callsite_context) {
            exists(FunctionObject func, Variable var |
                callee_context.fromCall(def.getCall(), func, callsite_context) and
                def.getSourceVariable() = var and
                var_at_exit(var, func, callee_var)
            )
        }

        /* Helper for callsite_exit_value_transfer */
        private predicate var_at_exit(Variable var, FunctionObject func, EssaVariable evar) {
            not var instanceof LocalVariable and
            evar.getSourceVariable() = var and
            evar.getScope() = func.getFunction() and
            BaseFlow::reaches_exit(evar)
        }

        /** Holds if the `(argument, caller)` pair matches up with `(param, callee)` pair across call. */
        cached predicate callsite_argument_transfer(ControlFlowNode argument, PointsToContext caller, ParameterDefinition param, PointsToContext callee) {
            exists(CallNode call, PyFunctionObject func, int n, int offset |
                callsite_calls_function(call, caller, func, callee, offset) and
                argument = call.getArg(n) and
                param = func.getParameter(n+offset)
            )
        }

        cached predicate callsite_calls_function(CallNode call, PointsToContext caller, PyFunctionObject func, PointsToContext callee, int parameter_offset) {
            /* Functions */
            callee.fromCall(call, func, caller) and
            function_call(func, caller, call) and
            parameter_offset = 0
            or
            /* Methods */
            callee.fromCall(call, func, caller) and
            method_call(func, caller, call) and
            parameter_offset = 1
            or
            /* Classes */
            exists(ClassObject cls |
                instantiation(call, caller, cls) and
                Types::class_attribute_lookup(cls, "__init__", func, _, _) and
                parameter_offset = 1 and
                callee.fromCall(call, caller)
            )
        }

        /** Helper for `import_star_points_to`. */
        cached predicate module_and_name_for_import_star(ModuleObject mod, string name, ImportStarRefinement def, PointsToContext context) {
            points_to(def.getDefiningNode().(ImportStarNode).getModule(), context, mod, _, _) and
            name = def.getSourceVariable().getName()
        }

        /** Holds if `def` is technically a definition of `var`, but the `from ... import *` does not in fact define `var`. */
        cached predicate variable_not_redefined_by_import_star(EssaVariable var, PointsToContext context, ImportStarRefinement def) {
            var = def.getInput() and
            exists(ModuleObject mod |
                points_to(def.getDefiningNode().(ImportStarNode).getModule(), context, mod, _, _) |
                module_exports_boolean(mod, var.getSourceVariable().getName()) = false
                or
                exists(Module m, string name |
                    m = mod.getModule() and name = var.getSourceVariable().getName() |
                    not m.declaredInAll(_) and name.charAt(0) = "_"
                )
            )
        }

    }

    private module SSA {


        /** Holds if the phi-function `phi` refers to `(value, cls, origin)` given the context `context`. */
        pragma [noinline]
        private predicate ssa_phi_points_to(PhiFunction phi, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(EssaVariable input, BasicBlock pred |
                input = phi.getInput(pred) and
                ssa_variable_points_to(input, context, value, cls, origin)
                |
                Layer::controlledReachableEdge(pred, phi.getBasicBlock(), context)
                or
                not exists(ConditionBlock guard | guard.controlsEdge(pred, phi.getBasicBlock(), _))
            )
            or
            ssa_variable_points_to(phi.getShortCircuitInput(), context, value, cls, origin)
        }

        /** Holds if the ESSA definition `def`  refers to `(value, cls, origin)` given the context `context`. */
        predicate ssa_definition_points_to(EssaDefinition def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            ssa_phi_points_to(def, context, value, cls, origin)
            or
            ssa_node_definition_points_to(def, context, value, cls, origin)
            or
            Filters::ssa_filter_definition_points_to(def, context, value, cls, origin)
            or
            ssa_node_refinement_points_to(def, context, value, cls, origin)
        }

        pragma [nomagic]
        private predicate ssa_node_definition_points_to_unpruned(EssaNodeDefinition def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            assignment_points_to(def, context, value, cls, origin)
            or
            parameter_points_to(def, context, value, cls, origin)
            or
            self_parameter_points_to(def, context, value, cls, origin)
            or
            delete_points_to(def, context, value, cls, origin)
            or
            scope_entry_points_to(def, context, value, cls, origin)
            or
            implicit_submodule_points_to(def, context, value, cls, origin)
            or
            module_name_points_to(def, context, value, cls, origin)
            or
            iteration_definition_points_to(def, context, value, cls, origin)
            /*
             * No points-to for non-local function entry definitions yet.
             */
        }

        pragma [noinline]
        private predicate reachable_definitions(EssaNodeDefinition def) {
            Layer::reachableBlock(def.getDefiningNode().getBasicBlock(), _)
        }

        pragma [noinline]
        private predicate ssa_node_definition_points_to(EssaNodeDefinition def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            reachable_definitions(def) and
            ssa_node_definition_points_to_unpruned(def, context, value, cls, origin)
        }

        pragma [noinline]
        private predicate ssa_node_refinement_points_to(EssaNodeRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            method_callsite_points_to(def, context, value, cls, origin)
            or
            import_star_points_to(def, context, value, cls, origin)
            or
            attribute_assignment_points_to(def, context, value, cls, origin)
            or
            callsite_points_to(def, context, value, cls, origin)
            or
            argument_points_to(def, context, value, cls, origin)
            or
            attribute_delete_points_to(def, context, value, cls, origin)
            or
            Filters::uni_edged_phi_points_to(def, context, value, cls, origin)
        }

        /** Points-to for normal assignments `def = ...`. */
        pragma [noinline]
        private predicate assignment_points_to(AssignmentDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            points_to(def.getValue(), context, value, cls, origin)
        }

        /** Helper for `parameter_points_to` */
        pragma [noinline]
        private predicate positional_parameter_points_to(ParameterDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            exists(PointsToContext caller, ControlFlowNode arg |
                points_to(arg, caller, value, cls, origin) and
                Flow::callsite_argument_transfer(arg, caller, def, context)
            )
            or
            not def.isSelf() and not def.getParameter().isVarargs() and not def.getParameter().isKwargs() and
            context.isRuntime() and value = unknownValue() and cls = theUnknownType() and origin = def.getDefiningNode()
        }

        /** Helper for `parameter_points_to` */
        pragma [noinline]
        private predicate named_parameter_points_to(ParameterDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            exists(CallNode call, PointsToContext caller, FunctionObject func, string name |
                context.fromCall(call, func, caller) and
                def.getParameter() = func.getFunction().getArgByName(name) and
                points_to(call.getArgByName(name), caller, value, cls, origin)
            )
        }

        /** Points-to for parameter. `def foo(param): ...`. */
        pragma [noinline]
        private predicate parameter_points_to(ParameterDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            positional_parameter_points_to(def, context, value, cls, origin)
            or
            named_parameter_points_to(def, context, value, cls, origin)
            or
            default_parameter_points_to(def, context, value, cls, origin)
            or
            special_parameter_points_to(def, context, value, cls, origin)
        }

        /** Helper for parameter_points_to */
        private predicate default_parameter_points_to(ParameterDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            default_value_points_to(def, value, cls, origin) and
            context_for_default_value(def, context)
        }

        /** Helper for default_parameter_points_to */
        pragma [noinline]
        private predicate default_value_points_to(ParameterDefinition def, Object value, ClassObject cls, ControlFlowNode origin) {
            exists(PointsToContext imp | imp.isImport() | points_to(def.getDefault(), imp, value, cls, origin))
        }

        /** Helper for default_parameter_points_to */
        pragma [noinline]
        private predicate context_for_default_value(ParameterDefinition def, PointsToContext context) {
            context.isRuntime()
            or
            exists(PointsToContext caller, CallNode call, FunctionObject func, int n |
                context.fromCall(call, func, caller) and
                func.getFunction().getArg(n) = def.getParameter() and
                not exists(call.getArg(n)) and
                not exists(call.getArgByName(def.getParameter().asName().getId())) and
                not exists(call.getNode().getKwargs()) and
                not exists(call.getNode().getStarargs())
            )
        }

        /** Helper for parameter_points_to */
        pragma [noinline]
        private predicate special_parameter_points_to(ParameterDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            context.isRuntime() and
            exists(ControlFlowNode param |
                param = def.getDefiningNode() |
                varargs_points_to(param, cls) and value = theEmptyTupleObject() and origin = param
                or
                varargs_points_to(param, cls) and value = param and origin = param
                or
                kwargs_points_to(param, cls) and value = param and origin = param
            )
            or
            exists(PointsToContext caller, CallNode call, FunctionObject func, Parameter p |
                context.fromCall(call, func, caller) and
                func.getFunction().getAnArg() = p and p = def.getParameter() and
                not p.isSelf() and
                not exists(call.getArg(p.getPosition())) and
                not exists(call.getArgByName(p.getName())) and
                (exists(call.getNode().getKwargs()) or exists(call.getNode().getStarargs())) and
                value = unknownValue() and cls = theUnknownType() and origin = def.getDefiningNode()
            )
        }

        /** Holds if the `(obj, caller)` pair matches up with `(self, callee)` pair across call. */
        pragma [noinline]
        private predicate callsite_self_argument_transfer(EssaVariable obj, PointsToContext caller, ParameterDefinition self, PointsToContext callee) {
            self.isSelf() and
            exists(CallNode call, PyFunctionObject meth |
                meth.getParameter(0) = self and
                callee.fromCall(call, caller) |
                Calls::plain_method_call(meth, caller, call) and
                obj.getASourceUse() = call.getFunction().(AttrNode).getObject()
                or
                Calls::super_method_call(caller, call, obj, meth)
             )
        }

        /** Points-to for self parameter: `def meth(self, ...): ...`. */
        pragma [noinline]
        private predicate self_parameter_points_to(ParameterDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            def.isSelf() and
            exists(FunctionObject meth, Function scope |
                meth.getFunction() = scope |
                def.getDefiningNode().getScope() = scope and
                context.isRuntime() and context.appliesToScope(scope) and
                scope.getScope() = cls.getPyClass() and
                Types::concrete_class(cls) and
                value = def.getDefiningNode() and origin = value and
                /* We want to allow decorated functions, otherwise we lose a lot of useful information.
                 * However, we want to exclude any function whose arguments are permuted by the decorator.
                 * In general we can't do that, but we can special case the most common ones.
                 */
                neither_class_nor_static_method(scope)
            )
            or
            exists(EssaVariable obj, PointsToContext caller |
                ssa_variable_points_to(obj, caller, value, cls, origin) and
                callsite_self_argument_transfer(obj, caller, def, context)
            )
            or
            cls_parameter_points_to(def, context, value, cls, origin)
        }

        private predicate neither_class_nor_static_method(Function f) {
            not exists(f.getADecorator())
            or
            exists(ControlFlowNode deco |
                deco = f.getADecorator().getAFlowNode() |
                exists(Object o |
                    points_to(deco, _, o, _, _) |
                    o != theStaticMethodType() and
                    o != theClassMethodType()
                )
                or not deco instanceof NameNode
            )
        }


        pragma [noinline]
        private predicate cls_parameter_points_to(ParameterDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            def.isSelf() and
            exists(CallNode call, PyFunctionObject meth, Object obj, ClassObject objcls, PointsToContext caller |
                context.fromCall(call, caller) and
                cls_method_object_points_to(call, caller, meth, obj, objcls, origin) and
                def.getScope() = meth.getFunction()
                |
                obj instanceof ClassObject and value = obj and cls = objcls
                or
                obj.notClass() and value = objcls and cls = Types::class_get_meta_class(objcls)
             )
        }

        /* Factor out part of `cls_parameter_points_to` to prevent bad join-order */
        pragma [noinline]
        private predicate cls_method_object_points_to(CallNode call, PointsToContext context, PyFunctionObject meth, Object value, ClassObject cls, ControlFlowNode origin) {
            exists(AttrNode attr |
                class_method_call(_, attr, meth, context, call) and
                points_to(attr.getObject(), context, value, cls, origin)
            )
        }

        /** Points-to for deletion: `del name`. */
        pragma [noinline]
        private predicate delete_points_to(DeletionDefinition def, PointsToContext context, Object value, ClassObject cls, ControlFlowNode origin) {
            value = undefinedVariable() and cls = theUnknownType() and origin = def.getDefiningNode() and context.appliesToScope(def.getScope())
        }

        /** Implicit "definition" of the names of submodules at the start of an `__init__.py` file.
         *
         * PointsTo isn't exactly how the interpreter works, but is the best approximation we can manage statically.
         */
        pragma [noinline]
        private predicate implicit_submodule_points_to(ImplicitSubModuleDefinition def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(PackageObject package |
                package.getInitModule().getModule() = def.getDefiningNode().getScope() |
                value = package.submodule(def.getSourceVariable().getName()) and
                cls = theModuleType() and
                origin = value and
                context.isImport()
            )
        }

        /** Implicit "definition" of `__name__` at the start of a module. */
        pragma [noinline]
        private predicate module_name_points_to(ScopeEntryDefinition def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            def.getVariable().getName() = "__name__" and
            exists(Module m |
                m = def.getScope()
                |
                value = module_dunder_name(m) and context.isImport()
                or
                value = object_for_string("__main__") and context.isMain() and context.appliesToScope(m)
            ) and
            cls = theStrType() and origin = def.getDefiningNode()
        }

        private Object module_dunder_name(Module m) {
            exists(string name |
                result = object_for_string(name) |
                if m.isPackageInit() then
                    name = m.getPackage().getName()
                else
                    name = m.getName()
            )
        }

        /** Definition of iteration variable in loop */
        pragma [noinline]
        private predicate iteration_definition_points_to(IterationDefinition def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            points_to(def.getSequence(), context, unknownValue(), _, _) and
            value = unknownValue() and cls = theUnknownType() and origin = def.getDefiningNode()
        }

        /** Points-to for implicit variable declarations at scope-entry. */
        pragma [noinline]
        private predicate scope_entry_points_to(ScopeEntryDefinition def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            /* Transfer from another scope */
            exists(EssaVariable var, PointsToContext outer |
                Flow::scope_entry_value_transfer(var, outer, def, context) and
                ssa_variable_points_to(var, outer, value, cls, origin)
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
            value = undefinedVariable() and cls = theUnknownType() and origin = def.getDefiningNode()
            or
            /* Builtin not defined in outer scope */
            exists(Module mod, GlobalVariable var |
                var = def.getSourceVariable() and
                mod = def.getScope().getEnclosingModule() and
                context.appliesToScope(def.getScope()) and
                not exists(EssaVariable v | v.getSourceVariable() = var and v.getScope() = mod) and
                builtin_name_points_to(var.getId(), value, cls) and origin = value
            )
        }

        /** Points-to for a variable (possibly) redefined by a call:
         * `var = ...; foo(); use(var)`
         * Where var may be redefined in call to `foo` if `var` escapes (is global or non-local).
         */
        pragma [noinline]
        private predicate callsite_points_to(CallsiteRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(EssaVariable var, PointsToContext callee |
                Flow::callsite_exit_value_transfer(var, callee, def, context) and
                ssa_variable_points_to(var, callee, value, cls, origin)
            )
            or
            callsite_points_to_python(def, context, value, cls, origin)
            or
            callsite_points_to_builtin(def, context, value, cls, origin)
        }

        pragma [noinline]
        private predicate callsite_points_to_python(CallsiteRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            ssa_variable_points_to(def.getInput(), context, value, cls, origin) and
            exists(CallNode call, PythonSsaSourceVariable var |
                call = def.getCall() and
                var = def.getSourceVariable() and
                context.untrackableCall(call) and
                exists(PyFunctionObject modifier, Function f |
                    f = modifier.getFunction() and
                    call = get_a_call(modifier, context) and
                    not modifies_escaping_variable(f, var)
                )
            )
        }

        private predicate modifies_escaping_variable(Function modifier, PythonSsaSourceVariable var) {
            exists(var.redefinedAtCallSite()) and
            modifier.getBody().contains(var.(Variable).getAStore())
        }

        pragma [noinline]
        private predicate callsite_points_to_builtin(CallsiteRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            ssa_variable_points_to(def.getInput(), context, value, cls, origin) and
            exists(CallNode call |
                call = def.getCall() |
                // An identifiable callee is a builtin
                exists(BuiltinCallable opaque | get_a_call(opaque, _) = call)
            )
        }

        /** Pass through for `self` for the implicit re-definition of `self` in `self.foo()`. */
        private predicate method_callsite_points_to(MethodCallsiteRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            /* The value of self remains the same, only the attributes may change */
            ssa_variable_points_to(def.getInput(), context, value, cls, origin)
        }

        /** Points-to for `from ... import *`. */
        private predicate import_star_points_to(ImportStarRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(ModuleObject mod, string name |
                Flow::module_and_name_for_import_star(mod, name, def, context) |
                /* Attribute from imported module */
                module_exports(mod, name) and
                Layer::module_attribute_points_to(mod, name, value, cls, origin)
            )
            or
            exists(EssaVariable var |
                /* Retain value held before import */
                Flow::variable_not_redefined_by_import_star(var, context, def) and
                ssa_variable_points_to(var, context, value, cls, origin)
            )
        }

        /** Attribute assignments have no effect as far as value tracking is concerned, except for `__class__`. */
        pragma [noinline]
        private predicate attribute_assignment_points_to(AttributeAssignment def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            if def.getName() = "__class__" then
                ssa_variable_points_to(def.getInput(), context, value, _, _) and points_to(def.getValue(), _, cls, _,_) and
                origin = def.getDefiningNode()
            else
                ssa_variable_points_to(def.getInput(), context, value, cls, origin)
        }

        /** Ignore the effects of calls on their arguments. PointsTo is an approximation, but attempting to improve accuracy would be very expensive for very little gain. */
        pragma [noinline]
        private predicate argument_points_to(ArgumentRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            ssa_variable_points_to(def.getInput(), context, value, cls, origin)
        }

        /** Attribute deletions have no effect as far as value tracking is concerned. */
        pragma [noinline]
        private predicate attribute_delete_points_to(EssaAttributeDeletion def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            ssa_variable_points_to(def.getInput(), context, value, cls, origin)
        }

        /* Data flow for attributes. These mirror the "normal" points-to predicates.
         * For each points-to predicate `xxx_points_to(XXX def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin)`
         * There is an equivalent predicate that tracks the values in attributes:
         * `xxx_named_attribute_points_to(XXX def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin)`
         *  */

        /** INTERNAL -- Public for testing only.
         *
         * Hold if the attribute `name` of the ssa variable `var` refers to `(value, cls, origin)`.
         */
        predicate ssa_variable_named_attribute_points_to(EssaVariable var, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            ssa_definition_named_attribute_points_to(var.getDefinition(), context, name, value, cls, origin)
        }

        /** Helper for `ssa_variable_named_attribute_points_to`. */
        private predicate ssa_definition_named_attribute_points_to(EssaDefinition def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            ssa_phi_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            ssa_node_definition_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            ssa_node_refinement_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            Filters::ssa_filter_definition_named_attribute_points_to(def, context, name, value, cls, origin)
        }

        /** Holds if the attribute `name` of the ssa phi-function definition `phi` refers to `(value, cls, origin)`. */
        pragma[noinline]
        private predicate ssa_phi_named_attribute_points_to(PhiFunction phi, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            ssa_variable_named_attribute_points_to(phi.getAnInput(), context, name, value, cls, origin)
        }

        /** Helper for `ssa_definition_named_attribute_points_to`. */
        pragma[noinline]
        private predicate ssa_node_definition_named_attribute_points_to(EssaNodeDefinition def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            assignment_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            delete_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            self_parameter_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            scope_entry_named_attribute_points_to(def, context, name, value, cls, origin)
        }

        /** Helper for `ssa_definition_named_attribute_points_to`. */
        pragma[noinline]
        private predicate ssa_node_refinement_named_attribute_points_to(EssaNodeRefinement def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            attribute_assignment_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            attribute_delete_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            import_star_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            self_callsite_named_attribute_points_to(def, context, name, value, cls, origin)
            or
            argument_named_attribute_points_to(def, context, name, value, cls, origin)
        }

        pragma[noinline]
        private predicate scope_entry_named_attribute_points_to(ScopeEntryDefinition def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            exists(EssaVariable var, PointsToContext outer |
                Flow::scope_entry_value_transfer(var, outer, def, context) and
                ssa_variable_named_attribute_points_to(var, outer, name, value, cls, origin)
            )
            or
            origin = def.getDefiningNode() and
            isModuleStateVariable(def.getVariable()) and
            context.isImport() and
            exists(PackageObject package |
                package.getInitModule().getModule() = def.getScope() |
                explicitly_imported(package.submodule(name)) and
                value = undefinedVariable() and
                cls = theUnknownType()
            )
        }

        pragma[noinline]
        private predicate assignment_named_attribute_points_to(AssignmentDefinition def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            named_attribute_points_to(def.getValue(), context, name, value, cls, origin)
        }

        pragma[noinline]
        private predicate attribute_assignment_named_attribute_points_to(AttributeAssignment def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            points_to(def.getValue(), context, value, cls, origin) and name = def.getName()
            or
            ssa_variable_named_attribute_points_to(def.getInput(), context, name, value, cls, origin) and not name = def.getName()
        }

        /** Holds if `def` defines the attribute `name`.
         *
         * `def` takes the form `setattr(use, "name")` where `use` is the input to the definition.
         */
        private boolean sets_attribute(ArgumentRefinement def, string name) {
            exists(ControlFlowNode func, Object obj |
                two_args_first_arg_string(def, func, name) and
                points_to(func, _, obj, _, _) |
                obj = builtin_object("setattr") and result = true
                or
                obj != builtin_object("setattr") and result = false
            )
        }

        private predicate two_args_first_arg_string(ArgumentRefinement def, ControlFlowNode func, string name) {
            exists(CallNode call |
                call = def.getDefiningNode() and
                call.getFunction() = func and
                def.getInput().getAUse() = call.getArg(0) and
                call.getArg(1).getNode().(StrConst).getText() = name
            )
        }

        pragma[noinline]
        private predicate argument_named_attribute_points_to(ArgumentRefinement def, PointsToContext context, string name, Object value, ClassObject cls, ObjectOrCfg origin) {
            not two_args_first_arg_string(def, _, name) and ssa_variable_named_attribute_points_to(def.getInput(), context, name, value, cls, origin)
            or
            sets_attribute(def, name) = true and points_to(def.getDefiningNode().(CallNode).getArg(2), context, value, cls, origin)
            or
            sets_attribute(def, name) = false and ssa_variable_named_attribute_points_to(def.getInput(), context, name, value, cls, origin)
        }

        /** Holds if the self variable in the callee (`(var, callee)`) refers to the same object as `def` immediately after the call, (`(def, caller)`). */
        pragma[noinline]
        private predicate callee_self_variable(EssaVariable var, PointsToContext callee, SelfCallsiteRefinement def, PointsToContext caller) {
            exists(FunctionObject func, LocalVariable self |
                callee.fromCall(def.getCall(), func, caller) and
                BaseFlow::reaches_exit(var) and
                var.getSourceVariable() = self and
                self.isSelf() and
                self.getScope() = func.getFunction()
            )
        }

        pragma[noinline]
        private predicate self_callsite_named_attribute_points_to(SelfCallsiteRefinement def, PointsToContext context, string name, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(EssaVariable var, PointsToContext callee |
                ssa_variable_named_attribute_points_to(var, callee, name, value, cls, origin) and
                callee_self_variable(var, callee, def, context)
            )
        }

        /** Gets the (temporally) preceding variable for `self`, e.g. `def` is in method `foo()` and `result` is in `__init__()`.  */
        private EssaVariable preceding_self_variable(ParameterDefinition def) {
            def.isSelf() and
            exists(Function preceding, Function method |
                method = def.getScope() and
                // Only methods
                preceding.isMethod() and preceding.precedes(method) and
                BaseFlow::reaches_exit(result) and result.getSourceVariable().(Variable).isSelf() and
                result.getScope() = preceding
            )
        }

        pragma [noinline]
        private predicate self_parameter_named_attribute_points_to(ParameterDefinition def, PointsToContext context, string name, Object value, ClassObject vcls, ControlFlowNode origin) {
            context.isRuntime() and executes_in_runtime_context(def.getScope()) and
            ssa_variable_named_attribute_points_to(preceding_self_variable(def), context, name, value, vcls, origin)
            or
            exists(FunctionObject meth, CallNode call, PointsToContext caller_context, ControlFlowNode obj |
                meth.getFunction() = def.getScope() and
                method_call(meth, caller_context, call) and
                call.getFunction().(AttrNode).getObject() = obj and
                context.fromCall(call, meth, caller_context) and
                named_attribute_points_to(obj, caller_context, name, value, vcls, origin)
            )
        }

        private predicate delete_named_attribute_points_to(DeletionDefinition def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            none()
        }

        private predicate attribute_delete_named_attribute_points_to(EssaAttributeDeletion def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            none()
        }

        /* Helper for import_star_named_attribute_points_to */
        pragma [noinline]
        private predicate star_variable_import_star_module(ImportStarRefinement def, ImportStarNode imp, PointsToContext context, ModuleObject mod) {
            isModuleStateVariable(def.getVariable()) and
            exists(ControlFlowNode fmod |
                fmod = imp.getModule() and
                imp = def.getDefiningNode() and
                points_to(fmod, context, mod, _, _)
            )
        }

        /* Helper for import_star_named_attribute_points_to */
        pragma [noinline, nomagic]
        private predicate ssa_star_variable_input_points_to(ImportStarRefinement def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            exists(EssaVariable var |
                ssa_star_import_star_input(def, var) and
                ssa_variable_named_attribute_points_to(var, context, name, value, cls, origin)
            )
        }

        /* Helper for ssa_star_variable_input_points_to */
        pragma [noinline]
        private predicate ssa_star_import_star_input(ImportStarRefinement def, EssaVariable var) {
            isModuleStateVariable(def.getVariable()) and var = def.getInput()
        }

        pragma [noinline]
        private predicate import_star_named_attribute_points_to(ImportStarRefinement def, PointsToContext context, string name, Object value, ClassObject cls, ControlFlowNode origin) {
            exists(ImportStarNode imp, ModuleObject mod |
                star_variable_import_star_module(def, imp, context, mod) |
                /* Attribute from imported module */
                module_exports_boolean(mod, name) = true and
                exists(ObjectOrCfg obj |
                    Layer::module_attribute_points_to(mod, name, value, cls, obj) and
                    not exists(Variable v | v.getId() = name and v.getScope() = imp.getScope()) and
                    origin = origin_from_object_or_here(obj, imp)
                )
                or
                /* Retain value held before import */
                module_exports_boolean(mod, name) = false and
                ssa_star_variable_input_points_to(def, context, name, value, cls, origin)
            )
        }

    }

    private module Filters {

        /** Holds if `expr` is the operand of a unary `not` expression. */
        private ControlFlowNode not_operand(ControlFlowNode expr) {
            expr.(UnaryExprNode).getNode().getOp() instanceof Not and
            result = expr.(UnaryExprNode).getOperand()
        }

        /** Gets the value that `expr` evaluates to (when converted to a boolean) when `use` refers to `(val, cls, origin)`
         * and `expr` contains `use` and both are contained within a test. */
        pragma [nomagic]
        boolean evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            result = isinstance_test_evaluates_boolean(expr, use, context, val, cls, origin)
            or
            result = issubclass_test_evaluates_boolean(expr, use, context, val, cls, origin)
            or
            result = equality_test_evaluates_boolean(expr, use, context, val, cls, origin)
            or
            result = callable_test_evaluates_boolean(expr, use, context, val, cls, origin)
            or
            result = hasattr_test_evaluates_boolean(expr, use, context, val, cls, origin)
            or
            result = evaluates(not_operand(expr), use, context, val, cls, origin).booleanNot()
        }

        /** Gets the value that `expr` evaluates to (when converted to a boolean) when `use` refers to `(val, cls, origin)`
         * and `expr` contains `use` and both are contained within a test. */
        pragma [nomagic]
        boolean evaluates(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            result = evaluates_boolean(expr, use, context, val,  cls, origin)
            or
            result = true and evaluates_int(expr, use, context, val, cls, origin) != 0
            or
            result = false and evaluates_int(expr, use, context, val, cls, origin) = 0
            or
            result = truth_test_evaluates_boolean(expr, use, context, val, cls, origin)
        }

        private boolean maybe() {
            result = true or result = false
        }

        pragma [nomagic]
        private boolean issubclass_test_evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            points_to(use, context, val, cls, origin) and
            exists(ControlFlowNode clsNode |
                BaseFilters::issubclass(expr, clsNode, use)
                |
                exists(ClassObject scls |
                    result = Types::is_improper_subclass_bool(val, scls)
                    |
                    points_to(clsNode, context, scls, _, _)
                    or
                    element_of_points_to_tuple(clsNode, context, scls) and result = true
                )
                or
                val = unknownValue() and result = maybe()
                or
                val = theUnknownType() and result = maybe()
            )
        }

        pragma [nomagic]
        private boolean isinstance_test_evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            points_to(use, context, val, cls, origin) and
            exists(ControlFlowNode clsNode |
                BaseFilters::isinstance(expr, clsNode, use)
                |
                exists(ClassObject scls |
                    result = Types::is_improper_subclass_bool(cls, scls)
                    |
                    points_to(clsNode, context, scls, _, _)
                    or
                    element_of_points_to_tuple(clsNode, context, scls) and result = true
                )
                or
                val = unknownValue() and result = maybe()
            )
        }

        pragma [noinline]
        private boolean equality_test_evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            exists(ControlFlowNode l, ControlFlowNode r, boolean sense |
                contains_interesting_expression_within_test(expr, use) and
                BaseFilters::equality_test(expr, l, sense, r) |
                exists(int il, int ir |
                    il = evaluates_int(l, use, context, val, cls, origin) and ir = simple_int_value(r)
                    |
                    result = sense and il = ir
                    or
                    result = sense.booleanNot() and il != ir
                )
                or
                use = l and
                exists(Object other |
                    /* Must be discrete values, not just types of things */
                    equatable_value(val) and equatable_value(other) and
                    points_to(use, context, val, cls, origin) and
                    points_to(r, context, other, _, _) |
                    other != val and result = sense.booleanNot()
                    or
                    other = val and result = sense
                )
            )
        }

        pragma [noinline]
        private boolean truth_test_evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            contains_interesting_expression_within_test(expr, use) and
            points_to(use, context, val, cls, origin) and
            expr = use and
            (
                val.booleanValue() = result
                or
                Types::instances_always_true(cls) and result = true
                or
                val.maybe() and result = true
                or
                val.maybe() and result = false
            )
        }

        pragma [noinline]
        private boolean callable_test_evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            contains_interesting_expression_within_test(expr, use) and
            points_to(use, context, val, cls, origin) and
            BaseFilters::is_callable(expr, use) and
            (
                result = Types::class_has_attribute_bool(cls, "__call__")
                or
                cls = theUnknownType() and result = maybe()
            )
        }

        pragma [noinline]
        private boolean hasattr_test_evaluates_boolean(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            contains_interesting_expression_within_test(expr, use) and
            points_to(use, context, val, cls, origin) and
            exists(string name |
                BaseFilters::hasattr(expr, use, name) |
                result = Types::class_has_attribute_bool(cls, name)
            )
        }

        /** Holds if meaningful equality tests can be made with `o`.
         * True for basic objects like 3 or None, but it is also true for sentinel objects.
         */
        predicate equatable_value(Object o) {
            comparable_value(o)
            or
            o.(ControlFlowNode).getScope() instanceof Module and
            exists(ClassObject c |
                c.isBuiltin() and
                points_to(o.(CallNode).getFunction(), _, c, _, _)
            )
        }

        /** Holds if meaningful comparisons can be made with `o`.
         * True for basic objects like 3 or None.
         */
        predicate comparable_value(Object o) {
            o.isBuiltin() and not o = unknownValue() and not o = undefinedVariable()
            or
            exists(o.booleanValue())
        }


        /** Holds if the test on `use` is a test that we can potentially understand */
        private predicate comprehensible_test(ControlFlowNode test, ControlFlowNode use) {
            BaseFilters::issubclass(test, _, use)
            or
            BaseFilters::isinstance(test, _, use)
            or
            BaseFilters::equality_test(test, use, _, _)
            or
            exists(ControlFlowNode l |
                BaseFilters::equality_test(test, l, _, _) |
                literal_or_len(l)
            )
            or
            BaseFilters::is_callable(test, use)
            or
            BaseFilters::hasattr(test, use, _)
            or
            test = use
            or
            literal_or_len(test)
            or
            comprehensible_test(not_operand(test), use)
        }


        /** Gets the simple integer value of `f` for numeric literals. */
        private int simple_int_value(ControlFlowNode f) {
            exists(NumericObject num |
                points_to(f, _, num, _, _) and
                result = num.intValue()
            )
        }

        /** Gets the integer value that `expr` evaluates to given that `use` refers to `val` and `use` is a part of `expr`.
         * Only applies to numeric literal and `len()` of sequences. */
        pragma [noinline]
        private int evaluates_int(ControlFlowNode expr, ControlFlowNode use, PointsToContext context, Object val, ClassObject cls, ControlFlowNode origin) {
            contains_interesting_expression_within_test(expr, use) and
            points_to(use, context, val, cls, origin) and
            (
                exists(CallNode call |
                    call = expr and
                    points_to(call.getFunction(), context, theLenFunction(), _, _) and
                    use = call.getArg(0) and
                    val.(SequenceObject).getLength() = result
                )
                or
                expr = use and result = val.(NumericObject).intValue()
            )
        }

        private predicate literal_or_len(ControlFlowNode expr) {
            expr.getNode() instanceof Num
            or
            expr.(CallNode).getFunction().(NameNode).getId() = "len"
        }

        /** Holds if ESSA edge refinement, `def`, refers to `(value, cls, origin)`. */
        predicate ssa_filter_definition_points_to(PyEdgeRefinement def, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(ControlFlowNode test, ControlFlowNode use |
                refinement_test(test, use, test_evaluates_boolean(test, use, context, value, cls, origin), def)
            )
            or
            /* If we can't understand the test, assume that value passes through.
             * Or, if the value is `unknownValue()` then let it pass through as well. */
            exists(ControlFlowNode test, ControlFlowNode use |
                refinement_test(test, use, _, def) and
                ssa_variable_points_to(def.getInput(), context, value, cls, origin) |
                not comprehensible_test(test, use) or
                value = unknownValue()
            )
        }

        /** Holds if ESSA definition, `uniphi`, refers to `(value, cls, origin)`. */
        pragma [noinline]
        predicate uni_edged_phi_points_to(SingleSuccessorGuard uniphi, PointsToContext context, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(ControlFlowNode test, ControlFlowNode use |
                /* Because calls such as `len` may create a new variable, we need to go via the source variable
                 * That is perfectly safe as we are only dealing with calls that do not mutate their arguments.
                 */
                use = uniphi.getInput().getSourceVariable().(Variable).getAUse() and
                test = uniphi.getDefiningNode() and
                uniphi.getSense() = test_evaluates_boolean(test, use, context, value, cls, origin)
            )
        }

        /** Holds if the named attibute of ESSA edge refinement, `def`, refers to `(value, cls, origin)`. */
        pragma[noinline]
        predicate ssa_filter_definition_named_attribute_points_to(PyEdgeRefinement def, PointsToContext context, string name, Object value, ClassObject cls, ObjectOrCfg origin) {
            exists(ControlFlowNode test, AttrNode use, boolean sense |
                edge_refinement_attr_use_sense(def, test, use, name, sense) and
                sense = test_evaluates_boolean(test, use, context, value, cls, origin)
            )
            or
            exists(EssaVariable input |
                input = def.getInput() and
                not edge_refinement_test(def, input, name) and
                SSA::ssa_variable_named_attribute_points_to(input, context, name, value, cls, origin)
            )
        }

        /* Helper for ssa_filter_definition_named_attribute_points_to
         * Holds if `use` is of the form `var.name` in the test of `def`, and `var` is the source variable of `def`, and `def` has sense `sense`.
         */
        pragma[noinline]
        private predicate edge_refinement_attr_use_sense(PyEdgeRefinement def, ControlFlowNode test, AttrNode use, string name, boolean sense) {
            def.getSense() = sense and
            exists(EssaVariable input |
                input = def.getInput() and
                test = def.getTest() and
                use.getObject(name) = def.getInput().getSourceVariable().(Variable).getAUse() and
                test_contains(test, use)
            )
        }

        /* Helper for ssa_filter_definition_named_attribute_points_to */
        pragma[noinline]
        private predicate edge_refinement_test(PyEdgeRefinement def, EssaVariable input, string name) {
            exists(ControlFlowNode test |
                input = def.getInput() and
                test = def.getTest() |
                exists(AttrNode use |
                    refinement_test(test, use.getObject(name), _, def)
                )
            )
        }

    }

    cached module Types {

        /** INTERNAL -- Use `ClassObject.getBaseType(n)` instead.
         *
         * Gets the nth base class of the class. */
        cached Object class_base_type(ClassObject cls, int n) {
            not result = unknownValue() and
            exists(ClassExpr cls_expr | cls.getOrigin() = cls_expr |
                points_to(cls_expr.getBase(n).getAFlowNode(), _, result, _, _)
                or
                is_new_style(cls) and not exists(cls_expr.getBase(0)) and result = theObjectType() and n = 0
            )
            or
            result = builtin_base_type(cls) and n = 0
            or
            cls = theUnknownType() and result = theObjectType() and n = 0
        }

        private Object py_base_type(ClassObject cls, int n) {
            not result = unknownValue() and
            exists(ClassExpr cls_expr | cls.getOrigin() = cls_expr |
                points_to(cls_expr.getBase(n).getAFlowNode(), _, result, _, _)
            )
        }

        cached int class_base_count(ClassObject cls) {
            exists(ClassExpr cls_expr |
                cls.getOrigin() = cls_expr |
                result = strictcount(cls_expr.getABase())
                or
                is_new_style_bool(cls) = true and not exists(cls_expr.getBase(0)) and result = 1
                or
                is_new_style_bool(cls) = false and not exists(cls_expr.getBase(0)) and result = 0
            )
            or
            cls = theObjectType() and result = 0
            or
            exists(builtin_base_type(cls)) and cls != theObjectType() and result = 1
            or
            cls = theUnknownType() and result = 1
        }

        /** INTERNAL -- Do not not use.
         *
         * Holds if a call to this class will return an instance of this class.
         */
        cached predicate callToClassWillReturnInstance(ClassObject cls) {
            callToClassWillReturnInstance(cls, 0) and
            not callToPythonClassMayNotReturnInstance(cls.getPyClass())
        }

        private predicate callToClassWillReturnInstance(ClassObject cls, int n) {
            n = class_base_count(cls)
            or
            callToClassWillReturnInstance(cls, n+1) and
            exists(ClassObject base |
               base = class_base_type(cls, n) |
               /* Most builtin types "declare" `__new__`, such as `int`, yet are well behaved. */
               base.isBuiltin()
               or
               exists(Class c |
                   c = cls.getPyClass() and
                   not callToPythonClassMayNotReturnInstance(c)
               )
           )
        }

        private predicate callToPythonClassMayNotReturnInstance(Class cls) {
            /* Django does this, so we need to account for it */
            exists(Function init, LocalVariable self |
                /* `self.__class__ = ...` in the `__init__` method */
                cls.getInitMethod() = init and
                self.isSelf() and self.getScope() = init and
                exists(AttrNode a | a.isStore() and a.getObject("__class__") = self.getAUse())
            )
            or
            exists(Function new | new.getName() = "__new__" and new.getScope() = cls)
        }

        cached boolean is_new_style_bool(ClassObject cls) {
            major_version() = 3 and result = true
            or
            cls.isBuiltin() and result = true
            or
            get_an_improper_super_type(class_get_meta_class(cls)) = theTypeType() and result = true
            or
            class_get_meta_class(cls) = theClassType() and result = false
        }

        /** INTERNAL -- Use `ClassObject.isNewStyle()` instead. */
        cached predicate is_new_style(ClassObject cls) {
            is_new_style_bool(cls) = true
            or
            is_new_style(get_a_super_type(cls))
        }

        /** INTERNAL -- Use `ClassObject.getASuperType()` instead. */
        cached ClassObject get_a_super_type(ClassObject cls) {
            result = class_base_type(cls, _)
            or
            result = class_base_type(get_a_super_type(cls), _)
        }

        /** INTERNAL -- Use `ClassObject.getAnImproperSuperType()` instead. */
        cached ClassObject get_an_improper_super_type(ClassObject cls) {
            result = cls
            or
            result = get_a_super_type(cls)
        }

        cached boolean is_subclass_bool(ClassObject cls, ClassObject sup) {
            if abcSubclass(cls, sup) then (
                /* Hard-code some abc subclass pairs -- In future we may change this to use stubs. */
                result = true
            ) else (
                sup = class_base_type(cls, _) and result = true
                or
                is_subclass_bool(class_base_type(cls, _), sup) = true and result = true
                or
                result = is_subclass_bool(cls, sup, 0)
            )
        }

        private predicate abcSubclass(ClassObject cls, ClassObject sup) {
            cls = theListType() and sup = collectionsAbcClass("Iterable")
            or
            cls = theSetType() and sup = collectionsAbcClass("Iterable")
            or
            cls = theDictType() and sup = collectionsAbcClass("Iterable")
            or
            cls = theSetType() and sup = collectionsAbcClass("Set")
            or
            cls = theListType() and sup = collectionsAbcClass("Sequence")
            or
            cls = theDictType() and sup = collectionsAbcClass("Mapping")
        }

        cached boolean is_improper_subclass_bool(ClassObject cls, ClassObject sup) {
            result = is_subclass_bool(cls, sup)
            or
            result = true and cls = sup
        }

        private boolean is_subclass_bool(ClassObject cls, ClassObject sup, int n) {
            relevant_subclass_relation(cls, sup) and
            (
                n = class_base_count(cls) and result = false and not cls = sup
                or
                exists(ClassObject basetype |
                    basetype = class_base_type(cls, n) |
                    not basetype = sup and
                    result = is_subclass_bool(cls, sup, n+1).booleanOr(is_subclass_bool(basetype, sup))
                    or
                    basetype = sup and result = true
                )
            )
        }

        private predicate relevant_subclass_relation(ClassObject cls, ClassObject sup) {
            exists(ControlFlowNode supnode |
                points_to(supnode, _, sup, _, _)
                or
                element_of_points_to_tuple(supnode, _, sup)
                |
                subclass_test(supnode, cls)
            )
            or
            exists(ClassObject sub |
                relevant_subclass_relation(sub, sup) and
                class_base_type(sub, _) = cls
            )
        }

        /** Holds if there is a subclass test of `f` against class `cls`.
         *  Helper for relevant_subclass_relation.
         */
        private predicate subclass_test(ControlFlowNode f, ClassObject cls) {
            exists(ControlFlowNode use |
                BaseFilters::issubclass(_, f, use) and points_to(use, _, cls, _, _)
                or
                BaseFilters::isinstance(_, f, use) and points_to(use, _, _, cls, _)
            )
        }

        cached ClassList get_mro(ClassObject cls) {
            result = new_style_mro(cls) and is_new_style_bool(cls) = true
            or
            result = old_style_mro(cls) and is_new_style_bool(cls) = false
        }

        /** INTERNAL -- Use `ClassObject.declaredAttribute(name). instead. */
        cached predicate class_declared_attribute(ClassObject owner, string name, Object value, ClassObject vcls, ObjectOrCfg origin) {
            /* Note that src_var must be a local variable, we aren't interested in the value that any global variable may hold */
             value != undefinedVariable() and
             exists(EssaVariable var, LocalVariable src_var |
                var.getSourceVariable() = src_var and
                src_var.getId() = name and
                var.getAUse() = owner.getImportTimeScope().getANormalExit() |
                ssa_variable_points_to(var, _, value, vcls, origin)
            )
            or
            value = builtin_class_attribute(owner, name) and class_declares_attribute(owner, name) and
            origin = value and vcls = builtin_object_type(value)
        }

        private predicate interesting_class_attribute(ClassList mro, string name) {
            exists(ControlFlowNode use, ClassObject cls |
                mro = cls.getMro() and
                BaseFilters::hasattr(_, use, name) |
                points_to(use, _, cls, _, _) or
                points_to(use, _, _, cls, _)
            )
            or
            exists(ClassList sublist |
                sublist.getTail() = mro and
                interesting_class_attribute(sublist, name)
            )
            or
            name = "__call__"
        }

        private predicate does_not_have_attribute(ClassList mro, string name) {
            interesting_class_attribute(mro, name) and
            (
                mro.isEmpty()
                or
                exists(ClassObject head, ClassList tail |
                    head = mro.getHead() and tail = mro.getTail() |
                    does_not_have_attribute(tail, name) and
                    not class_declares_attribute(head, name)
                )
            )
        }

        /** Holds if the class `cls` has an attribute called `name` */
        cached predicate class_has_attribute(ClassObject cls, string name) {
            class_declares_attribute(get_an_improper_super_type(cls), name)
        }

        /** Gets `true` if the class `cls` is known to have attribute `name`,
         * or `false` if  the class `cls` is known to not have attribute `name`.
         */
        cached boolean class_has_attribute_bool(ClassObject cls, string name) {
            exists(ClassList mro |
                mro = cls.getMro() |
                mro.declares(name) and result = true
                or
                does_not_have_attribute(mro, name) and result = false
            )
        }

        /** INTERNAL -- Use `ClassObject.attributeRefersTo(name, value, vlcs, origin). instead.
         */
        cached predicate class_attribute_lookup(ClassObject cls, string name, Object value, ClassObject vcls, ObjectOrCfg origin) {
           exists(ClassObject defn |
               defn = get_mro(cls).findDeclaringClass(name) and
               class_declared_attribute(defn, name, value, vcls, origin)
           )
        }

        /** INTERNAL -- Use `ClassObject.failedInference(reason). instead.
         *
         *  Holds if type inference failed to compute the full class hierarchy for this class for the reason given. */
        cached predicate failed_inference(ClassObject cls, string reason) {
            strictcount(cls.getPyClass().getADecorator()) > 1 and reason = "Multiple decorators"
            or
            exists(cls.getPyClass().getADecorator()) and not six_add_metaclass(_, cls, _) and reason = "Decorator not understood"
            or
            exists(int i |
                exists(((ClassExpr)cls.getOrigin()).getBase(i)) and reason = "Missing base " + i
                |
                not exists(class_base_type(cls, i))
            )
            or
            exists(cls.getPyClass().getMetaClass()) and not exists(class_get_meta_class(cls)) and reason = "Failed to infer metaclass"
            or
            exists(int i | failed_inference(class_base_type(cls, i), _) and reason = "Failed inference for base class at position " + i)
            or
            exists(int i, Object base1, Object base2 |
                base1 = class_base_type(cls, i) and
                base2 = class_base_type(cls, i) and
                base1 != base2 and
                reason = "Multiple bases at position " + i
            )
            or
            exists(int i, int j | class_base_type(cls, i) = class_base_type(cls, j) and i != j and reason = "Duplicate bases classes")
            or
            cls = theUnknownType() and reason = "Unknown Type"
        }

        /** INTERNAL -- Use `ClassObject.getMetaClass()` instead.
         *
         *  Gets the metaclass for this class */
        cached ClassObject class_get_meta_class(ClassObject cls) {
            result = declared_meta_class(cls)
            or
            has_declared_metaclass(cls) = false and result = get_inherited_metaclass(cls)
            or
            cls = theUnknownType() and result = theUnknownType()
        }

        private ClassObject declared_meta_class(ClassObject cls) {
            exists(Object obj |
                ssa_variable_points_to(metaclass_var(cls.getPyClass()), _, obj, _, _) |
                result = obj
                or
                obj = unknownValue() and result = theUnknownType()
            )
            or
            py_cobjecttypes(cls, result) and is_c_metaclass(result)
            or
            exists(ControlFlowNode meta |
                Types::six_add_metaclass(_, cls, meta) and
                points_to(meta, _, result, _, _)
            )
        }

        private boolean has_metaclass_var_metaclass(ClassObject cls) {
            exists(Object obj |
                ssa_variable_points_to(metaclass_var(cls.getPyClass()), _, obj, _, _) |
                obj = undefinedVariable() and result = false
                or
                obj != undefinedVariable() and result = true
            )
            or
            exists(Class pycls |
                pycls = cls.getPyClass() and
                not exists(metaclass_var(pycls)) and result = false
            )
        }

        private boolean has_declared_metaclass(ClassObject cls) {
            py_cobjecttypes(cls, _) and result = true
            or
            result = has_six_add_metaclass(cls).booleanOr(has_metaclass_var_metaclass(cls))
        }

        private EssaVariable metaclass_var(Class cls) {
            result.getASourceUse() = cls.getMetaClass().getAFlowNode()
            or
            major_version() = 2 and not exists(cls.getMetaClass()) and
            result.getName() = "__metaclass__" and
            cls.(ImportTimeScope).entryEdge(result.getAUse(), _)
        }

        private ClassObject get_inherited_metaclass(ClassObject cls) {
            result = get_inherited_metaclass(cls, 0)
            or
            // Best guess if base is not a known class
            exists(Object base |
                base = class_base_type(cls, _) and
                result = theUnknownType() |
                base.notClass()
                or
                base = theUnknownType()
            )
        }

        private ClassObject get_inherited_metaclass(ClassObject cls, int n) {
            exists(Class c |
                c = cls.getPyClass() and
                n = count(c.getABase())
                |
                major_version() = 3 and result = theTypeType()
                or
                major_version() = 2 and result = theClassType()
            )
            or
            exists(ClassObject meta1, ClassObject meta2 |
                meta1 = class_get_meta_class(py_base_type(cls, n)) and
                meta2 = get_inherited_metaclass(cls, n+1)
                |
                /* Choose sub-class */
                get_an_improper_super_type(meta1) = meta2 and result = meta1
                or
                get_an_improper_super_type(meta2) = meta1 and result = meta2
                or
                /* Choose new-style meta-class over old-style */
                meta2 = theClassType() and result = meta1
                or
                /* Make sure we have a metaclass, even if base is unknown */
                meta1 = theUnknownType() and result = theTypeType()
                or
                meta2 = theUnknownType() and result = meta1
            )
        }

        private Object six_add_metaclass_function() {
            exists(Module six, FunctionExpr add_metaclass |
                add_metaclass.getInnerScope().getName() = "add_metaclass" and
                add_metaclass.getScope() = six and
                result.getOrigin() = add_metaclass
            )
        }

        private ControlFlowNode decorator_call_callee(ClassObject cls) {
            exists(CallNode decorator_call, CallNode decorator |
                 decorator_call.getArg(0) = cls and
                 decorator = decorator_call.getFunction() and
                 result = decorator.getFunction()
            )
        }

        /** INTERNAL -- Do not use */
        cached boolean has_six_add_metaclass(ClassObject cls) {
            exists(ControlFlowNode callee, Object func |
                callee = decorator_call_callee(cls) and
                points_to(callee, _, func, _, _) |
                func = six_add_metaclass_function() and result = true
                or
                not func = six_add_metaclass_function() and result = false
            )
            or
            not exists(six_add_metaclass_function()) and result = false
            or
            not exists(decorator_call_callee(cls)) and result = false
        }

        /** INTERNAL -- Do not use */
        cached predicate six_add_metaclass(CallNode decorator_call, ClassObject decorated, ControlFlowNode metaclass) {
            exists(CallNode decorator |
                decorator_call.getArg(0) = decorated and
                decorator = decorator_call.getFunction() and
                decorator.getArg(0) = metaclass |
                points_to(decorator.getFunction(), _, six_add_metaclass_function(), _, _)
                or
                exists(ModuleObject six |
                   six.getName() = "six" and
                   points_to(decorator.getFunction().(AttrNode).getObject("add_metaclass"), _, six, _, _)
               )
            )
        }

        /** INTERNAL -- Use `not cls.isAbstract()` instead. */
        cached predicate concrete_class(ClassObject cls) {
            Types::class_get_meta_class(cls) != theAbcMetaClassObject()
            or
            exists(Class c |
                c = cls.getPyClass() and
                not exists(c.getMetaClass())
                |
                forall(Function f |
                    f.getScope() = c |
                    not exists(Raise r, Name ex |
                        r.getScope() = f and
                        (r.getException() = ex or r.getException().(Call).getFunc() = ex) and
                        (ex.getId() = "NotImplementedError" or ex.getId() = "NotImplemented")
                    )
                )
            )
        }

        /** Holds if instances of class `cls` are always truthy. */
        cached predicate instances_always_true(ClassObject cls) {
            cls = theObjectType()
            or
            instances_always_true(cls, 0) and
            not exists(string meth |
               class_declares_attribute(cls, meth) |
               meth = "__bool__" or meth = "__len__" or
               meth = "__nonzero__" and major_version() = 2
            )
        }

        /** Holds if instances of class `cls` are always truthy. */
        cached predicate instances_always_true(ClassObject cls, int n) {
            not cls = theNoneType() and
            n = class_base_count(cls)
            or
            instances_always_true(cls, n+1) and
            instances_always_true(class_base_type(cls, n))
        }

    }

    /** Get the ESSA pseudo-variable used to retain module state
     * during module initialization. Module attributes are handled 
     * as attributes of this variable, allowing the SSA form to track 
     * mutations of the module during its creation.
     */
    private predicate isModuleStateVariable(EssaVariable var) {
        var.getName() = "$" and var.getScope() instanceof Module
    }

    /** INTERNAL -- Public for testing only */
    module Test {

        import Calls
        import SSA
        import Layer

    }

}

/* Helper classes for `super` dispatching. */

class SuperCall extends Object {

    EssaVariable self;
    ClassObject start;

    override string toString() {
        result = "super()"
    }

    SuperCall() {
        exists(CallNode call, PointsToContext context |
            call = this and
            PointsTo::points_to(call.getFunction(), _, theSuperType(), _, _) |
            PointsTo::points_to(call.getArg(0), context, start, _, _) and
            self.getASourceUse() = call.getArg(1)
            or
            major_version() = 3 and
            not exists(call.getArg(0)) and
            exists(Function func |
                call.getScope() = func and
                context.appliesToScope(func) and
                /* Implicit class argument is lexically enclosing scope */
                func.getScope() = start.getPyClass() and
                /* Implicit 'self' is the 0th parameter */
                self.getDefinition().(ParameterDefinition).getDefiningNode() = func.getArg(0).asName().getAFlowNode()
            )
        )
    }

    ClassObject startType() {
        result = start
    }

    ClassObject selfType(PointsToContext ctx) {
        PointsTo::ssa_variable_points_to(self, ctx, _, result, _)
    }

    predicate instantiation(PointsToContext ctx, ControlFlowNode f) {
        PointsTo::points_to(this.(CallNode).getArg(0), ctx, start, _, _) and f = this
    }

    EssaVariable getSelf() {
        result = self
    }
}

class SuperBoundMethod extends Object {

    override string toString() {
        result = "super()." + name
    }

    SuperCall superObject;
    string name;

    cached
    SuperBoundMethod() {
        exists(ControlFlowNode object |
            this.(AttrNode).getObject(name) = object |
            PointsTo::points_to(object, _, superObject, _, _)
        )
    }

    FunctionObject getFunction(PointsToContext ctx) {
        exists(ClassList mro |
            mro = PointsTo::Types::get_mro(superObject.selfType(ctx)) |
            result = mro.startingAt(superObject.startType()).getTail().lookup(name)
        )
    }

    predicate instantiation(PointsToContext ctx, ControlFlowNode f) {
        PointsTo::points_to(this.(AttrNode).getObject(name), ctx, superObject, _, _) and f = this
    }

    EssaVariable getSelf() {
        result = superObject.getSelf()
    }

}

