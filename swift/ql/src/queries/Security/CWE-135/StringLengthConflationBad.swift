
func myFunction(s: String) {
	let ns = NSString(string: s)
	let nsrange = NSMakeRange(0, s.count) // BAD: String length used in NSMakeRange

	// ... use nsrange to process ns
}
