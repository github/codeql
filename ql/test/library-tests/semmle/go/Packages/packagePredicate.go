package main

import (
	"fmt"

	_ "PackageName//v//test"      // Not OK
	_ "PackageName//v/test"       // Not OK
	_ "PackageName/test"          // OK
	_ "PackageName/v//test"       // Not OK
	_ "PackageName/v/asd/v2/test" // Not OK
	_ "PackageName/v/test"        // Not OK

	_ "PackageName//v2//test" // Not OK
	_ "PackageName//v2/test"  // Not OK
	_ "PackageName/v2//test"  // Not OK
	_ "PackageName/v2/test"   //OK
)

func main() {
	pkg.Foo()
	fmt.Println("")
}
