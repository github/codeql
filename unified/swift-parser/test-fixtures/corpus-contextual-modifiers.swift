func contextualModifiers(override: Int?, weak: Object?, final: Object?) {
    override ?? fallback
    weak!
    final?.member
    open()
    open(urlString: "https://example.invalid")
    nonisolated()
    nonisolated(unsafe)
    open(set)
    use()
    let another = 0
}
open class Accessors {
    open open(set) var exposed = 0
    public public(set) var alsoExposed = 0
}
