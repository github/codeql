// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
}

struct URL {
	init?(string: String) {}
}

extension String {
	init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
}

class XMLNode {
    struct Options : OptionSet {
        let rawValue: Int
        static let nodeLoadExternalEntitiesAlways = XMLNode.Options(rawValue: 1 << 0)
        static let nodeLoadExternalEntitiesNever = XMLNode.Options(rawValue: 1 << 1)
    }
}

class XMLElement {}

class XMLDocument {
    init(contentsOf: URL, options: XMLNode.Options = []) {}
    init(data: Data, options: XMLNode.Options = []) {}
    init(rootElement: XMLElement?) {}
    init(xmlString: String, options: XMLNode.Options = []) {}
}

// --- tests ---

func testUrl() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteUrl = URL(string: remoteString)!
    let _ = XMLDocument(contentsOf: remoteUrl, options: [.nodeLoadExternalEntitiesAlways]) // $ Alert
}

func testUrlSafeImplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteUrl = URL(string: remoteString)!
    let _ = XMLDocument(contentsOf: remoteUrl, options: []) // NO XXE: document doesn't enable external entities
}

func testUrlSafeExplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteUrl = URL(string: remoteString)!
    let _ = XMLDocument(contentsOf: remoteUrl, options: [.nodeLoadExternalEntitiesNever]) // NO XXE: document disables external entities
}

func testData() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteData = Data(remoteString)
    let _ = XMLDocument(data: remoteData, options: [.nodeLoadExternalEntitiesAlways]) // $ Alert
}

func testDataSafeImplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let _ = XMLDocument(data: remoteData, options: []) // NO XXE: document doesn't enable external entities
}

func testDataSafeExplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let _ = XMLDocument(data: remoteData, options: [.nodeLoadExternalEntitiesNever]) // NO XXE: document disables external entities
}

func testString() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let _ = XMLDocument(xmlString: remoteString, options: [.nodeLoadExternalEntitiesAlways]) // $ Alert
}

func testStringSafeImplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let _ = XMLDocument(xmlString: remoteString, options: []) // NO XXE: document doesn't enable external entities
}

func testStringSafeExplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let _ = XMLDocument(xmlString: remoteString, options: [.nodeLoadExternalEntitiesNever]) // NO XXE: document disables external entities
}
