package pkg1

import (
	"fmt"

	"github.com/github/codeql-go/extractor/dbscheme"
	"github.com/github/codeql-go/extractor/trap"
	"golang.org/x/tools/go/packages"
)

func usePkgs() {
	fmt.Println(packages.NeedImports)
	fmt.Println(dbscheme.LabelObjectType.Index())
	var lbl trap.Label
	fmt.Println(lbl)
}
