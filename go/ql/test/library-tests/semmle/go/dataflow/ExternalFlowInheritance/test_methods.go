package main

import (
	"github.com/nonexistent/test"
)

func TestMethodsI1(t test.I1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[f] I1[t] ql_I1 SPURIOUS: ql_S1
}

func TestMethodsI2(t test.I2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[f] I2[t]
}

func TestMethodsS1(t test.S1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[f] S1[t] ql_S1
}

func TestMethodsS2(t test.S2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t]
}

func TestMethodsSEmbedI1(t test.SEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SEmbedI1[t] ql_I1 SPURIOUS: ql_S1
}

func TestMethodsSEmbedI2(t test.SEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SEmbedI2[t]
}

func TestMethodsIEmbedI1(t test.IEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] IEmbedI1[t] ql_I1 SPURIOUS: ql_S1
}

func TestMethodsIEmbedI2(t test.IEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] IEmbedI2[t]
}

func TestMethodsSImplEmbedI1(t test.SImplEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SImplEmbedI1[t]
}

func TestMethodsSImplEmbedI2(t test.SImplEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SImplEmbedI2[t]
}

func TestMethodsSEmbedS1(t test.SEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] SEmbedS1[t] ql_S1
}

func TestMethodsSEmbedS2(t test.SEmbedS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SEmbedS2[t]
}

func TestMethodsSImplEmbedS1(t test.SImplEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SImplEmbedS1[t]
}

func TestMethodsSImplEmbedS2(t test.SImplEmbedS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SImplEmbedS2[t]
}

func TestMethodsSEmbedSEmbedI1(t test.SEmbedSEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SEmbedI1[t] ql_I1 SPURIOUS: ql_S1
}

func TestMethodsSEmbedSEmbedS1(t test.SEmbedSEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] SEmbedS1[t] ql_S1
}
