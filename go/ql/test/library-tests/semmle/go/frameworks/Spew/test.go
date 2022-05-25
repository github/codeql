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

	spew.Dump(pUntrusted)      // NOT OK
	spew.Print(pUntrusted)     // NOT OK
	spew.Println(pUntrusted)   // NOT OK
	spew.Errorf(sUntrusted, p) // NOT OK
	spew.Errorf(s, pUntrusted) // NOT OK
	spew.Printf(sUntrusted, p) // NOT OK
	spew.Printf(s, pUntrusted) // NOT OK

	spew.Fdump(w, pUntrusted)      // NOT OK
	spew.Fprint(w, pUntrusted)     // NOT OK
	spew.Fprintln(w, pUntrusted)   // NOT OK
	spew.Fprintf(w, sUntrusted, p) // NOT OK
	spew.Fprintf(w, s, pUntrusted) // NOT OK

	str1 := spew.Sdump(pUntrusted)
	sinkString(str1) // NOT OK

	str2 := spew.Sprint(pUntrusted)
	sinkString(str2) // NOT OK

	str3 := spew.Sprintf(sUntrusted, p)
	sinkString(str3) // NOT OK

	str4 := spew.Sprintf(s, pUntrusted)
	sinkString(str4) // NOT OK

	str5 := spew.Sprintln(pUntrusted)
	sinkString(str5) // NOT OK
}
