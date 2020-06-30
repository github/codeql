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

	// Read before secret without overflowing to secret:
	var leaking = (*[8]byte)(unsafe.Pointer(&harmless)) // OK

	fmt.Println(string((*leaking)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
func good1() {
	// A harmless piece of data:
	harmless := uint(123)
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret:
	var leaking = (*int)(unsafe.Pointer(&harmless)) // TODO: is this really OK?

	fmt.Println(*leaking)

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}

func bad00() {
	// A harmless piece of data:
	harmless := [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we get the pointer to the first byte of harmless)
	var leaking = (*[8 + 9]byte)(unsafe.Pointer(&harmless[0])) // BAD

	fmt.Println(string((*leaking)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}

func bad0() {
	// A harmless piece of data:
	harmless := [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless)
	var leaking = (*[8 + 9]byte)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(string((*leaking)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}

type Harmless [8]byte

func bad1() {
	// A harmless piece of data:
	harmless := Harmless{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless)
	var leaking = (*[8 + 9]byte)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(string((*leaking)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
func bad2() {
	// A harmless piece of data:
	harmless := [8]string{"A", "A", "A", "A", "A", "A", "A", "A"}
	// Something secret:
	secret := [9]string{"s", "e", "n", "s", "i", "t", "i", "v", "e"}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless)
	var leaking = (*[8 + 9]string)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(*leaking)
	fmt.Println([17]string((*leaking)))

	// Avoid optimization:
	if secret[0] == "42" {
		fmt.Println("hello world")
	}
}
func bad3() {
	type harmlessType struct {
		Data [8]byte
	}
	// A harmless piece of data:
	harmless := harmlessType{
		Data: [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'},
	}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless)
	var leaking = (*[8 + 9]byte)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(string((*leaking)[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
func bad4() {
	type harmlessType struct {
		Data [8]byte
	}
	// A harmless piece of data:
	harmless := harmlessType{
		Data: [8]byte{'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'},
	}
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless)
	var leaking = (*[8 + 9]byte)(unsafe.Pointer(&harmless.Data)) // BAD

	fmt.Println(string(leaking[:]))

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
func bad5() {
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
	// The length of req is 8 bytes,
	// but we cast it to a longer array,
	// which means that when the resulting array
	// will be read, the read will also contain pieces of
	// data from `secret`.
	var buf [8 + 9]byte
	buf = *(*[8 + 9]byte)(req)
	return buf
}
func bad6() {
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
func bad7() {
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
func bad8() {
	// A harmless piece of data:
	harmless := int8(123)
	// Something secret:
	secret := [9]byte{'s', 'e', 'n', 's', 'i', 't', 'i', 'v', 'e'}

	// Read before secret, overflowing into secret
	// (notice we read more than the length of harmless);
	// the leaking data will contain some bits from `secret`.
	var leaking = (*int)(unsafe.Pointer(&harmless)) // BAD

	fmt.Println(*leaking)

	// Avoid optimization:
	if secret[0] == 123 {
		fmt.Println("hello world")
	}
}
