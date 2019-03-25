import python
private import semmle.python.types.Builtins
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2
private import semmle.python.pointsto.PointsToContext

newtype TObject =
    TBuiltinClassObject(Builtin bltn) {
        bltn.isClass() and not bltn = Builtin::unknownType()
    }
    or
    TBuiltinFunctionObject(Builtin bltn) { bltn.isFunction() }
    or
    TBuiltinMethodObject(Builtin bltn) { bltn.isMethod() }
    or
    TBuiltinModuleObject(Builtin bltn) { bltn.isModule() }
    or
    TBuiltinOpaqueObject(Builtin bltn) {
        not bltn.isClass() and not bltn.isFunction() and
        not bltn.isMethod() and not bltn.isModule() and
        not bltn.getClass() = Builtin::special("tuple") and
        not exists(bltn.intValue()) and
        not exists(bltn.strValue()) and
        not py_special_objects(bltn, _)
    }
    or
    TPythonFunctionObject(ControlFlowNode callable) {
        callable.getNode() instanceof CallableExpr
    }
    or
    TPythonClassObject(ControlFlowNode classexpr) {
        classexpr.getNode() instanceof ClassExpr
    }
    or
    TPackageObject(Folder f) {
        exists(moduleNameFromFile(f))
    }
    or
    TPythonModule(Module m) { not m.isPackage() }
    or
    TTrue()
    or
    TFalse()
    or
    TNone()
    or
    TUnknown()
    or
    TUnknownClass()
    or
    TUndefined()
    or
    TInt(int n) {
        // Powers of 2 are used for flags
        is_power_2(n) or
        // And all combinations of flags up to 2^8
        n in [0..511] or
        // Any number explicitly mentioned in the source code.
        exists(Num num |
            n = num.getN().toInt() or
            exists(UnaryExpr neg | neg.getOp() instanceof USub and neg.getOperand() = num)
            and n = -num.getN().toInt()
        )
        or
        n = any(Builtin b).intValue()
    }
    or
    TString(string s) {
        // Any string explicitly mentioned in the source code.
        s = any(StrConst str).getText()
        or
        // Any string from the library put in the DB by the extractor.
        s = any(Builtin b).strValue()
        or
        s = "__main__"
    }
    or
    TSpecificInstance(ControlFlowNode instantiation, ClassObjectInternal cls, PointsToContext context) {
        PointsTo2::points_to(instantiation.(CallNode).getFunction(), context, cls, _) and
        cls.isSpecial() = false
    }
    or
    TSelfInstance(ParameterDefinition def, PointsToContext context, PythonClassObjectInternal cls) {
        self_parameter(def, context, cls)
    }
    or
    TBoundMethod(AttrNode instantiation, ObjectInternal self, CallableObjectInternal function, PointsToContext context) {
        method_binding(instantiation, self, function, context)
    }
    or
    TUnknownInstance(BuiltinClassObjectInternal cls) { any() }
    or
    TSuperInstance(ObjectInternal self, ClassObjectInternal startclass) {
        super_instantiation(_, self, startclass, _)
    }
    or
    TClassMethod(CallNode instantiation, CallableObjectInternal function) {
        class_method(instantiation, function, _)
    }
    or
    TStaticMethod(CallNode instantiation, CallableObjectInternal function) {
        static_method(instantiation, function, _)
    }
    or
    TBuiltinTuple(Builtin bltn) {
        bltn.getClass() = Builtin::special("tuple")
    }
    or
    TPythonTuple(TupleNode origin, PointsToContext context) {
        context.appliesTo(origin)
    }

private predicate is_power_2(int n) {
    n = 1 or
    exists(int half | is_power_2(half) and n = half*2)
}

predicate static_method(CallNode instantiation, CallableObjectInternal function, PointsToContext context) {
    PointsTo2::points_to(instantiation.getFunction(), context, ObjectInternal::builtin("staticmethod"), _) and
    PointsTo2::points_to(instantiation.getArg(0), context, function, _)
}

predicate class_method(CallNode instantiation, CallableObjectInternal function, PointsToContext context) {
    PointsTo2::points_to(instantiation.getFunction(), context, ObjectInternal::builtin("classmethod"), _) and
    PointsTo2::points_to(instantiation.getArg(0), context, function, _)
}

predicate super_instantiation(CallNode instantiation, ObjectInternal self, ClassObjectInternal startclass, PointsToContext context) {
    PointsTo2::points_to(instantiation.getFunction(), context, ObjectInternal::builtin("super"), _) and
    (
        PointsTo2::points_to(instantiation.getArg(0), context, startclass, _) and
        PointsTo2::points_to(instantiation.getArg(1), context, self, _)
        or
        major_version() = 3 and
        not exists(instantiation.getArg(0)) and
        exists(Function func |
            instantiation.getScope() = func and
            /* Implicit class argument is lexically enclosing scope */
            func.getScope() = startclass.(PythonClassObjectInternal).getScope() and
            /* Implicit 'self' is the 0th parameter */
            PointsTo2::points_to(func.getArg(0).asName().getAFlowNode(), context, self, _)
        )
    )
}

predicate method_binding(AttrNode instantiation, ObjectInternal self, CallableObjectInternal function, PointsToContext context) {
    exists(ObjectInternal obj, string name |
        receiver(instantiation, context, obj, name) |
        exists(ObjectInternal cls |
            cls = obj.getClass() and
            cls != ObjectInternal::builtin("super") and
            cls.attribute(name, function, _) and
            self = obj
        )
        or
        exists(SuperInstance sup |
            sup = obj and
            sup.getStartClass().attribute(name, function, _) and
            self = sup.getSelf()
        )
    )
}


/** Helper for method_binding */
pragma [noinline]
predicate receiver(AttrNode instantiation, PointsToContext context, ObjectInternal obj, string name) {
    PointsTo2::points_to(instantiation.getObject(name), context, obj, _)
}

/** Helper self parameters: `def meth(self, ...): ...`. */
pragma [noinline]
private predicate self_parameter(ParameterDefinition def, PointsToContext context, PythonClassObjectInternal cls) {
    def.isSelf() and
    exists(Function scope |
        def.getScope() = scope and
        def.isSelf() and
        context.isRuntime() and context.appliesToScope(scope) and
        scope.getScope() = cls.getScope() and
        concrete_class(cls) and
        /* We want to allow decorated functions, otherwise we lose a lot of useful information.
         * However, we want to exclude any function whose arguments are permuted by the decorator.
         * In general we can't do that, but we can special case the most common ones.
         */
        neither_class_nor_static_method(scope)
    )
}

/** INTERNAL -- Use `not cls.isAbstract()` instead. */
cached predicate concrete_class(PythonClassObjectInternal cls) {
    cls.getClass() != abcMetaClassObject()
    or
    exists(Class c |
        c = cls.getScope() and
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

private PythonClassObjectInternal abcMetaClassObject() {
    /* Avoid using points-to and thus negative recursion */
    exists(Class abcmeta |
        result.getScope() = abcmeta |
        abcmeta.getName() = "ABCMeta" and
        abcmeta.getScope().getName() = "abc"
    )
}

private predicate neither_class_nor_static_method(Function f) {
    not exists(f.getADecorator())
    or
    exists(ControlFlowNode deco |
        deco = f.getADecorator().getAFlowNode() |
        exists(ObjectInternal o |
            PointsTo2::points_to(deco, _, o, _) |
            o != ObjectInternal::staticMethod() and
            o != ObjectInternal::classMethod()
        )
        or not deco instanceof NameNode
    )
}



library class ClassDecl extends @py_object {

    ClassDecl() {
        this.(Builtin).isClass() and not this = Builtin::unknownType()
        or
        this.(ControlFlowNode).getNode() instanceof ClassExpr
    }

    string toString() {
        result = "ClassDecl"
    }

    private Class getClass() {
        result = this.(ControlFlowNode).getNode().(ClassExpr).getInnerScope()
    }

    predicate declaresAttribute(string name) {
        exists(this.(Builtin).getMember(name))
        or
        exists(SsaVariable var | name = var.getId() and var.getAUse() = this.getClass().getANormalExit())
    }

    string getName() {
        result = this.(Builtin).getName()
        or
        result = this.getClass().getName()
    }

    /** Whether this is a class whose instances we treat specially, rather than as a generic instance.
     */
    predicate isSpecial() {
        exists(string name |
            this = Builtin::special(name) |
            not name = "object" and
            not name = "list" and
            not name = "set" and
            not name.matches("%Exception") and
            not name.matches("%Error")
        )
    }

}

