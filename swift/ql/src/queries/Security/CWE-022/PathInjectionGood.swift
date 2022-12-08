let fm = FileManager.default
let path = try String(contentsOf: URL(string: "http://example.com/")!)

// GOOD
let filePath = FilePath(stringLiteral: path)
if (filePath.lexicallyNormalized().starts(with: FilePath(stringLiteral: NSHomeDirectory() + "/Library/Caches"))) {
    return fm.contents(atPath: path)
}
