package main

//go:generate depstubber -vendor github.com/davecgh/go-spew/spew "" Dump,Print,Println,Fdump,Fprint,Fprintln,Errorf,Fprintf,Printf,Sdump,Sprint,Sprintf,Sprintln

import (
	"io"

	"github.com/davecgh/go-spew/spew"
)

func main() {}

type Person struct {
	Name    string
	Address string
}

func getUntrustedString() string { return "%v" }

func getUntrustedStruct() Person { return Person{} }

func sinkString(s string) {}

func testSpew(w io.Writer) {
	s := "%v"
	sUntrusted := getUntrustedString()
	p := Person{}
	pUntrusted := getUntrustedStruct()

	spew.Dump(pUntrusted)      // $ hasValueFlow="pUntrusted"
	spew.Print(pUntrusted)     // $ hasValueFlow="pUntrusted"
	spew.Println(pUntrusted)   // $ hasValueFlow="pUntrusted"
	spew.Errorf(sUntrusted, p) // $ hasValueFlow="sUntrusted"
	spew.Errorf(s, pUntrusted) // $ hasValueFlow="pUntrusted"
	spew.Printf(sUntrusted, p) // $ hasValueFlow="sUntrusted"
	spew.Printf(s, pUntrusted) // $ hasValueFlow="pUntrusted"

	spew.Fdump(w, pUntrusted)      // $ hasValueFlow="pUntrusted"
	spew.Fprint(w, pUntrusted)     // $ hasValueFlow="pUntrusted"
	spew.Fprintln(w, pUntrusted)   // $ hasValueFlow="pUntrusted"
	spew.Fprintf(w, sUntrusted, p) // $ hasValueFlow="sUntrusted"
	spew.Fprintf(w, s, pUntrusted) // $ hasValueFlow="pUntrusted"

	str1 := spew.Sdump(pUntrusted)
	sinkString(str1) // $ hasTaintFlow="str1"

	str2 := spew.Sprint(pUntrusted)
	sinkString(str2) // $ hasTaintFlow="str2"

	str3 := spew.Sprintf(sUntrusted, p)
	sinkString(str3) // $ hasTaintFlow="str3"

	str4 := spew.Sprintf(s, pUntrusted)
	sinkString(str4) // $ hasTaintFlow="str4"

	str5 := spew.Sprintln(pUntrusted)
	sinkString(str5) // $ hasTaintFlow="str5"
}
