func source() -> Int { return 0; }
func sink(arg: Int) {}

func intraprocedural_with_local_flow() -> Void {
    var t2: Int
    var t1: Int = source()
    sink(arg: t1) // $ flow=6
    t2 = t1
    sink(arg: t1) // $ flow=6
    sink(arg: t2) // $ flow=6
    if(t1 != 0) {
        t2 = 0
        sink(arg: t2)
    }
    sink(arg: t2) // $ MISSING: flow=6

    t1 = 0;
    while(false) {
        t1 = t2
    }
    sink(arg: t1)
}

func caller_source() -> Void {
    callee_sink(x: source(), y: 1)
    callee_sink(x: 1, y: source())
}

func callee_sink(x: Int, y: Int) -> Void {
    sink(arg: x) // $ flow=25
    sink(arg: y) // $ flow=26
}

func callee_source() -> Int {
    return source()
}

func caller_sink() -> Void {
    sink(arg: callee_source()) // $ flow=35
}

func branching(b: Bool) -> Void {
    var t1: Int = source()
    var t: Int = 0
    if(b) {
        t = t1;
    } else {
        t = 1;
    }
    sink(arg: t) // $ flow=43
}

func inoutSource(arg: inout Int) -> Void {
    arg = source()
    return
}

func inoutUser() {
    var x: Int = 0
    sink(arg: x)
    inoutSource(arg: &x)
    sink(arg: x) // $ flow=54
}

func inoutSwap(arg1: inout Int, arg2: inout Int) -> Void {
    var temp: Int = arg1
    arg1 = arg2
    arg2 = temp
    return
}

func swapUser() {
    var x: Int = source()
    var y: Int = 0
    inoutSwap(arg1: &x, arg2: &y)
    sink(arg: x) // clean
    sink(arg: y) // $ flow=73
}

func inoutSourceWithoutReturn(arg: inout Int) {
    arg = source()
}

func inoutSourceMultipleReturn(arg: inout Int, bool: Bool) {
    if(bool) {
        arg = source()
        return
    } else {
        arg = source()
    }
}

func inoutUser2(bool: Bool) {
    do {
        var x: Int = 0
        sink(arg: x) // clean
        inoutSourceWithoutReturn(arg: &x)
        sink(arg: x)  // $ flow=81
    }

    do {
        var x: Int = 0
        sink(arg: x) // clean
        inoutSourceMultipleReturn(arg: &x, bool: bool)
        sink(arg: x) // $ flow=86 flow=89
    }
}

func id(arg: Int) -> Int {
    return arg
}

func forward(arg: Int, lambda: (Int) -> Int) -> Int {
    return lambda(arg)
}

func forwarder() {
    var x: Int = source()
    var y: Int = forward(arg: x, lambda: id)
    sink(arg: y) // $ flow=118

    var z: Int = forward(arg: source(), lambda: {
        (i: Int) -> Int in
        return i
    })
    sink(arg: z) // $ flow=122
    
    var clean: Int = forward(arg: source(), lambda: {
        (i: Int) -> Int in
        return 0
    })
    sink(arg: clean)
}

func lambdaFlows() {
    var lambda1 = {
        () -> Void in
        sink(arg: source()) // $ flow=138
    }

    var lambda2 = {
        (i: Int) -> Int in
        return i
    }
    sink(arg: lambda2(source())) // $ flow=145

    var lambdaSource = {
        () -> Int in
        return source()
    }
    sink(arg: lambdaSource()) // $ flow=149

    var lambdaSink = {
        (i: Int) -> Void in
        sink(arg: i) // $ flow=157 flow=149
    }
    lambdaSink(source())

    lambdaSink(lambdaSource())
}

class A {
  var x : Int

  init() {
    x = 0
  }

  func set(_ value : Int) {
    x = value
  }

  func get() -> Int {
    return x
  }
}

func simple_field_flow() {
  var a = A()
  a.x = source()
  sink(arg: a.x) // $ MISSING: flow=180
}

class B {
  var a : A

  init() {
    a = A()
  }
}

func reverse_read() {
  var b = B()
  b.a.x = source()
  sink(arg: b.a.x) // $ MISSING: flow=194
}

func test_setter() {
  var a = A()
  a.set(source())
  sink(arg: a.x) // $ MISSING: flow=200
}

func test_getter() {
  var a = A()
  a.x = source()
  sink(arg: a.get()) // $ MISSING: flow=206
}

func test_setter_getter() {
  var a = A()
  a.set(source())
  sink(arg: a.get()) // $ MISSING: flow=212
}

func flow_through(b : B) {
  var b = B()
  b.a.set(source())
  sink(arg: b.a.x) // $ MISSING: flow=218
}

class HasComputedProperty {
  var source_value : Int {
    get {
      return source()
    }
    set {

    }
  }
}

func test_computed_property() {
  var a = HasComputedProperty()
  sink(arg: a.source_value) // $ MISSING: flow=225

  a.source_value = 0
  sink(arg: a.source_value) // $ MISSING: flow=225
}

@propertyWrapper struct DidSetSource {
    var wrappedValue: Int {
        didSet { wrappedValue = source() }
    }

    init(wrappedValue: Int) {
        self.wrappedValue = 0
    }
}

func test_property_wrapper() {
    @DidSetSource var x = 42
    sink(arg: x) // $ MISSING: flow=243
}