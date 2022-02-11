package main

import (
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
	taintSlice = test.StepArgResArrayContent(arg)
	taint = test.StepArgArrayContentRes(array)
	taint = test.StepArgResCollectionContent(arg)
	taint = test.StepArgCollectionContentRes(array)
	taint = test.StepArgResMapKeyContent(arg)
	taint = test.StepArgMapKeyContentRes(array)
	taint = test.StepArgResMapValueContent(arg)
	taint = test.StepArgMapValueContentRes(array)

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
	arg.(test.B).SinkMethod()

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

	taint8 := test.StepArgResArrayContent(src)
	b.Sink1(taint8[0]) // $ hasTaintFlow="index expression"

	srcArray := []interface{}{nil, src}
	taint9 := test.StepArgArrayContentRes(srcArray)
	b.Sink1(taint9) // $ hasTaintFlow="taint9"

	taint10 := test.StepArgResCollectionContent(a.Src1()).(chan interface{})
	b.Sink1(test.GetElement(taint10)) // $ hasTaintFlow="call to GetElement"
	b.Sink1(<-taint10)                // $ hasTaintFlow="<-..."

	srcCollection := test.SetElement(a.Src1())
	taint11 := test.StepArgCollectionContentRes(srcCollection)
	b.Sink1(taint11) // $ hasTaintFlow="taint11"

	taint12 := test.StepArgResMapKeyContent(a.Src1()).(map[string]string)
	b.Sink1(test.GetMapKey(taint12)) // $ hasTaintFlow="call to GetMapKey"
	for k, _ := range taint12 {
		b.Sink1(k) // $ hasTaintFlow="k"
	}
	for k := range taint12 {
		b.Sink1(k) // $ hasTaintFlow="k"
	}

	srcMap13 := map[string]string{src.(string): ""}
	taint13 := test.StepArgMapKeyContentRes(srcMap13)
	b.Sink1(taint13) // $ hasTaintFlow="taint13"

	taint14 := test.StepArgResMapValueContent(src).(map[string]string)
	b.Sink1(taint14[""]) // $ hasTaintFlow="index expression"

	srcMap15 := map[string]string{"": src.(string)}
	taint15 := test.StepArgMapValueContentRes(srcMap15)
	b.Sink1(taint15) // $ hasTaintFlow="taint15"

	slice := make([]interface{}, 0)
	slice = append(slice, src)
	b.Sink1(slice[0]) // $ hasTaintFlow="index expression"

	ch := make(chan string)
	ch <- a.Src1().(string)
	taint16 := test.StepArgCollectionContentRes(ch)
	b.Sink1(taint16) // $ MISSING: hasTaintFlow="taint16" // currently fails due to lack of post-update nodes after send statements

	c1 := test.C{""}
	c1.Set(a.Src1().(string))
	b.Sink1(c1.F) // $ hasTaintFlow="selection of F"

	c2 := test.C{a.Src1().(string)}
	b.Sink1(c2.Get()) // $ hasTaintFlow="call to Get"

	c3 := test.C{""}
	c3.Set(a.Src1().(string))
	b.Sink1(c3.Get()) // $ hasTaintFlow="call to Get"

	c4 := test.C{""}
	c4.Set(a.Src1().(string))
	c4.Set("")
	b.Sink1(c4.Get()) // $ SPURIOUS: hasTaintFlow="call to Get" // because we currently don't clear content

	arg1 := src
	arg2 := src
	arg3 := src
	arg4 := src
	b.SinkManyArgs(arg1, arg2, arg3, arg4) // $ hasTaintFlow="arg1" hasTaintFlow="arg2" hasTaintFlow="arg3"
}
