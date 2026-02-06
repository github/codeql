package main

func source() string {
	return "untrusted data"
}

func sink(any) {
}

type A struct {
	f string
}

func functionWithSliceParameter(s []string) string {
	return s[1]
}

func functionWithVarArgsParameter(s ...string) string {
	return s[1]
}

func functionWithVarArgsOutParameter(in string, out ...*string) {
	*out[0] = in
}

func functionWithSliceOfStructsParameter(s []A) string {
	return s[1].f
}

func functionWithVarArgsOfStructsParameter(s ...A) string {
	return s[1].f
}

func main() {
	stringSlice := []string{source()}
	sink(stringSlice[0]) // $ hasValueFlow="index expression"

	s0 := ""
	s1 := source()
	sSlice := []string{s0, s1}
	sink(functionWithSliceParameter(sSlice))      // $ hasValueFlow="call to functionWithSliceParameter"
	sink(functionWithVarArgsParameter(sSlice...)) // $ hasValueFlow="call to functionWithVarArgsParameter"
	sink(functionWithVarArgsParameter(s0, s1))    // $ hasValueFlow="call to functionWithVarArgsParameter"

	var out1 *string
	var out2 *string
	functionWithVarArgsOutParameter(source(), out1, out2)
	sink(out1) // $ MISSING: hasValueFlow="out1"
	sink(out2) // $ MISSING: hasValueFlow="out2"

	sliceOfStructs := []A{{f: source()}}
	sink(sliceOfStructs[0].f) // $ hasValueFlow="selection of f"

	a0 := A{f: ""}
	a1 := A{f: source()}
	aSlice := []A{a0, a1}
	sink(functionWithSliceOfStructsParameter(aSlice))      // $ hasValueFlow="call to functionWithSliceOfStructsParameter"
	sink(functionWithVarArgsOfStructsParameter(aSlice...)) // $ hasValueFlow="call to functionWithVarArgsOfStructsParameter"
	sink(functionWithVarArgsOfStructsParameter(a0, a1))    // $ hasValueFlow="call to functionWithVarArgsOfStructsParameter"
}
