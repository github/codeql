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
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let safeString = "safe"

    NSPredicate(format: remoteString, argumentArray: []) // $ hasPredicateInjection=23
    NSPredicate(format: safeString, argumentArray: []) // Safe
    NSPredicate(format: safeString, argumentArray: [remoteString]) // Safe
    NSPredicate(format: remoteString, arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer(bitPattern: 0)!)) // $ hasPredicateInjection=23
    NSPredicate(format: safeString, arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer(bitPattern: 0)!)) // Safe
    NSPredicate(format: remoteString) // $ hasPredicateInjection=23
    NSPredicate(format: safeString) // Safe
    NSPredicate(format: remoteString, "" as! CVarArg) // $ hasPredicateInjection=23
    NSPredicate(format: safeString, "" as! CVarArg) // Safe
    NSPredicate(format: safeString, remoteString as! CVarArg) // Safe
    NSPredicate(fromMetadataQueryString: remoteString) // $ hasPredicateInjection=23
    NSPredicate(fromMetadataQueryString: safeString) // Safe
}
