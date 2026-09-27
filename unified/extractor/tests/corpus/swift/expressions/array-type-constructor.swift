let values = [Result<Void>]()
let initialized = [Result<Void>](unsafeUninitializedCapacity: 1) { _, count in
	count = 0
}
