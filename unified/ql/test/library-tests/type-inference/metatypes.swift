class Meta {
    static func create() -> Meta { return Meta() }  // $ target=Meta.init
    class func name() -> String { return "Meta" }
    func instanceMethod() -> Int { return 0 }
}

class MetaChild: Meta {
    override class func name() -> String { return "MetaChild" }
}

func metaTypeParameter(t: Meta.Type, c: MetaChild.Type) {
    let m = t.create()  // $ type=m:Meta target=Meta.create
    let n = t.name()  // $ type=n:String target=Meta.name
    let cn = c.name()  // $ type=cn:String target=MetaChild.name
    let cm = c.create()  // $ type=cm:Meta target=Meta.create
}

func metaTypeFromSelf() {
    let t = Meta.self  // $ type=t:Meta.Type
    let m = t.create()  // $ type=m:Meta target=Meta.create
}

func metaTypeAnnotation() {
    let t: Meta.Type = Meta.self  // $ type=t:Meta.Type
    let n = t.name()  // $ type=n:String target=Meta.name
}
