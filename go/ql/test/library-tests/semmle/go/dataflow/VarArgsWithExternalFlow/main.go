package main

import (
	"github.com/nonexistent/test"
)

func source() string {
	return "untrusted data"
}

func sink(any) {
}

func main() {
	s := source()
	sink(test.FunctionWithParameter(s)) // $ hasValueFlow="call to FunctionWithParameter"

	stringSlice := []string{source()}
	sink(stringSlice[0]) // $ hasValueFlow="index expression"

	s0 := ""
	s1 := source()
	sSlice := []string{s0, s1}
	sink(test.FunctionWithParameter(sSlice[1]))        // $ hasValueFlow="call to FunctionWithParameter"
	sink(test.FunctionWithSliceParameter(sSlice))      // $ hasValueFlow="call to FunctionWithSliceParameter"
	sink(test.FunctionWithVarArgsParameter(sSlice...)) // $ hasValueFlow="call to FunctionWithVarArgsParameter"
	sink(test.FunctionWithVarArgsParameter(s0, s1))    // $ hasValueFlow="call to FunctionWithVarArgsParameter"

	var out1 *string
	var out2 *string
	test.FunctionWithVarArgsOutParameter(source(), out1, out2)
	sink(out1) // $ hasValueFlow="out1"
	sink(out2) // $ hasValueFlow="out2"

	sliceOfStructs := []test.A{{Field: source()}}
	sink(sliceOfStructs[0].Field) // $ hasValueFlow="selection of Field"

	a0 := test.A{Field: ""}
	a1 := test.A{Field: source()}
	aSlice := []test.A{a0, a1}
	sink(test.FunctionWithSliceOfStructsParameter(aSlice))      // $ hasValueFlow="call to FunctionWithSliceOfStructsParameter"
	sink(test.FunctionWithVarArgsOfStructsParameter(aSlice...)) // $ hasValueFlow="call to FunctionWithVarArgsOfStructsParameter"
	sink(test.FunctionWithVarArgsOfStructsParameter(a0, a1))    // $ hasValueFlow="call to FunctionWithVarArgsOfStructsParameter"

	var variadicSource string
	test.VariadicSource(&variadicSource)
	sink(variadicSource) // $ MISSING: hasTaintFlow="variadicSource"

	test.VariadicSink(source()) // $ hasTaintFlow="[]type{args}"

}
