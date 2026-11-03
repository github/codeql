package main

// Field-write target variations for go/useless-assignment-to-field, exercising
// the FieldTarget write target with different selector-expression shapes.

type wtInner struct {
	a int
	b int
}

type wtEmbed struct {
	wtInner
	c int
}

// direct field write on a value copy (dead)
func wtDirect(v wtInner) {
	v.a = 0 // $ Alert
}

// non-embedded field write on a value copy (dead)
func wtOwnField(v wtEmbed) {
	v.c = 0 // $ Alert
}

// The query only reports direct `v.f` writes, so writes whose base is itself a
// field access are not flagged, even though they are also dead.

// explicitly-qualified embedded field write on a value copy (not flagged)
func wtNested(v wtEmbed) {
	v.wtInner.b = 0 // OK
}

// promoted (value-embedded) field write on a value copy (not flagged)
func wtPromoted(v wtEmbed) {
	v.a = 0 // OK
}
