import csharp

query predicate extensionTypeReceiverParameter(ExtensionType et, Parameter p) {
  et.getFile().getBaseName() = "extensions.cs" and
  p = et.getReceiverParameter()
}

query predicate extensionTypeExtendedType(ExtensionType et, string t) {
  et.getFile().getBaseName() = "extensions.cs" and
  t = et.getExtendedType().toStringWithTypes()
}
