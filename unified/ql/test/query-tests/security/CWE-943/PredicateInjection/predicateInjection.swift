// --- stubs ---
struct URL {
	init?(string: String) {}
}

extension String {
	init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
}

class NSPredicate {
    init(format: String, argumentArray: [Any]?) {}
    init(format: String, arguments: CVaListPointer) {}
    init(format: String, _: CVarArg...) {}
    init?(fromMetadataQueryString: String) {}
}

// --- tests ---

func test() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let safeString = "safe"

    NSPredicate(format: remoteString, argumentArray: []) // $ Alert
    NSPredicate(format: safeString, argumentArray: []) // Safe
    NSPredicate(format: safeString, argumentArray: [remoteString]) // Safe
    NSPredicate(format: remoteString, arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer(bitPattern: 0)!)) // $ Alert
    NSPredicate(format: safeString, arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer(bitPattern: 0)!)) // Safe
    NSPredicate(format: remoteString) // $ Alert
    NSPredicate(format: remoteString, "") // $ Alert
    NSPredicate(format: remoteString, "", "") // $ MISSING: Alert
    NSPredicate(format: safeString, remoteString, remoteString) // Safe
    NSPredicate(format: safeString) // Safe
    NSPredicate(format: remoteString, "" as! CVarArg) // $ Alert
    NSPredicate(format: safeString, "" as! CVarArg) // Safe
    NSPredicate(format: safeString, remoteString as! CVarArg) // Safe
    NSPredicate(fromMetadataQueryString: remoteString) // $ Alert
    NSPredicate(fromMetadataQueryString: safeString) // Safe
}

func testConstructedFormats() {
    let remoteString = String(contentsOf: URL(string: "https://example.com/")!) // $ Source

    NSPredicate(format: "SELF LIKE \(remoteString)") // $ Alert
    NSPredicate(format: "SELF LIKE " + remoteString) // $ Alert
    NSPredicate(format: "SELF LIKE %@", remoteString) // Safe
    NSPredicate(format: "SELF LIKE %@", argumentArray: [remoteString]) // Safe
}
