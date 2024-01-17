package main

func source() string {
	return "untrusted data"
}

func sink(any) {
}

func main() {
}

// Value flow with array content through slice expressions

func arrayBase(base [4]string) {
	base[1] = source()
	slice := base[1:4]
	sink(slice[0]) // $ hasValueFlow="index expression"
	sink(slice[1]) // $ SPURIOUS: hasValueFlow="index expression" // we don't distinguish different elements of arrays or slices
	sink(slice)    // $ hasTaintFlow="slice"
}

func arrayPointerBase(base *[4]string) {
	base[1] = source()
	slice := base[1:4]
	sink(slice[0]) // $ hasValueFlow="index expression"
	sink(slice[1]) // $ SPURIOUS: hasValueFlow="index expression" // we don't distinguish different elements of arrays or slices
	sink(slice)    // $ hasTaintFlow="slice"
}

func sliceBase(base []string) {
	base[1] = source()
	slice := base[1:4]
	sink(slice[0]) // $ hasValueFlow="index expression"
	sink(slice[1]) // $ SPURIOUS: hasValueFlow="index expression" // we don't distinguish different elements of arrays or slices
	sink(slice)    // $ hasTaintFlow="slice"
}

func slicePointerBase(base *[]string) {
	(*base)[1] = source()
	slice := (*base)[1:4]
	sink(slice[0]) // $ hasValueFlow="index expression"
	sink(slice[1]) // $ SPURIOUS: hasValueFlow="index expression" // we don't distinguish different elements of arrays or slices
	sink(slice)    // $ hasTaintFlow="slice"
}
