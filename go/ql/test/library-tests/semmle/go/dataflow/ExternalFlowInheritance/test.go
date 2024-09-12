package main

import (
	"github.com/nonexistent/test"
)

func TestI1(t test.I1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestI2(t test.I2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestS1(t test.S1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestS2(t test.S2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingI1(t test.StructEmbeddingI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingI2(t test.StructEmbeddingI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingAndOverridingI1(t test.StructEmbeddingAndOverridingI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingAndOverridingI2(t test.StructEmbeddingAndOverridingI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingS1(t test.StructEmbeddingS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingS2(t test.StructEmbeddingS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingAndOverridingS1(t test.StructEmbeddingAndOverridingS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestStructEmbeddingAndOverridingS2(t test.StructEmbeddingAndOverridingS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}
