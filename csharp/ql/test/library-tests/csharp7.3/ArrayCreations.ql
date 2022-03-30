import csharp

query predicate arrayCreation(ArrayCreation creation, int i, Expr length) {
  creation.fromSource() and
  length = creation.getLengthArgument(i)
}

query predicate arrayElement(ArrayCreation array, int i, Expr element) {
  array.fromSource() and
  element = array.getInitializer().getElement(i)
}

query predicate stackalloc(Stackalloc a) { a.fromSource() }
