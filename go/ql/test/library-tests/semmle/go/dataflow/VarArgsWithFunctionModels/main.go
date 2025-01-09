package main

import (
	"github.com/nonexistent/test"
)

func source() string {
	return "untrusted data"
}

func sink(string) {
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
	sink(test.FunctionWithSliceParameter(sSlice))      // $ hasTaintFlow="call to FunctionWithSliceParameter" MISSING: hasValueFlow="call to FunctionWithSliceParameter"
	sink(test.FunctionWithVarArgsParameter(sSlice...)) // $ hasTaintFlow="call to FunctionWithVarArgsParameter" MISSING: hasValueFlow="call to FunctionWithVarArgsParameter"
	sink(test.FunctionWithVarArgsParameter(s0, s1))    // $ MISSING: hasValueFlow="call to FunctionWithVarArgsParameter"

	sliceOfStructs := []test.A{{Field: source()}}
	sink(sliceOfStructs[0].Field) // $ hasValueFlow="selection of Field"

	// The following tests all fail because FunctionModel doesn't interact with access paths
	a0 := test.A{Field: ""}
	a1 := test.A{Field: source()}
	aSlice := []test.A{a0, a1}
	sink(test.FunctionWithSliceOfStructsParameter(aSlice))      // $ MISSING: hasValueFlow="call to FunctionWithSliceOfStructsParameter"
	sink(test.FunctionWithVarArgsOfStructsParameter(aSlice...)) // $ MISSING: hasValueFlow="call to FunctionWithVarArgsOfStructsParameter"
	sink(test.FunctionWithVarArgsOfStructsParameter(a0, a1))    // $ MISSING: hasValueFlow="call to FunctionWithVarArgsOfStructsParameter"
}
