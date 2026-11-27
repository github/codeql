package capture

import "strings"

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

func (r receiver) closure() func() string { // $ receiver-node,function-receiver,input-receiver,receiver-agreement=1
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

func deferredReadAfterRegistration() {
	x := "safe"
	defer func() { sink(x) }() // $ hasValueFlow="x"
	x = source()
}

func deferredOverwriteAfterRegistration() {
	x := source()
	defer func() { sink(x) }()
	x = "safe"
}

func deferredResult() (x string) {
	defer func() { x = source() }()
	return "safe"
}

func deferredNamedResult() {
	sink(deferredResult()) // $ hasValueFlow="call to deferredResult"
}

func deferredCallsRunInReverseOrder() {
	x := "safe"
	defer func() { sink(x) }() // $ hasValueFlow="x"
	defer func() { x = source() }()
}

func deferredArgumentsEvaluatedEarly() {
	x := source()
	defer func(arg string) {
		sink(arg) // $ hasValueFlow="arg"
		sink(x)
	}(x)
	x = "safe"
}

func deferredCapturesReadLate() {
	x := "safe"
	defer func(arg string) {
		sink(arg)
		sink(x) // $ hasValueFlow="x"
	}(x)
	x = source()
}

func deferredCalleeEvaluatedEarly() {
	x := "safe"
	f := func() { sink(x) } // $ hasValueFlow="x"
	defer f()
	f = func() {}
	x = source()
}

func deferredCalleeIsNotReevaluated() {
	x := source()
	f := func() {}
	defer f()
	f = func() { sink(x) }
}

func deferredCallback() {
	x := "safe"
	defer callback(func() { sink(x) }) // $ hasValueFlow="x"
	x = source()
}

func runBoth(f, g func()) {
	f()
	g()
}

func deferredMultipleCallbacks() {
	x := "safe"
	defer runBoth(
		func() { sink(x) }, // $ hasValueFlow="x"
		func() { sink(x) }, // $ hasValueFlow="x"
	)
	x = source()
}

func deferredHigherOrderClosure() {
	x := "safe"
	run := func(f func()) {
		sink(x) // $ hasValueFlow="x"
		f()
	}
	defer run(func() { sink(x) }) // $ hasValueFlow="x"
	x = source()
}

type runnableFunc func()

func (f runnableFunc) run() { f() }

func deferredMethodReceiver() {
	x := "safe"
	h := runnableFunc(func() { sink(x) }) // $ hasValueFlow="x"
	defer h.run()
	x = source()
}

func deferredMethodReceiverOverwrite() {
	x := source()
	h := runnableFunc(func() { sink(x) })
	defer h.run()
	x = "safe"
}

func apply(f func(string) string, s string) string { return f(s) }

func identity(s string) string { return s }
func constant(string) string   { return "safe" }

func genericIdentity[T any](s T) T { return s }

func (receiver) identity(s string) string { return s }

func namedAndLiteralTargets() {
	sink(apply(func(s string) string { return s }, "safe"))
	sink(apply(identity, source())) // $ hasValueFlow="call to apply"
	sink(apply(constant, source()))
	sink(apply(receiver{}.identity, source()))     // $ hasValueFlow="call to apply"
	sink(apply(genericIdentity[string], source())) // $ hasValueFlow="call to apply"
	sink(apply(strings.Clone, source()))           // $ hasValueFlow="call to apply"
}

type identityMethod interface{ identity(string) string }

func interfaceMethodValue(r identityMethod) {
	sink(apply(r.identity, source())) // $ hasValueFlow="call to apply"
}

func capturedClosureAlias() {
	x := "safe"
	f := func() { sink(x) } // $ hasValueFlow="x"
	g := func() { f() }
	x = source()
	g()
}

func capturedCallbackAlias() {
	x := "safe"
	f := func() { sink(x) } // $ hasValueFlow="x"
	g := func() { callback(f) }
	x = source()
	g()
}

func overwrittenCapturedClosureAlias() {
	x := source()
	f := func() { sink(x) }
	g := func() { f() }
	x = "safe"
	g()
}

func innerClosureEscapeViaCapturedVar() {
	var f func()
	set := func() {
		y := "safe"
		g := func() { sink(y) } // $ hasValueFlow="y"
		y = source()
		f = g
	}
	set()
	f()
}

func overwrittenInnerClosureEscapeViaCapturedVar() {
	var f func()
	set := func() {
		y := source()
		g := func() { sink(y) }
		y = "safe"
		f = g
	}
	set()
	f()
}

func makeNamedResultClosure() (f func() string) {
	x := "safe"
	f = func() string { return x }
	x = source()
	return
}

func namedResultClosure() {
	sink(makeNamedResultClosure()()) // $ hasValueFlow="function call"
}

func makeOverwrittenNamedResultClosure() (f func() string) {
	x := source()
	f = func() string { return x }
	x = "safe"
	return
}

func overwrittenNamedResultClosure() {
	sink(makeOverwrittenNamedResultClosure()())
}

func applyCaptured(f func(string) string, s string) string {
	_ = f
	return func() string { return f(s) }()
}

func capturedNamedAndLiteralTargets() {
	sink(applyCaptured(func(s string) string { return s }, "safe"))
	sink(applyCaptured(identity, source())) // $ hasValueFlow="call to applyCaptured"
	// Captured callback targets are discovered without distinguishing calls to applyCaptured.
	sink(applyCaptured(constant, source())) // $ SPURIOUS: hasValueFlow="call to applyCaptured"
}

func assertedClosure() {
	x := "safe"
	var stored any = func() { sink(x) } // $ hasValueFlow="x"
	f := stored.(func())
	x = source()
	f()
}

func overwrittenAssertedClosure() {
	x := source()
	var stored any = func() { sink(x) }
	f := stored.(func())
	x = "safe"
	f()
}

func checkedAssertedClosure() {
	x := "safe"
	var stored any = func() { sink(x) } // $ hasValueFlow="x"
	f, ok := stored.(func())
	if ok {
		x = source()
		f()
	}
}

func assertedClosureWriteBack() {
	x := "safe"
	var stored any = func() { x = source() }
	f := stored.(func())
	f()
	sink(x) // $ hasValueFlow="x"
}

func closureArgumentNodes() {
	constant("safe")                // $ closure-args,callee-post,closure-post=0
	genericIdentity[string]("safe") // $ closure-args,callee-post,closure-post=0
	r := receiver{}
	r.identity("safe") // $ closure-args,callee-post,closure-post=0 receiver-post,effective-receiver-post=1
	var im identityMethod = r
	defer im.identity("safe") // $ closure-args,callee-post,closure-post=0 receiver-post,effective-receiver-post=1

	f := func() {} // $ closure-params=0
	f()            // $ closure-args,callee-post,closure-post=1
	named := constant
	named("safe") // $ closure-args,callee-post,closure-post=1
	method := r.identity
	method("safe") // $ closure-args,callee-post,closure-post=1

	x := "safe"
	g := func() { _ = x }  // $ closure-params=1
	g()                    // $ closure-args,callee-post,closure-post=1
	callback(g)            // $ closure-args,callee-post,closure-post=0 argument-post,syntactic-arg,registration-post=1
	defer constant("safe") // $ closure-args,callee-post,closure-post=0
	defer f()              // $ closure-args,closure-post=1 callee-post=0
	defer (f)()            // $ closure-args,closure-post=1 callee-post=0
	defer callback(g)      // $ closure-args,callee-post,closure-post,registration-post=0 argument-post,syntactic-arg=1
	defer callback((g))    // $ closure-args,callee-post,closure-post,registration-post=0 argument-post,syntactic-arg=1
	callbackAny(g)         // $ closure-args,callee-post,closure-post=0 argument-post,syntactic-arg,registration-post=1
	defer callbackAny(g)   // $ closure-args,callee-post,closure-post,registration-post=0 argument-post,syntactic-arg=1
	var nonClosure any = &receiver{}
	defer callbackAny(nonClosure) // $ closure-args,callee-post,closure-post=0 argument-post,syntactic-arg,registration-post=1
	h := runnableFunc(g)
	h.run()       // $ closure-args,callee-post,closure-post=0 receiver-post,effective-receiver-post=1
	defer h.run() // $ closure-args,callee-post,closure-post,receiver-post=0 effective-receiver-post=1
}

func localCapturedFlow() {
	x := source()
	_ = func() { _ = x }
	sink(x) // $ hasValueFlow="x" local-flow,local-taint=1
	x = "safe"
	sink(x) // $ local-flow,local-taint=0
}

func lazyInitCapturedClosureVar() {
	var f func()
	set := func() {
		if f == nil {
			y := "safe"
			g := func() { sink(y) } // $ hasValueFlow="y"
			y = source()
			f = g
		}
	}
	set()
	f()
}

func overwrittenLazyInitCapturedClosureVar() {
	var f func()
	set := func() {
		if f == nil {
			y := source()
			g := func() { sink(y) }
			y = "safe"
			f = g
		}
	}
	set()
	f()
}

func innerClosureEscapeWithLocalCall(cond bool) {
	var f func()
	set := func() {
		y := "safe"
		g := func() { sink(y) } // $ hasValueFlow="y"
		y = source()
		f = g
		if cond {
			y = "safe"
			f()
		}
	}
	set()
	f()
}

func overwrittenInnerClosureEscapeWithLocalCall(cond bool) {
	var f func()
	set := func() {
		y := source()
		g := func() { sink(y) }
		y = "safe"
		f = g
		if cond {
			f()
		}
	}
	set()
	f()
}

func (r receiver) directReceiver() string { // $ receiver-node,function-receiver,input-receiver,receiver-agreement=1
	return r.value
}

func (r receiver) unusedReceiver() {} // $ receiver-node,function-receiver,input-receiver,receiver-agreement=1

func callbackAny(f any) {
	if fn, ok := f.(func()); ok {
		fn()
	}
}

func deferredInterfaceReadAfterRegistration() {
	x := "safe"
	var f any = func() { sink(x) } // $ hasValueFlow="x"
	defer callbackAny(f)
	x = source()
}

func deferredInterfaceOverwriteAfterRegistration() {
	x := source()
	var f any = func() { sink(x) }
	defer callbackAny(f)
	x = "safe"
}

func deferredInterfaceArgumentEvaluatedEarly() {
	x := "safe"
	var f any = func() { sink(x) } // $ hasValueFlow="x"
	defer callbackAny(f)
	f = func() {}
	x = source()
}

func deferredInterfaceArgumentIsNotReevaluated() {
	x := source()
	var f any = func() {}
	defer callbackAny(f)
	f = func() { sink(x) }
}

func setViaAny(dst any, s string) {
	dst.(*receiver).value = s
}

func deferredNonClosureInterfacePostUpdate() {
	var dst any = &receiver{}
	defer func() { sink(dst.(*receiver).value) }() // $ hasValueFlow="selection of value"
	defer setViaAny(dst, source())
}

func deferredParenthesizedClosure() {
	x := "safe"
	f := func() { sink(x) } // $ hasValueFlow="x"
	defer (f)()
	x = source()
}

func deferredParenthesizedCallback() {
	x := "safe"
	g := func() { sink(x) } // $ hasValueFlow="x"
	defer callback((g))
	x = source()
}

func deferredParenthesizedReceiver() {
	x := "safe"
	h := runnableFunc((func() { sink(x) })) // $ hasValueFlow="x"
	defer (h).run()
	x = source()
}
