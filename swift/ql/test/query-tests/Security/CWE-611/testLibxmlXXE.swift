// --- stubs ---

class NSObject {
}

class Data {
    init<S>(_ elements: S) {}
}

struct URL {
	init?(string: String) {}

    func appendingPathComponent(_ pathComponent: String) -> URL { return self }
}

class FileManager : NSObject {
    class var `default`: FileManager { get { return FileManager() } }

    var homeDirectoryForCurrentUser: URL { get { return URL(string: "")! } }
}

class Bundle : NSObject {
    class var main: Bundle { get { return Bundle() } }

    func path(forResource name: String?, ofType ext: String?) -> String? { return "" }
}

struct FilePath {
    init?(_ url: URL) { }
    init(_ string: String) { }
}

struct FileDescriptor {
    let rawValue: CInt

    struct AccessMode : RawRepresentable {
        var rawValue: CInt

        static let readOnly = AccessMode(rawValue: 0)
    }

    static func open(
        _ path: FilePath,
        _ mode: FileDescriptor.AccessMode,
        options: Int? = nil,
        permissions: Int? = nil,
        retryOnInterrupt: Bool = true
    ) throws -> FileDescriptor {
        return FileDescriptor(rawValue: 0)
    }
}

struct xmlParserOption : Hashable {
    let rawValue: UInt32 = 0
}

var XML_PARSE_NOENT: xmlParserOption { get { return xmlParserOption() } }
var XML_PARSE_DTDLOAD: xmlParserOption { get { return xmlParserOption() } }

typealias xmlChar = UInt8
typealias xmlDocPtr = UnsafeMutablePointer<xmlDoc>
typealias xmlNodePtr = UnsafeMutablePointer<xmlNode>
typealias xmlParserCtxtPtr = UnsafeMutablePointer<xmlParserCtxt>
struct xmlDoc {}
struct xmlNode {}
struct xmlParserCtxt {}
struct xmlParserErrors {}
struct xmlInputReadCallback {}
struct xmlInputCloseCallback {}

func xmlCtxtUseOptions(_ ctxt: xmlParserCtxtPtr!, _ options: Int32) -> Int32 { return 0 }
func xmlReadDoc(_ cur: UnsafePointer<xmlChar>!, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlReadFile(_ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlReadMemory(_ buffer: UnsafePointer<CChar>!, _ size: Int32, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlReadFd(_ fd: Int32, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlReadIO(_ ioread: xmlInputReadCallback!, _ ioclose: xmlInputCloseCallback!, _ ioctx: UnsafeMutableRawPointer!, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlCtxtReadDoc(_ ctxt: xmlParserCtxtPtr!, _ cur: UnsafePointer<xmlChar>!, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlCtxtReadFile(_ ctxt: xmlParserCtxtPtr!, _ filename: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlParseInNodeContext(_ node: xmlNodePtr!, _ data: UnsafePointer<CChar>!, _ datalen: Int32, _ options: Int32, _ lst: UnsafeMutablePointer<xmlNodePtr?>!) -> xmlParserErrors { return xmlParserErrors() }
func xmlCtxtReadMemory(_ ctxt: xmlParserCtxtPtr!, _ buffer: UnsafePointer<CChar>!, _ size: Int32, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlCtxtReadFd(_ ctxt: xmlParserCtxtPtr!, _ fd: Int32, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlCtxtReadIO(_ ctxt: xmlParserCtxtPtr!, _ ioread: xmlInputReadCallback!, _ ioclose: xmlInputCloseCallback!, _ ioctx: UnsafeMutableRawPointer!, _ URL: UnsafePointer<CChar>!, _ encoding: UnsafePointer<CChar>!, _ options: Int32) -> xmlDocPtr! { return xmlDocPtr.allocate(capacity: 0) }
func xmlParseChunk(_ ctxt: xmlParserCtxtPtr!, _ chunk: UnsafePointer<CChar>?, _ size: Int32, _ terminate: Int32) -> Int32 { return 0 }

// --- tests ---

func sourcePtr() -> UnsafeMutablePointer<UInt8> { return UnsafeMutablePointer<UInt8>.allocate(capacity: 0) }
func sourceCharPtr() -> UnsafeMutablePointer<CChar> { return UnsafeMutablePointer<CChar>.allocate(capacity: 0) }

func getACtxt() -> xmlParserCtxtPtr {
    return 0 as! xmlParserCtxtPtr
}

func test() {
    let remotePtr = sourcePtr()
    let remoteCharPtr = sourceCharPtr()
    let safeCharPtr = UnsafeMutablePointer<CChar>.allocate(capacity: 1024)
    safeCharPtr.initialize(repeating: 0, count: 1024)

    let _ = xmlReadFile(remoteCharPtr, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=96
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=96
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue | XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=96
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue | 0)) // $ hasXXE=96
    let _ = xmlReadDoc(remotePtr, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadDoc(remotePtr, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=95
    let _ = xmlReadDoc(remotePtr, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=95
    let _ = xmlCtxtReadFile(nil, remoteCharPtr, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadFile(nil, remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=96
    let _ = xmlCtxtReadFile(nil, remoteCharPtr, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=96
    let _ = xmlParseInNodeContext(nil, remoteCharPtr, -1, 0, nil) // NO XXE: external entities not enabled
    let _ = xmlParseInNodeContext(nil, remoteCharPtr, -1, Int32(XML_PARSE_DTDLOAD.rawValue), nil) // $ hasXXE=96
    let _ = xmlParseInNodeContext(nil, remoteCharPtr, -1, Int32(XML_PARSE_NOENT.rawValue), nil) // $ hasXXE=96
    let _ = xmlCtxtReadDoc(nil, remotePtr, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadDoc(nil, remotePtr, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=95
    let _ = xmlCtxtReadDoc(nil, remotePtr, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=95
    let _ = xmlReadMemory(remoteCharPtr, -1, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadMemory(remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=96
    let _ = xmlReadMemory(remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=96
    let _ = xmlCtxtReadMemory(nil, remoteCharPtr, -1, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadMemory(nil, remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=96
    let _ = xmlCtxtReadMemory(nil, remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=96

    let ctxt1 = getACtxt()
    if (xmlCtxtUseOptions(ctxt1, 0) == 0) { // NO XXE: external entities not enabled
        let _ = xmlParseChunk(ctxt1, remoteCharPtr, 1024, 0)
    }

    let ctxt2 = getACtxt()
    if (xmlCtxtUseOptions(ctxt2, Int32(XML_PARSE_NOENT.rawValue)) == 0) { // $ MISSING: hasXXE=96
        let _ = xmlParseChunk(ctxt2, remoteCharPtr, 1024, 0)
    }

    let ctxt3 = getACtxt()
    if (xmlCtxtUseOptions(ctxt3, Int32(XML_PARSE_DTDLOAD.rawValue)) == 0) { // $ MISSING: hasXXE=96
        let _ = xmlParseChunk(ctxt3, remoteCharPtr, 1024, 0)
    }

    let ctxt4 = getACtxt()
    if (xmlCtxtUseOptions(ctxt4, Int32(XML_PARSE_DTDLOAD.rawValue)) == 0) { // $ NO XXE: the input chunk isn't tainted
        let _ = xmlParseChunk(ctxt4, safeCharPtr, 1024, 0)
    }

    let remotePath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("shared.xml")
    let safePath = Bundle.main.path(forResource: "my", ofType: "xml")
    let remoteFd = try! FileDescriptor.open(FilePath(remotePath)!, FileDescriptor.AccessMode.readOnly)
    let safeFd = try! FileDescriptor.open(FilePath(safePath!), FileDescriptor.AccessMode.readOnly)

    let _ = xmlReadFd(remoteFd.rawValue, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadFd(remoteFd.rawValue, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ MISSING: hasXXE=146
    let _ = xmlReadFd(remoteFd.rawValue, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ MISSING: hasXXE=146
    let _ = xmlReadFd(safeFd.rawValue, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // NO XXE: the input file is trusted

    let ctxt5 = getACtxt()
    let _ = xmlCtxtReadFd(ctxt5, remoteFd.rawValue, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadFd(ctxt5, remoteFd.rawValue, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ MISSING: hasXXE=146
    let _ = xmlCtxtReadFd(ctxt5, remoteFd.rawValue, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ MISSING: hasXXE=146
    let _ = xmlCtxtReadFd(ctxt5, safeFd.rawValue, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // NO XXE: the input file is trusted

    let ctxt6 = getACtxt()
    if (xmlCtxtUseOptions(ctxt6, Int32(XML_PARSE_NOENT.rawValue)) == 0) { // $ MISSING: hasXXE=146
        let _ = xmlCtxtReadFd(ctxt6, remoteFd.rawValue, nil, nil, 0)
    }

    let _ = xmlReadIO(nil, nil, nil, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadIO(nil, nil, nil, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ MISSING: hasXXE=?
    let _ = xmlReadIO(nil, nil, nil, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ MISSING: hasXXE=?

    let _ = xmlCtxtReadIO(nil, nil, nil, nil, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadIO(nil, nil, nil, nil, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ MISSING: hasXXE=?
    let _ = xmlCtxtReadIO(nil, nil, nil, nil, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ MISSING: hasXXE=?
}
