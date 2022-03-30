package main

import (
	"fmt"
	"unsafe"
)

func main() {}

func good0() {
	// A harmless piece of data:
	harmless := [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret without overflowing to secret;
	// the new `target` variable contains only data
	// inside the bounds of `harmless`, without overflowing
	// into the memory occupied by `secret`.
	var target = (*[8]byte)(unsafe.Pointer(&harmless)) // OK

	fmt.Println(string((*target)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
