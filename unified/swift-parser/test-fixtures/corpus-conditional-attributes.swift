struct Source {
#if compiler(>=6.2)
    @concurrent
#else
    @Sendable
#endif
    public nonisolated func value() async -> Int { 42 }
    @inlinable
    __consuming func makeIterator() -> Iterator { .init() }
}
switch value {
case (is Cell, is Void): break
default: break
}
#if EMPTY
#endif
func afterEmpty() {}
struct CommentOnly {
#if EMPTY
// no attributes
#endif
}
#if OUTER
#if INNER
#endif
#else
// no attributes in this branch either
#endif
func afterNestedEmpty() {}
#if OUTER
#if INNER
@MainActor
#endif
#else
@Sendable
#endif
func afterNestedAttributes() {}
