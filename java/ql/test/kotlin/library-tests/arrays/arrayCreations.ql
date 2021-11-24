import java

query predicate arrayCreationTypes(ArrayCreationExpr ace, Type t) { t = ace.getType() }

query predicate arrayCreationDimensions(ArrayCreationExpr ace, Expr dimension, int dimensionIdx) {
  ace.getDimension(dimensionIdx) = dimension
}

query predicate arrayCreationInit(ArrayCreationExpr ace, ArrayInit init, Expr e, int idx) {
  ace.getInit() = init and
  init.getInit(idx) = e
}
