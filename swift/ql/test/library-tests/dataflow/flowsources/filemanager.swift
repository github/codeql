// --- stubs ---

class NSObject {
}

struct URL {
}

struct URLResourceKey {
}

struct Data {
}

class FileManager : NSObject {
	struct DirectoryEnumerationOptions : OptionSet{
    	let rawValue: Int
	}

	func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions = []) throws -> [URL] { return [] }
	func contentsOfDirectory(atPath path: String) throws -> [String] { return [] }
	func directoryContents(atPath path: String) -> [Any]? { return [] } // returns array of NSString
	func subpathsOfDirectory(atPath path: String) throws -> [String] { return [] }
	func subpaths(atPath path: String) -> [String]? { return [] }

	func destinationOfSymbolicLink(atPath path: String) throws -> String { return "" }
	func pathContentOfSymbolicLink(atPath path: String) -> String? { return "" }

	func contents(atPath path: String) -> Data? { return nil }
}

// --- tests ---

func testFileHandle(fm: FileManager, url: URL, path: String) {
	do
	{
		let contents1 = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
		let contents2 = try fm.contentsOfDirectory(atPath: path)
		let contents3 = fm.directoryContents(atPath: path)!

		let subpaths1 = try fm.subpathsOfDirectory(atPath: path)
		let subpaths2 = fm.subpaths(atPath: path)!

		let link1 = try fm.destinationOfSymbolicLink(atPath: path)
		let link2 = fm.pathContentOfSymbolicLink(atPath: path)!

		let data = fm.contents(atPath: path)! // $ source=local
	} catch {
		// ...
	}
}
