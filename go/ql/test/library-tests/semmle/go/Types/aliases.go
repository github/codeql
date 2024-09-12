package main

type aliasesX = int
type aliasesY = int

type aliasesS1 = struct{ x aliasesX }

type aliasesS2 = struct{ x aliasesY }

func F(Afs1 aliasesS1) int {
	return G(Afs1) + Afs1.x
}

func G(Afs2 aliasesS2) int {
	return Afs2.x
}

// This is a named type, not an alias
type S3 struct{ x int }

// This is a type alias
type T = S3

// We expect `Afs3` to be of type `S3` here, not `struct{ x int }`
func H(Afs3 T) int {
	return Afs3.x
}
