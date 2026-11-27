package a

import "encoding/json"

func source() string {
	return "tainted"
}

func sink(any) {}

type inner struct {
	val string
}

func (i *inner) setVal(v string) {
	i.val = v
}

func setInner(i *inner, v string) {
	i.val = v
}

type middle struct {
	in *inner
}

type embedded struct {
	*inner
}

type outer struct {
	mid   middle
	midPt *middle
	mids  []middle
	emb   embedded
}

func testNestedReceiver() {
	o1 := outer{mid: middle{in: &inner{}}}
	o1.mid.in.setVal(source())
	sink(o1.mid.in.val) // $ hasValueFlow="selection of val"

	o2 := outer{midPt: &middle{in: &inner{}}}
	o2.midPt.in.setVal(source())
	sink(o2.midPt.in.val) // $ hasValueFlow="selection of val"

	o3 := outer{mids: []middle{{in: &inner{}}}}
	o3.mids[0].in.setVal(source())
	sink(o3.mids[0].in.val) // $ hasValueFlow="selection of val"

	o4 := outer{emb: embedded{inner: &inner{}}}
	o4.emb.setVal(source())
	sink(o4.emb.val) // $ hasValueFlow="selection of val"
}

func testNestedArgument() {
	o := outer{mid: middle{in: &inner{}}}
	setInner(o.mid.in, source())
	sink(o.mid.in.val) // $ hasValueFlow="selection of val"
}

func testChannelReceiveReceiver(ch chan *inner) {
	(<-ch).setVal(source())
	sink((<-ch).val) // $ hasValueFlow="selection of val"
}

type jsonInner struct {
	Val string
}

type jsonOuter struct {
	Inner jsonInner
}

func testAddressOfFieldUnmarshal() {
	var o jsonOuter
	_ = json.Unmarshal([]byte(source()), &o.Inner)
	sink(o.Inner)     // $ hasTaintFlow="selection of Inner"
	sink(o.Inner.Val) // $ hasTaintFlow="selection of Val"
}

func taint() *inner {
	return &inner{}
}

func calleeReadsOnly(p *inner) {
	if p == nil {
		p = taint()
	}
	_ = p.val
}

func testNoBackflowFromReadOnlyDeref() {
	clean := &inner{val: "safe"}
	calleeReadsOnly(clean)
	sink(clean)
	sink(clean.val)
}
