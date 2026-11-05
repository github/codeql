// Conditional compilation is not yet supported: swift-syntax reports a
// structured `ifConfigDecl` (whose branches hold ordinary member items), but
// the mapping has no rule for it, so the whole block becomes one
// `unsupported_node` and its members are not extracted.
class C {
#if DEBUG
    init(x: Int) {}
    deinit {}
#endif
}
