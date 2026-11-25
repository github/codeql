import Foundation

func withModuleImport(url: URL, qualifiedURL: Foundation.URL, path: String) {
    _ = url.lines  // $ isSource=remote
    _ = qualifiedURL.lines  // $ MISSING: isSource=remote

    let unqualified = URL(fileURLWithPath: path)  // $ constructor=URL
    _ = unqualified.lines  // $ isSource=remote
    let qualified = Foundation.URL(fileURLWithPath: path)  // $ MISSING: constructor=URL
    _ = qualified.lines  // $ MISSING: isSource=remote
    _ = Foundation.URL.init(fileURLWithPath: path)  // $ MISSING: constructor=URL
}
