package main

import (
	"fmt"
	"unsafe"
)

func main() {}

func badArrays() {
	// A harmless piece of data:
	harmless := [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// The declared `leaking` contains data from `harmless`
	// plus the data from `secret`;
	// (notice we read more than the length of harmless)
	var leaking = (*[8 + 9]byte)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(string((*leaking)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
func badIndexExpr() {
	// A harmless piece of data:
	harmless := [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret.
	// NOTE: unsafe.Pointer(&harmless) != unsafe.Pointer(&harmless[2])
	// Even tough harmless and leaking have the same size,
	// the new variable `leaking` will contain data starting from
	// the address of the 3rd element of the `harmless` array,
	// and continue for 8 bytes, going out of the boundaries of
	// `harmless` and crossing into the memory occupied by `secret`.
	var leaking = (*[8]byte)(unsafe.Pointer(&harmless[2])) // BAD

	fmt.Println(string((*leaking)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
