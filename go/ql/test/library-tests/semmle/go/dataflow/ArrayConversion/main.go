package main

func source() string {
	return "untrusted data"
}

func sink(string) {
}

func sliceToArray(p []string) [1]string {
	return [1]string(p)
}

func main() {
	// Test the new slice->array conversion permitted in Go 1.20
	var a [4]string
	a[0] = source()
	alias := sliceToArray(a[:])
	sink(alias[0]) // $ taintflow

	// Compare with the standard dataflow support for arrays
	var b [4]string
	b[0] = source()
	sink(b[0]) // $ taintflow
}
