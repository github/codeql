package main

func source() string {
	return "hello world"
}

func sink(s string) {}

type Inner struct {
	field string
}

type Middle struct {
	Inner
}

type Outer struct {
	Middle
}

func testPromotedFieldNamedInitialization() {
	outer := Outer{
		Middle: Middle{Inner: Inner{source()}},
	}
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	outerp := &Outer{
		Middle: Middle{Inner: Inner{source()}},
	}
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}

func testPromotedFieldUnnamedInitialization() {
	outer := Outer{Middle{Inner{source()}}}
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	outerp := &Outer{Middle{Inner{source()}}}
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}

func testPromotedFieldUnnamedInitializationFromVariable() {
	inner := Inner{source()}
	middle := Middle{inner}
	outer := Outer{middle}
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	innerp := Inner{source()}
	middlep := Middle{innerp}
	outerp := Outer{middlep}
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}

func testPromotedFieldNamedInitializationFromVariable() {
	inner := Inner{source()}
	middle := Middle{Inner: inner}
	outer := Outer{Middle: middle}
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	innerp := Inner{source()}
	middlep := Middle{Inner: innerp}
	outerp := Outer{Middle: middlep}
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}

func testPromotedFieldDirectAssignment() {
	var outer Outer
	outer.field = source()
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	var outerp Outer
	outerp.field = source()
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}

func testPromotedFieldIndirectAssignment1() {
	var outer Outer
	outer.Inner.field = source()
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	var outerp Outer
	outerp.Inner.field = source()
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}

func testPromotedFieldIndirectAssignment2() {
	var outer Outer
	outer.Middle.field = source()
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	var outerp Outer
	outerp.Middle.field = source()
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}

func testPromotedFieldIndirectAssignment3() {
	var outer Outer
	outer.Middle.Inner.field = source()
	sink(outer.field)              // $ hasValueFlow="selection of field"
	sink(outer.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outer.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outer.Middle.Inner.field) // $ hasValueFlow="selection of field"

	var outerp Outer
	outerp.Middle.Inner.field = source()
	sink(outerp.field)              // $ hasValueFlow="selection of field"
	sink(outerp.Inner.field)        // $ hasValueFlow="selection of field"
	sink(outerp.Middle.field)       // $ hasValueFlow="selection of field"
	sink(outerp.Middle.Inner.field) // $ hasValueFlow="selection of field"
}
