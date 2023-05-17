import csharp

private predicate fromTestLocation(Element e) {
  e.fromSource() or e.getFile().getStem() = "Parameters"
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

query predicate withDefaultValue(Parameterizable container, Parameter p, int i, Expr e, string value) {
  fromTestLocation(container) and
  p.hasDefaultValue() and
  container.getParameter(i) = p and
  p.getDefaultValue() = e and
  (if exists(e.getValue()) then value = e.getValue() else value = "-") and
  not compilerGeneratedAttribute(container)
}

query predicate dateTimeDefaults(
  Parameterizable container, Parameter p, ObjectCreation o, string constructor, string value
) {
  fromTestLocation(container) and
  p.hasDefaultValue() and
  container.getAParameter() = p and
  p.getDefaultValue() = o and
  o.getTarget().toStringWithTypes() = constructor and
  o.getAnArgument().getValue() = value and
  not compilerGeneratedAttribute(container)
}
