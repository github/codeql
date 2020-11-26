package main

//go:generate depstubber -vendor github.com/evanphx/json-patch/v5 Patch MergePatch,MergeMergePatches,CreateMergePatch,DecodePatch

import patch "github.com/evanphx/json-patch/v5"

func getTaintedByteArray() []byte {
	return make([]byte, 1, 1)
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
	untaintedByteArray := make([]byte, 1, 1)
	var untaintedPatch patch.Patch

	// func MergeMergePatches(patch1Data, patch2Data []byte) ([]byte, error)
	b1, _ := patch.MergeMergePatches(getTaintedByteArray(), untaintedByteArray)
	sinkByteArray(b1)

	b2, _ := patch.MergeMergePatches(untaintedByteArray, getTaintedByteArray())
	sinkByteArray(b2)

	// func MergePatch(docData, patchData []byte) ([]byte, error)
	b3, _ := patch.MergePatch(getTaintedByteArray(), untaintedByteArray)
	sinkByteArray(b3)

	b4, _ := patch.MergePatch(untaintedByteArray, getTaintedByteArray())
	sinkByteArray(b4)

	// func CreateMergePatch(originalJSON, modifiedJSON []byte) ([]byte, error)
	b5, _ := patch.CreateMergePatch(getTaintedByteArray(), untaintedByteArray)
	sinkByteArray(b5)

	b6, _ := patch.CreateMergePatch(untaintedByteArray, getTaintedByteArray())
	sinkByteArray(b6)

	// func DecodePatch(buf []byte) (Patch, error)
	p7, _ := patch.DecodePatch(getTaintedByteArray())
	sinkPatch(p7)

	// func (p Patch) Apply(doc []byte) ([]byte, error)
	b8, _ := untaintedPatch.Apply(getTaintedByteArray())
	sinkByteArray(b8)

	b9, _ := getTaintedPatch().Apply(untaintedByteArray)
	sinkByteArray(b9)

	// func (p Patch) ApplyIndent(doc []byte, indent string) ([]byte, error)
	b10, _ := untaintedPatch.ApplyIndent(getTaintedByteArray(), "  ")
	sinkByteArray(b10)

	b11, _ := getTaintedPatch().ApplyIndent(untaintedByteArray, "  ")
	sinkByteArray(b11)
}
