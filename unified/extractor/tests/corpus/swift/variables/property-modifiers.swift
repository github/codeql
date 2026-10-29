class C {
    public static var shared: C { get }
    @objc public var name: String { get set }
    private var count: Int { return 0 }
}
