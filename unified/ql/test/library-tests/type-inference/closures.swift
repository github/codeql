func testExplicitClosureCall() {
    let addOne = { value in  // $ type=value:Int
        value + 1
    }
    let result = addOne(41)  // $ target=Function.callAsFunction
    _ = result  // $ type=result:Int
}

func callWithIntCallback(_ callback: (Int) -> String) -> String {
    callback(42)  // $ target=Function.callAsFunction
}

func callWithGenericCallback<T1>(_ callback: (T1) -> Void, _ arg: T1) -> T1 {
    callback(arg)  // $ target=Function.callAsFunction
    return arg
}

func testImplicitClosureCall() {
    let result = callWithIntCallback { value in
        String(value)  // $ type=value:Int target=String.init
    }  // $ target=callWithIntCallback
    _ = result  // $ type=result:String

    let genericResult = callWithGenericCallback(
        { value in  // $ type=value:Bool
            // do nothing
        }, false)  // $ target=callWithGenericCallback
    _ = genericResult  // $ type=genericResult:Bool
}

class ClosureField {
    var f: (Int) -> Int  // name=f_closure

    func f(_ value: Int) -> Int {  // name=f_method
        return 0
    }

    var f2: (Int) -> Int  // name=f2_closure

    init(f: @escaping (Int) -> Int) {
        self.f = f  // $ field=f_closure
        self.f2 = f  // $ field=f2_closure
    }

    func callsMethod(_ value: Int) -> Int {
        // when both a method and a closure have the same name, the method takes precedence
        self.f(value)  // $ target=f_method $ SPURIOUS: field=f_closure target=Function.callAsFunction
        return self.f2(value)  // $ field=f2_closure target=Function.callAsFunction
    }
}

func foo() {
    let numbers = [1, 2, 3]  // $ type=numbers@Array<Element>:Int

    let strings = numbers.map { x in  // $ type=x:Int
        String(x)  // $ target=String.init
    }  // $ target=Array.map
}

func apply<T1, T2>(_ callback: (T1) -> T2, _ arg: T1) -> T2 {
    callback(arg)  // $ target=Function.callAsFunction
}

func testApply() {
    let result = apply(
        { value in  // $ type=value:Int
            String(value)  // $ target=String.init
        }, 42)  // $ target=apply
    _ = result  // $ type=result:String
}

class Box<T> {}

let f: (Box<Int>) -> Void = { box in
}

f(Box())  // $ target=Function.callAsFunction target=Box.init type=Box(...)@Box<T>:Int

func testShorthandClosureCall() {
    let result = apply(
        {
            String($0)  // $ target=String.init type=$0:Int
        }, 42)  // $ target=apply
    _ = result  // $ type=result:String
}

func testSkippedShorthandParameter() {
    let result = {
        $1  // $ type=$1:String
    }(42, "hello")  // $ target=Function.callAsFunction
    _ = result  // $ type=result:String
}

func testNestedShorthandParameters() {
    let result = {
        let value = $0  // $ type=$0:Int
        let string = {
            $1  // $ type=$1:String
        }(false, "hello")  // $ target=Function.callAsFunction
        _ = string  // $ type=string:String
        return value  // $ type=value:Int
    }(42)  // $ target=Function.callAsFunction
    _ = result  // $ type=result:Int
}

func testContextualShorthandParameter() {
    let identity: (Int) -> Int = {
        $0  // $ type=$0:Int
    }
    let result = identity(42)  // $ target=Function.callAsFunction
    _ = result  // $ type=result:Int
}

func testNamedOuterWithShorthandInner(xs: [Int], ys: [Int]) {
    let result = xs.map { outer in  // $ type=outer:Int
        ys.map {
            outer + $0  // $ type=outer:Int type=$0:Int
        }  // $ target=Array.map
    }  // $ target=Array.map
    _ = result  // $ type=result:Array type=result@Array<Element>:Array
}

func makeClosureArgument<T>() -> T {
    fatalError()
}

func testReturnContextShorthandParameter() {
    let result: String = {
        $1  // $ type=$1:String
    }(false, makeClosureArgument())  // $ target=Function.callAsFunction target=makeClosureArgument
    _ = result  // $ type=result:String
}

func testRepeatedContextualShorthandParameters() {
    let repeated = {
        let a = $0  // $ type=$0:Int
        let b = $0  // $ type=$0:Int
        let c = $1  // $ type=$1:String
        let d = $1  // $ type=$1:String
        return (a, b, c, d)  // $ type=a:Int type=b:Int type=c:String type=d:String
    }
    let result = repeated(1, "a")  // $ target=Function.callAsFunction
    _ = result  // $ type=result@Tuple4<T0>:Int type=result@Tuple4<T1>:Int type=result@Tuple4<T2>:String type=result@Tuple4<T3>:String
}

func testRepeatedReturnContextShorthandParameter() {
    let result: String = {
        ($1, $1).1  // $ type=$1:String field=Tuple2.1
    }(false, makeClosureArgument())  // $ target=Function.callAsFunction target=makeClosureArgument
    _ = result  // $ type=result:String
}
