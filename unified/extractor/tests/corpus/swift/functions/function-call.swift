foo(1, 2)

handle {
  first()
} completion: {
  second()
} failure: {
  third()
}
