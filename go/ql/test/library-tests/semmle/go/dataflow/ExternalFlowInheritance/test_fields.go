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
