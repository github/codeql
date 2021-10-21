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
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	outerp := &Outer{
		Middle: Middle{Inner: Inner{source()}},
	}
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}

func testPromotedFieldUnnamedInitialization() {
	outer := Outer{Middle{Inner{source()}}}
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	outerp := &Outer{Middle{Inner{source()}}}
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}

func testPromotedFieldUnnamedInitializationFromVariable() {
	inner := Inner{source()}
	middle := Middle{inner}
	outer := Outer{middle}
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	innerp := Inner{source()}
	middlep := Middle{innerp}
	outerp := Outer{middlep}
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}

func testPromotedFieldNamedInitializationFromVariable() {
	inner := Inner{source()}
	middle := Middle{Inner: inner}
	outer := Outer{Middle: middle}
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	innerp := Inner{source()}
	middlep := Middle{Inner: innerp}
	outerp := Outer{Middle: middlep}
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}

func testPromotedFieldDirectAssignment() {
	var outer Outer
	outer.field = source()
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	var outerp Outer
	outerp.field = source()
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}

func testPromotedFieldIndirectAssignment1() {
	var outer Outer
	outer.Inner.field = source()
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	var outerp Outer
	outerp.Inner.field = source()
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}

func testPromotedFieldIndirectAssignment2() {
	var outer Outer
	outer.Middle.field = source()
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	var outerp Outer
	outerp.Middle.field = source()
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}

func testPromotedFieldIndirectAssignment3() {
	var outer Outer
	outer.Middle.Inner.field = source()
	sink(outer.field)              // $ promotedfields
	sink(outer.Inner.field)        // $ promotedfields
	sink(outer.Middle.field)       // $ promotedfields
	sink(outer.Middle.Inner.field) // $ promotedfields

	var outerp Outer
	outerp.Middle.Inner.field = source()
	sink(outerp.field)              // $ promotedfields
	sink(outerp.Inner.field)        // $ promotedfields
	sink(outerp.Middle.field)       // $ promotedfields
	sink(outerp.Middle.Inner.field) // $ promotedfields
}
