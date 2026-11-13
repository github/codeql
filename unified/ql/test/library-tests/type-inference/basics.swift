var topLevelDecl: Int = 0
0
topLevelDecl + 1  // $ type=topLevelDecl:Int

class C {
  var myInt: Int
  init(n: Int) {
    myInt = n  // $ type=n:Int field=C.myInt
  }

  func getMyInt() -> Int {
    return myInt  // $ type=myInt:Int field=C.myInt
  }
}

class Derived: C {
  init() {
    super.init(n: 0)  // $ type=super:C target=C.init
  }

  func callGetMyInt() -> Int {
    let x = getMyInt()  // $ type=x:Int target=C.getMyInt
    return x
  }
}

class Generic<T> {
  var value: T
  init(v: T) {
    value = v  // $ type=v:T field=Generic.value
  }

  func getValue() -> T {
    return value  // $ type=value:T field=Generic.value
  }
}

class GenericDerived: Generic<Int> {
  init() {
    super.init(v: 0)  // $ type=super@Generic<T>:Int target=Generic.init
  }
}

func testGeneric() {
  let g = Generic(v: 42)  // $ type=g@Generic<T>:Int target=Generic.init
  let x = g.getValue()  // $ type=x:Int target=Generic.getValue

  let gd = GenericDerived()  // $ type=gd:GenericDerived target=GenericDerived.init
  let y = gd.getValue()  // $ type=y:Int target=Generic.getValue
}

// --- Extensions ---

extension C {
  func doubled() -> Int {
    return myInt * 2  // $ type=myInt:Int field=C.myInt
  }
}

func testExtension() {
  let obj = C(n: 10)  // $ target=C.init
  let d = obj.doubled()  // $ type=d:Int target=C.doubled
}

// --- Named Arguments ---

func swap<T1, T2>(a a1: T1, a a2: T2) -> (T2, T1) {
  return (a2, a1)
}

let pair = swap(a: 1, a: true)  // $ target=swap type=pair@Tuple2<T0>:Bool type=pair@Tuple2<T1>:Int

func f(a first: (Int) -> Void, a second: (String) -> Void) {}

f { x in  // $ type=x:Int
} a: { y in  // $ MISSING: type=y:String (second closure is incorrectly matched against the first `a` parameter)
}  // $  target=f
