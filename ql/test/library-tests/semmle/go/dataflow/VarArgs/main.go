package main

func source() string {
	return "untrusted data"
}

func sink(string) {
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

func functionWithSliceOfStructsParameter(s []A) string {
	return s[1].f
}

func functionWithVarArgsOfStructsParameter(s ...A) string {
	return s[1].f
}

func main() {
	stringSlice := []string{source()}
	sink(stringSlice[0]) // $ taintflow dataflow

	s0 := ""
	s1 := source()
	sSlice := []string{s0, s1}
	sink(functionWithSliceParameter(sSlice))      // $ taintflow dataflow
	sink(functionWithVarArgsParameter(sSlice...)) // $ taintflow dataflow
	sink(functionWithVarArgsParameter(s0, s1))    // $ MISSING: taintflow dataflow

	sliceOfStructs := []A{{f: source()}}
	sink(sliceOfStructs[0].f) // $ taintflow dataflow

	a0 := A{f: ""}
	a1 := A{f: source()}
	aSlice := []A{a0, a1}
	sink(functionWithSliceOfStructsParameter(aSlice))      // $ taintflow dataflow
	sink(functionWithVarArgsOfStructsParameter(aSlice...)) // $ taintflow dataflow
	sink(functionWithVarArgsOfStructsParameter(a0, a1))    // $ MISSING: taintflow dataflow
}
