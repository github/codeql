import csharp

query predicate fptrCall(FunctionPointerCall fptrc, Callable c, CallContext::CallContext cc) {
  c = fptrc.getARuntimeTarget(cc)
}
