package main

import (
	"github.com/nonexistent/test"
	"io"
)

func use(args ...interface{}) {}

func main() {
	var arg interface{}
	var arg1 interface{}
	var t *test.T
	var taint interface{}

	taint = t.StepArgRes(arg)
	_, taint = t.StepArgRes1(arg)
	t.StepArgArg(arg, arg1)
	t.StepArgQual(arg)
	taint = t.StepQualRes()
	t.StepQualArg(arg)
	taint = test.StepArgResNoQual(arg)
	taint = test.StepArgResContent(arg)
	taint = test.StepArgContentRes(arg)

	var src interface{}
	var src1 interface{}
	var a test.A
	var a1 test.A1

	src = a.Src1()
	src = a.Src2()
	src = a1.Src2()
	src, src1 = a.Src3()
	src, src1 = a1.Src3()
	a.SrcArg(arg)

	var b test.B

	b.Sink1(arg)
	b.SinkMethod().(io.Writer).Write(arg.([]byte))

	use(arg, arg1, t, taint, src, src1)
}

func simpleflow() {
	var a test.A
	var b test.B
	var t *test.T

	src := a.Src1()

	taint := t.StepArgRes(src)

	b.Sink1(taint) // $ hasTaintFlow="taint"
}

func simpleflow1() {
	var a test.A
	var b test.B

	src := a.Src1()

	taint := test.StepArgResContent(src)

	b.Sink1(taint[0]) // $ hasTaintFlow="index expression"
}

func contentflow() {
	var a test.A
	var b test.B

	src := a.Src1()

	slice := make([]interface{}, 0)
	slice = append(slice, src)

	b.Sink1(slice[0]) // $ hasTaintFlow="index expression"
}
