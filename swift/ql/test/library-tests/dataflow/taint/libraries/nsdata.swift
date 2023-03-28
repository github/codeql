// --- stubs ---

struct URL
{
	init?(string: String) {}
}

struct Data
{
    init<S>(_ elements: S) {}
}

struct NSRange {}

struct ObjCBool {}

class NSData {
    struct ReadingOptions : OptionSet { let rawValue: Int }
    struct Base64EncodingOptions : OptionSet { let rawValue: Int }
    struct Base64DecodingOptions : OptionSet { let rawValue: Int }
    enum CompressionAlgorithm : Int { case none }
    var bytes: UnsafeRawPointer = UnsafeRawPointer(bitPattern: 0)!
    var description: String = ""
    init(bytes: UnsafeRawPointer?, length: Int) {}
    init(bytesNoCopy bytes: UnsafeMutableRawPointer, length: Int) {}
    init(bytesNoCopy bytes: UnsafeMutableRawPointer, length: Int, deallocator: ((UnsafeMutableRawPointer, Int) -> Void)? = nil) {}
    init(bytesNoCopy bytes: UnsafeMutableRawPointer, length: Int, freeWhenDone b: Bool) {}
    init(data: Data) {}
    init?(contentsOfFile: String) {}
    init(contentsOfFile path: String, options readOptionsMask: NSData.ReadingOptions = []) {} 
    init?(contentsOf: URL) {}
    init?(contentsOf: URL, options: NSData.ReadingOptions) {}
    init?(contentsOfMappedFile path: String) {}
    init?(base64Encoded base64Data: Data, options: NSData.Base64DecodingOptions = []) {}
    init?(base64Encoded base64String: String, options: NSData.Base64DecodingOptions = []) {}
    init?(base64Encoding base64String: String) {}
    func base64EncodedData(options: NSData.Base64EncodingOptions = []) -> Data { return Data("") }
    func base64EncodedString(options: NSData.Base64EncodingOptions = []) -> String { return "" }
    func base64Encoding() -> String { return "" }
    class func dataWithContentsOfMappedFile(_ path: String) -> Any? { return nil }
    func enumerateBytes(_ block: (UnsafeRawPointer, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {}
    func getBytes(_ buffer: UnsafeMutableRawPointer) {}
    func getBytes(_ buffer: UnsafeMutableRawPointer, length: Int) {}
    func getBytes(_ buffer: UnsafeMutableRawPointer, range: NSRange) {}
    func subdata(with range: NSRange) -> Data { return Data("") }
    func compressed(using algorithm: NSData.CompressionAlgorithm) -> Self { return self }
    func decompressed(using algorithm: NSData.CompressionAlgorithm) -> Self { return self }
}

// --- tests ---

func source() -> Any { return "" }
func sink(arg: Any) {}

func test() {
    // ";NSData;true;init(bytes:length:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted1 = NSData(bytes: source() as? UnsafeRawPointer, length: 0)
    sink(arg: nsDataTainted1) // $ tainted=57
    // ";NSData;true;init(bytesNoCopy:length:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted2 = NSData(bytesNoCopy: source() as! UnsafeMutableRawPointer, length: 0)
    sink(arg: nsDataTainted2) // $ tainted=60
    // ";NSData;true;init(bytesNoCopy:length:deallocator:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted3 = NSData(bytesNoCopy: source() as! UnsafeMutableRawPointer, length: 0, deallocator: nil)
    sink(arg: nsDataTainted3) // $ tainted=63
    // ";NSData;true;init(bytesNoCopy:length:freeWhenDone:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted4 = NSData(bytesNoCopy: source() as! UnsafeMutableRawPointer, length: 0, freeWhenDone: true)
    sink(arg: nsDataTainted4) // $ tainted=66
    // ";NSData;true;init(data:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted5 = NSData(data: source() as! Data)
    sink(arg: nsDataTainted5) // $ tainted=69
    // ";NSData;true;init(contentsOfFile:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted6 = NSData(contentsOfFile: source() as! String)
    sink(arg: nsDataTainted6!) // $ tainted=72
    // ";NSData;true;init(contentsOfFile:options:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted7 = NSData(contentsOfFile: source() as! String, options: [])
    sink(arg: nsDataTainted7) // $ tainted=75
    // ";NSData;true;init(contentsOf:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted8 = NSData(contentsOf: source() as! URL)
    sink(arg: nsDataTainted8!) // $ tainted=78
    // ";NSData;true;init(contentsOf:options:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted9 = NSData(contentsOf: source() as! URL, options: [])
    sink(arg: nsDataTainted9!) // $ tainted=81
    // ";NSData;true;init(contentsOfMappedFile:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted10 = NSData(contentsOfMappedFile: source() as! String)
    sink(arg: nsDataTainted10!) // $ tainted=84
    // ";NSData;true;init(base64Encoded:options:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted11 = NSData(base64Encoded: source() as! Data, options: [])
    sink(arg: nsDataTainted11!) // $ tainted=87
    let nsDataTainted12 = NSData(base64Encoded: source() as! String, options: [])
    sink(arg: nsDataTainted12!) // $ tainted=89
    // ";NSData;true;init(base64Encoding:);;;Argument[0];ReturnValue;taint",
    let nsDataTainted13 = NSData(base64Encoding: source() as! String)
    sink(arg: nsDataTainted13!) // $ tainted=92
    // ";NSData;true;base64EncodedData(options:);;;Argument[-1];ReturnValue;taint",
    let nsDataTainted14 = source() as! NSData
    sink(arg: nsDataTainted14.base64EncodedData()) // $ tainted=95
    sink(arg: nsDataTainted14.base64EncodedData(options: [])) // $ tainted=95
    // ";NSData;true;base64EncodedString(options:);;;Argument[-1];ReturnValue;taint",
    let nsDataTainted15 = source() as! NSData
    sink(arg: nsDataTainted15.base64EncodedString()) // $ tainted=99
    sink(arg: nsDataTainted15.base64EncodedString(options: [])) // $ tainted=99
    // ";NSData;true;base64Encoding();;;Argument[-1];ReturnValue;taint",
    let nsDataTainted16 = source() as! NSData
    sink(arg: nsDataTainted16.base64Encoding()) // $ tainted=103
    // ";NSData;true;dataWithContentsOfMappedFile(_:);;;Argument[0];ReturnValue;taint",
    sink(arg: NSData.dataWithContentsOfMappedFile(source() as! String)!) // $ tainted=106
    // ";NSData;true;enumerateBytes(_:);;;Argument[-1];Argument[0].Parameter[0];taint"
    let nsDataTainted17 = source() as! NSData
    nsDataTainted17.enumerateBytes {
        bytes, byteRange, stop in sink(arg: bytes) // $ tainted=108
    }
    // ";NSData;true;getBytes(_:);;;Argument[-1];Argument[0];taint",
    let nsDataTainted18 = source() as! NSData
    let bufferTainted18 = UnsafeMutableRawPointer(bitPattern: 0)!
    nsDataTainted18.getBytes(bufferTainted18)
    sink(arg: bufferTainted18) // $ tainted=113
    // ";NSData;true;getBytes(_:length:);;;Argument[-1];Argument[0];taint",
    let nsDataTainted19 = source() as! NSData
    let bufferTainted19 = UnsafeMutableRawPointer(bitPattern: 0)!
    nsDataTainted19.getBytes(bufferTainted19, length: 0)
    sink(arg: bufferTainted19) // $ tainted=118
    // ";NSData;true;getBytes(_:range:);;;Argument[-1];Argument[0];taint",
    let nsDataTainted20 = source() as! NSData
    let bufferTainted20 = UnsafeMutableRawPointer(bitPattern: 0)!
    nsDataTainted20.getBytes(bufferTainted20, range: NSRange())
    sink(arg: bufferTainted20) // $ tainted=123
    // ";NSData;true;subdata(with:);;;Argument[-1];ReturnValue;taint",
    let nsDataTainted21 = source() as! NSData
    sink(arg: nsDataTainted21.subdata(with: NSRange())) // $ tainted=128
    // ";NSData;true;compressed(using:);;;Argument[-1];ReturnValue;taint",
    let nsDataTainted22 = source() as! NSData
    sink(arg: nsDataTainted22.compressed(using: NSData.CompressionAlgorithm.none)) // $ tainted=131
    // ";NSData;true;decompressed(using:);;;Argument[-1];ReturnValue;taint"
    let nsDataTainted23 = source() as! NSData
    sink(arg: nsDataTainted23.decompressed(using: NSData.CompressionAlgorithm.none)) // $ tainted=134

    // Fields
    let nsDataTainted24 = source() as! NSData
    sink(arg: nsDataTainted24.bytes) // $ tainted=138
    sink(arg: nsDataTainted24.description) // $ tainted=138
}
