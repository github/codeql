package main

import "fmt"

// analysis does not detect calls to this function as constant (yet)
func nonconst() int {
	return 0
}

func main() {
	exp := 3
	expectingResponse := 1 << 5
	power := 10

	fmt.Println(3 ^ 5)                   // Not OK
	fmt.Println(0755 ^ 2423)             // OK
	fmt.Println(2 ^ 32)                  // Not OK
	fmt.Println(10 ^ 5)                  // Not OK
	fmt.Println(10 ^ exp)                // Not OK
	fmt.Println(253 ^ expectingResponse) // OK
	fmt.Println(2 ^ power)               // Not OK

	mask := (((1 << 10) - 1) ^ 7) // OK

	// This is not ok, but isn't detected because the multiplication binds tighter
	// than the xor operator and so the query doesn't see a constant on the left
	// hand side of ^.
	fmt.Println(nonconst()*10 ^ 9)

	fmt.Println(mask)
}
