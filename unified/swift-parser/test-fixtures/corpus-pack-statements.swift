func packs<each Element>(_ element: repeat each Element) -> (repeat each Element) {
    { @Sendable in
        repeat _ = each element
    }()
    repeat print(each element)
    repeat { tick() } while active
    return repeat each element
}
