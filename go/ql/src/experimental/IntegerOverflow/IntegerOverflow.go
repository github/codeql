package main

import "fmt"

func getSubSlice(buf []byte, start int, offset int) []byte {
	return buf[start : start+offset]
}

func main() {
	var s = make([]byte, 100)
	s2 := getSubSlice(s, 10, 9223372036854775807)
	fmt.Println("s2 = ", s2)
}
