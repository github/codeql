func foo() {
  let numbers = [1, 2, 3] // $ type=numbers@Array<Element>:Int

  let strings = numbers.map { x in // $ type=x:Int
      String(x)
  } // $ target=map(_:)
}