// --- stubs ---

struct URL {
    enum DirectoryHint {
        case inferFromPath
    }

	init?(string: String) {}
    init(fileURLWithPath path: String, isDirectory: Bool) {}
    init(filePath path: String, directoryHint: URL.DirectoryHint = .inferFromPath, relativeTo base: URL? = nil) {}

    mutating func appendPathComponent(_ pathComponent: String) {}
    func appendingPathComponent(_ pathComponent: String) -> URL { return self }
}

class NSURL {
    init?(string: String) {}

    func appendingPathComponent(_ pathComponent: String) -> URL? { return nil }

    var filePathURL: URL? { get { URL(string: "") } }
}

extension StringProtocol {
    func completePath(
        into outputName: UnsafeMutablePointer<String>? = nil,
        caseSensitive: Bool,
        matchesInto outputArray: UnsafeMutablePointer<[String]>? = nil,
        filterTypes: [String]? = nil) -> Int { 0 }
}

extension String {
    struct Encoding {
        static let utf8 = Encoding()
    }

    init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }

    init(contentsOfFile path: String) throws {
        self.init("")
    }

    init(contentsOfFile path: String, encoding enc: String.Encoding) throws {
        self.init("")
    }

    init(contentsOfFile path: String, usedEncoding: inout String.Encoding) throws {
        self.init("")
    }
}

class NSString {
    init() { }
    init(string aString: String) { }
    convenience init(contentsOfFile path: String, encoding enc: UInt) throws { self.init() }
    convenience init(contentsOfFile path: String, usedEncoding enc: UnsafeMutablePointer<UInt>?) throws { self.init() }

    func write(toFile: String, atomically: Bool, encoding: UInt) {}
    func write(to: URL, atomically: Bool, encoding: UInt) {}

    var utf8String: UnsafePointer<CChar>? { get { return nil } }
}
protocol DataProtocol { }
class Data : DataProtocol {
    struct ReadingOptions : OptionSet { let rawValue: Int }
    struct WritingOptions : OptionSet { let rawValue: Int }

    init<S>(_ elements: S) { count = 0 }
	init(contentsOf: URL, options: ReadingOptions) { count = 0 }

	func copyBytes(to: UnsafeMutablePointer<UInt8>, count: Int) {}

    func write(to: URL, options: Data.WritingOptions = []) {}

	var count: Int
}

class NSData {
    init() { }
    init?(contentsOfFile path: String) { }
    init?(contentsOfMappedFile path: String) { }
    init?(contentsOf url: URL) { }
    class func dataWithContentsOfMappedFile(_ path: String) -> Any? { return nil }

    struct WritingOptions : OptionSet { let rawValue: Int }
    func write(to: URL, atomically: Bool) -> Bool { return false }
    func write(to: URL, options: NSData.WritingOptions) {}
    func write(toFile: String, atomically: Bool) -> Bool { return false }
    func write(toFile: String, options: NSData.WritingOptions) {}
}

class NSKeyedUnarchiver {
    func unarchiveObject(withFile: String) -> Any? { return nil }
}

struct URLResourceKey {}

struct FileAttributeKey : Hashable {}

struct ObjCBool {}

struct AutoreleasingUnsafeMutablePointer<Pointee> {}

struct FilePath : ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    init(stringLiteral: String) {}
    func lexicallyNormalized() -> FilePath { return "" }
    func starts(with: FilePath) -> Bool { return false }
}

class FileManager {
    class DirectoryEnumerator {}
    struct DirectoryEnumerationOptions : OptionSet { let rawValue: Int }
    struct ItemReplacementOptions : OptionSet { let rawValue: Int }
    struct UnmountOptions : OptionSet { let rawValue: Int }
    struct SearchPathDomainMask {}
    enum SearchPathDirectory : UInt { case none }
    enum URLRelationship : Int { case none }

    func contentsOfDirectory(at: URL, includingPropertiesForKeys: [URLResourceKey]?, options: FileManager.DirectoryEnumerationOptions) -> [URL] { return []}
    func contentsOfDirectory(atPath: String) -> [String] { return [] }
    func enumerator(at: URL, includingPropertiesForKeys: [URLResourceKey]?, options: FileManager.DirectoryEnumerationOptions, errorHandler: ((URL, Error) -> Bool)?) -> FileManager.DirectoryEnumerator? { return nil }
    func enumerator(atPath: String) -> FileManager.DirectoryEnumerator? { return nil }
    func subpathsOfDirectory(atPath: String) -> [String] { return [] }
    func subpaths(atPath: String) -> [String]? { return nil }
    func createDirectory(at: URL, withIntermediateDirectories: Bool, attributes: [FileAttributeKey : Any]?) {}
    func createDirectory(atPath: String, withIntermediateDirectories: Bool, attributes: [FileAttributeKey : Any]?) {}
    func createFile(atPath: String, contents: Data?, attributes: [FileAttributeKey : Any]?) -> Bool { return false }
    func removeItem(at: URL) {}
    func removeItem(atPath: String) {}
    func trashItem(at: URL, resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>?) {}
    func replaceItemAt(_: URL, withItemAt: URL, backupItemName: String?, options: FileManager.ItemReplacementOptions) -> URL? { return nil}
    func replaceItem(at: URL, withItemAt: URL, backupItemName: String?, options: FileManager.ItemReplacementOptions, resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>?) {}
    func copyItem(at: URL, to: URL) {}
    func copyItem(atPath: String, toPath: String) {}
    func moveItem(at: URL, to: URL) {}
    func moveItem(atPath: String, toPath: String) {}
    func createSymbolicLink(at: URL, withDestinationURL: URL) {}
    func createSymbolicLink(atPath: String, withDestinationPath: String) {}
    func linkItem(at: URL, to: URL) {}
    func linkItem(atPath: String, toPath: String) {}
    func destinationOfSymbolicLink(atPath: String) -> String { return "" }
    func fileExists(atPath: String) -> Bool { return false }
    func fileExists(atPath: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool { return false }
    func setAttributes(_: [FileAttributeKey : Any], ofItemAtPath: String) {}
    func contents(atPath: String) -> Data? { return nil }
    func contentsEqual(atPath: String, andPath: String) -> Bool { return false }
    func changeCurrentDirectoryPath(_: String) -> Bool { return false }
    func unmountVolume(at: URL, options: FileManager.UnmountOptions, completionHandler: (Error?) -> Void) {}
    // Deprecated methods
    func fileAttributes(atPath path: String, traverseLink yorn: Bool) -> [AnyHashable : Any]? { nil }
    func changeFileAttributes(_: [AnyHashable : Any], atPath: String) -> Bool { return false }
    func attributesOfItem(atPath path: String) throws -> [FileAttributeKey : Any] { return [:] }
    func directoryContents(atPath: String) -> [Any]? { return nil }
    func createDirectory(atPath: String, attributes: [AnyHashable : Any]) -> Bool { return false }
    func createSymbolicLink(atPath: String, pathContent: String) -> Bool { return false }
    func pathContentOfSymbolicLink(atPath: String) -> String? { return nil }
    func replaceItemAtURL(originalItemURL: NSURL, withItemAtURL: NSURL, backupItemName: String?, options: FileManager.ItemReplacementOptions) -> NSURL? { return nil }
}

struct FileDescriptor {
    struct AccessMode : RawRepresentable {
        static let readOnly = AccessMode(rawValue: 0)
        let rawValue: UInt8
        init(rawValue: UInt8) { self.rawValue = rawValue}
    }

    struct OpenOptions : RawRepresentable {
        static let append = OpenOptions(rawValue: 0)
        let rawValue: UInt8
        init(rawValue: UInt8) { self.rawValue = rawValue}
    }
}

struct FilePermissions : RawRepresentable {
    static let ownerRead = FilePermissions(rawValue: 0)
    let rawValue: UInt8
    init(rawValue: UInt8) { self.rawValue = rawValue}
}

class ArchiveByteStream {
    static func fileStream(fd: FileDescriptor, automaticClose: Bool = true) -> ArchiveByteStream? { return nil }
    static func withFileStream<E>(fd: FileDescriptor, automaticClose: Bool = true, _ body: (ArchiveByteStream) -> E) -> E { return body(ArchiveByteStream()) }
    static func fileStream(path: FilePath, mode: FileDescriptor.AccessMode, options: FileDescriptor.OpenOptions, permissions: FilePermissions) -> ArchiveByteStream? { return nil }
    static func withFileStream<E>(path: FilePath, mode: FileDescriptor.AccessMode, options: FileDescriptor.OpenOptions, permissions: FilePermissions, _ body: (ArchiveByteStream) -> E) -> E { return body(ArchiveByteStream()) }
}

class Bundle {
    init?(url: URL) {}
    init?(path: String) {}
}

class KeyPath<Root, Value> {
}

class NSSortDescriptor {
    init(key: String?, ascending: Bool) { }
    convenience init<Root, Value>(keyPath: KeyPath<Root, Value>, ascending: Bool) { self.init(key: nil, ascending: ascending) }
}

// GRDB

struct Configuration {}

class Database {
    init(path: String, description: String, configuration: Configuration) {}
}

class DatabasePool {
    init(path: String, configuration: Configuration) {}
}

class DatabaseQueue {
    init(path: String, configuration: Configuration) {}
}

class DatabaseSnapshotPool {
    init(path: String, configuration: Configuration) {}
}

class SerializedDatabase {
    init(path: String, configuration: Configuration = Configuration(), defaultLabel: String, purpose: String? = nil) {}
}

// Realm

class Realm {
}

extension Realm {
	struct Configuration {
		init(
			fileURL: URL? = URL(fileURLWithPath: "defaultFile", isDirectory: false),
			inMemoryIdentifier: String? = nil,
			syncConfiguration: Int = 0,
			encryptionKey: Data? = nil,
			readOnly: Bool = false,
			schemaVersion: UInt64 = 0,
			migrationBlock: Int = 0,
			deleteRealmIfMigrationNeeded: Bool = false,
			shouldCompactOnLaunch: Bool = false,
			objectTypes: Int = 0,
			seedFilePath: URL? = nil) { }

		var fileURL: URL?
        var seedFilePath: URL?
	}
}

// sqlite3

func sqlite3_open(
    _ filename: UnsafePointer<CChar>?,
    _ ppDb: UnsafeMutablePointer<OpaquePointer?>?) -> Int32 { return 0 }

func sqlite3_open16(
    _ filename: UnsafeRawPointer?,
    _ ppDb: UnsafeMutablePointer<OpaquePointer?>?) -> Int32 { return 0 }

func sqlite3_open_v2(
    _ filename: UnsafePointer<CChar>?,
    _ ppDb: UnsafeMutablePointer<OpaquePointer?>?,
    _ flags: Int32,
    _ zVfs: UnsafePointer<CChar>?) -> Int32 { return 0 }

var sqlite3_temp_directory: UnsafeMutablePointer<CChar>?

// SQLite.swift

enum URIQueryParameter {
}

class Connection {
	enum Location {
		case inMemory
		case uri(String, parameters: [URIQueryParameter] = [])
	}

	init(_ location: Location = .inMemory, readonly: Bool = false) throws { }
	convenience init(_ filename: String, readonly: Bool = false) throws { try self.init() }
}

// --- tests ---

func test(buffer1: UnsafeMutablePointer<UInt8>, buffer2: UnsafeMutablePointer<UInt8>) {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteUrl = URL(string: remoteString)!
    let remoteNsUrl = NSURL(string: remoteString)!
    let safeUrl =  URL(string: "")!
    let safeNsUrl = NSURL(string: "")!

    Data("").write(to: remoteUrl, options: []) // $ hasPathInjection=289

    let nsData = NSData()
    let _ = nsData.write(to: remoteUrl, atomically: false) // $ hasPathInjection=289
    nsData.write(to: remoteUrl, options: []) // $ hasPathInjection=289
    let _ = nsData.write(toFile: remoteString, atomically: false) // $ hasPathInjection=289
    nsData.write(toFile: remoteString, options: []) // $ hasPathInjection=289

    let fm = FileManager()
    let _ = fm.contentsOfDirectory(at: remoteUrl, includingPropertiesForKeys: [], options: []) // $ hasPathInjection=289
    let _ = fm.contentsOfDirectory(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.enumerator(at: remoteUrl, includingPropertiesForKeys: [], options: [], errorHandler: nil) // $ hasPathInjection=289
    let _ = fm.enumerator(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.subpathsOfDirectory(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.subpaths(atPath: remoteString) // $ hasPathInjection=289
    fm.createDirectory(at: remoteUrl, withIntermediateDirectories: false, attributes: [:]) // $ hasPathInjection=289
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:]) // $ hasPathInjection=289
    let _ = fm.createFile(atPath: remoteString, contents: nil, attributes: [:]) // $ hasPathInjection=289
    fm.removeItem(at: remoteUrl) // $ hasPathInjection=289
    fm.removeItem(atPath: remoteString) // $ hasPathInjection=289
    fm.trashItem(at: remoteUrl, resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=289
    let _ = fm.replaceItemAt(remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: []) // $ hasPathInjection=289
    let _ = fm.replaceItemAt(safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: []) // $ hasPathInjection=289
    fm.replaceItem(at: remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: [], resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=289
    fm.replaceItem(at: safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: [], resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=289
    fm.copyItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=289
    fm.copyItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=289
    fm.copyItem(atPath: remoteString, toPath: "") // $ hasPathInjection=289
    fm.copyItem(atPath: "", toPath: remoteString) // $ hasPathInjection=289
    fm.moveItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=289
    fm.moveItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=289
    fm.moveItem(atPath: remoteString, toPath: "") // $ hasPathInjection=289
    fm.moveItem(atPath: "", toPath: remoteString) // $ hasPathInjection=289
    fm.createSymbolicLink(at: remoteUrl, withDestinationURL: safeUrl) // $ hasPathInjection=289
    fm.createSymbolicLink(at: safeUrl, withDestinationURL: remoteUrl) // $ hasPathInjection=289
    fm.createSymbolicLink(atPath: remoteString, withDestinationPath: "") // $ hasPathInjection=289
    fm.createSymbolicLink(atPath: "", withDestinationPath: remoteString) // $ hasPathInjection=289
    fm.linkItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=289
    fm.linkItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=289
    fm.linkItem(atPath: remoteString, toPath: "") // $ hasPathInjection=289
    fm.linkItem(atPath: "", toPath: remoteString) // $ hasPathInjection=289
    let _ = fm.destinationOfSymbolicLink(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.fileExists(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.fileExists(atPath: remoteString, isDirectory: UnsafeMutablePointer<ObjCBool>.init(bitPattern: 0)) // $ hasPathInjection=289
    fm.setAttributes([:], ofItemAtPath: remoteString) // $ hasPathInjection=289
    let _ = fm.contents(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.contentsEqual(atPath: remoteString, andPath: "") // $ hasPathInjection=289
    let _ = fm.contentsEqual(atPath: "", andPath: remoteString) // $ hasPathInjection=289
    let _ = fm.changeCurrentDirectoryPath(remoteString) // $ hasPathInjection=289
    let _ = fm.unmountVolume(at: remoteUrl, options: [], completionHandler: { _ in }) // $ hasPathInjection=289
    // Deprecated methods
    let _ = fm.changeFileAttributes([:], atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.directoryContents(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:]) // $ hasPathInjection=289
    let _ = fm.createSymbolicLink(atPath: remoteString, pathContent: "") // $ hasPathInjection=289
    let _ = fm.createSymbolicLink(atPath: "", pathContent: remoteString) // $ hasPathInjection=289
    let _ = fm.pathContentOfSymbolicLink(atPath: remoteString) // $ hasPathInjection=289
    let _ = fm.replaceItemAtURL(originalItemURL: remoteNsUrl, withItemAtURL: safeNsUrl, backupItemName: nil, options: []) // $ hasPathInjection=289
    let _ = fm.replaceItemAtURL(originalItemURL: safeNsUrl, withItemAtURL: remoteNsUrl, backupItemName: nil, options: []) // $ hasPathInjection=289

    var encoding = String.Encoding.utf8
    let _ = try! String(contentsOfFile: remoteString) // $ hasPathInjection=289
    let _ = try! String(contentsOfFile: remoteString, encoding: String.Encoding.utf8) // $ hasPathInjection=289
    let _ = try! String(contentsOfFile: remoteString, usedEncoding: &encoding) // $ hasPathInjection=289

    let _ = try! NSString(contentsOfFile: remoteString, encoding: 0) // $ hasPathInjection=289
    let _ = try! NSString(contentsOfFile: remoteString, usedEncoding: nil) // $ hasPathInjection=289
    NSString().write(to: remoteUrl, atomically: true, encoding: 0)  // $ hasPathInjection=289
    NSString().write(toFile: remoteString, atomically: true, encoding: 0) // $ hasPathInjection=289

    let _ = NSKeyedUnarchiver().unarchiveObject(withFile: remoteString) // $ hasPathInjection=289
    let _ = ArchiveByteStream.fileStream(fd: remoteString as! FileDescriptor, automaticClose: true) // $ hasPathInjection=289
    ArchiveByteStream.withFileStream(fd: remoteString as! FileDescriptor, automaticClose: true) { _ in } // $ hasPathInjection=289
    let _ = ArchiveByteStream.fileStream(path: FilePath(stringLiteral: remoteString), mode: .readOnly, options: .append, permissions: .ownerRead) // $ hasPathInjection=289
    ArchiveByteStream.withFileStream(path: FilePath(stringLiteral: remoteString), mode: .readOnly, options: .append, permissions: .ownerRead) { _ in } // $ hasPathInjection=289
    let _ = Bundle(url: remoteUrl) // $ hasPathInjection=289
    let _ = Bundle(path: remoteString) // $ hasPathInjection=289

    // GRDB

    let _ = Database(path: remoteString, description: "", configuration: Configuration()) // $ hasPathInjection=289
    let _ = Database(path: "", description: "", configuration: Configuration()) // Safe
    let _ = DatabasePool(path: remoteString, configuration: Configuration()) // $ hasPathInjection=289
    let _ = DatabasePool(path: "", configuration: Configuration()) // Safe
    let _ = DatabaseQueue(path: remoteString, configuration: Configuration()) // $ hasPathInjection=289
    let _ = DatabaseQueue(path: "", configuration: Configuration()) // Safe
    let _ = DatabaseSnapshotPool(path: remoteString, configuration: Configuration()) // $ hasPathInjection=289
    let _ = DatabaseSnapshotPool(path: "", configuration: Configuration()) // Safe
    let _ = SerializedDatabase(path: remoteString, defaultLabel: "") // $ hasPathInjection=289
    let _ = SerializedDatabase(path: "", defaultLabel: "") // Safe
    let _ = SerializedDatabase(path: remoteString, defaultLabel: "", purpose: nil) // $ hasPathInjection=289
    let _ = SerializedDatabase(path: "", defaultLabel: "", purpose: nil) // Safe
    let _ = SerializedDatabase(path: remoteString, configuration: Configuration(), defaultLabel: "") // $ hasPathInjection=289
    let _ = SerializedDatabase(path: "", configuration: Configuration(), defaultLabel: "") // Safe
    let _ = SerializedDatabase(path: remoteString, configuration: Configuration(), defaultLabel: "", purpose: nil) // $ hasPathInjection=289
    let _ = SerializedDatabase(path: "", configuration: Configuration(), defaultLabel: "", purpose: nil) // Safe

    // Realm

	_ = Realm.Configuration(fileURL: safeUrl) // GOOD
	_ = Realm.Configuration(fileURL: remoteUrl) // $ hasPathInjection=289
	_ = Realm.Configuration(seedFilePath: safeUrl) // GOOD
	_ = Realm.Configuration(seedFilePath: remoteUrl) // $ hasPathInjection=289

	var config = Realm.Configuration() // GOOD
	config.fileURL = safeUrl // GOOD
	config.fileURL = remoteUrl // $ hasPathInjection=289
	config.seedFilePath = safeUrl // GOOD
	config.seedFilePath = remoteUrl // $ hasPathInjection=289

    // sqlite3

    var db: OpaquePointer?
    let localData = Data(0)
    let remoteData = Data(contentsOf: URL(string: "http://example.com/")!, options: [])
    localData.copyBytes(to: buffer1, count: localData.count)
    remoteData.copyBytes(to: buffer2, count: remoteData.count)

    _ = sqlite3_open("myFile.sqlite3", &db) // GOOD
    _ = sqlite3_open(remoteString, &db) // $ hasPathInjection=289
    _ = sqlite3_open16(buffer1, &db) // GOOD
    _ = sqlite3_open16(buffer2, &db) // $ hasPathInjection=409
    _ = sqlite3_open_v2("myFile.sqlite3", &db, 0, nil) // GOOD
    _ = sqlite3_open_v2(remoteString, &db, 0, nil) // $ hasPathInjection=289

    sqlite3_temp_directory = UnsafeMutablePointer<CChar>(mutating: NSString(string: "myFile.sqlite3").utf8String) // GOOD
    sqlite3_temp_directory = UnsafeMutablePointer<CChar>(mutating: NSString(string: remoteString).utf8String) // $ MISSING: hasPathInjection=289

    // SQLite.swift

    try! _ = Connection()
    try! _ = Connection(Connection.Location.uri("myFile.sqlite3")) // GOOD
    try! _ = Connection(Connection.Location.uri(remoteString)) // $ hasPathInjection=289
    try! _ = Connection("myFile.sqlite3") // GOOD
    try! _ = Connection(remoteString) // $ hasPathInjection=289
}

func testBarriers() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)

    let fm = FileManager()

    let filePath = FilePath(stringLiteral: remoteString)
    if (filePath.lexicallyNormalized().starts(with: "/safe")) {
        let _ = fm.contents(atPath: remoteString) // Safe
    }
    let _ = fm.contents(atPath: remoteString) // $ hasPathInjection=433
}

func testPathInjection2(s1: UnsafeMutablePointer<String>, s2: UnsafeMutablePointer<String>, s3: UnsafeMutablePointer<String>, fm: FileManager) throws {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)

    var u1 = URL(filePath: "")
    _ = NSData(contentsOf: u1)
    _ = NSData(contentsOf: u1.appendingPathComponent(""))
    _ = NSData(contentsOf: u1.appendingPathComponent(remoteString)) // $ hasPathInjection=445
    _ = NSData(contentsOf: u1.appendingPathComponent(remoteString).appendingPathComponent("")) // $ hasPathInjection=445
    u1.appendPathComponent(remoteString)
    _ = NSData(contentsOf: u1) // $ hasPathInjection=445

    let u2 = URL(filePath: remoteString) // $ hasPathInjection=445
    _ = NSData(contentsOf: u2) // $ hasPathInjection=445

    let u3 = NSURL(string: "")!
    Data("").write(to: u3.filePathURL!, options: [])
    Data("").write(to: u3.appendingPathComponent("")!, options: [])
    Data("").write(to: u3.appendingPathComponent(remoteString)!, options: []) // $ hasPathInjection=445

    let u4 = NSURL(string: remoteString)!
    Data("").write(to: u4.filePathURL!, options: []) // $ hasPathInjection=445
    Data("").write(to: u4.appendingPathComponent("")!, options: []) // $ hasPathInjection=445

    _ = NSData(contentsOfFile: remoteString)! // $ hasPathInjection=445
    _ = NSData(contentsOfMappedFile: remoteString)! // $ hasPathInjection=445
    _ = NSData.dataWithContentsOfMappedFile(remoteString)! // $ hasPathInjection=445

    _ = NSData().write(toFile: s1.pointee, atomically: true)
    s1.pointee = remoteString
    _ = NSData().write(toFile: s1.pointee, atomically: true) // $ hasPathInjection=445
    _ = NSData().write(toFile: s1[0], atomically: true) // $ MISSING: hasPathInjection=445

    _ = "".completePath(into: s2, caseSensitive: false, matchesInto: nil, filterTypes: nil)
    _ = NSData().write(toFile: s2.pointee, atomically: true)
    _ = NSData().write(toFile: s2[0], atomically: true)

    _ = remoteString.completePath(into: s3, caseSensitive: false, matchesInto: nil, filterTypes: nil)
    _ = NSData().write(toFile: s3.pointee, atomically: true) // $ MISSING: hasPathInjection=445
    _ = NSData().write(toFile: s3[0], atomically: true) // $ hasPathInjection=445

    _ = fm.fileAttributes(atPath: remoteString, traverseLink: true) // $ hasPathInjection=445
    _ = try fm.attributesOfItem(atPath: remoteString) // $ hasPathInjection=445
}

// ---

func myOpenFile1(atPath path: String) { }
func myOpenFile2(_ filePath: String) { }
func myFindFiles(ofType type: Int, inDirectory dir: String) { }

class MyClass {
    init(contentsOfFile: String) { }
    func doSomething(keyPath: String) { }
    func write(toFile: String) { }
}

class MyFile {
    init(path: String) { }
}

func testPathInjectionHeuristics() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)

    myOpenFile1(atPath: remoteString) // $ hasPathInjection=505
    myOpenFile2(remoteString) // $ hasPathInjection=505
    myFindFiles(ofType: 0, inDirectory: remoteString) // $ hasPathInjection=505

    let mc = MyClass(contentsOfFile: remoteString) // $ hasPathInjection=505
    mc.doSomething(keyPath: remoteString) // good - not a path
    mc.write(toFile: remoteString) // $ hasPathInjection=505

    let mf1 = MyFile(path: "")
    let mf2 = MyFile(path: remoteString) // $ MISSING: hasPathInjection=

    _ = NSSortDescriptor(key: remoteString, ascending: true) // good - not a path
    _ = NSSortDescriptor(keyPath: remoteString as! KeyPath<Int, Int>, ascending: true) // good - not a path
}
