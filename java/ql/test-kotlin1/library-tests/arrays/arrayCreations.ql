import java

query predicate arrayCreationTypes(ArrayCreationExpr ace, Type t, TypeAccess elementType) {
  t = ace.getType() and elementType.getParent() = ace
}

query predicate arrayCreationDimensions(ArrayCreationExpr ace, Expr dimension, int dimensionIdx) {
  ace.getDimension(dimensionIdx) = dimension
}

query predicate arrayCreationInit(ArrayCreationExpr ace, ArrayInit init, Expr e, int idx) {
  ace.getInit() = init and
  init.getInit(idx) = e
}

query predicate cloneCalls(MethodCall ma, Type resultType) {
  ma.getMethod().getName() = "clone" and resultType = ma.getType()
}
