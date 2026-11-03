class MyClass<T> {
    let value: T
    init(value: T) {
        self.value = value  // $ field=MyClass.value
    }
    func getValue() -> T {
        return self.value  // $ field=MyClass.value
    }
}

typealias Alias1 = MyClass<Int>

typealias Alias2<T2> = MyClass<(T2, T2)>

typealias Alias3<T3> = Alias2<T3?>

func test(_ a1: Alias1, _ a2: Alias2<Bool>, _ a3: Alias3<String>) {
    let v1 = a1.getValue()  // $ target=MyClass.getValue type=v1:Int
    let v2 = a2.getValue()  // $ target=MyClass.getValue type=v2@Tuple2<T0>:Bool
    let v3 = a3.getValue()  // $ target=MyClass.getValue type=v3@Tuple2<T0>.Optional<Wrapped>:String
}
