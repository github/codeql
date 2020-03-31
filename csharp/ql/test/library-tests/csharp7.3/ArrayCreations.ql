import csharp

query predicate arrayCreation(ArrayCreation creation, int i, Expr length) {
  length = creation.getLengthArgument(i)
}

query predicate arrayElement(ArrayCreation array, int i, Expr element) {
  element = array.getInitializer().getElement(i)
}

query predicate stackalloc(Stackalloc a) { any() }
