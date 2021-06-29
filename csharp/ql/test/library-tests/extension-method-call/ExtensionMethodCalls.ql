import csharp

query predicate methodCallTargets(MethodCall mc, Method m, string sig) {
  m = mc.getTarget() and sig = m.toStringWithTypes()
}

query predicate genericMethodCallTargets(
  MethodCall mc, ConstructedMethod cm, string sig1, UnboundGenericMethod ugm, string sig2
) {
  cm = mc.getTarget() and
  sig1 = cm.toStringWithTypes() and
  ugm = cm.getUnboundGeneric() and
  sig2 = ugm.toStringWithTypes()
}
