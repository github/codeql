package main

//go:generate depstubber -vendor github.com/evanphx/json-patch/v5 Patch MergePatch,MergeMergePatches,CreateMergePatch,DecodePatch

import patch "github.com/evanphx/json-patch/v5"

func getTaintedByteArray() []byte {
	return make([]byte, 1)
}

func getTaintedPatch() patch.Patch {
	var patch patch.Patch
	return patch
}

func sinkByteArray([]byte) {
}

func sinkPatch(patch.Patch) {
}

func main() {
	untaintedByteArray := make([]byte, 1)
	var untaintedPatch patch.Patch

	// func MergeMergePatches(patch1Data, patch2Data []byte) ([]byte, error)
	b1, _ := patch.MergeMergePatches(getTaintedByteArray(), untaintedByteArray)
	sinkByteArray(b1) // $ hasTaintFlow="b1"

	b2, _ := patch.MergeMergePatches(untaintedByteArray, getTaintedByteArray())
	sinkByteArray(b2) // $ hasTaintFlow="b2"

	// func MergePatch(docData, patchData []byte) ([]byte, error)
	b3, _ := patch.MergePatch(getTaintedByteArray(), untaintedByteArray)
	sinkByteArray(b3) // $ hasTaintFlow="b3"

	b4, _ := patch.MergePatch(untaintedByteArray, getTaintedByteArray())
	sinkByteArray(b4) // $ hasTaintFlow="b4"

	// func CreateMergePatch(originalJSON, modifiedJSON []byte) ([]byte, error)
	b5, _ := patch.CreateMergePatch(getTaintedByteArray(), untaintedByteArray)
	sinkByteArray(b5) // $ hasTaintFlow="b5"

	b6, _ := patch.CreateMergePatch(untaintedByteArray, getTaintedByteArray())
	sinkByteArray(b6) // $ hasTaintFlow="b6"

	// func DecodePatch(buf []byte) (Patch, error)
	p7, _ := patch.DecodePatch(getTaintedByteArray())
	sinkPatch(p7) // $ hasTaintFlow="p7"

	// func (p Patch) Apply(doc []byte) ([]byte, error)
	b8, _ := untaintedPatch.Apply(getTaintedByteArray())
	sinkByteArray(b8) // $ hasTaintFlow="b8"

	b9, _ := getTaintedPatch().Apply(untaintedByteArray)
	sinkByteArray(b9) // $ hasTaintFlow="b9"

	// func (p Patch) ApplyIndent(doc []byte, indent string) ([]byte, error)
	b10, _ := untaintedPatch.ApplyIndent(getTaintedByteArray(), "  ")
	sinkByteArray(b10) // $ hasTaintFlow="b10"

	b11, _ := getTaintedPatch().ApplyIndent(untaintedByteArray, "  ")
	sinkByteArray(b11) // $ hasTaintFlow="b11"

	// func (p Patch) ApplyWithOptions(doc []byte, options *ApplyOptions) ([]byte, error)
	b12, _ := untaintedPatch.ApplyWithOptions(getTaintedByteArray(), nil)
	sinkByteArray(b12) // $ hasTaintFlow="b12"

	b13, _ := getTaintedPatch().ApplyWithOptions(untaintedByteArray, nil)
	sinkByteArray(b13) // $ hasTaintFlow="b13"

	// func (p Patch) ApplyIndentWithOptions(doc []byte, indent string, options *ApplyOptions) ([]byte, error)
	b14, _ := untaintedPatch.ApplyIndentWithOptions(getTaintedByteArray(), "  ", nil)
	sinkByteArray(b14) // $ hasTaintFlow="b14"

	b15, _ := getTaintedPatch().ApplyIndentWithOptions(untaintedByteArray, "  ", nil)
	sinkByteArray(b15) // $ hasTaintFlow="b15"
}
