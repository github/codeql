import cil
import semmle.code.cil.Type

bindingset[kind]
private string getKind(int kind) { if kind = 1 then result = "modreq" else result = "modopt" }

query predicate fnptr(FunctionPointerType fn, int paramCount, Type returnType, int callingConvention) {
  paramCount = fn.getNumberOfParameters() and
  returnType = fn.getReturnType() and
  callingConvention = fn.getCallingConvention()
}

query predicate params(FunctionPointerType fn, int i, Parameter p, Type t) {
  fn.getParameter(i) = p and p.getType() = t
}

query predicate modifiers(FunctionPointerType fn, string modifier, string sKind) {
  exists(Type modType, int kind |
    cil_custom_modifiers(fn, modType, kind) and
    modType.getQualifiedName() = modifier and
    sKind = getKind(kind)
  )
}
