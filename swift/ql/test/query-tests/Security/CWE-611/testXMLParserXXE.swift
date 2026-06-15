// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
}

struct URL {
	init?(string: String) {}
}

class InputStream {
    init(data: Data) {}
}

extension String {
	init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
}

class XMLParser {
    var shouldResolveExternalEntities: Bool { get { return false } set {} }
    init?(contentsOf: URL) {}
    init(data: Data) {}
    init(stream: InputStream) {}
}

// --- tests ---

func testData() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteData = Data(remoteString)
    let parser = XMLParser(data: remoteData) // $ Alert
    parser.shouldResolveExternalEntities = true
}

func testInputStream() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteData = Data(remoteString)
    let remoteStream = InputStream(data: remoteData)
    let parser = XMLParser(stream: remoteStream) // $ Alert
    parser.shouldResolveExternalEntities = true
}

func testUrl() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    let remoteUrl = URL(string: remoteString)!
    let parser = XMLParser(contentsOf: remoteUrl) // $ Alert
    parser?.shouldResolveExternalEntities = true
}

func testDataSafe() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let _ = XMLParser(data: remoteData) // NO XXE: parser doesn't enable external entities
}

func testDataSafeExplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let parser = XMLParser(data: remoteData) // NO XXE: parser disables external entities
    parser.shouldResolveExternalEntities = false
}

func testInputStreamSafe() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let remoteStream = InputStream(data: remoteData)
    let _ = XMLParser(stream: remoteStream) // NO XXE: parser doesn't enable external entities
}

func testInputStreamSafeExplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let remoteStream = InputStream(data: remoteData)
    let parser = XMLParser(stream: remoteStream) // NO XXE: parser disables external entities
    parser.shouldResolveExternalEntities = false
}

func testUrlSafe() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
     let remoteUrl = URL(string: remoteString)!
     let _ = XMLParser(contentsOf: remoteUrl) // NO XXE: parser doesn't enable external entities
}

func testUrlSafeExplicit() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteUrl = URL(string: remoteString)!
    let parser = XMLParser(contentsOf: remoteUrl) // NO XXE: parser disables external entities
    parser?.shouldResolveExternalEntities = false
}
