import csharp

query predicate type(FunctionPointerType fpt, string returnType, string callingConvention) {
  fpt.getAnnotatedReturnType().toString() = returnType and
  fpt.getCallingConvention().toString() = callingConvention
}

query predicate unmanagedCallingConvention(FunctionPointerType fpt, int i, string callingConvention) {
  fpt.getUnmanagedCallingConvention(i).toString() = callingConvention
}

query predicate parameter(FunctionPointerType fpt, int i, Parameter p, string t) {
  fpt.getParameter(i) = p and p.getAnnotatedType().toString() = t
}

query predicate invocation(FunctionPointerCall fpc) { any() }

query predicate casts(ImplicitCast cast, FunctionPointerType fromType, FunctionPointerType toType) {
  cast.getSourceType() = fromType and cast.getTargetType() = toType
}
