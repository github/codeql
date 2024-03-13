package pio

import (
	"io"
)

// Version is the current PIO version.
const Version = "0.0.10"

// NewLine is a slice of bytes which controls the
// how a new line should be presented.
//
// Defaults to \n.
var NewLine = []byte("\n")

// Default returns the default, package-level registry instance.
var Default = NewRegistry()

// RegisterPrinter registers an already-created printer to the
// registry.
//
// If a printer with the same `Name` is already
// registered then it will be overridden by
// this new "printer".
//
// Returns the Registry, therefore it can be used as builder.
func RegisterPrinter(p *Printer) *Registry {
	return Default.RegisterPrinter(p)
}

// Register creates and registers a new Printer
// based on a name(string) and an "output"(io.Writer).
//
// If a printer with the same `Name` is already
// registered then it will be overridden by
// this new "printer".
//
// Look `OutputFrom` too.
//
// Returns the just created Printer.
func Register(printerName string, output io.Writer) *Printer {
	return Default.Register(printerName, output)
}

// Get returns a Printer based on the "printerName".
// If printer with this name can't be found then
// this function will return nil, so a check for
// nil is always a good practice.
func Get(printerName string) *Printer {
	return Default.Get(printerName)
}

// Remove deletes a printer item from the printers collection
// by its name.
func Remove(printerName string) {
	Default.Remove(printerName)
}

// Print accepts a value of "v",
// tries to marshal its contents and flushes the result
// to all available printers.
func Print(v interface{}) (int, error) {
	return Default.Print(v)
}

// Println accepts a value of "v",
// tries to marshal its contents and flushes the result
// to all available printers, it adds a new line at the ending,
// the result doesn't contain this new line, therefore result's contnets kept as expected.
func Println(v interface{}) (int, error) {
	return Default.Println(v)
}

// Scan scans everything from "r" and prints
// its new contents to the printers,
// forever or until the returning "cancel" is fired, once.
func Scan(r io.Reader, addNewLine bool) (cancel func()) {
	return Default.Scan(r, addNewLine)
}
