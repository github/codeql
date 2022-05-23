package main

import (
	"io"

	yaml1 "gopkg.in/yaml.v1"
	yaml2 "gopkg.in/yaml.v2"
	yaml3 "gopkg.in/yaml.v3"
)

func main() {
	var in, out interface{}
	var inb []byte

	out, _ = yaml1.Marshal(in) // $ marshaler="yaml: in -> ... = ...[0]" ttfnmodelstep="in -> ... = ...[0]"
	yaml1.Unmarshal(inb, out)  // $ unmarshaler="yaml: inb -> definition of out" ttfnmodelstep="inb -> definition of out"

	out, _ = yaml2.Marshal(in)      // $ marshaler="yaml: in -> ... = ...[0]" ttfnmodelstep="in -> ... = ...[0]"
	yaml2.Unmarshal(inb, out)       // $ unmarshaler="yaml: inb -> definition of out" ttfnmodelstep="inb -> definition of out"
	yaml2.UnmarshalStrict(inb, out) // $ unmarshaler="yaml: inb -> definition of out" ttfnmodelstep="inb -> definition of out"

	var r io.Reader
	d := yaml2.NewDecoder(r) // $ ttfnmodelstep="r -> call to NewDecoder"
	d.Decode(out)            // $ ttfnmodelstep="d -> definition of out"

	var w io.Writer
	e := yaml2.NewEncoder(w) // $ ttfnmodelstep="definition of e -> definition of w"
	e.Encode(in)             // $ ttfnmodelstep="in -> definition of e"

	out, _ = yaml3.Marshal(in) // $ marshaler="yaml: in -> ... = ...[0]" ttfnmodelstep="in -> ... = ...[0]"
	yaml3.Unmarshal(inb, out)  // $ unmarshaler="yaml: inb -> definition of out" ttfnmodelstep="inb -> definition of out"

	d1 := yaml3.NewDecoder(r) // $ ttfnmodelstep="r -> call to NewDecoder"
	d1.Decode(out)            // $ ttfnmodelstep="d1 -> definition of out"

	e1 := yaml3.NewEncoder(w) // $ ttfnmodelstep="definition of e1 -> definition of w"
	e1.Encode(in)             // $ ttfnmodelstep="in -> definition of e1"

	var n1 yaml3.Node
	n1.Decode(out) // $ ttfnmodelstep="n1 -> definition of out"
	n1.Encode(in)  // $ ttfnmodelstep="in -> definition of n1"
}
