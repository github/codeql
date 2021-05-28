import csharp

private class RelevantElement extends Element {
  RelevantElement() {
    this.fromSource()
    or
    this.getLocation().(Assembly).getName() = "Assembly1"
  }
}

private class RelevantAttribute extends RelevantElement, Attribute {
  RelevantAttribute() {
    this.fromSource()
    or
    this.getType().getName() = "CustomAttribute"
  }
}

private class RelevantExpr extends RelevantElement, Expr { }

query predicate arguments(RelevantAttribute attribute, int index, RelevantExpr e) {
  e = attribute.getArgument(index)
}

query predicate constructorArguments(RelevantAttribute attribute, int index, RelevantExpr e) {
  e = attribute.getConstructorArgument(index)
}

query predicate namedArguments(RelevantAttribute attribute, string name, RelevantExpr e) {
  e = attribute.getNamedArgument(name)
}
