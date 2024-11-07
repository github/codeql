package main

import (
	"github.com/nonexistent/test"
)

func TestI1(t test.I1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[f] I1[t] ql_I1 SPURIOUS: IEmbedI1[t] SEmbedI1[t] ql_S1
}

func TestI2(t test.I2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[f] I2[t] SPURIOUS: IEmbedI1[t] IEmbedI2[t] SEmbedI1[t] SEmbedI2[t]
}

func TestS1(t test.S1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[f] S1[t] ql_S1 SPURIOUS: IEmbedI1[t] SEmbedI1[t]
}

func TestS2(t test.S2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SPURIOUS: IEmbedI1[t] IEmbedI2[t] SEmbedI1[t] SEmbedI2[t]
}

func TestSEmbedI1(t test.SEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SEmbedI1[t] ql_I1 SPURIOUS: I1[f] IEmbedI1[t] ql_S1
}

func TestSEmbedI2(t test.SEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SEmbedI2[t] SPURIOUS: I2[f] IEmbedI1[t] IEmbedI2[t] SEmbedI1[t]
}

func TestIEmbedI1(t test.IEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] IEmbedI1[t] ql_I1 SPURIOUS: I1[f] SEmbedI1[t] ql_S1
}

func TestIEmbedI2(t test.IEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] IEmbedI2[t] SPURIOUS: I2[f] IEmbedI1[t] SEmbedI1[t] SEmbedI2[t]
}

func TestSImplEmbedI1(t test.SImplEmbedI1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SImplEmbedI1[t] SPURIOUS: IEmbedI1[t] SEmbedI1[t]
}

func TestSImplEmbedI2(t test.SImplEmbedI2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SImplEmbedI2[t] SPURIOUS: IEmbedI1[t] IEmbedI2[t] SEmbedI1[t] SEmbedI2[t]
}

func TestSEmbedS1(t test.SEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] S1[t] ql_S1 SPURIOUS: IEmbedI1[t] S1[f] SEmbedI1[t]
}

func TestSEmbedS2(t test.SEmbedS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SPURIOUS: IEmbedI1[t] IEmbedI2[t] SEmbedI1[t] SEmbedI2[t]
}

func TestSImplEmbedS1(t test.SImplEmbedS1) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] SImplEmbedS1[t] SPURIOUS: IEmbedI1[t] SEmbedI1[t]
}

func TestSImplEmbedS2(t test.SImplEmbedS2) {
	x := t.Source()
	y := t.Step(x)
	t.Sink(y) // $ I1[t] I2[t] SImplEmbedS2[t] SPURIOUS: IEmbedI1[t] IEmbedI2[t] SEmbedI1[t] SEmbedI2[t]
}
