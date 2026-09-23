func testExplicitClosureCall() {
    let addOne = { value in  // $ type=value:Int
        value + 1
    }
    let result = addOne(41)  // $ target=Function.invoke
    _ = result  // $ type=result:Int
}

func callWithIntCallback(_ callback: (Int) -> String) -> String {
    callback(42)  // $ target=Function.invoke
}

func callWithGenericCallback<T1>(_ callback: (T1) -> Void, _ arg: T1) -> T1 {
    callback(arg)  // $ target=Function.invoke
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
        self.f(value)  // $ target=f_method $ SPURIOUS: field=f_closure target=Function.invoke
        return self.f2(value)  // $ field=f2_closure target=Function.invoke
    }
}

func foo() {
    let numbers = [1, 2, 3]  // $ type=numbers@Array<Element>:Int

    let strings = numbers.map { x in  // $ type=x:Int
        String(x)  // $ target=String.init
    }  // $ target=Array.map
}

func apply<T1, T2>(_ callback: (T1) -> T2, _ arg: T1) -> T2 {
    callback(arg)  // $ target=Function.invoke
}

func testApply() {
    let result = apply(
        { value in  // $ type=value:Int
            String(value)  // $ target=String.init
        }, 42)  // $ target=apply
    _ = result  // $ type=result:String
}
