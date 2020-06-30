package main

import (
	"fmt"
	"unsafe"
)

func main() {}

func bad0() {
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
func bad1() {
	// A harmless piece of data:
	harmless := [8]string{"A", "A", "A", "A", "A", "A", "A", "A"}
	// Something secret:
	secret := [9]string{"s", "e", "n", "s", "i", "t", "i", "v", "e"}

	// The declared `leaking` contains data from `harmless`
	// plus the data from `secret`;
	// (notice we read more than the length of harmless)
	var leaking = (*[8 + 9]string)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(*leaking)
	fmt.Println([17]string((*leaking)))

	// Avoid optimization:
	if secret[0] == "42" {
		fmt.Println("hello world")
	}
}

func bad2() {
	// A harmless piece of data:
	harmless := [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret:
	var leaking = buffer_request(unsafe.Pointer(&harmless)) // BAD (see inside buffer_request func)

	fmt.Println((string)(leaking[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
func buffer_request(req unsafe.Pointer) [8 + 9]byte {
	// The length of req is 8 bytes (see origin in above function),
	// but we cast it to a longer array,
	// which means that when the resulting array
	// will be read, the read will also contain pieces of
	// data from anything occupying memory after the target
	// (namely, memory occupied by`secret`).
	var buf [8 + 9]byte
	buf = *(*[8 + 9]byte)(req)
	return buf
}

func bad3() {
	// A harmless piece of data:
	harmless := [1]int64{23}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless);
	// the leaking array will not contain letters,
	// but integers representing bytes from `secret`.
	var leaking = (*[4]int64)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(*leaking)

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
func bad4() {
	// A harmless piece of data:
	harmless := int8(123)
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless);
	// the leaking data will contain some bits from `secret`.
	var leaking = (*int64)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(*leaking)

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
