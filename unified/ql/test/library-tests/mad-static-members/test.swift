// `StaticTest` and `StaticTest.Nested` are not declared in the test codebase; they are only known from the models.

func testStaticMembers(obj: StaticTest) {
    _ = StaticTest.init(x: 1)  // $ baseMetaType=StaticTest.Type // not a static member: constructors are not members of the meta type
    _ = StaticTest.staticMethod(1)  // $ baseMetaType=StaticTest.Type staticMember=StaticTest.Type.staticMethod
    _ = StaticTest.staticProp  // $ baseMetaType=StaticTest.Type staticMember=StaticTest.Type.staticProp
    _ = StaticTest.Nested.nestedStaticProp  // $ baseMetaType=StaticTest.Nested.Type baseMetaType=StaticTest.Type staticMember=StaticTest.Nested.Type.nestedStaticProp

    _ = StaticTest.instanceMethod(1)  // $ baseMetaType=StaticTest.Type // not a static member
    _ = StaticTest.instanceProp  // $ baseMetaType=StaticTest.Type // not a static member
    _ = StaticTest.unknownProp  // $ baseMetaType=StaticTest.Type // not in a model

    // Accesses through an instance are not resolved by name binding
    _ = obj.staticMethod(1)
    _ = obj.staticProp
}

class StaticTestSub: StaticTest {
    func testInstanceContextInSubclass() {
        _ = instanceProp  // $ unqualified=StaticTest.instanceProp
        _ = staticProp  // $ baseMetaType=StaticTestSub.Type staticMember=StaticTest.Type.staticProp SPURIOUS: unqualified=StaticTest.Type.staticProp // not accessible from an instance context
    }

    static func testStaticContextInSubclass() {
        _ = staticProp  // $ baseMetaType=StaticTestSub.Type unqualified=StaticTest.Type.staticProp staticMember=StaticTest.Type.staticProp
        _ = instanceProp  // $ baseMetaType=StaticTestSub.Type SPURIOUS: unqualified=StaticTest.instanceProp // not accessible from a static context
    }
}

func testInheritedStaticMembers() {
    _ = StaticTestSub.staticMethod(1)  // $ baseMetaType=StaticTestSub.Type staticMember=StaticTest.Type.staticMethod
    _ = StaticTestSub.staticProp  // $ baseMetaType=StaticTestSub.Type staticMember=StaticTest.Type.staticProp
    _ = StaticTestSub.init(x: 1)  // $ baseMetaType=StaticTestSub.Type // not a static member: constructors are not members of the meta type
    _ = StaticTestSub.instanceProp  // $ baseMetaType=StaticTestSub.Type // not a static member
}

func testTopLevelFunctions(string: String) {
    NSLog(string)  // $ staticMember=.NSLog
}

extension StaticTest {
    func testInstanceContextInExtension() {
        _ = instanceProp  // $ unqualified=StaticTest.instanceProp
        _ = instanceMethod(1)  // $ unqualified=StaticTest.instanceMethod
        _ = staticProp  // $ baseMetaType=StaticTest.Type staticMember=StaticTest.Type.staticProp SPURIOUS: unqualified=StaticTest.Type.staticProp // not accessible from an instance context
    }

    static func testStaticContextInExtension() {
        _ = staticProp  // $ baseMetaType=StaticTest.Type unqualified=StaticTest.Type.staticProp staticMember=StaticTest.Type.staticProp
        _ = staticMethod(1)  // $ baseMetaType=StaticTest.Type unqualified=StaticTest.Type.staticMethod staticMember=StaticTest.Type.staticMethod
        _ = instanceProp  // $ baseMetaType=StaticTest.Type SPURIOUS: unqualified=StaticTest.instanceProp // not accessible from a static context
    }
}

class DeclaredType {
    static var staticField = 0
    var instanceField = 0

    static func staticContext() {
        _ = staticField  // $ baseMetaType=DeclaredType.Type
    }

    func instanceContext() {
        _ = instanceField
    }
}

func testDeclaredType(obj: DeclaredType) {
    _ = DeclaredType.staticField  // $ baseMetaType=DeclaredType.Type
    _ = obj.instanceField
}
