
func myFunction(s: String) {
	let ns = NSString(string: s)
	let nsrange = NSMakeRange(0, ns.length) // Fixed: NSString length used in NSMakeRange

	// ... use nsrange to process ns
}
