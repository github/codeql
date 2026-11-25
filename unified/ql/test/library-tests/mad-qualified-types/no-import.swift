func withoutImports(url: URL, qualifiedURL: Foundation.URL, path: String) {
    _ = url.lines  // $ isSource=remote
    _ = qualifiedURL.lines  // $ MISSING: isSource=remote

    let unqualified = URL(fileURLWithPath: path)  // $ constructor=URL
    _ = unqualified.lines  // $ isSource=remote
    let qualified = Foundation.URL(fileURLWithPath: path)  // $ MISSING: constructor=URL
    _ = qualified.lines  // $ MISSING: isSource=remote
    _ = Foundation.URL.init(fileURLWithPath: path)  // $ MISSING: constructor=URL

    // Keep nested model types distinct from module qualifiers.
    _ = String.Index(encodedOffset: 0)  // $ constructor=String.Index isSink=string-length
    _ = Foundation.String.Index(encodedOffset: 0)  // $ MISSING: constructor=String.Index isSink=string-length
}
