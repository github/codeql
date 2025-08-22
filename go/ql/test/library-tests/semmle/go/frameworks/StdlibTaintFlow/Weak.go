package main

import "weak"

func TaintStepTest_WeakMake_manual(sourceCQL interface{}) interface{} {
	fromStringPointer := sourceCQL.(*string)
	intoWeakPointer := weak.Make(fromStringPointer)
	return intoWeakPointer
}
func TaintStepTest_WeakValue_manual(sourceCQL interface{}) interface{} {
	fromWeakPointer := sourceCQL.(weak.Pointer[string])
	intoStringPointer := fromWeakPointer.Value()
	return intoStringPointer
}

func RunAllTaints_Weak() {
	{
		source := newSource(0)
		out := TaintStepTest_WeakMake_manual(source)
		sink(0, out)
	}
	{
		source := newSource(1)
		out := TaintStepTest_WeakValue_manual(source)
		sink(1, out)
	}
}
