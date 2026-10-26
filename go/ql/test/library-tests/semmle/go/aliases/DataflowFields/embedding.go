package test

import (
	"test.com/basename/pkg1"
	"test.com/basename/pkg2"
)

// Tests that dataflow behaves as expected when loads and stores from a field traverse embeddings that use different type names.

// pkg2.IntStruct is an alias for pkg1.IntStruct
// Note referring to symbols in different packages is necessary so that Go will assign the fields the same name as well as the same type--
// for example, if we defined two aliases here named 'IntStruct1' and 'IntStruct2' and embedded them into two types,
// the types would be non-identical due to having a field implicitly named IntStruct1 and IntStruct2 respectively,
// even though syntactically it could be addressed without mentioning the field name.

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
