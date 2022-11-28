// --- stubs ---

struct URL {
	init?(string: String) {}
}

class NSURL {
    init?(string: String) {}
}

extension String {
	init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
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

struct URLResourceKey {}

struct FileAttributeKey : Hashable {}

struct ObjCBool {}

struct AutoreleasingUnsafeMutablePointer<Pointee> {}

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
    func isReadableFile(atPath: String) -> Bool { return false }
    func isWritableFile(atPath: String) -> Bool { return false }
    func isExecutableFile(atPath: String) -> Bool { return false }
    func isDeletableFile(atPath: String) -> Bool { return false }
    func componentsToDisplay(forPath: String) -> [String]? { return nil }
    func displayName(atPath: String) -> String { return "" }
    func attributesOfItem(atPath: String) -> [FileAttributeKey : Any] { return [:] }
    func attributesOfFileSystem(forPath: String) -> [FileAttributeKey : Any] { return [:] }
    func setAttributes(_: [FileAttributeKey : Any], ofItemAtPath: String) {}
    func contents(atPath: String) -> Data? { return nil }
    func contentsEqual(atPath: String, andPath: String) -> Bool { return false }
    func getRelationship(_: UnsafeMutablePointer<FileManager.URLRelationship>, ofDirectoryAt: URL, toItemAt: URL) {}
    func getRelationship(_: UnsafeMutablePointer<FileManager.URLRelationship>, of: FileManager.SearchPathDirectory, in: FileManager.SearchPathDomainMask, toItemAt: URL) {}
    func changeCurrentDirectoryPath(_: String) -> Bool { return false }
    func unmountVolume(at: URL, options: FileManager.UnmountOptions, completionHandler: (Error?) -> Void) {}
    func NSHFSTypeOfFile(_: String!) -> String! { return "" }
    // Deprecated methods
    func changeFileAttributes(_: [AnyHashable : Any], atPath: String) -> Bool { return false }
    func fileAttributes(atPath: String, traverseLink: Bool) -> [AnyHashable : Any]? { return nil }
    func fileSystemAttributes(atPath: String) -> [AnyHashable : Any]? { return nil }
    func directoryContents(atPath: String) -> [Any]? { return nil }
    func createDirectory(atPath: String, attributes: [AnyHashable : Any]) -> Bool { return false }
    func createSymbolicLink(atPath: String, pathContent: String) -> Bool { return false }
    func pathContentOfSymbolicLink(atPath: String) -> String? { return nil }
    func replaceItemAtURL(originalItemURL: NSURL, withItemAtURL: NSURL, backupItemName: String?, options: FileManager.ItemReplacementOptions) -> NSURL? { return nil }
}

// --- tests ---

func test() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)
    let remoteUrl = URL(string: remoteString)!
    let remoteNsUrl = NSURL(string: remoteString)!
    let safeUrl =  URL(string: "")!
    let safeNsUrl = NSURL(string: "")!

    Data("").write(to: remoteUrl, options: []) // $ hasPathInjection=104

    let nsData = NSData()
    let _ = nsData.write(to: remoteUrl, atomically: false) // $ hasPathInjection=104
    nsData.write(to: remoteUrl, options: []) // $ hasPathInjection=104
    let _ = nsData.write(toFile: remoteString, atomically: false) // $ hasPathInjection=104
    nsData.write(toFile: remoteString, options: []) // $ hasPathInjection=104

    let fm = FileManager()
    let _ = fm.contentsOfDirectory(at: remoteUrl, includingPropertiesForKeys: [], options: []) // $ hasPathInjection=104
    let _ = fm.contentsOfDirectory(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.enumerator(at: remoteUrl, includingPropertiesForKeys: [], options: [], errorHandler: nil) // $ hasPathInjection=104
    let _ = fm.enumerator(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.subpathsOfDirectory(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.subpaths(atPath: remoteString) // $ hasPathInjection=104
    fm.createDirectory(at: remoteUrl, withIntermediateDirectories: false, attributes: [:]) // $ hasPathInjection=104
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:]) // $ hasPathInjection=104
    let _ = fm.createFile(atPath: remoteString, contents: nil, attributes: [:]) // $ hasPathInjection=104
    fm.removeItem(at: remoteUrl) // $ hasPathInjection=104
    fm.removeItem(atPath: remoteString) // $ hasPathInjection=104
    fm.trashItem(at: remoteUrl, resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=104
    let _ = fm.replaceItemAt(remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: []) // $ hasPathInjection=104
    let _ = fm.replaceItemAt(safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: []) // $ hasPathInjection=104
    fm.replaceItem(at: remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: [], resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=104
    fm.replaceItem(at: safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: [], resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>()) // $ hasPathInjection=104
    fm.copyItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=104
    fm.copyItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=104
    fm.copyItem(atPath: remoteString, toPath: "") // $ hasPathInjection=104
    fm.copyItem(atPath: "", toPath: remoteString) // $ hasPathInjection=104
    fm.moveItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=104
    fm.moveItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=104
    fm.moveItem(atPath: remoteString, toPath: "") // $ hasPathInjection=104
    fm.moveItem(atPath: "", toPath: remoteString) // $ hasPathInjection=104
    fm.createSymbolicLink(at: remoteUrl, withDestinationURL: safeUrl) // $ hasPathInjection=104
    fm.createSymbolicLink(at: safeUrl, withDestinationURL: remoteUrl) // $ hasPathInjection=104
    fm.createSymbolicLink(atPath: remoteString, withDestinationPath: "") // $ hasPathInjection=104
    fm.createSymbolicLink(atPath: "", withDestinationPath: remoteString) // $ hasPathInjection=104
    fm.linkItem(at: remoteUrl, to: safeUrl) // $ hasPathInjection=104
    fm.linkItem(at: safeUrl, to: remoteUrl) // $ hasPathInjection=104
    fm.linkItem(atPath: remoteString, toPath: "") // $ hasPathInjection=104
    fm.linkItem(atPath: "", toPath: remoteString) // $ hasPathInjection=104
    let _ = fm.destinationOfSymbolicLink(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.fileExists(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.fileExists(atPath: remoteString, isDirectory: UnsafeMutablePointer<ObjCBool>.init(bitPattern: 0)) // $ hasPathInjection=104
    let _ = fm.isReadableFile(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.isWritableFile(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.isDeletableFile(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.componentsToDisplay(forPath: remoteString) // $ hasPathInjection=104
    let _ = fm.displayName(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.attributesOfItem(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.attributesOfFileSystem(forPath: remoteString) // $ hasPathInjection=104
    fm.setAttributes([:], ofItemAtPath: remoteString) // $ hasPathInjection=104
    let _ = fm.contents(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.contentsEqual(atPath: remoteString, andPath: "") // $ hasPathInjection=104
    let _ = fm.contentsEqual(atPath: "", andPath: remoteString) // $ hasPathInjection=104
    fm.getRelationship(UnsafeMutablePointer<FileManager.URLRelationship>.allocate(capacity: 0), ofDirectoryAt: remoteUrl, toItemAt: safeUrl) // $ hasPathInjection=104
    fm.getRelationship(UnsafeMutablePointer<FileManager.URLRelationship>.allocate(capacity: 0), ofDirectoryAt: safeUrl, toItemAt: remoteUrl) // $ hasPathInjection=104
    fm.getRelationship(UnsafeMutablePointer<FileManager.URLRelationship>.allocate(capacity: 0), of: FileManager.SearchPathDirectory.none, in: FileManager.SearchPathDomainMask(), toItemAt: remoteUrl) // $ hasPathInjection=104
    let _ = fm.changeCurrentDirectoryPath(remoteString) // $ hasPathInjection=104
    let _ = fm.unmountVolume(at: remoteUrl, options: [], completionHandler: { _ in }) // $ hasPathInjection=104
    let _ = fm.NSHFSTypeOfFile(remoteString) // $ hasPathInjection=104
    // Deprecated methods
    let _ = fm.changeFileAttributes([:], atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.fileAttributes(atPath: remoteString, traverseLink: false) // $ hasPathInjection=104
    let _ = fm.fileSystemAttributes(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.directoryContents(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:]) // $ hasPathInjection=104
    let _ = fm.createSymbolicLink(atPath: remoteString, pathContent: "") // $ hasPathInjection=104
    let _ = fm.createSymbolicLink(atPath: "", pathContent: remoteString) // $ hasPathInjection=104
    let _ = fm.pathContentOfSymbolicLink(atPath: remoteString) // $ hasPathInjection=104
    let _ = fm.replaceItemAtURL(originalItemURL: remoteNsUrl, withItemAtURL: safeNsUrl, backupItemName: nil, options: []) // $ hasPathInjection=104
    let _ = fm.replaceItemAtURL(originalItemURL: safeNsUrl, withItemAtURL: remoteNsUrl, backupItemName: nil, options: []) // $ hasPathInjection=104
}
