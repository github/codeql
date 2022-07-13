package main

import "unsafe"

func use(_ ...interface{}) {}

func main() {
	var a unsafe.Pointer

	b := unsafe.Add(a, 10)
	use(b)

	var arr *int
	slice := unsafe.Slice(arr, 20)

	// may panic
	ptr := (*[10]int)(slice)
	use(ptr)

	// cannot panic
	str := "a string"
	bytes := []byte(str)
	use(bytes)
	runes := []rune(str)
	use(runes)
}
