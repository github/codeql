package main

import (
	"github.com/nonexistent/test"
)

func TestMethodsI1(t test.I1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[f] I1[t] ql_I1 SPURIOUS: ql_P1 ql_S1
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

func TestMethodsP1(t test.P1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] P1[f] P1[t] ql_P1
}

func TestMethodsS2(t test.S2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t]
}

func TestMethodsP2(t test.P2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t]
}

func TestMethodsSEmbedI1(t test.SEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SEmbedI1[t] ql_I1 SPURIOUS: ql_P1 ql_S1
}

func TestMethodsSEmbedI2(t test.SEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SEmbedI2[t]
}

func TestMethodsIEmbedI1(t test.IEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] IEmbedI1[t] ql_I1 SPURIOUS: ql_P1 ql_S1
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

func TestMethodsPImplEmbedI1(t test.PImplEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] PImplEmbedI1[t]
}

func TestMethodsPImplEmbedI2(t test.PImplEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] PImplEmbedI2[t]
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

func TestMethodsSEmbedPtrS1(t test.SEmbedPtrS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] SEmbedPtrS1[t] ql_S1
}

func TestMethodsSEmbedPtrS2(t test.SEmbedPtrS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SEmbedPtrS2[t]
}

func TestMethodsSEmbedP1(t *test.SEmbedP1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] P1[t] SEmbedP1[t] ql_P1
}

func TestMethodsSEmbedP2(t *test.SEmbedP2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SEmbedP2[t]
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
	t.Sink(y) // $ I1[t] SEmbedI1[t] ql_I1 SPURIOUS: ql_P1 ql_S1
}

func TestMethodsSEmbedSEmbedS1(t test.SEmbedSEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] SEmbedS1[t] ql_S1
}

func TestMethodsSEmbedSEmbedPtrS1(t test.SEmbedSEmbedPtrS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] SEmbedPtrS1[t] ql_S1
}

func TestMethodsSEmbedPtrSEmbedS1(t test.SEmbedPtrSEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] SEmbedS1[t] ql_S1
}

func TestMethodsSEmbedPtrSEmbedPtrS1(t test.SEmbedPtrSEmbedPtrS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] SEmbedPtrS1[t] ql_S1
}

func TestMethodsSEmbedS1AndSEmbedS1(t test.SEmbedS1AndSEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] ql_S1
}
