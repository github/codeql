import javascript

query predicate test_TaggedTemplateLiteralTypeArgument(TaggedTemplateExpr expr, int i, TypeExpr arg) {
  arg = expr.getTypeArgument(i)
}
