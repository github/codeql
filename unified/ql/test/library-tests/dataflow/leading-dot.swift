class Leading {
    init(_ x: String) {
        sink(x)  // $ hasValueFlow=lead.init
    }

    static func make(_ x: String) -> Leading {
        sink(x)  // $ hasValueFlow=lead.decl hasValueFlow=lead.arg hasValueFlow=lead.return hasValueFlow=lead.assign
        return Leading("safe")
    }

    static func makeChained(_ x: String) -> Leading {
        return Leading("safe")
    }

    func then(_ x: String) -> Leading {
        sink(x)  // $ hasValueFlow=lead.chain
        return self
    }

    var next: Leading { return self }

    static var shared: Leading { return Leading("safe") }
}

func takesLeading(_ l: Leading) {}

func testLeadingDotDeclaration() {
    let l: Leading = .make(source("lead.decl"))
}

func testLeadingDotArgument() {
    takesLeading(.make(source("lead.arg")))
}

func testLeadingDotReturn() -> Leading {
    return .make(source("lead.return"))
}

func testLeadingDotAssignment(l: Leading) {
    var x = l
    x = .make(source("lead.assign"))
}

func testLeadingDotChain() {
    let l: Leading = .makeChained("safe").next.then(source("lead.chain"))
}

func testLeadingDotInit() {
    let l: Leading = .init(source("lead.init"))
}
