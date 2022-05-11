import csharp

query predicate missingUnbound(ConstructedGeneric g) { not exists(g.getUnboundGeneric()) }

query predicate missingArgs(ConstructedGeneric g) { g.getNumberOfTypeArguments() = 0 }

query predicate inconsistentArgCount(ConstructedGeneric g) {
  g.getUnboundGeneric().getNumberOfTypeParameters() != g.getNumberOfTypeArguments()
}
