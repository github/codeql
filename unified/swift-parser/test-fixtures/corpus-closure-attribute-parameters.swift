func closures() async {
    await compute { @concurrent (x: Int) in
        _ = x
    }
    await compute { @concurrent (x: Int) async throws -> Int in x }
    use { @Sendable (x: Int) in x }
    use { (@Sendable key: CodingKey) in key }
    use { (@Sendable callback: () -> Void, value: Int) in callback() }
}
