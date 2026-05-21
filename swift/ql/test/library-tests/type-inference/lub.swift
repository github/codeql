class A {}

class B : A {}

class C : A {}

func foo() {
  let b = B() // $ type=b:B target=init()
  let c = C() // $ type=c:C target=init()
  let x = 2 > 3 ? b : c // $ type=x:A
}