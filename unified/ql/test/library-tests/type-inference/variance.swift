// variance is not currently supported

class A<Ta> {}

class B<Tb>: A<Tb> {}

func foo<T1, T2>(f: (B<T1>) -> A<T2>) -> (T1, T2) {
  fatalError()  // placeholder implementation
}

let lam = { (a: A<Int>) -> B<String> in B<String>() }  // $ target=A.init

let x = foo(f: lam)  // $ target=foo $ MISSING: type=x@Tuple2<T0>:Int type=x@Tuple2<T1>:String

func bar<T>() -> B<T> { B() }  // $ target=A.init

func baz() {
  let x: A<Int> = bar()  // $ target=bar $ MISSING: type=bar(...)@B<Tb>:Int
}
