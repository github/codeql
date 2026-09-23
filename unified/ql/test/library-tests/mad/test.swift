func test(url: URL, string: String) {
    String(url)  // not a source

    String(contentsOf: url)  // $ isSource=remote
    String(contentsOf: url, encoding: .utf8)  // $ isSource=remote
    String(contentsOf: url, usedEncoding: .utf8)  // $ isSource=remote

    String(contentsOfFile: string)  // $ isSource=local isSink=path-injection
    String(
        contentsOfFile: string,  // $ isSink=path-injection
        encoding: .utf8)  // $ isSource=local
    String(
        contentsOfFile: string,  // $ isSink=path-injection
        usedEncoding: .utf8)  // $ isSource=local

    FileManager.default.createDirectory(
        atPath: string,  // $ isSink=path-injection
        withIntermediateDirectories: true, attributes: nil)

    string.md5()  // $ isSink=weak-hash-input-MD5

    _ = try! Regex(string)  // $ isSink=regex-use
    _ = try! Regex(string, as: Substring.self)  // $ isSink=regex-use
}
