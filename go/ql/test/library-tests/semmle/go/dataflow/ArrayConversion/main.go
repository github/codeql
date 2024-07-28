package main

func source() string {
	return "untrusted data"
}

func sink(any) {
}

func sliceToArray(p []string) [1]string {
	return [1]string(p)
}

func main() {
	// Test the new slice->array conversion permitted in Go 1.20
	var a [4]string
	a[0] = source()
	alias := [2]string(a[:])
	sink(alias[0]) // $ hasValueFlow="index expression"
	sink(alias[1]) // $ SPURIOUS: hasValueFlow="index expression" // we don't distinguish different elements of arrays or slices
	sink(alias)    // $ hasTaintFlow="alias"

	// Compare with the standard dataflow support for arrays
	var b [4]string
	b[0] = source()
	sink(b[0]) // $ hasValueFlow="index expression"
	sink(b[1]) // $ SPURIOUS: hasValueFlow="index expression" // we don't distinguish different elements of arrays or slices
	sink(b)    // $ hasTaintFlow="b"
}
