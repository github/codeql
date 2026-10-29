// Provides built-in Swift types

struct Bool {}

struct Int {}

struct String {
    public init<T>(_ value: T) where T: LosslessStringConvertible {
        fatalError("Dummy implementation.")
    }

    struct Index {}
}

struct Character {}

struct Substring {}

struct Int8 {}

struct Int16 {}

struct Int32 {}

struct Int64 {}

struct UInt {}

struct UInt8 {}

struct UInt16 {}

struct UInt32 {}

struct UInt64 {}

struct Float16 {}

struct Float {}

struct Double {}

struct Float80 {}

struct Array<Element> {
    public func map<T, E>(_ transform: (Element) throws(E) -> T) throws(E) -> [T]
    where E: Error {
        fatalError("Dummy implementation.")
    }
}

struct Dictionary<Key, Value> {}

struct Set<Element> {}

enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

struct Range<Bound> {}

struct ClosedRange<Bound> {}

struct PartialRangeFrom<Bound> {}

struct PartialRangeThrough<Bound> {}

struct PartialRangeUpTo<Bound> {}

enum Never {}

struct UnsafePointer<Pointee> {}

struct UnsafeMutablePointer<Pointee> {}

struct UnsafeRawPointer {}

struct UnsafeMutableRawPointer {}

struct UnsafeBufferPointer<Element> {}

struct UnsafeMutableBufferPointer<Element> {}

struct UnsafeRawBufferPointer {}

struct UnsafeMutableRawBufferPointer {}

struct AutoreleasingUnsafeMutablePointer<Pointee> {}

struct OpaquePointer {}

struct Unmanaged<Instance> {}

struct Function<Args, Return> {  // `Args` is always instantiated as a tuple type
    public func callAsFunction(args: Args) -> Return {
        fatalError("Dummy implementation.")
    }
}

typealias Void = Tuple0

struct Tuple0 {}

struct Tuple1<T0> {
    var _0: T0
}

struct Tuple2<T0, T1> {
    var _0: T0
    var _1: T1
}

struct Tuple3<T0, T1, T2> {
    var _0: T0
    var _1: T1
    var _2: T2
}

struct Tuple4<T0, T1, T2, T3> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
}

struct Tuple5<T0, T1, T2, T3, T4> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
}

struct Tuple6<T0, T1, T2, T3, T4, T5> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
}

struct Tuple7<T0, T1, T2, T3, T4, T5, T6> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
}

struct Tuple8<T0, T1, T2, T3, T4, T5, T6, T7> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
}

struct Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
}

struct Tuple10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
    var _9: T9
}

struct Tuple11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
    var _9: T9
    var _10: T10
}

struct Tuple12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
    var _9: T9
    var _10: T10
    var _11: T11
}

// The types below are referenced by models in `ql/lib/ext/legacy-swift.model.yml`.
// They are included so that type inference can resolve these types (and hence match
// models against property accesses) even though declarations from dependencies are not
// extracted. Only the type hierarchy is represented here, not the members.

// Swift standard library

protocol Sequence {}

protocol IteratorProtocol {}

protocol Collection: Sequence {}

protocol BidirectionalCollection: Collection {}

protocol MutableCollection: Collection {}

protocol RangeReplaceableCollection: Collection {}

protocol StringProtocol: BidirectionalCollection {}

protocol LosslessStringConvertible {}

protocol TextOutputStream {}

protocol TextOutputStreamable {}

protocol RawRepresentable {}

protocol OptionSet: RawRepresentable {}

protocol Strideable {}

protocol Numeric {}

protocol BinaryInteger: Numeric {}

protocol SignedInteger: BinaryInteger {}

protocol UnsignedInteger: BinaryInteger {}

protocol FixedWidthInteger: BinaryInteger {}

protocol FloatingPoint: Numeric {}

protocol BinaryFloatingPoint: FloatingPoint {}

struct ContiguousArray<Element> {}

struct Slice<Base> {}

struct Regex<Output> {}

// Foundation

class NSObject {}

protocol NSCopying {}

protocol NSMutableCopying {}

protocol ContiguousBytes {}

protocol DataProtocol {}

struct Data: DataProtocol, ContiguousBytes {}

class NSData: NSObject {}

class NSMutableData: NSData {}

class NSString: NSObject {}

class NSMutableString: NSString {}

struct NSRange {}

struct URL {
    struct AsyncBytes {}
}

struct URLResource {}

class NSURL: NSObject {}

class NSException: NSObject {}

class NSKeyedUnarchiver: NSObject {}

class NSPredicate: NSObject {}

class NSRegularExpression: NSObject {}

class NSUserScriptTask: NSObject {}

class NSUserUnixTask: NSUserScriptTask {}

class Process: NSObject {}

class FileManager: NSObject {}

class Bundle: NSObject {}

class InputStream: NSObject {}

class URLSession: NSObject {}

class URLSessionConfiguration: NSObject {}

// System, os, Network, AppleArchive

struct FilePath {
    struct Component {}

    struct Root {}
}

struct Logger {}

class NWConnection {}

class ArchiveByteStream {}

// UIKit, WebKit, JavaScriptCore

protocol UITextInput {}

protocol UITextFieldDelegate {}

protocol UITextViewDelegate {}

protocol UIApplicationDelegate {}

protocol UISceneDelegate {}

class UITextField: NSObject, UITextInput {}

protocol WKScriptMessageHandler {}

class WKUserScript: NSObject {}

class JSContext: NSObject {}

class JSValue: NSObject {}

// CryptoKit

protocol Digest {}

enum Insecure {
    struct MD5 {}

    struct SHA1 {}
}

struct SHA256 {}

struct SHA384 {}

struct SHA512 {}

// CryptoSwift

class AES {}

class Blowfish {}

class MD5 {}

class SHA1 {}

class SHA2 {}

class SHA3 {}

// Alamofire

struct DataResponse<Success, Failure> {}

struct DownloadResponse<Success, Failure> {}

// GRDB

protocol DatabaseValueConvertible {}

protocol FetchableRecord {}

protocol TableRecord {}

class Database {}

class DatabasePool {}

class DatabaseQueue {}

class DatabaseSnapshotPool {}

class SerializedDatabase {}

class Row {}

class Statement {}

class SQLStatementCursor {}

struct SQL {}

struct SQLRequest<RowDecoder> {}

struct CommonTableExpression<RowDecoder> {}

// SQLite.swift

class Connection {
    enum Location {}
}

struct Blob {}

struct Expression<Datatype> {}

protocol ExpressionType {}

protocol QueryType {}

// RealmSwift

struct Realm {
    struct Configuration {}
}

// NIO

class NIOFileHandle {}

// Zip

class Zip {}
