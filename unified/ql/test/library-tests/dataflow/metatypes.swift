class MetaBase {
    static func staticId(_ x: String) -> String { return x }

    class func classId(_ x: String) -> String { return x }

    static func staticSink(_ x: String) {
        sink(x)  // $ hasValueFlow=meta.static-sink
    }

    func instanceId(_ x: String) -> String { return x }
}

class MetaSub: MetaBase {
    override class func classId(_ x: String) -> String { return "safe" }
}

func testMetaTypeParameter(t: MetaBase.Type) {
    sink(t.staticId(source("meta.1")))  // $ hasValueFlow=meta.1
    sink(t.classId(source("meta.2")))  // $ hasValueFlow=meta.2
    t.staticSink(source("meta.static-sink"))
}

func testMetaTypeLocal() {
    let t: MetaBase.Type = MetaBase.self
    sink(t.staticId(source("meta.3")))  // $ hasValueFlow=meta.3
}

func testSelfExpr() {
    let t = MetaBase.self
    sink(t.staticId(source("meta.4")))  // $ hasValueFlow=meta.4
}

func testSubclassMetaType(t: MetaSub.Type) {
    sink(t.staticId(source("meta.5")))  // $ hasValueFlow=meta.5
}

func testExplicitTypeReference() {
    sink(MetaBase.staticId(source("meta.6")))  // $ hasValueFlow=meta.6
    sink(MetaBase.classId(source("meta.7")))  // $ hasValueFlow=meta.7
}

class MetaDispatchBase {
    class func classSink(_ x: String) {}
}

class MetaDispatchSub: MetaDispatchBase {
    override class func classSink(_ x: String) {
        sink(x)  // $ hasValueFlow=meta.dispatch.1
    }
}

func testClassMemberOverride(t: MetaDispatchSub.Type) {
    t.classSink(source("meta.dispatch.1"))
}
