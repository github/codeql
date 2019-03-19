import python
private import semmle.python.types.Builtins

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
        not py_special_objects(bltn, _)
    }
    or
    TPythonFunctionObject(ControlFlowNode callable) {
        callable.getNode() instanceof CallableExpr
    }
    or
    TPythonClassObject(ControlFlowNode classdef) {
        classdef.getNode() instanceof ClassDef
    }
    or
    TPackageObject(Folder f)
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


library class ClassDecl extends @py_object {

    ClassDecl() {
        this.(Builtin).isClass() and not this = Builtin::unknownType()
        or
        this.(ControlFlowNode).getNode() instanceof ClassDef
    }

    string toString() {
        result = "ClassDecl"
    }

    predicate declaresAttribute(string name) {
        exists(this.(Builtin).getMember(name))
        or
        exists(Class cls |
            cls = this.(ControlFlowNode).getNode().(ClassDef).getDefinedClass() and
            exists(SsaVariable var | name = var.getId() and var.getAUse() = cls.getANormalExit())
        )
    }
}
