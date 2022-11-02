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
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let parser = XMLParser(data: remoteData) // $ hasXXE=32
    parser.shouldResolveExternalEntities = true
}

func testInputStream() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let remoteStream = InputStream(data: remoteData)
    let parser = XMLParser(stream: remoteStream) // $ hasXXE=39
    parser.shouldResolveExternalEntities = true

}

func testDataSafe() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let _ = XMLParser(data: remoteData) // NO XXE: parser doesn't enable external entities
}

func testInputStreamSafe() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteData = Data(remoteString)
    let remoteStream = InputStream(data: remoteData)
    let _ = XMLParser(stream: remoteStream) // NO XXE: parser doesn't enable external entities
}