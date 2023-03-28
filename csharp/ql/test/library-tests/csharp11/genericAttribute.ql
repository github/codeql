import csharp

private string getTypeArguments(GenericAttribute a) {
  result = "(" + concat(Type t | t = a.getATypeArgument() | t.getName(), ",") + ")"
}

from GenericAttribute a
where a.getFile().getStem() = "GenericAttribute"
select a, a.getType().getName(), a.getNumberOfTypeArguments(), getTypeArguments(a),
  a.getAPrimaryQlClass()
