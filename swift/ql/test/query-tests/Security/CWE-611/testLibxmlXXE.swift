// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
    func copyBytes(to: UnsafeMutablePointer<UInt8>, count: Int) {}
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

// --- tests ---

func sourcePtr() -> UnsafeMutablePointer<UInt8> { return UnsafeMutablePointer<UInt8>.allocate(capacity: 0) }
func sourceCharPtr() -> UnsafeMutablePointer<CChar> { return UnsafeMutablePointer<CChar>.allocate(capacity: 0) }

func test() {
    let remotePtr = sourcePtr()
    let remoteCharPtr = sourceCharPtr()
    let _ = xmlReadFile(remoteCharPtr, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=57
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=57
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue | XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=57
    let _ = xmlReadFile(remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue | 0)) // $ hasXXE=57
    let _ = xmlReadDoc(remotePtr, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadDoc(remotePtr, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=56
    let _ = xmlReadDoc(remotePtr, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=56
    let _ = xmlCtxtReadFile(nil, remoteCharPtr, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadFile(nil, remoteCharPtr, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=57
    let _ = xmlCtxtReadFile(nil, remoteCharPtr, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=57
    let _ = xmlParseInNodeContext(nil, remoteCharPtr, -1, 0, nil) // NO XXE: external entities not enabled
    let _ = xmlParseInNodeContext(nil, remoteCharPtr, -1, Int32(XML_PARSE_DTDLOAD.rawValue), nil) // $ hasXXE=57
    let _ = xmlParseInNodeContext(nil, remoteCharPtr, -1, Int32(XML_PARSE_NOENT.rawValue), nil) // $ hasXXE=57
    let _ = xmlCtxtReadDoc(nil, remotePtr, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadDoc(nil, remotePtr, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=56
    let _ = xmlCtxtReadDoc(nil, remotePtr, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=56
    let _ = xmlReadMemory(remoteCharPtr, -1, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlReadMemory(remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=57
    let _ = xmlReadMemory(remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=57
    let _ = xmlCtxtReadMemory(nil, remoteCharPtr, -1, nil, nil, 0) // NO XXE: external entities not enabled
    let _ = xmlCtxtReadMemory(nil, remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_NOENT.rawValue)) // $ hasXXE=57
    let _ = xmlCtxtReadMemory(nil, remoteCharPtr, -1, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue)) // $ hasXXE=57
    // TODO: We would need to model taint around `xmlParserCtxtPtr`, file descriptors, and `xmlInputReadCallback`
    // to be able to alert on these methods. Not doing it for now because of the effort required vs the expected gain.
    let _ = xmlCtxtUseOptions(nil, 0)
    let _ = xmlCtxtUseOptions(nil, Int32(XML_PARSE_NOENT.rawValue))
    let _ = xmlCtxtUseOptions(nil, Int32(XML_PARSE_DTDLOAD.rawValue))
    let _ = xmlReadFd(0, nil, nil, 0)
    let _ = xmlReadFd(0, nil, nil, Int32(XML_PARSE_NOENT.rawValue))
    let _ = xmlReadFd(0, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue))
    let _ = xmlCtxtReadFd(nil, 0, nil, nil, 0)
    let _ = xmlCtxtReadFd(nil, 0, nil, nil, Int32(XML_PARSE_NOENT.rawValue))
    let _ = xmlCtxtReadFd(nil, 0, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue))
    let _ = xmlReadIO(nil, nil, nil, nil, nil, 0)
    let _ = xmlReadIO(nil, nil, nil, nil, nil, Int32(XML_PARSE_NOENT.rawValue))
    let _ = xmlReadIO(nil, nil, nil, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue))
    let _ = xmlCtxtReadIO(nil, nil, nil, nil, nil, nil, 0)
    let _ = xmlCtxtReadIO(nil, nil, nil, nil, nil, nil, Int32(XML_PARSE_NOENT.rawValue))
    let _ = xmlCtxtReadIO(nil, nil, nil, nil, nil, nil, Int32(XML_PARSE_DTDLOAD.rawValue))
}
