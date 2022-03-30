package main

import (
	_ "embed"
	"fmt"
)

//go:embed file
var e string = "hi"

func main() {
	fmt.Println(e)
	e = "why"
	fmt.Println(e)
}
