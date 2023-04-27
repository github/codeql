// --- stubs ---

struct Data
{
    init<S>(_ elements: S) {}
}

struct NSRange {}

class NSData {}

class NSMutableData : NSData {
    var mutableBytes: UnsafeMutableRawPointer = UnsafeMutableRawPointer(bitPattern: 0)!
    func append(_ bytes: UnsafeRawPointer, length: Int) {}
    func append(_ other: Data) {}
    func replaceBytes(in range: NSRange, withBytes bytes: UnsafeRawPointer) {}
    func replaceBytes(in range: NSRange, withBytes replacementBytes: UnsafeRawPointer?, length replacementLength: Int) {}
    func setData(_ data: Data) {}
}

// --- tests ---
func source() -> Any { return "" }
func sink(arg: Any) {}

func test() {
    // ";NSMutableData;true;append(_:length:);;;Argument[0];Argument[-1];taint",
    let nsMutableDataTainted1 = NSMutableData()
    nsMutableDataTainted1.append(source() as! UnsafeRawPointer, length: 0)
    sink(arg: nsMutableDataTainted1) // $ tainted=28
    // ";MutableNSData;true;append(_:);;;Argument[0];Argument[-1];taint",
    let nsMutableDataTainted2 = NSMutableData()
    nsMutableDataTainted2.append(source() as! Data)
    sink(arg: nsMutableDataTainted2) // $ tainted=32
    // ";NSMutableData;true;replaceBytes(in:withBytes:);;;Argument[1];Argument[-1];taint",
    let nsMutableDataTainted3 = NSMutableData()
    nsMutableDataTainted3.replaceBytes(in: NSRange(), withBytes: source() as! UnsafeRawPointer)
    sink(arg: nsMutableDataTainted3) // $ tainted=36
    // ";NSMutableData;true;replaceBytes(in:withBytes:length:);;;Argument[1];Argument[-1];taint",
    let nsMutableDataTainted4 = NSMutableData()
    nsMutableDataTainted4.replaceBytes(in: NSRange(), withBytes: source() as? UnsafeRawPointer, length: 0)
    sink(arg: nsMutableDataTainted4) // $ tainted=40
    // ";NSMutableData;true;setData(_:);;;Argument[1];Argument[-1];taint",
    let nsMutableDataTainted5 = NSMutableData()
    nsMutableDataTainted5.setData(source() as! Data)
    sink(arg: nsMutableDataTainted5) // $ tainted=44

    // Fields
    let nsMutableDataTainted6 = source() as! NSMutableData
    sink(arg: nsMutableDataTainted6.mutableBytes) // $ tainted=48
}
