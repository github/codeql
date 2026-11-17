extension Array {
    @_specialize(exported: true,
                 availability: SwiftStdlib 5.9, *;
                 target: _endMutation(),
                 where @_noMetadata Element: _Class)
    func endMutation() {}

    @_specialize(target: init(repeating:count:), kind: full, where Element == Int)
    init(copy: Self) {}
}
