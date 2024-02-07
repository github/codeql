
// --- stubs ---
struct URL
{
	init?(string: String) {}
	init(fileURLWithPath: String) {}
}

class Zip {
    class func unzipFile(_ zipFilePath: URL, destination: URL, overwrite: Bool, password: String?, progress: ((_ progress: Double) -> ())? = nil, fileOutputHandler: ((_ unzippedFile: URL) -> Void)? = nil) throws {}
}


class NSObject {
}

class Progress : NSObject {

}

class FileManager : NSObject {
    func unzipItem(at sourceURL: URL, to destinationURL: URL, skipCRC32: Bool = false,
                         progress: Progress? = nil, pathEncoding: String.Encoding? = nil) throws  {}
}

protocol DataProtocol { }
class Data : DataProtocol {
    struct ReadingOptions : OptionSet { let rawValue: Int }
    struct WritingOptions : OptionSet { let rawValue: Int }

    init<S>(_ elements: S) { count = 0 }
	init(contentsOf: URL, options: ReadingOptions) { count = 0 }
    func write(to: URL, options: Data.WritingOptions = []) {}

	var count: Int
}

extension String {

    struct Encoding {
		var rawValue: UInt

		init(rawValue: UInt) { self.rawValue = rawValue }

		static let ascii = Encoding(rawValue: 1)
	}
    init(contentsOf url: URL) throws {
        self.init("")
    }
}

// --- tests ---

func testCommandInjectionQhelpExamples() {
    guard let remoteURL = URL(string: "https://example.com/") else {
        return
    }

    let source  = URL(fileURLWithPath: "/sourcePath")
    let destination = URL(fileURLWithPath: "/destination")

    try Data(contentsOf: remoteURL, options: []).write(to: source) 
    do {
        try Zip.unzipFile(source, destination: destination, overwrite: true, password: nil) // BAD

        let fileManager = FileManager()
        try fileManager.unzipItem(at: source, to: destination) // BAD
    } catch {
        print("Error: \(error)")
    }
}