package main

import (
	"github.com/nonexistent/test"
)

func TestFieldsS1(t test.S1) {
	a := t.SourceField
	t.SinkField = a // $ S1[f] S1[t] ql_S1
}

func TestFieldsSEmbedI1(t test.SEmbedI1) {
	a := t.SourceField
	t.SinkField = a // $ SEmbedI1[t]
}

func TestFieldsSImplEmbedI1(t test.SImplEmbedI1) {
	a := t.SourceField
	t.SinkField = a // $ SImplEmbedI1[t]
}

func TestFieldsSEmbedS1(t test.SEmbedS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] SEmbedS1[t] ql_S1
}

func TestFieldsSImplEmbedS1(t test.SImplEmbedS1) {
	a := t.SourceField
	t.SinkField = a // $ SImplEmbedS1[t]
}

func TestFieldsSEmbedSEmbedI1(t test.SEmbedSEmbedI1) {
	a := t.SourceField
	t.SinkField = a
}

func TestFieldsSEmbedSEmbedS1(t test.SEmbedSEmbedS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] ql_S1 SEmbedS1[t]
}

func TestFieldsSEmbedS1AndSEmbedS1(t test.SEmbedS1AndSEmbedS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] ql_S1
}

// This is needed because of a bug that causes some things to not work unless we
// extract the pointer to a named type.
func doNothingFields(
	_ *test.I1,
	_ *test.I2,
	_ *test.S1,
	_ *test.S2,
	_ *test.SEmbedI1,
	_ *test.SEmbedI2,
	_ *test.IEmbedI1,
	_ *test.IEmbedI2,
	_ *test.SImplEmbedI1,
	_ *test.SImplEmbedI2,
	_ *test.SEmbedS1,
	_ *test.SEmbedS2,
	_ *test.SImplEmbedS1,
	_ *test.SImplEmbedS2,
	_ *test.SEmbedSEmbedI1,
	_ *test.SEmbedSEmbedS1,
	_ *test.SEmbedS1AndSEmbedS1,
) {
}
