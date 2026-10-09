package main

import "math/big"

func TaintStepTest_MathBigIntFloat64(sourceCQL interface{}) interface{} {
	out, _ := sourceCQL.(*big.Int).Float64()
	return out
}

func RunAllTaints_MathBig() {
	source := newSource(0)
	out := TaintStepTest_MathBigIntFloat64(source)
	sink(0, out)
}
