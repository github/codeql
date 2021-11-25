package main

import (
	"io"

	"github.com/nonexistent/test"
)

func use(args ...interface{}) {}

func main() {
	var arg interface{}
	var arg1 interface{}
	var array []interface{}
	var t *test.T
	var taint interface{}
	var taintSlice []interface{}

	taint = t.StepArgRes(arg)
	_, taint = t.StepArgRes1(arg)
	t.StepArgArg(arg, arg1)
	t.StepArgQual(arg)
	taint = t.StepQualRes()
	t.StepQualArg(arg)
	taint = test.StepArgResNoQual(arg)
	taintSlice = test.StepArgResContent(arg)
	taint = test.StepArgContentRes(array)

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

	use(arg, arg1, t, taint, taintSlice, src, src1)
}

func simpleflow() {
	var a test.A
	var b test.B
	var t *test.T

	src := a.Src1()

	taint1 := t.StepArgRes(src)
	b.Sink1(taint1) // $ hasTaintFlow="taint1"

	_, taint2 := t.StepArgRes1(src)
	b.Sink1(taint2) // $ hasTaintFlow="taint2"

	var taint3 interface{}
	t.StepArgArg(src, taint3)
	b.Sink1(taint3) // $ hasTaintFlow="taint3"

	var taint4 test.T
	taint4.StepArgQual(src)
	b.Sink1(taint4) // $ hasTaintFlow="taint4"

	taint5 := (src.(*test.T)).StepQualRes()
	b.Sink1(taint5) // $ hasTaintFlow="taint5"

	var taint6 interface{}
	(src.(*test.T)).StepQualArg(taint6)
	b.Sink1(taint6) // $ hasTaintFlow="taint6"

	taint7 := test.StepArgResNoQual(src)
	b.Sink1(taint7) // $ hasTaintFlow="taint7"

	taint8 := test.StepArgResContent(src)
	b.Sink1(taint8[0]) // $ hasTaintFlow="index expression"

	srcArray := []interface{}{nil, src}
	taint9 := test.StepArgContentRes(srcArray)
	b.Sink1(taint9) // $ hasTaintFlow="taint9"

	slice := make([]interface{}, 0)
	slice = append(slice, src)
	b.Sink1(slice[0]) // $ hasTaintFlow="index expression"
}
