import cil::CIL

deprecated query predicate constructedMethods(
  UnboundGenericMethod f, ConstructedMethod fc, Type typeArgument
) {
  fc.getUnboundMethod() = f and
  f.hasFullyQualifiedName("Methods", "Class1", "F") and
  typeArgument = fc.getTypeArgument(0)
}
