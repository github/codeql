
func test() {
	// builtin literals
	_ = 1
	_ = 0xFF
	_ = 2.34
	_ = true
	_ = "abc"
	_ = "⡲" // (braille)
	let maybe: Int? = nil // (no BuiltinLiteralExpr)
	_ = [5]
	_ = [6: 7]
	_ = #line
}
