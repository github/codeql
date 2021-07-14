import cil
import semmle.code.cil.Type

bindingset[kind]
private string getKind(int kind) { if kind = 1 then result = "modreq" else result = "modopt" }

bindingset[t, e]
private string getAnnotatedType(Type t, Element e) {
  cil_type_annotation(e, 32) and result = t.toString() + "&"
  or
  not cil_type_annotation(e, 32) and result = t.toString()
}

query predicate fnptr(string fnptr, int paramCount, string returnType, int callingConvention) {
  exists(FunctionPointerType fn | fnptr = fn.toString() |
    paramCount = fn.getNumberOfParameters() and
    returnType = getAnnotatedType(fn.getReturnType(), fn) and
    callingConvention = fn.getCallingConvention()
  )
}

query predicate params(string fnptr, int i, string param, string t) {
  exists(FunctionPointerType fn, Parameter p | fnptr = fn.toString() and param = p.toString() |
    fn.getParameter(i) = p and t = getAnnotatedType(p.getType(), p)
  )
}

query predicate modifiers(string fnptr, string modifier, string sKind) {
  exists(Type modType, int kind, FunctionPointerType fn | fnptr = fn.toString() |
    cil_custom_modifiers(fn, modType, kind) and
    modType.getQualifiedName() = modifier and
    sKind = getKind(kind)
  )
}
