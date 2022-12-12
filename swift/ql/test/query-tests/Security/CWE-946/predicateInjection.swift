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

    NSPredicate(format: remoteString, argumentArray: []) // $ hasPredicateInjection=23
    NSPredicate(format: remoteString, arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer(bitPattern: 0)!)) // $ hasPredicateInjection=23
    NSPredicate(format: remoteString) // $ hasPredicateInjection=23
    NSPredicate(format: remoteString, "" as! CVarArg) // $ hasPredicateInjection=23
    NSPredicate(fromMetadataQueryString: remoteString) // $ hasPredicateInjection=23
}
