class LeadingType {
    static func make() -> LeadingType { return LeadingType() }  // $ target=LeadingType.init
    static var shared: LeadingType { return LeadingType() }  // $ target=LeadingType.init
    var next: LeadingType { return self }
    func then() -> LeadingType { return self }
}

func takesLeadingType(_ l: LeadingType) {}

func leadingDot() {
    let a: LeadingType = .make()  // $ type=a:LeadingType target=LeadingType.make
    let b: LeadingType = .shared  // $ type=b:LeadingType accessor=LeadingType.shared
    let c: LeadingType = .make().next.then()  // $ type=c:LeadingType target=LeadingType.make accessor=LeadingType.next target=LeadingType.then
    takesLeadingType(.make())  // $ target=takesLeadingType target=LeadingType.make
}

enum LeadingColor {
    case red
    case custom(Int)
}

func leadingDotEnum() {
    let red: LeadingColor = .red  // $ field=LeadingColor.red
    let custom: LeadingColor = .custom(1)  // $ target=LeadingColor.custom
}

func leadingDotOptionalContext() {
    let a: LeadingType? = .make()  // $ MISSING: target=LeadingType.make -- contextual optional types are not unwrapped
}
