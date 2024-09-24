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

func TestSEmbedI1(t test.SEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestSEmbedI2(t test.SEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestIEmbedI1(t test.IEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestIEmbedI2(t test.IEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestSImplEmbedI1(t test.SImplEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestSImplEmbedI2(t test.SImplEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestSEmbedS1(t test.SEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestSEmbedS2(t test.SEmbedS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestSImplEmbedS1(t test.SImplEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}

func TestSImplEmbedS2(t test.SImplEmbedS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y)
}
