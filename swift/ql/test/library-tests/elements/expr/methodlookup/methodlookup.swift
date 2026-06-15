class Foo {
    init() {}
    func instanceMethod() {}
    static func staticMethod() {}
    class func classMethod() {}
}

actor Bar {
    init() {}
    func instanceMethod() {}
    static func staticMethod() {}
}

@MainActor
class Baz {
    init() {}
    nonisolated func instanceMethod() {}
    static func staticMethod() {}
    class func classMethod() {}
}

do {
    let foo = Foo()
    _ = Foo.init()

    foo.instanceMethod()
    Foo.instanceMethod(foo)()

    Foo.classMethod()
    Foo.staticMethod()
}

Task {
    let bar = Bar()
    _ = Bar.init()

    await bar.instanceMethod()
    // Bar.instanceMethod(bar2)() // error: actor-isolated instance method 'instanceMethod()' can not be referenced from a non-isolated context

    Bar.staticMethod()
}

Task {
    let baz = await Baz()
    _ = await Baz.init()

    await baz.instanceMethod() // DotSyntaxCallExpr
    await Baz.instanceMethod(baz)() // DotSyntaxBaseIgnoredExpr

    await Baz.classMethod()
    await Baz.staticMethod()
}
