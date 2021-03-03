package main

func source() string {
	return "untrusted data"
}

func sink(string) {
}

type A struct {
	f string
}

func functionWithVarArgsOfStructsParameter(s ...A) {
	sink(s[0].f) // $ MISSING: taintflow dataflow
}

func main() {
	stringSlice := []string{source()}
	sink(stringSlice[0]) // $ taintflow MISSING: dataflow

	arrayOfStructs := []A{{f: source()}}
	sink(arrayOfStructs[0].f) // $ MISSING: taintflow dataflow

	a := A{f: source()}
	functionWithVarArgsOfStructsParameter(a)
}
