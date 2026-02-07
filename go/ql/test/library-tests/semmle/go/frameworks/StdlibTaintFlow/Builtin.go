package main

// Also tested in go/ql/test/library-tests/semmle/go/dataflow/ExternalValueFlow
// and go/ql/test/library-tests/semmle/go/dataflow/ExternalTaintFlow.

func TaintStepTest_Append1(sourceCQL interface{}) interface{} {
	from := sourceCQL.([]byte)
	var intoInterface interface{}
	intoInterface = append(from, "a string"...)
	return intoInterface
}

func TaintStepTest_Append2(sourceCQL interface{}) interface{} {
	from := sourceCQL.(int)
	slice := []int{from}
	var intoInterface []int
	intoInterface = append(slice, 0)
	return intoInterface[0]
}

func TaintStepTest_Append3(sourceCQL interface{}) interface{} {
	from := sourceCQL.(string)
	var intoInterface interface{}
	intoInterface = append([]byte{}, from...)
	return intoInterface
}

func TaintStepTest_Append4(sourceCQL interface{}) interface{} {
	from := sourceCQL.(int)
	var intoInterface []int
	intoInterface = append([]int{}, 0, from, 1)
	return intoInterface[0]
}

func TaintStepTest_Copy1(sourceCQL interface{}) interface{} {
	from := sourceCQL.(string)
	var intoInterface []byte
	copy(intoInterface, from)
	return intoInterface
}

func TaintStepTest_Copy2(sourceCQL interface{}) interface{} {
	from := []int{sourceCQL.(int)}
	var intoInterface []int
	copy(intoInterface, from)
	return intoInterface[0]
}

func TaintStepTest_Max(sourceCQL interface{}) interface{} {
	from := sourceCQL.(int)
	var intoInterface int
	intoInterface = max(0, 1, from, 2, 3)
	return intoInterface
}

func TaintStepTest_Min(sourceCQL interface{}) interface{} {
	from := sourceCQL.(int)
	var intoInterface int
	intoInterface = min(0, 1, from, 2, 3)
	return intoInterface
}

func TaintStepTest_New(sourceCQL interface{}) interface{} {
	from := sourceCQL.(int)
	var intoInterface *int
	intoInterface = new(from)
	return *intoInterface
}

func RunAllTaints_Builtin() {
	{
		source := newSource(0)
		out := TaintStepTest_Append1(source)
		sink(0, out)
	}
	{
		source := newSource(1)
		out := TaintStepTest_Append2(source)
		sink(1, out)
	}
	{
		source := newSource(2)
		out := TaintStepTest_Append3(source)
		sink(2, out)
	}
	{
		source := newSource(3)
		out := TaintStepTest_Append4(source)
		sink(3, out)
	}
	{
		source := newSource(4)
		out := TaintStepTest_Copy1(source)
		sink(4, out)
	}
	{
		source := newSource(5)
		out := TaintStepTest_Copy2(source)
		sink(5, out)
	}
	{
		source := newSource(3)
		out := TaintStepTest_Max(source)
		sink(3, out)
	}
	{
		source := newSource(4)
		out := TaintStepTest_Min(source)
		sink(4, out)
	}
	{
		source := newSource(5)
		out := TaintStepTest_New(source)
		sink(5, out)
	}
}
