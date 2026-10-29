import AppleArchive
import Foundation
import GRDB
import RealmSwift
import SQLite
import SQLite3
import System

// --- tests ---

func test(buffer1: UnsafeMutablePointer<UInt8>, buffer2: UnsafeMutablePointer<UInt8>) {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)  // $ Source
    let remoteUrl = URL(string: remoteString)!
    let remoteNsUrl = NSURL(string: remoteString)!
    let safeUrl = URL(string: "")!
    let safeNsUrl = NSURL(string: "")!

    Data("").write(to: remoteUrl, options: [])  // $ Alert

    let nsData = NSData()
    let _ = nsData.write(to: remoteUrl, atomically: false)  // $ Alert
    nsData.write(to: remoteUrl, options: [])  // $ Alert
    let _ = nsData.write(toFile: remoteString, atomically: false)  // $ Alert
    nsData.write(toFile: remoteString, options: [])  // $ Alert

    let fm = FileManager()
    let _ = fm.contentsOfDirectory(at: remoteUrl, includingPropertiesForKeys: [], options: [])  // $ Alert
    let _ = fm.contentsOfDirectory(atPath: remoteString)  // $ Alert
    let _ = fm.enumerator(
        at: remoteUrl, includingPropertiesForKeys: [], options: [], errorHandler: nil)  // $ Alert
    let _ = fm.enumerator(atPath: remoteString)  // $ Alert
    let _ = fm.subpathsOfDirectory(atPath: remoteString)  // $ Alert
    let _ = fm.subpaths(atPath: remoteString)  // $ Alert
    fm.createDirectory(at: remoteUrl, withIntermediateDirectories: false, attributes: [:])  // $ Alert
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:])  // $ Alert
    let _ = fm.createFile(atPath: remoteString, contents: nil, attributes: [:])  // $ Alert
    fm.removeItem(at: remoteUrl)  // $ Alert
    fm.removeItem(atPath: remoteString)  // $ Alert
    fm.trashItem(at: remoteUrl, resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>())  // $ Alert
    let _ = fm.replaceItemAt(remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: [])  // $ Alert
    let _ = fm.replaceItemAt(safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: [])  // $ Alert
    fm.replaceItem(
        at: remoteUrl, withItemAt: safeUrl, backupItemName: nil, options: [], // $ Alert
        resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>())  // $ MISSING: Alert // reported on a different line
    fm.replaceItem(
        at: safeUrl, withItemAt: remoteUrl, backupItemName: nil, options: [], // $ Alert
        resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>())  // $ MISSING: Alert // reported on a different line
    fm.copyItem(at: remoteUrl, to: safeUrl)  // $ Alert
    fm.copyItem(at: safeUrl, to: remoteUrl)  // $ Alert
    fm.copyItem(atPath: remoteString, toPath: "")  // $ Alert
    fm.copyItem(atPath: "", toPath: remoteString)  // $ Alert
    fm.moveItem(at: remoteUrl, to: safeUrl)  // $ Alert
    fm.moveItem(at: safeUrl, to: remoteUrl)  // $ Alert
    fm.moveItem(atPath: remoteString, toPath: "")  // $ Alert
    fm.moveItem(atPath: "", toPath: remoteString)  // $ Alert
    fm.createSymbolicLink(at: remoteUrl, withDestinationURL: safeUrl)  // $ Alert
    fm.createSymbolicLink(at: safeUrl, withDestinationURL: remoteUrl)  // $ Alert
    fm.createSymbolicLink(atPath: remoteString, withDestinationPath: "")  // $ Alert
    fm.createSymbolicLink(atPath: "", withDestinationPath: remoteString)  // $ Alert
    fm.linkItem(at: remoteUrl, to: safeUrl)  // $ Alert
    fm.linkItem(at: safeUrl, to: remoteUrl)  // $ Alert
    fm.linkItem(atPath: remoteString, toPath: "")  // $ Alert
    fm.linkItem(atPath: "", toPath: remoteString)  // $ Alert
    let _ = fm.destinationOfSymbolicLink(atPath: remoteString)  // $ Alert
    let _ = fm.fileExists(atPath: remoteString)  // $ Alert
    let _ = fm.fileExists(
        atPath: remoteString, isDirectory: UnsafeMutablePointer<ObjCBool>.init(bitPattern: 0))  // $ Alert
    fm.setAttributes([:], ofItemAtPath: remoteString)  // $ Alert
    let _ = fm.contents(atPath: remoteString)  // $ Alert
    let _ = fm.contentsEqual(atPath: remoteString, andPath: "")  // $ Alert
    let _ = fm.contentsEqual(atPath: "", andPath: remoteString)  // $ Alert
    let _ = fm.changeCurrentDirectoryPath(remoteString)  // $ Alert
    let _ = fm.unmountVolume(at: remoteUrl, options: [], completionHandler: { _ in })  // $ Alert
    // Deprecated methods
    let _ = fm.changeFileAttributes([:], atPath: remoteString)  // $ Alert
    let _ = fm.directoryContents(atPath: remoteString)  // $ Alert
    let _ = fm.createDirectory(atPath: remoteString, attributes: [:])  // $ Alert
    let _ = fm.createSymbolicLink(atPath: remoteString, pathContent: "")  // $ Alert
    let _ = fm.createSymbolicLink(atPath: "", pathContent: remoteString)  // $ Alert
    let _ = fm.pathContentOfSymbolicLink(atPath: remoteString)  // $ Alert
    let _ = fm.replaceItemAtURL(
        originalItemURL: remoteNsUrl, withItemAtURL: safeNsUrl, backupItemName: nil, options: [])  // $ Alert
    let _ = fm.replaceItemAtURL(
        originalItemURL: safeNsUrl, withItemAtURL: remoteNsUrl, backupItemName: nil, options: [])  // $ Alert

    var encoding = String.Encoding.utf8
    let _ = try! String(contentsOfFile: remoteString)  // $ Alert
    let _ = try! String(contentsOfFile: remoteString, encoding: String.Encoding.utf8)  // $ Alert
    let _ = try! String(contentsOfFile: remoteString, usedEncoding: &encoding)  // $ Alert

    let _ = try! NSString(contentsOfFile: remoteString, encoding: 0)  // $ Alert
    let _ = try! NSString(contentsOfFile: remoteString, usedEncoding: nil)  // $ Alert
    NSString().write(to: remoteUrl, atomically: true, encoding: 0)  // $ Alert
    NSString().write(toFile: remoteString, atomically: true, encoding: 0)  // $ Alert

    let _ = NSKeyedUnarchiver().unarchiveObject(withFile: remoteString)  // $ Alert
    let _ = ArchiveByteStream.fileStream(fd: remoteString as! FileDescriptor, automaticClose: true)  // $ Alert
    ArchiveByteStream.withFileStream(fd: remoteString as! FileDescriptor, automaticClose: true) { // $ Alert
        _ in
    }
    let _ = ArchiveByteStream.fileStream(
        path: FilePath(stringLiteral: remoteString), mode: .readOnly, options: .append, // $ Alert
        permissions: .ownerRead)  // $ MISSING: Alert // reported on a different line
    ArchiveByteStream.withFileStream(
        path: FilePath(stringLiteral: remoteString), mode: .readOnly, options: .append, // $ Alert
        permissions: .ownerRead
    ) { _ in }  // $ MISSING: Alert // reported on a different line
    let _ = Bundle(url: remoteUrl)  // $ Alert
    let _ = Bundle(path: remoteString)  // $ Alert

    // GRDB

    let _ = Database(path: remoteString, description: "", configuration: Configuration())  // $ Alert
    let _ = Database(path: "", description: "", configuration: Configuration())  // Safe
    let _ = DatabasePool(path: remoteString, configuration: Configuration())  // $ Alert
    let _ = DatabasePool(path: "", configuration: Configuration())  // Safe
    let _ = DatabaseQueue(path: remoteString, configuration: Configuration())  // $ Alert
    let _ = DatabaseQueue(path: "", configuration: Configuration())  // Safe
    let _ = DatabaseSnapshotPool(path: remoteString, configuration: Configuration())  // $ Alert
    let _ = DatabaseSnapshotPool(path: "", configuration: Configuration())  // Safe
    let _ = SerializedDatabase(path: remoteString, defaultLabel: "")  // $ Alert
    let _ = SerializedDatabase(path: "", defaultLabel: "")  // Safe
    let _ = SerializedDatabase(path: remoteString, defaultLabel: "", purpose: nil)  // $ Alert
    let _ = SerializedDatabase(path: "", defaultLabel: "", purpose: nil)  // Safe
    let _ = SerializedDatabase(path: remoteString, configuration: Configuration(), defaultLabel: "")  // $ Alert
    let _ = SerializedDatabase(path: "", configuration: Configuration(), defaultLabel: "")  // Safe
    let _ = SerializedDatabase(
        path: remoteString, configuration: Configuration(), defaultLabel: "", purpose: nil)  // $ Alert
    let _ = SerializedDatabase(
        path: "", configuration: Configuration(), defaultLabel: "", purpose: nil)  // Safe

    // Realm

    _ = Realm.Configuration(fileURL: safeUrl)  // GOOD
    _ = Realm.Configuration(fileURL: remoteUrl)  // $ Alert
    _ = Realm.Configuration(seedFilePath: safeUrl)  // GOOD
    _ = Realm.Configuration(seedFilePath: remoteUrl)  // $ Alert

    var config = Realm.Configuration()  // GOOD
    config.fileURL = safeUrl  // GOOD
    config.fileURL = remoteUrl  // $ Alert
    config.seedFilePath = safeUrl  // GOOD
    config.seedFilePath = remoteUrl  // $ Alert

    // sqlite3

    var db: OpaquePointer?
    let localData = Data(0)
    let remoteData = Data(contentsOf: URL(string: "http://example.com/")!, options: [])  // $ Source
    localData.copyBytes(to: buffer1, count: localData.count)
    remoteData.copyBytes(to: buffer2, count: remoteData.count)

    _ = sqlite3_open("myFile.sqlite3", &db)  // GOOD
    _ = sqlite3_open(remoteString, &db)  // $ Alert
    _ = sqlite3_open16(buffer1, &db)  // GOOD
    _ = sqlite3_open16(buffer2, &db)  // $ Alert
    _ = sqlite3_open_v2("myFile.sqlite3", &db, 0, nil)  // GOOD
    _ = sqlite3_open_v2(remoteString, &db, 0, nil)  // $ Alert

    sqlite3_temp_directory = UnsafeMutablePointer<CChar>(
        mutating: NSString(string: "myFile.sqlite3").utf8String)  // GOOD
    sqlite3_temp_directory = UnsafeMutablePointer<CChar>(
        mutating: NSString(string: remoteString).utf8String)  // $ MISSING: Alert // Originally missing

    // SQLite.swift

    try! _ = Connection()
    try! _ = Connection(Connection.Location.uri("myFile.sqlite3"))  // GOOD
    try! _ = Connection(Connection.Location.uri(remoteString))  // $ Alert
    try! _ = Connection(Connection.Location.uri(remoteString, parameters: []))  // $ Alert
    try! _ = Connection("myFile.sqlite3")  // GOOD
    try! _ = Connection(remoteString)  // $ Alert
    let remoteData2 = Data(contentsOf: URL(string: "http://example.com/")!)  // $ Source
    nsData.write(toFile: remoteData2, options: [])  // $ Alert
}

func testBarriers() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)  // $ Source

    let fm = FileManager()

    let filePath = FilePath(stringLiteral: remoteString)
    if filePath.lexicallyNormalized().starts(with: "/safe") {
        let _ = fm.contents(atPath: remoteString)  // $ SPURIOUS: Alert // Safe
    }
    let _ = fm.contents(atPath: remoteString)  // $ Alert
}

func testPathInjection2(
    s1: UnsafeMutablePointer<String>, s2: UnsafeMutablePointer<String>,
    s3: UnsafeMutablePointer<String>, fm: FileManager
) throws {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)  // $ Source

    var u1 = URL(filePath: "")
    _ = NSData(contentsOf: u1)
    _ = NSData(contentsOf: u1.appendingPathComponent(""))
    _ = NSData(contentsOf: u1.appendingPathComponent(remoteString))  // $ Alert
    _ = NSData(contentsOf: u1.appendingPathComponent(remoteString).appendingPathComponent(""))  // $ Alert
    u1.appendPathComponent(remoteString)
    _ = NSData(contentsOf: u1)  // $ Alert

    let u2 = URL(filePath: remoteString)  // $ Alert
    _ = NSData(contentsOf: u2)  // $ MISSING: Alert

    let u3 = NSURL(string: "")!
    Data("").write(to: u3.filePathURL!, options: [])
    Data("").write(to: u3.appendingPathComponent("")!, options: [])
    Data("").write(to: u3.appendingPathComponent(remoteString)!, options: [])  // $ Alert

    let u4 = NSURL(string: remoteString)!
    Data("").write(to: u4.filePathURL!, options: [])  // $ MISSING: Alert
    Data("").write(to: u4.appendingPathComponent("")!, options: [])  // $ Alert

    _ = NSData(contentsOfFile: remoteString)!  // $ Alert
    _ = NSData(contentsOfMappedFile: remoteString)!  // $ Alert
    _ = NSData.dataWithContentsOfMappedFile(remoteString)!  // $ Alert

    _ = NSData().write(toFile: s1.pointee, atomically: true)
    s1.pointee = remoteString
    _ = NSData().write(toFile: s1.pointee, atomically: true)  // $ Alert
    _ = NSData().write(toFile: s1[0], atomically: true)  // $ MISSING: Alert // Originally missing

    _ = "".completePath(into: s2, caseSensitive: false, matchesInto: nil, filterTypes: nil)
    _ = NSData().write(toFile: s2.pointee, atomically: true)
    _ = NSData().write(toFile: s2[0], atomically: true)

    _ = remoteString.completePath(
        into: s3, caseSensitive: false, matchesInto: nil, filterTypes: nil)
    _ = NSData().write(toFile: s3.pointee, atomically: true)  // $ MISSING: Alert // Originally missing
    _ = NSData().write(toFile: s3[0], atomically: true)  // $ MISSING: Alert

    _ = fm.fileAttributes(atPath: remoteString, traverseLink: true)  // $ Alert
    _ = try fm.attributesOfItem(atPath: remoteString)  // $ Alert
}

// ---

func myOpenFile1(atPath path: String) {}
func myOpenFile2(_ filePath: String) {}
func myFindFiles(ofType type: Int, inDirectory dir: String) {}

class MyClass {
    init(contentsOfFile: String) {}
    func doSomething(keyPath: String) {}
    func write(toFile: String) {}
}

class MyFile {
    init(path: String) {}
}

func testPathInjectionHeuristics() {
    let remoteString = String(contentsOf: URL(string: "http://example.com/")!)  // $ Source

    myOpenFile1(atPath: remoteString)  // $ Alert
    myOpenFile2(remoteString)  // $ MISSING: Alert
    myFindFiles(ofType: 0, inDirectory: remoteString)  // $ Alert

    let mc = MyClass(contentsOfFile: remoteString)  // $ Alert
    mc.doSomething(keyPath: remoteString)  // good - not a path
    mc.write(toFile: remoteString)  // $ Alert

    let mf1 = MyFile(path: "")
    let mf2 = MyFile(path: remoteString)  // $ MISSING: Alert // Originally missing

    _ = NSSortDescriptor(key: remoteString, ascending: true)  // good - not a path
    _ = NSSortDescriptor(keyPath: remoteString as! KeyPath<Int, Int>, ascending: true)  // good - not a path
}
