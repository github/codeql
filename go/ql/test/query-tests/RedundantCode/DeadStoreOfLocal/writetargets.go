package p

// Examples exercising each kind of IR write target, to check that
// `go/useless-assignment-to-local` reports the assigned variable for every kind
// and correctly ignores writes that do not define a local variable.

func wtTwoInts() (int, int) { return deadStore(), deadStore() }

func wtMap() map[string]int { return nil }

func wtIface() interface{} { return nil }

type wtStruct struct{ f int }

// --- Write targets that define a local variable (can be flagged) ---

// simple assignment (assign / VarOrConstTarget)
func wtAssign() {
	var x int
	x = deadStore() // $ Alert
	x = deadStore()
	_ = x
}

// short variable declaration (assign)
func wtShortDecl() {
	x := deadStore() // $ Alert
	x = deadStore()
	_ = x
}

// var declaration with initializer (assign via ValueSpec)
func wtVarDecl() {
	var x = deadStore() // $ Alert
	x = deadStore()
	_ = x
}

// compound assignment (compound-rhs)
func wtCompound(x int) int {
	x += deadStore() // $ Alert
	x = deadStore()
	return x
}

// increment (compound-rhs on an IncDecStmt)
func wtIncrement(x int) int {
	x++ // $ Alert
	x = deadStore()
	return x
}

// decrement (compound-rhs on an IncDecStmt)
func wtDecrement(x int) int {
	x-- // $ Alert
	x = deadStore()
	return x
}

// tuple destructuring in a short declaration (extract)
func wtExtractShortDecl() {
	x, y := wtTwoInts() // $ Alert
	x = deadStore()
	_ = x
	_ = y
}

// tuple destructuring in an assignment (extract)
func wtExtractAssign() {
	var x, y int
	x, y = wtTwoInts() // $ Alert
	x = deadStore()
	_ = x
	_ = y
}

// map access with comma-ok (extract)
func wtExtractMapCommaOk() {
	v, ok := wtMap()["k"] // $ Alert
	v = deadStore()
	_ = v
	_ = ok
}

// type assertion with comma-ok (extract)
func wtExtractTypeAssert() {
	v, ok := wtIface().(int) // $ Alert
	v = deadStore()
	_ = v
	_ = ok
}

// range key/value (extract on a RangeElementExpr)
func wtExtractRange(xs []int) {
	for i, v := range xs { // $ Alert
		v = deadStore()
		_ = i
		_ = v
	}
}

// assignment to a named result (VarOrConstTarget), dead because it is
// overwritten by the value in the `return` statement
func wtNamedResult() (r int) {
	r = deadStore() // $ Alert
	return deadStore()
}

// --- Write targets that do not define a local variable (never flagged here) ---

// field write (FieldTarget) - covered by go/useless-assignment-to-field
func wtField(s *wtStruct) {
	s.f = deadStore()
	s.f = deadStore()
	_ = s.f
}

// element write (ElementTarget)
func wtElement(xs []int) {
	xs[0] = deadStore()
	xs[0] = deadStore()
	_ = xs[0]
}

// pointer dereference write (PointerTarget)
func wtPointer(p *int) {
	*p = deadStore()
	*p = deadStore()
	_ = *p
}

// composite literal element (MkLiteralElementTarget)
func wtLiteralElement() {
	_ = []int{deadStore(), deadStore()}
}
