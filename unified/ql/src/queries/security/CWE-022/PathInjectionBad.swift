let fm = FileManager.default
let path = try String(contentsOf: URL(string: "http://example.com/")!)

// BAD
return fm.contents(atPath: path)

// BAD
if (path.hasPrefix(NSHomeDirectory() + "/Library/Caches")) {
    return fm.contents(atPath: path)
}
