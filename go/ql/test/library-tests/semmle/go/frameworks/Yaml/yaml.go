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
	yaml1.Unmarshal(inb, out)  // $ unmarshaler="yaml: inb -> out [postupdate]" ttfnmodelstep="inb -> out [postupdate]"

	out, _ = yaml2.Marshal(in)      // $ marshaler="yaml: in -> ... = ...[0]" ttfnmodelstep="in -> ... = ...[0]"
	yaml2.Unmarshal(inb, out)       // $ unmarshaler="yaml: inb -> out [postupdate]" ttfnmodelstep="inb -> out [postupdate]"
	yaml2.UnmarshalStrict(inb, out) // $ unmarshaler="yaml: inb -> out [postupdate]" ttfnmodelstep="inb -> out [postupdate]"

	var r io.Reader
	d := yaml2.NewDecoder(r) // $ ttfnmodelstep="r -> call to NewDecoder"
	d.Decode(out)            // $ ttfnmodelstep="d -> out [postupdate]"

	var w io.Writer
	e := yaml2.NewEncoder(w) // $ ttfnmodelstep="definition of e -> w [postupdate]"
	e.Encode(in)             // $ ttfnmodelstep="in -> e [postupdate]"

	out, _ = yaml3.Marshal(in) // $ marshaler="yaml: in -> ... = ...[0]" ttfnmodelstep="in -> ... = ...[0]"
	yaml3.Unmarshal(inb, out)  // $ unmarshaler="yaml: inb -> out [postupdate]" ttfnmodelstep="inb -> out [postupdate]"

	d1 := yaml3.NewDecoder(r) // $ ttfnmodelstep="r -> call to NewDecoder"
	d1.Decode(out)            // $ ttfnmodelstep="d1 -> out [postupdate]"

	e1 := yaml3.NewEncoder(w) // $ ttfnmodelstep="definition of e1 -> w [postupdate]"
	e1.Encode(in)             // $ ttfnmodelstep="in -> e1 [postupdate]"

	var n1 yaml3.Node
	n1.Decode(out) // $ ttfnmodelstep="n1 -> out [postupdate]"
	n1.Encode(in)  // $ ttfnmodelstep="in -> n1 [postupdate]"
}
