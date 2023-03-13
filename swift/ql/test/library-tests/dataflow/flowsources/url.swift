// --- stubs ---

struct URL {
	init?(string: String) {}

	struct AsyncBytes : AsyncSequence, AsyncIteratorProtocol {
		typealias Element = UInt8

		func makeAsyncIterator() -> AsyncBytes {
			return AsyncBytes()
		}

		mutating func next() async -> Element? { return nil }

		var lines: AsyncLineSequence<Self> {
			get {
				return AsyncLineSequence<Self>()
			}
		}
	}

	var resourceBytes: URL.AsyncBytes {
		get {
			return AsyncBytes()
		}
	}

	struct AsyncLineSequence<Base> : AsyncSequence, AsyncIteratorProtocol where Base : AsyncSequence, Base.Element == UInt8 {
		typealias Element = String

		func makeAsyncIterator() -> AsyncLineSequence<Base> {
			return AsyncLineSequence<Base>()
		}

		mutating func next() async -> Element? { return nil }
	}

	var lines: AsyncLineSequence<URL.AsyncBytes> {
		get {
			return AsyncLineSequence<URL.AsyncBytes>()
		}
	}
}

func print(_ items: Any...) {}

// --- tests ---

func testURLs() async {
	do
	{
		let url = URL(string: "http://example.com/")!
		let bytes = url.resourceBytes // $ source=remote

		for try await byte in bytes
		{
			print(byte)
		}

		let lines = url.lines // $ source=remote

		for try await line in lines
		{
			print(line)
		}

		let lines2 = bytes.lines // $ source=remote

		for try await line in lines2
		{
			print(line)
		}
	} catch {
		// ...
	}
}
