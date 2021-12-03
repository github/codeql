package main

import (
	"fmt"

	"github.com/nonexistent-test-pkg"
	_ "github.com/nonexistent/test"
	_ "github.com/nonexistent/v2/test"
)

func main() {
	pkg.Foo()
	fmt.Println("")
}
