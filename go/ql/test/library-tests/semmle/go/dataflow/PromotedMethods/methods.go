package main

func source() string {
	return "hello world"
}

func sink(s string) {}

type Embedded struct {
	field string
}

type Base1 struct {
	Embedded
}

type Base2 struct {
	*Embedded
}

func (e Embedded) sinkFieldOnEmbeddedNonPointerReceiver() {
	sink(e.field) // $ promotedmethods=nonPointerSender1 promotedmethods=pointerSender1 promotedmethods=nonPointerSender2 promotedmethods=pointerSender2
}

func (e *Embedded) sinkFieldOnEmbeddedPointerReceiver() {
	sink(e.field) // $ MISSING: promotedmethods=nonPointerSender1 promotedmethods=pointerSender1 promotedmethods=nonPointerSender2 promotedmethods=pointerSender2
}

func (base1 Base1) sinkFieldOnBase1NonPointerReceiver() {
	sink(base1.field) // $ promotedmethods=nonPointerSender1 promotedmethods=pointerSender1
}

func (base1 *Base1) sinkFieldOnBase1PointerReceiver() {
	sink(base1.field) // $ promotedmethods=pointerSender1 MISSING: promotedmethods=nonPointerSender1
}

func (base2 Base2) sinkFieldOnBase2NonPointerReceiver() {
	sink(base2.field) // $ promotedmethods=nonPointerSender2 promotedmethods=pointerSender2
}

func (base2 *Base2) sinkFieldOnBase2PointerReceiver() {
	sink(base2.field) // $ promotedmethods=pointerSender2 MISSING: promotedmethods=nonPointerSender2
}

func nonPointerSender1() {
	var base1 Base1
	base1.field = source()
	base1.sinkFieldOnEmbeddedNonPointerReceiver()
	base1.sinkFieldOnEmbeddedPointerReceiver()
	base1.sinkFieldOnBase1NonPointerReceiver()
	base1.sinkFieldOnBase1PointerReceiver()
}

func pointerSender1() {
	var base1 Base1
	base1.field = source()
	base1p := &base1
	base1p.sinkFieldOnEmbeddedNonPointerReceiver()
	base1p.sinkFieldOnEmbeddedPointerReceiver()
	base1p.sinkFieldOnBase1NonPointerReceiver()
	base1p.sinkFieldOnBase1PointerReceiver()
}

func nonPointerSender2() {
	var base2 Base2
	base2.field = source()
	base2.sinkFieldOnEmbeddedNonPointerReceiver()
	base2.sinkFieldOnEmbeddedPointerReceiver()
	base2.sinkFieldOnBase2NonPointerReceiver()
	base2.sinkFieldOnBase2PointerReceiver()
}

func pointerSender2() {
	var base2 Base2
	base2.field = source()
	base2p := &base2
	base2p.sinkFieldOnEmbeddedNonPointerReceiver()
	base2p.sinkFieldOnEmbeddedPointerReceiver()
	base2p.sinkFieldOnBase2NonPointerReceiver()
	base2p.sinkFieldOnBase2PointerReceiver()
}
