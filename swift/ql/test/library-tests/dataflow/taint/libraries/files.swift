// --- stubs ---

struct URL {
	init?(string: String) {}
}

enum CInterop {
  typealias Char = CChar
  typealias PlatformChar = CInterop.Char
}

struct FilePath {
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

func test_files(e1: Encoder) {
	// --- FilePath.Root, FilePath.Component ---

	sink(string: FilePath.Root("/")!.string)
	sink(string: FilePath.Root(sourceString())!.string) // $ MISSING: tainted=
	sink(string: FilePath.Component("path")!.string)
	sink(string: FilePath.Component(sourceString())!.string) // $ MISSING: tainted=

	// --- FilePath constructors ---

	let cleanUrl = URL(string: "https://example.com")!
	let taintedUrl = URL(string: sourceString())!

	sink(filePath: FilePath("my/path"))
	sink(filePath: FilePath(sourceString())) // $ MISSING: tainted=
	sink(filePath: FilePath(cleanUrl)!)
	sink(filePath: FilePath(taintedUrl)!) // $ MISSING: tainted=
	sink(filePath: FilePath(from: sourceDecoder())) // $ MISSING: tainted=
	sink(filePath: FilePath(cString: sourceCCharArray())) // $ MISSING: tainted=
	sink(filePath: FilePath(cString: sourceCString())) // $ MISSING: tainted=
	sink(filePath: FilePath(root: FilePath.Root("/"), [FilePath.Component("my")!, FilePath.Component("path")!]))
	sink(filePath: FilePath(root: FilePath.Root(sourceString()), [FilePath.Component("my")!, FilePath.Component("path")!])) // $ MISSING: tainted=
	sink(filePath: FilePath(root: FilePath.Root("/"), [FilePath.Component("my")!, FilePath.Component(sourceString())!])) // $ MISSING: tainted=

	// --- FilePath methods ---

	let clean = FilePath("")
	let tainted = FilePath(sourceString())

	sink(filePath: clean)
	sink(filePath: tainted) // $ MISSING: tainted=

	sink(encoder: e1)
	try! clean.encode(to: e1)
	sink(encoder: e1)
	try! tainted.encode(to: e1)
	sink(encoder: e1) // $ MISSING: tainted=

	sink(string: String(decoding: tainted)) // $ MISSING: tainted=
	sink(string: String(validating: tainted)!) // $ MISSING: tainted=

	sink(filePath: clean.lexicallyResolving(clean)!)
	sink(filePath: tainted.lexicallyResolving(clean)!) // $ MISSING: tainted=
	sink(filePath: clean.lexicallyResolving(tainted)!) // $ MISSING: tainted=

	let _ = clean.withCString({
		ptr in
		sink(ptr: ptr)
	})
	let _ = tainted.withCString({
		ptr in
		sink(ptr: ptr) // $ MISSING: tainted=
	})

	let _ = clean.withPlatformString({
		ptr in
		sink(ptr: ptr)
		sink(string: String(platformString: ptr))
		sink(string: String(validatingPlatformString: ptr)!)
	})
	let _ = tainted.withPlatformString({
		ptr in
		sink(ptr: ptr) // $ MISSING: tainted=
		sink(string: String(platformString: ptr)) // $ MISSING: tainted=
		sink(string: String(validatingPlatformString: ptr)!) // $ MISSING: tainted=
	})

 	var fp1 = FilePath("")
	sink(filePath: fp1)
	fp1.append(sourceString())
	sink(filePath: fp1) // $ MISSING: tainted=
	fp1.append("")
	sink(filePath: fp1) // $ MISSING: tainted=

	sink(filePath: clean.appending(""))
	sink(filePath: clean.appending(sourceString())) // $ MISSING: tainted=
	sink(filePath: tainted.appending("")) // $ MISSING: tainted=
	sink(filePath: tainted.appending(sourceString())) // $ MISSING: tainted=

	// --- FilePath member variables ---

	sink(string: tainted.description) // $ MISSING: tainted=
	sink(string: tainted.debugDescription) // $ MISSING: tainted=
	sink(string: tainted.extension!) // $ MISSING: tainted=
	sink(string: tainted.stem!) // $ MISSING: tainted=
	sink(string: tainted.string) // $ MISSING: tainted=

	sink(component: tainted.lastComponent!) // $ MISSING: tainted=
	sink(string: tainted.lastComponent!.string) // $ MISSING: tainted=
	sink(root: tainted.root!) // $ MISSING: tainted=
	sink(string: tainted.root!.string) // $ MISSING: tainted=

	let taintedComponents = tainted.components
	sink(componentView: taintedComponents) // $ MISSING: tainted=
	sink(string: taintedComponents[taintedComponents.startIndex].string) // $ MISSING: tainted=
}
