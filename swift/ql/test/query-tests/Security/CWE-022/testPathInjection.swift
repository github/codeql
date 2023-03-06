// --- stubs ---

struct URL {
	init?(string: String) {}
}

class NSURL {
    init?(string: String) {}
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
    convenience init(contentsOfFile path: String, encoding enc: UInt) throws { self.init() }
    convenience init(contentsOfFile path: String, usedEncoding enc: UnsafeMutablePointer<UInt>?) throws { self.init() }

    func write(toFile: String, atomically: Bool, encoding: UInt) {}
    func write(to: URL, atomically: Bool, encoding: UInt) {}
}

class Data {
    struct WritingOptions : OptionSet { let rawValue: Int }
    init<S>(_ elements: S) {}
    func write(to: URL, options: Data.WritingOptions = []) {}
}

class NSData {
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
    func changeFileAttributes(_: [AnyHashable : Any], atPath: String) -> Bool { return false }
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

// --- tests ---

func test() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteUrl = URL(string: remoteString)!
    let remoteNsUrl = NSURL(string: remoteString)!
    let safeUrl =  URL(string: "")!
    let safeNsUrl = NSURL(string: "")!

    Data("").write(to: remoteUrl, options: []) // $ hasPathInjection=182

    let nsData = NSData()
    let _ = nsData.write(to: remoteUrl, atomically: false) // $ hasPathInjection=182
    nsData.write(to: remoteUrl, options: []) // $ hasPathInjection=182
    let _ = nsData.write(toFile: remoteString, atomically: false) // $ hasPathInjection=182
    nsData.write(toFile: remoteString, options: []) // $ hasPathInjection=182

    let fm = FileManager()
    let _ = fm.contentsOfDirectory(at: remoteUrl, includingPropertiesForKeys: [], options: []) // $ hasPathInjection=182
    let _ = fm.contentsOfDirectory(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.enumerator(at: remoteUrl, includingPropertiesForKeys: [], options: [], errorHandler: nil) // $ hasPathInjection=182
    let _ = fm.enumerator(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.subpathsOfDirectory(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.subpaths(atPath: remoteString) // $ hasPathInjection=182
    fm.createDirectory(at: remoteUrl, withIntermediateDirectories: false, attributes: [:]) // $ hasPathInjection=182
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:]) // $ hasPathInjection=182
    let _ = fm.createFile(atPath: remoteString, contents: nil, attributes: [:]) // $ hasPathInjection=182
    fm.removeItem(at: remoteUrl) // $ hasPathInjection=182
    fm.removeItem(atPath: remoteString) // $ hasPathInjection=182
    fm.trashItem(at: remoteUrl, resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=182
    let _ = fm.replaceItemAt(remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: []) // $ hasPathInjection=182
    let _ = fm.replaceItemAt(safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: []) // $ hasPathInjection=182
    fm.replaceItem(at: remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: [], resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=182
    fm.replaceItem(at: safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: [], resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=182
    fm.copyItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=182
    fm.copyItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=182
    fm.copyItem(atPath: remoteString, toPath: "") // $ hasPathInjection=182
    fm.copyItem(atPath: "", toPath: remoteString) // $ hasPathInjection=182
    fm.moveItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=182
    fm.moveItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=182
    fm.moveItem(atPath: remoteString, toPath: "") // $ hasPathInjection=182
    fm.moveItem(atPath: "", toPath: remoteString) // $ hasPathInjection=182
    fm.createSymbolicLink(at: remoteUrl, withDestinationURL: safeUrl) // $ hasPathInjection=182
    fm.createSymbolicLink(at: safeUrl, withDestinationURL: remoteUrl) // $ hasPathInjection=182
    fm.createSymbolicLink(atPath: remoteString, withDestinationPath: "") // $ hasPathInjection=182
    fm.createSymbolicLink(atPath: "", withDestinationPath: remoteString) // $ hasPathInjection=182
    fm.linkItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=182
    fm.linkItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=182
    fm.linkItem(atPath: remoteString, toPath: "") // $ hasPathInjection=182
    fm.linkItem(atPath: "", toPath: remoteString) // $ hasPathInjection=182
    let _ = fm.destinationOfSymbolicLink(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.fileExists(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.fileExists(atPath: remoteString, isDirectory: UnsafeMutablePointer<ObjCBool>.init(bitPattern: 0)) // $ hasPathInjection=182
    fm.setAttributes([:], ofItemAtPath: remoteString) // $ hasPathInjection=182
    let _ = fm.contents(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.contentsEqual(atPath: remoteString, andPath: "") // $ hasPathInjection=182
    let _ = fm.contentsEqual(atPath: "", andPath: remoteString) // $ hasPathInjection=182
    let _ = fm.changeCurrentDirectoryPath(remoteString) // $ hasPathInjection=182
    let _ = fm.unmountVolume(at: remoteUrl, options: [], completionHandler: { _ in }) // $ hasPathInjection=182
    // Deprecated methods
    let _ = fm.changeFileAttributes([:], atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.directoryContents(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:]) // $ hasPathInjection=182
    let _ = fm.createSymbolicLink(atPath: remoteString, pathContent: "") // $ hasPathInjection=182
    let _ = fm.createSymbolicLink(atPath: "", pathContent: remoteString) // $ hasPathInjection=182
    let _ = fm.pathContentOfSymbolicLink(atPath: remoteString) // $ hasPathInjection=182
    let _ = fm.replaceItemAtURL(originalItemURL: remoteNsUrl, withItemAtURL: safeNsUrl, backupItemName: nil, options: []) // $ hasPathInjection=182
    let _ = fm.replaceItemAtURL(originalItemURL: safeNsUrl, withItemAtURL: remoteNsUrl, backupItemName: nil, options: []) // $ hasPathInjection=182

    var encoding = String.Encoding.utf8
    let _ = try! String(contentsOfFile: remoteString) // $ hasPathInjection=182
    let _ = try! String(contentsOfFile: remoteString, encoding: String.Encoding.utf8) // $ hasPathInjection=182
    let _ = try! String(contentsOfFile: remoteString, usedEncoding: &encoding) // $ hasPathInjection=182

    let _ = try! NSString(contentsOfFile: remoteString, encoding: 0) // $ hasPathInjection=182
    let _ = try! NSString(contentsOfFile: remoteString, usedEncoding: nil) // $ hasPathInjection=182
    NSString().write(to: remoteUrl, atomically: true, encoding: 0)  // $ hasPathInjection=182
    NSString().write(toFile: remoteString, atomically: true, encoding: 0) // $ hasPathInjection=182

    let _ = NSKeyedUnarchiver().unarchiveObject(withFile: remoteString) // $ hasPathInjection=182
    let _ = ArchiveByteStream.fileStream(fd: remoteString as! FileDescriptor, automaticClose: true) // $ hasPathInjection=182
    ArchiveByteStream.withFileStream(fd: remoteString as! FileDescriptor, automaticClose: true) { _ in } // $ hasPathInjection=182
    let _ = ArchiveByteStream.fileStream(path: FilePath(stringLiteral: remoteString), mode: .readOnly, options: .append, permissions: .ownerRead) // $ hasPathInjection=182
    ArchiveByteStream.withFileStream(path: FilePath(stringLiteral: remoteString), mode: .readOnly, options: .append, permissions: .ownerRead) { _ in } // $ hasPathInjection=182
    let _ = Bundle(url: remoteUrl) // $ hasPathInjection=182
    let _ = Bundle(path: remoteString) // $ hasPathInjection=182

    let _ = Database(path: remoteString, description: "", configuration: Configuration()) // $ hasPathInjection=182
    let _ = Database(path: "", description: "", configuration: Configuration()) // Safe
    let _ = DatabasePool(path: remoteString, configuration: Configuration()) // $ hasPathInjection=182
    let _ = DatabasePool(path: "", configuration: Configuration()) // Safe
    let _ = DatabaseQueue(path: remoteString, configuration: Configuration()) // $ hasPathInjection=182
    let _ = DatabaseQueue(path: "", configuration: Configuration()) // Safe
    let _ = DatabaseSnapshotPool(path: remoteString, configuration: Configuration()) // $ hasPathInjection=182
    let _ = DatabaseSnapshotPool(path: "", configuration: Configuration()) // Safe
    let _ = SerializedDatabase(path: remoteString, defaultLabel: "") // $ hasPathInjection=182
    let _ = SerializedDatabase(path: "", defaultLabel: "") // Safe
    let _ = SerializedDatabase(path: remoteString, defaultLabel: "", purpose: nil) // $ hasPathInjection=182
    let _ = SerializedDatabase(path: "", defaultLabel: "", purpose: nil) // Safe
    let _ = SerializedDatabase(path: remoteString, configuration: Configuration(), defaultLabel: "") // $ hasPathInjection=182
    let _ = SerializedDatabase(path: "", configuration: Configuration(), defaultLabel: "") // Safe
    let _ = SerializedDatabase(path: remoteString, configuration: Configuration(), defaultLabel: "", purpose: nil) // $ hasPathInjection=182
    let _ = SerializedDatabase(path: "", configuration: Configuration(), defaultLabel: "", purpose: nil) // Safe
}

func testSanitizers() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)

    let fm = FileManager()

    let filePath = FilePath(stringLiteral: remoteString)
    if (filePath.lexicallyNormalized().starts(with: "/safe")) {
        let _ = fm.contents(atPath: remoteString) // Safe
    }
    let _ = fm.contents(atPath: remoteString) // $ hasPathInjection=285
}
