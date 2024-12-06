package main

import "github.com/github/codeql-go/ql/test/library-tests/semmle/go/Types/pkg1"

// IMPORTANT: Make sure that *pkg1.SEmbedP is not referenced.

func testS(t pkg1.S) {
	_ = t.SMethod()
	_ = t.SField
}

func testP(t pkg1.P) {
	_ = t.PMethod()
	_ = t.PField
}

func testSEmbedS(t pkg1.SEmbedS) {
	_ = t.SMethod()
	_ = t.SField
}

func testSEmbedP(t pkg1.SEmbedP) {
	_ = t.PMethod()
	_ = t.PField
}
