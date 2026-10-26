package main

import "unsafe"

func TaintStepTest_UnsafeSlice(sourceCQL interface{}) interface{} {
	s := sourceCQL.(*byte)
	return unsafe.Slice(s, 1)
}

func TaintStepTest_UnsafeSliceData(sourceCQL interface{}) interface{} {
	s := sourceCQL.([]byte)
	return unsafe.SliceData(s)
}

func TaintStepTest_UnsafeString(sourceCQL interface{}) interface{} {
	s := sourceCQL.(*byte)
	return unsafe.String(s, 1)
}

func TaintStepTest_UnsafeStringData(sourceCQL interface{}) interface{} {
	s := sourceCQL.(string)
	return unsafe.StringData(s)
}

func RunAllTaints_Unsafe() {
	{
		source := newSource(0)
		out := TaintStepTest_UnsafeSlice(source)
		sink(0, out)
	}
	{
		source := newSource(1)
		out := TaintStepTest_UnsafeSliceData(source)
		sink(1, out)
	}
	{
		source := newSource(2)
		out := TaintStepTest_UnsafeString(source)
		sink(2, out)
	}
	{
		source := newSource(3)
		out := TaintStepTest_UnsafeStringData(source)
		sink(3, out)
	}
}
