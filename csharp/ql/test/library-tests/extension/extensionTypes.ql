import csharp

private predicate inTestFile(ExtensionType et) {
  et.getFile().getBaseName() = ["extensions.cs", "extensionTypes.cs"]
}

private string getModifier(Parameter p) {
  p.isIn() and result = "in"
  or
  p.isRef() and result = "ref"
  or
  p.isReadonlyRef() and result = "ref readonly"
}

query predicate extensionTypeReceiverParameter(ExtensionType et, Parameter p) {
  inTestFile(et) and
  p = et.getReceiverParameter()
}

query predicate extensionTypeExtendedType(ExtensionType et, string t) {
  inTestFile(et) and
  t = et.getExtendedType().toStringWithTypes()
}

query predicate extensionTypeReceiverParameterAttribute(ExtensionType et, Parameter p, Attribute a) {
  inTestFile(et) and
  et.getReceiverParameter() = p and
  p.getAnAttribute() = a
}

query predicate extensionTypeReceiverParameterModifier(
  ExtensionType et, Parameter p, string modifier
) {
  inTestFile(et) and
  et.getReceiverParameter() = p and
  modifier = getModifier(p)
}

query predicate extensionTypeParameterConstraints(
  UnboundGeneric ug, TypeParameter tp, TypeParameterConstraints c
) {
  inTestFile(ug) and
  ug instanceof ExtensionType and
  tp = ug.getATypeParameter() and
  tp.getConstraints() = c
}

query predicate syntheticParameterModifier(
  ExtensionType et, ExtensionMethod em, Parameter p, string modifier
) {
  inTestFile(et) and
  em.getDeclaringType() = et and
  p = em.getParameter(0) and
  not em.isStatic() and
  modifier = getModifier(p)
}
