package test

import (
	"test.com/basename/pkg1"
	"test.com/basename/pkg2"
)

// pkg2.IntStruct is an alias for pkg1.IntStruct
// Note trickery with packages is necessary so that Go will assign the fields the same name as well as the same type.

type EmbedsPkg1IntStruct = struct{ pkg1.IntStruct }
type EmbedsPkg2IntStruct = struct{ pkg2.IntStruct }

func FEmbedded() {

	x := source()
	pkg1Struct := EmbedsPkg1IntStruct{pkg1.IntStruct{x}}

	GEmbedded(&pkg1Struct)

}

func GEmbedded(pkg2Struct *EmbedsPkg2IntStruct) {

	sink(pkg2Struct.Field) // $ hasValueFlow="selection of Field"

}
