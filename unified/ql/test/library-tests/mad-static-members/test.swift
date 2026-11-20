// `StaticTest` and `StaticTest.Nested` are not declared in the test codebase; they are only known from the models.

func testStaticMembers(obj: StaticTest) {
    _ = StaticTest.init(x: 1)  // not a static member: constructors are not members of the meta type
    _ = StaticTest.staticMethod(1)  // $ staticMember=StaticTest.Type.staticMethod
    _ = StaticTest.staticProp  // $ staticMember=StaticTest.Type.staticProp
    _ = StaticTest.Nested.nestedStaticProp  // $ staticMember=StaticTest.Nested.Type.nestedStaticProp

    _ = StaticTest.instanceMethod(1)  // not a static member
    _ = StaticTest.instanceProp  // not a static member
    _ = StaticTest.unknownProp  // not in a model

    // Accesses through an instance are not resolved by name binding
    _ = obj.staticMethod(1)
    _ = obj.staticProp
}
