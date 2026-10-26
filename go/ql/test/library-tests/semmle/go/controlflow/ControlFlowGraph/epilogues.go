package main

import "fmt"

// epiLogger has methods with both pointer and value receivers, used to check
// that the receiver and arguments of a deferred call are evaluated at the
// `defer` statement rather than in the function epilogue.
type epiLogger struct {
	prefix string
}

func (l *epiLogger) log(msg string, code int) {
	fmt.Println(l.prefix, msg, code)
}

func (l epiLogger) logValue(msg string) {
	fmt.Println(l.prefix, msg)
}

// epiRecover recovers from a panic. It is used as a deferred function so we can
// check that control flow returns to the result-read nodes and the normal exit
// node after recovering.
func epiRecover() {
	if r := recover(); r != nil {
		fmt.Println("recovered:", r)
	}
}

// epiPlain has no named result variable and a single `return` with a child
// expression.
func epiPlain(x int) int {
	return x * 2
}

// epiVoid has no named result variable and no `return` statement at all.
func epiVoid() {
	fmt.Println("void")
}

// epiNamedMixed has named result variables and a mix of a bare `return` (no
// child expressions) and a `return` with child expressions.
func epiNamedMixed(x int) (result int, err error) {
	if x < 0 {
		result = -x
		return
	}
	return x, nil
}

// epiNamedBareOnly has a named result variable and only a bare `return`.
func epiNamedBareOnly(x int) (n int) {
	n = x + 1
	return
}

// epiDeferReceiverArgs has a deferred call with a (pointer) receiver and
// arguments that are expressions, so we can check the receiver `l` and the
// arguments `"count"` and `len(items)` are evaluated at the `defer` statement.
func epiDeferReceiverArgs(l *epiLogger, items []int) {
	defer l.log("count", len(items))
	fmt.Println("processing", len(items))
}

// epiDeferValueReceiver has deferred calls with a value receiver and an
// address-of receiver, both with arguments evaluated at the `defer` statement.
func epiDeferValueReceiver(prefix string) {
	l := epiLogger{prefix: prefix}
	defer l.logValue("bye")
	defer (&l).log("ptr", 7)
	fmt.Println("body")
}

// epiDeferFuncLit has a deferred function literal with parameters, so we can
// check that the arguments `"done"` and `x+1` are evaluated at the `defer`
// statement and that control flow enters the function literal body when it is
// invoked at the function epilogue.
func epiDeferFuncLit(x int) {
	defer func(label string, n int) {
		fmt.Println(label, n)
	}("done", x+1)
	fmt.Println("body", x)
}

// epiRecoverNamed has a named result variable and a deferred closure containing
// `recover()`. After recovering on the panic path, control flow should return
// to the result-read nodes and the normal exit node.
func epiRecoverNamed(x int) (result int) {
	defer func() {
		if r := recover(); r != nil {
			result = -1
		}
	}()
	if x < 0 {
		panic("neg")
	}
	result = x * x
	return result
}

// epiRecoverNamedBare has named result variables, a deferred function
// containing `recover()`, and only bare `return` statements.
func epiRecoverNamedBare(x int) (ok bool, n int) {
	defer epiRecover()
	if x == 0 {
		return
	}
	n = x
	ok = true
	return
}

// epiRecoverUnnamed has no named result variables and a deferred function
// containing `recover()`; after recovering, control flow should reach the
// normal exit node directly (there are no result-read nodes).
func epiRecoverUnnamed() {
	defer epiRecover()
	panic("boom")
}
