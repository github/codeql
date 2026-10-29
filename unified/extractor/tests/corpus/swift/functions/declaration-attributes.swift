class C {
    @discardableResult public func f() -> Int { return 0 }
    @available(*, unavailable) public init(x: Int) {}
}
