import csharp

// - Method should be from source (it looks like it is considered) compiler generated.
// - It appears that two methods are extracted
//   - One "generated" (which is what the compiler will generate).
//   - One "source" method, which reflects the method as it looks in source code.
//.  - Design decision: Only extract the associated extension implementation.
// - Make tests for ExtendedType.
// - Like there are extension methods, we need to declare isExtension for properties.
// - Make QL classes similar to ExtensionMethod for Properties and Operators.
// - Make sure we can declare MaD
// - Check that control flow works as expected.
// - Check that dataflow works as expected.
query predicate extensionMethodCallArgument(
  ExtensionMethodCall emc, ExtensionMethod em, Parameter p, int i, Expr e
) {
  em.getFile().getBaseName() = "extensions.cs" and
  emc.getTarget() = em and
  em.getParameter(i) = p and
  emc.getArgument(i) = e
}

query predicate extensionMethodCalls(
  ExtensionMethodCall emc, ExtensionMethod em, Type t, string type
) {
  em.getFile().getBaseName() = "extensions.cs" and
  emc.getTarget() = em and
  em.getDeclaringType() = t and
  em.getFullyQualifiedNameDebug() = type
}

query predicate extensionOperatorCallArgument(
  ExtensionOperator op, ExtensionOperatorCall opc, Parameter p, int pos, Expr e
) {
  opc.getTarget() = op and
  op.getFile().getBaseName() = "extensions.cs" and
  p = op.getParameter(pos) and
  e = opc.getArgument(pos)
}

query predicate extensionOperatorCalls(
  ExtensionOperatorCall opc, ExtensionOperator op, Type t, string type
) {
  op.getFile().getBaseName() = "extensions.cs" and
  opc.getTarget() = op and
  op.getDeclaringType() = t and
  op.getFullyQualifiedNameDebug() = type
}

query predicate extensionProperty(ExtensionProperty p, Type t) {
  p.getFile().getBaseName() = "extensions.cs" and
  p.getDeclaringType() = t
}

query predicate extensionPropertyCall(
  ExtensionPropertyCall pc, ExtensionProperty p, Type t, string type
) {
  p.getFile().getBaseName() = "extensions.cs" and
  pc.getProperty() = p and
  p.getDeclaringType() = t and
  p.getFullyQualifiedNameDebug() = type
}

query predicate extensionAccessorCall(
  ExtensionAccessorCall ac, ExtensionAccessor a, ExtensionProperty p, string type
) {
  p.getFile().getBaseName() = "extensions.cs" and
  (a.(Getter).getDeclaration() = p or a.(Setter).getDeclaration() = p) and
  ac.getTarget() = a and
  a.getFullyQualifiedNameDebug() = type
}
