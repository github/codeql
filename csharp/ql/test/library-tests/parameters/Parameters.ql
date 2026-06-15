import csharp

private predicate fromTestLocation(Element e) {
  e.fromSource() and
  e.getFile().getBaseName() = ["Parameters.cs", "LambdaParameters.cs"]
  or
  e.getFile().getStem() = "Parameters"
}

private predicate compilerGeneratedAttribute(Parameterizable container) {
  container.getDeclaringType().getAnAttribute().getType().toStringWithTypes() =
    "CompilerGeneratedAttribute"
}

query predicate noDefaultValue(Parameterizable container, Parameter p, int i) {
  fromTestLocation(container) and
  not p.hasDefaultValue() and
  container.getParameter(i) = p and
  not compilerGeneratedAttribute(container)
}

private predicate defaultValue(Parameterizable container, Parameter p, int i, Expr e) {
  fromTestLocation(container) and
  p.hasDefaultValue() and
  container.getParameter(i) = p and
  p.getDefaultValue() = e
}

query predicate withDefaultValue(Parameterizable container, Parameter p, int i, Expr e, string value) {
  defaultValue(container, p, i, e) and
  (if exists(e.getValue()) then value = e.getValue() else value = "-") and
  not compilerGeneratedAttribute(container)
}

query predicate dateTimeDefaults(
  Parameterizable container, Parameter p, ObjectCreation o, string constructor, string value
) {
  defaultValue(container, p, _, o) and
  o.getTarget().toStringWithTypes() = constructor and
  o.getAnArgument().getValue() = value and
  not compilerGeneratedAttribute(container)
}

query predicate implicitConversionDefaults(
  Parameterizable container, Parameter p, OperatorCall o, Expr e, string type, string value
) {
  defaultValue(container, p, _, o) and
  o.getAnArgument() = e and
  type = e.getType().toString() and
  value = e.getValue()
}
