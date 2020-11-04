import csharp

query predicate type(FunctionPointerType fpt, string returnType, int callingConvention) {
  fpt.getReturnType().toString() = returnType and
  fpt.getCallingConvention() = callingConvention
}

query predicate unmanagedCallingConvention(FunctionPointerType fpt, int i, string callingConvention) {
  fpt.getUnmanagedCallingConvention(i).toString() = callingConvention
}

query predicate parameter(FunctionPointerType fpt, int i, Parameter p, string t) {
  fpt.getParameter(i) = p and p.getType().toString() = t
}

query predicate invocation(FunctionPointerCall fpc) { any() }
