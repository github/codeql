package xyz

import (
	"bytes"
	"text/template"
)

type Inner1 struct {
	Data string
}

type Inner2 struct {
	Data string
}

type Inner3 struct {
	Data string
}

type HasInner3Slice struct {
	Slice []Inner3
}

type Outer struct {
	SliceField []Inner1
	PtrField   *Inner2
	MapField   map[string]Inner3
	DeepField  HasInner3Slice
}

func source(n int) string { return "dummy" }
func sink(arg any)        {}

func test() {

	source1 := source(1)
	source2 := source(2)
	source3 := source(3)
	source4 := source(4)

	toSerialize := Outer{[]Inner1{{source1}}, &Inner2{source2}, map[string]Inner3{"key": {source3}},
		HasInner3Slice{[]Inner3{{source4}}}}
	buff1 := new(bytes.Buffer)
	buff2 := new(bytes.Buffer)
	bytes1 := make([]byte, 10)
	bytes2 := make([]byte, 10)

	tmpl, _ := template.New("test").Parse("Template text goes here (irrelevant for test)")
	tmpl.ExecuteTemplate(buff1, "test", toSerialize)
	buff1.Read(bytes1)
	sink(bytes1) // $ hasTaintFlow=1 hasTaintFlow=2 hasTaintFlow=3 hasTaintFlow=4

	// Read `buff2` via an `any`-typed variable, to ensure the static type of the argument to tmpl.Execute makes no difference to the result
	var toSerializeAsAny any
	toSerializeAsAny = toSerialize
	tmpl.Execute(buff2, toSerializeAsAny)
	buff2.Read(bytes2)
	sink(bytes2) // $ hasTaintFlow=1 hasTaintFlow=2 hasTaintFlow=3 hasTaintFlow=4

}
