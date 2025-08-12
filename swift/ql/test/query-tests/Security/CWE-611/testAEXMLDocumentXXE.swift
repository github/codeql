// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
}

struct URL {
	init?(string: String) {}
}

extension String {
    struct Encoding: Hashable {
        let rawValue: UInt
        static let utf8 = String.Encoding(rawValue: 1)
    }

	init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
}

class AEXMLElement {}

struct AEXMLOptions {
    var parserSettings = ParserSettings()

    struct ParserSettings {
        public var shouldResolveExternalEntities = false
    }
}

class AEXMLDocument {
    init(root: AEXMLElement? = nil, options: AEXMLOptions) {}
    init(xml: Data, options: AEXMLOptions = AEXMLOptions()) {}
    init(xml: String, encoding: String.Encoding, options: AEXMLOptions) {}
    func loadXML(_: Data) {}
}

class AEXMLParser {
    init(document: AEXMLDocument, data: Data) {}
}

// --- tests ---

func testString() {
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = true

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let _ = AEXMLDocument(xml: remoteString, encoding: String.Encoding.utf8, options: options) // $ Alert
}

func testStringSafeImplicit() {
    var options = AEXMLOptions()

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let _ = AEXMLDocument(xml: remoteString, encoding: String.Encoding.utf8, options: options) // NO XXE
}

func testStringSafeExplicit() {
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = false

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let _ = AEXMLDocument(xml: remoteString, encoding: String.Encoding.utf8, options: options) // NO XXE
}

func testData() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteData = Data(remoteString)
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = true
    let _ = AEXMLDocument(xml: remoteData, options: options) // $ Alert
}

func testDataSafeImplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    var options = AEXMLOptions()
    let _ = AEXMLDocument(xml: remoteData, options: options) // NO XXE
}

func testDataSafeExplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = false
    let _ = AEXMLDocument(xml: remoteData, options: options) // NO XXE
}

func testDataLoadXml() {
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = true
    let doc = AEXMLDocument(root: nil, options: options)

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteData = Data(remoteString)
    doc.loadXML(remoteData) // $ Alert
}

func testDataLoadXmlSafeImplicit() {
    var options = AEXMLOptions()
    let doc = AEXMLDocument(root: nil, options: options)

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    doc.loadXML(remoteData) // NO XXE
}

func testDataLoadXmlSafeExplicit() {
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = false
    let doc = AEXMLDocument(root: nil, options: options)

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    doc.loadXML(remoteData) // NO XXE
}

func testParser() {
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = true
    let doc = AEXMLDocument(root: nil, options: options)

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteData = Data(remoteString)
    let _ = AEXMLParser(document: doc, data: remoteData) // $ Alert
}

func testParserSafeImplicit() {
    var options = AEXMLOptions()
    let doc = AEXMLDocument(root: nil, options: options)

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let _ = AEXMLParser(document: doc, data: remoteData) // NO XXE
}

func testParserSafeExplicit() {
    var options = AEXMLOptions()
    options.parserSettings.shouldResolveExternalEntities = false
    let doc = AEXMLDocument(root: nil, options: options)

    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let _ = AEXMLParser(document: doc, data: remoteData) // NO XXE
}
