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
	t.StepArgArgIgnored(arg, arg1)
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
	b.Sink1(taint1) // $ hasValueFlow="taint1"

	_, taint2 := t.StepArgRes1(src)
	b.Sink1(taint2) // $ hasValueFlow="taint2"

	var taint3 interface{}
	t.StepArgArg(src, taint3)
	b.Sink1(taint3) // $ hasValueFlow="taint3"

	var taint3ignored interface{}
	t.StepArgArgIgnored(src, taint3ignored)
	b.Sink1(taint3ignored)

	var taint4 test.T
	taint4.StepArgQual(src)
	b.Sink1(taint4) // $ hasValueFlow="taint4"

	taint5 := (src.(*test.T)).StepQualRes()
	b.Sink1(taint5) // $ hasValueFlow="taint5"

	var taint6 interface{}
	(src.(*test.T)).StepQualArg(taint6)
	b.Sink1(taint6) // $ hasValueFlow="taint6"

	taint7 := test.StepArgResNoQual(src)
	b.Sink1(taint7) // $ hasValueFlow="taint7"

	taint8 := test.StepArgResArrayContent(src)
	b.Sink1(taint8[0]) // $ hasValueFlow="index expression"
	for _, x := range taint8 {
		b.Sink1(x) // $ hasValueFlow="x"
	}
	for _, x := range arraytype(taint8) {
		b.Sink1(x) // $ hasValueFlow="x"
	}

	srcArray := []interface{}{nil, src}
	taint9 := test.StepArgArrayContentRes(srcArray)
	b.Sink1(taint9) // $ hasValueFlow="taint9"

	taint10 := test.StepArgResCollectionContent(a.Src1()).(chan interface{})
	b.Sink1(test.GetElement(taint10)) // $ hasValueFlow="call to GetElement"
	b.Sink1(<-taint10)                // $ hasValueFlow="<-..."
	for e := range taint10 {
		b.Sink1(e) // $ MISSING: hasValueFlow="e"
	}
	for e := range channeltype(taint10) {
		b.Sink1(e) // $ MISSING: hasValueFlow="e"
	}

	srcCollection := test.SetElement(a.Src1())
	taint11 := test.StepArgCollectionContentRes(srcCollection)
	b.Sink1(taint11) // $ hasValueFlow="taint11"

	taint12 := test.StepArgResMapKeyContent(a.Src1()).(map[string]string)
	b.Sink1(test.GetMapKey(taint12)) // $ hasValueFlow="call to GetMapKey"
	for k, _ := range taint12 {
		b.Sink1(k) // $ hasValueFlow="k"
	}
	for k := range taint12 {
		b.Sink1(k) // $ hasValueFlow="k"
	}
	for k, _ := range mapstringstringtype(taint12) {
		b.Sink1(k) // $ hasValueFlow="k"
	}
	for k := range mapstringstringtype(taint12) {
		b.Sink1(k) // $ hasValueFlow="k"
	}

	srcMap13 := map[string]string{src.(string): ""}
	taint13 := test.StepArgMapKeyContentRes(srcMap13)
	b.Sink1(taint13) // $ hasValueFlow="taint13"

	taint14 := test.StepArgResMapValueContent(src).(map[string]string)
	b.Sink1(taint14[""]) // $ hasValueFlow="index expression"
	for _, v := range taint14 {
		b.Sink1(v) // $ hasValueFlow="v"
	}
	for _, v := range mapstringstringtype(taint14) {
		b.Sink1(v) // $ hasValueFlow="v"
	}

	srcMap15 := map[string]string{"": src.(string)}
	taint15 := test.StepArgMapValueContentRes(srcMap15)
	b.Sink1(taint15) // $ hasValueFlow="taint15"

	slice := make([]interface{}, 0)
	slice = append(slice, src)
	b.Sink1(slice[0]) // $ hasValueFlow="index expression"

	slice1 := make([]string, 2)
	slice1[0] = src.(string)
	slice2 := make([]string, 2)
	copy(slice2, slice1)
	b.Sink1(slice2[0]) // $ hasValueFlow="index expression"

	ch := make(chan string)
	ch <- a.Src1().(string)
	taint16 := test.StepArgCollectionContentRes(ch)
	b.Sink1(taint16) // $ MISSING: hasValueFlow="taint16" // currently fails due to lack of post-update nodes after send statements

	c1 := test.C{""}
	c1.Set(a.Src1().(string))
	b.Sink1(c1.F) // $ hasValueFlow="selection of F"

	c2 := test.C{a.Src1().(string)}
	b.Sink1(c2.Get()) // $ hasValueFlow="call to Get"

	c3 := test.C{""}
	c3.Set(a.Src1().(string))
	b.Sink1(c3.Get()) // $ hasValueFlow="call to Get"

	c4 := test.C{""}
	c4.Set(a.Src1().(string))
	c4.Set("")
	b.Sink1(c4.Get()) // $ SPURIOUS: hasValueFlow="call to Get" // because we currently don't clear content

	cp1 := &test.C{""}
	cp1.SetThroughPointer(a.Src1().(string))
	b.Sink1(cp1.F) // $ hasValueFlow="selection of F"

	cp2 := &test.C{a.Src1().(string)}
	b.Sink1(cp2.GetThroughPointer()) // $ hasValueFlow="call to GetThroughPointer"

	cp3 := &test.C{""}
	cp3.SetThroughPointer(a.Src1().(string))
	b.Sink1(cp3.GetThroughPointer()) // $ hasValueFlow="call to GetThroughPointer"

	cp4 := &test.C{""}
	cp4.SetThroughPointer(a.Src1().(string))
	cp4.SetThroughPointer("")
	b.Sink1(cp4.GetThroughPointer()) // $ SPURIOUS: hasValueFlow="call to GetThroughPointer" // because we currently don't clear content

	arg1 := src
	arg2 := src
	arg3 := src
	arg4 := src
	b.SinkManyArgs(arg1, arg2, arg3, arg4) // $ hasValueFlow="arg1" hasValueFlow="arg2" hasValueFlow="arg3"

	var srcInt int = src.(int)
	b.Sink1(max(srcInt, 0, 1)) // $ hasValueFlow="call to max"
	b.Sink1(max(0, srcInt, 1)) // $ hasValueFlow="call to max"
	b.Sink1(max(0, 1, srcInt)) // $ hasValueFlow="call to max"
	b.Sink1(min(srcInt, 0, 1)) // $ hasValueFlow="call to min"
	b.Sink1(min(0, srcInt, 1)) // $ hasValueFlow="call to min"
	b.Sink1(min(0, 1, srcInt)) // $ hasValueFlow="call to min"
}

type mapstringstringtype map[string]string
type arraytype []interface{}
type channeltype chan interface{}
