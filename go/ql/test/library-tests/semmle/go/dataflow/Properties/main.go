package main

import "fmt"

func test(b bool) {
	fmt.Println(b == true)
	fmt.Println(false == b)
	fmt.Println(b != true)
	fmt.Println(b != false)
}

func test2(s interface{}) {
	fmt.Println(s == nil)
	fmt.Println(s != nil)
}

func main() {}
