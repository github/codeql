import semmle.code.cil.CIL

deprecated private string getTypeArguments(GenericAttribute a) {
  result = "(" + concat(Type t | t = a.getATypeArgument() | t.getName(), ",") + ")"
}

deprecated query predicate genericAttribute(
  GenericAttribute a, string name, int numArgs, string args
) {
  a.getFile().getStem() = "assembly" and
  name = a.getType().getName() and
  numArgs = a.getNumberOfTypeArguments() and
  args = getTypeArguments(a)
}
