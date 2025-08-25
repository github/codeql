package subpkg

import "fmt"

func F() {
	// It is required that there is an import in this package, which is import by another package using a local path
	fmt.Println("subpkg.F")
}
