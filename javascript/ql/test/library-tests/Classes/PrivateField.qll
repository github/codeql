import javascript

query string getAccessModifier(DataFlow::PropRef ref, Expr prop) {
  prop = ref.getPropertyNameExpr() and
  if ref.isPrivateField() then result = "Private" else result = "Public"
}
