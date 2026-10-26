// --- stubs ---

struct URL {
	init?(string: String) {}
}

enum CInterop {
  typealias Char = CChar
  typealias PlatformChar = CInterop.Char
}

struct FilePath : CustomStringConvertible, CustomDebugStringConvertible {
	struct Component {
		init?(_ string: String) { }

		var string: String { get { return "" } }
	}

	struct Root {
		init?(_ string: String) { }

		var string: String { get { return "" } }
	}

	struct ComponentView {
	}

	init(_ string: String) { }
	init?(_ url: URL) { }
	init(cString: [CChar]) { }
	init(cString: UnsafePointer<CChar>) { }
	init(from decoder: Decoder) { }
	init<C>(root: FilePath.Root?, _ components: C) where C : Collection, C.Element == FilePath.Component { }

	func encode(to encoder: Encoder) throws { }

	mutating func append(_ other: String) { }
	func appending(_ other: String) -> FilePath { return FilePath("") }
	func lexicallyResolving(_ subpath: FilePath) -> FilePath? { return nil }

	func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
		return 0 as! Result
	}
	func withPlatformString<Result>(_ body: (UnsafePointer<CInterop.PlatformChar>) throws -> Result) rethrows -> Result {
		return 0 as! Result
	}

	var description: String { get { return "" } }
	var debugDescription: String { get { return "" } }
	var `extension`: String? { get { return "" } set { } }
	var stem: String? { get { return "" } }
	var string: String { get { return "" } }

	var components: FilePath.ComponentView { get { return FilePath.ComponentView() } set { } }
	var lastComponent: FilePath.Component? { get { return nil} }
	var root: FilePath.Root? { get { return nil } set { } }
}

extension FilePath.ComponentView: BidirectionalCollection {
	typealias Element = FilePath.Component

	struct Index: Comparable {
		static func < (lhs: Self, rhs: Self) -> Bool {
			return false
		}
	}

	var startIndex: Index { Index() }
	var endIndex: Index { Index() }

	func index(after i: Index) -> Index {
		return Index()
	}

	func index(before i: Index) -> Index {
		return Index()
	}

	subscript(position: Index) -> FilePath.Component {
		return FilePath.Component("")!
	}
}

extension String {
	init(decoding path: FilePath) { self.init() }
	init?(validating path: FilePath) { self.init() }
	init(platformString: UnsafePointer<CInterop.PlatformChar>) { self.init() }
	init?(validatingPlatformString platformStrinbg: UnsafePointer<CInterop.PlatformChar>) { self.init() }
}

// --- tests ---

func sourceString() -> String { return "" }
func sourceCCharArray() -> [CChar] { return [] }
func sourceCString() -> UnsafePointer<CChar> { return (nil as UnsafePointer<CChar>?)! }
func sourceDecoder() -> Decoder { return (nil as Decoder?)! }
func sink(filePath: FilePath) { }
func sink(string: String) { }
func sink(component: FilePath.Component) { }
func sink(root: FilePath.Root) { }
func sink(componentView: FilePath.ComponentView) { }
func sink(encoder: Encoder) { }
func sink<T>(ptr: UnsafePointer<T>) { }
func sink<T>(arg: T) { }

func test_files(e1: Encoder) {
	// --- FilePath.Root, FilePath.Component ---

	sink(string: FilePath.Root("/")!.string)
	sink(string: FilePath.Root(sourceString())!.string) // $ tainted=110
	sink(string: FilePath.Component("path")!.string)
	sink(string: FilePath.Component(sourceString())!.string) // $ tainted=112

	// --- FilePath constructors ---

	let cleanUrl = URL(string: "https://example.com")!
	let taintedUrl = URL(string: sourceString())!

	sink(filePath: FilePath("my/path"))
	sink(filePath: FilePath(sourceString())) // $ tainted=120
	sink(filePath: FilePath(cleanUrl)!)
	sink(filePath: FilePath(taintedUrl)!) // $ tainted=117
	sink(filePath: FilePath(from: sourceDecoder())) // $ tainted=123
	sink(filePath: FilePath(cString: sourceCCharArray())) // $ tainted=124
	sink(filePath: FilePath(cString: sourceCString())) // $ tainted=125
	sink(filePath: FilePath(root: FilePath.Root("/"), [FilePath.Component("my")!, FilePath.Component("path")!]))
	sink(filePath: FilePath(root: FilePath.Root(sourceString()), [FilePath.Component("my")!, FilePath.Component("path")!])) // $ tainted=127
	sink(filePath: FilePath(root: FilePath.Root("/"), [FilePath.Component("my")!, FilePath.Component(sourceString())!])) // $ MISSING: tainted=

	// --- FilePath methods ---

	let clean = FilePath("")
	let tainted = FilePath(sourceString())

	sink(filePath: clean)
	sink(filePath: tainted) // $ tainted=133

	sink(encoder: e1)
	try! clean.encode(to: e1)
	sink(encoder: e1)
	try! tainted.encode(to: e1)
	sink(encoder: e1) // $ MISSING: tainted=

	sink(string: String(decoding: tainted)) // $ tainted=133
	sink(string: String(validating: tainted)!) // $ tainted=133

	sink(filePath: clean.lexicallyResolving(clean)!)
	sink(filePath: tainted.lexicallyResolving(clean)!) // $ tainted=133
	sink(filePath: clean.lexicallyResolving(tainted)!) // $ tainted=133

	let result1 = clean.withCString({
		ptr in
		sink(ptr: ptr)
		sink(arg: ptr[0])
		return sourceString()
	})
	sink(string: result1) // $ tainted=155
	let result2 = tainted.withCString({
		ptr in
		sink(ptr: ptr) // $ tainted=133
		sink(arg: ptr[0]) // $ tainted=133
		return ""
	})
	sink(string: result2)

	let result3 = clean.withPlatformString({
		ptr in
		sink(ptr: ptr)
		sink(arg: ptr[0])
		sink(string: String(platformString: ptr))
		sink(string: String(validatingPlatformString: ptr)!)
		return sourceString()
	})
	sink(string: result3) // $ tainted=172
	let result4 = tainted.withPlatformString({
		ptr in
		sink(ptr: ptr) // $ tainted=133
		sink(arg: ptr[0]) // $ tainted=133
		sink(string: String(platformString: ptr)) // $ tainted=133
		sink(string: String(validatingPlatformString: ptr)!) // $ tainted=133
		return ""
	})
	sink(string: result4)

 	var fp1 = FilePath("")
	sink(filePath: fp1)
	fp1.append(sourceString())
	sink(filePath: fp1) // $ tainted=187
	fp1.append("")
	sink(filePath: fp1) // $ tainted=187

	sink(filePath: clean.appending(""))
	sink(filePath: clean.appending(sourceString())) // $ tainted=193
	sink(filePath: tainted.appending("")) // $ tainted=133
	sink(filePath: tainted.appending(sourceString())) // $ tainted=133 tainted=195

	// --- FilePath member variables ---

	sink(string: tainted.description) // $ tainted=133
	sink(string: tainted.debugDescription) // $ tainted=133
	sink(string: tainted.extension!) // $ tainted=133
	sink(string: tainted.stem!) // $ tainted=133
	sink(string: tainted.string) // $ tainted=133

	sink(component: tainted.lastComponent!) // $ tainted=133
	sink(string: tainted.lastComponent!.string) // $ tainted=133
	sink(root: tainted.root!) // $ tainted=133
	sink(string: tainted.root!.string) // $ tainted=133

	let taintedComponents = tainted.components
	sink(componentView: taintedComponents) // $ tainted=133
	sink(string: taintedComponents[taintedComponents.startIndex].string) // $ tainted=133
}
