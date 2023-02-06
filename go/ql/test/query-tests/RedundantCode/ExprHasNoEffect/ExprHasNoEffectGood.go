package main

import "fmt"

func testGood(t Timestamp) {
	fmt.Printf("Before: %s\n", t)
	t = t.addDays(7)
	fmt.Printf("After: %s\n", t)
}
