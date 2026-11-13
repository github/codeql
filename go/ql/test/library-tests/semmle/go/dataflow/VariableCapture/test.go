package capture

func source() string { return "" }
func sink(string)    {}

var packageClosure = func() {}

func direct() {
	x := source()
	f := func() { sink(x) } // $ hasValueFlow="x"
	f()
}

func overwritten() {
	x := source()
	f := func() { sink(x) }
	x = "safe"
	f()
}

func assignedAfterCreation() {
	x := "safe"
	f := func() { sink(x) } // $ hasValueFlow="x"
	x = source()
	f()
}

func writeBack() {
	x := "safe"
	f := func() { x = source() }
	f()
	sink(x) // $ hasValueFlow="x"
}

func siblingClosures() {
	x := "safe"
	set := func() { x = source() }
	get := func() { sink(x) } // $ hasValueFlow="x"
	set()
	get()
}

func nested() {
	x := source()
	f := func() func() {
		return func() { sink(x) } // $ hasValueFlow="x"
	}
	f()()
}

func captureParameter(x string) func() string {
	return func() string { return x }
}

func separateInvocations() {
	bad := captureParameter(source())
	good := captureParameter("safe")
	sink(bad()) // $ hasValueFlow="call to bad"
	sink(good())
}

func copyBetweenCaptures() {
	x := source()
	y := "safe"
	f := func() { y = x }
	f()
	sink(y) // $ hasValueFlow="y"
}

func multipleWrites() {
	x := source()
	x = "safe"
	sink(x)
	f := func() { sink(x) }
	f()
}

func tuple() (string, bool) { return source(), true }

func tupleWrite() {
	x, _ := tuple()
	f := func() { sink(x) } // $ hasValueFlow="x"
	f()
}

func rangeWrite() {
	for _, x := range []string{source()} {
		f := func() { sink(x) } // $ hasValueFlow="x"
		f()
	}
}

type receiver struct{ value string }

func (r receiver) closure() func() string {
	return func() string { return r.value }
}

func capturedReceiver() {
	r := receiver{source()}
	sink(r.closure()()) // $ hasValueFlow="function call"
}

func aliasedClosure(branch bool) {
	x := "safe"
	f := func() { sink(x) } // $ hasValueFlow="x"
	g := func() {}
	if branch {
		g = f
	}
	x = source()
	g()
}

func nestedWriteBack() {
	x := "safe"
	f := func() {
		g := func() { x = source() }
		g()
	}
	f()
	sink(x) // $ hasValueFlow="x"
}

func capturedResult() (x string) {
	f := func() { x = source() }
	f()
	return
}

func namedResult() {
	sink(capturedResult()) // $ hasValueFlow="call to capturedResult"
}

func mutateCapturedPointer() {
	x := &receiver{}
	f := func() { x.value = source() }
	f()
	sink(x.value) // $ hasValueFlow="selection of value"
}

func callback(f func()) { f() }

func passedClosure() {
	x := source()
	callback(func() { sink(x) }) // $ hasValueFlow="x"
}

func capturedCallee() {
	handler := sink
	func() {
		handler(source()) // $ hasValueFlow="call to source"
	}()
}

func returnedWriter() (func(string), func() string) {
	x := "safe"
	return func(s string) { x = s }, func() string { return x }
}

func sharedEscapedStorage() {
	set, get := returnedWriter()
	set(source())
	sink(get()) // $ MISSING: hasValueFlow="call to get"
}
