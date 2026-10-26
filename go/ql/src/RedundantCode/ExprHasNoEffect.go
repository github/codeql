package main

import "fmt"

type Timestamp int

func (t Timestamp) addDays(d int) Timestamp {
	return Timestamp(int(t) + d*24*3600)
}

func test(t Timestamp) {
	fmt.Printf("Before: %s\n", t)
	t.addDays(7)
	fmt.Printf("After: %s\n", t)
}
