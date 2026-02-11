package main

import (
	"github.com/nonexistent/test"
)

func TestFieldsP1(t test.P1) {
	a := t.SourceField
	t.SinkField = a // $ P1[f] P1[t] ql_P1
}

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

func TestFieldsPImplEmbedI1(t test.PImplEmbedI1) {
	a := t.SourceField
	t.SinkField = a // $ PImplEmbedI1[t]
}

func TestFieldsSEmbedP1(t test.SEmbedP1) {
	a := t.SourceField
	t.SinkField = a // $ P1[t] SEmbedP1[t] ql_P1
}

func TestFieldsSEmbedS1(t test.SEmbedS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] SEmbedS1[t] ql_S1
}

func TestFieldsSEmbedPtrP1(t test.SEmbedPtrP1) {
	a := t.SourceField
	t.SinkField = a // $ P1[t] SEmbedPtrP1[t] ql_P1
}

func TestFieldsSEmbedPtrS1(t test.SEmbedPtrS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] SEmbedPtrS1[t] ql_S1
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
	t.SinkField = a // $ S1[t] SEmbedS1[t] ql_S1
}

func TestFieldsSEmbedSEmbedPtrS1(t test.SEmbedSEmbedPtrS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] SEmbedPtrS1[t] ql_S1
}

func TestFieldsSEmbedPtrSEmbedS1(t test.SEmbedPtrSEmbedS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] SEmbedS1[t] ql_S1
}

func TestFieldsSEmbedPtrSEmbedPtrS1(t test.SEmbedPtrSEmbedPtrS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] SEmbedPtrS1[t] ql_S1
}

func TestFieldsSEmbedS1AndSEmbedS1(t test.SEmbedS1AndSEmbedS1) {
	a := t.SourceField
	t.SinkField = a // $ S1[t] ql_S1
}
