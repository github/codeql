package pio

import (
	"errors"
	"io"
	"sort"
	"sync"
)

// Registry is the Printer(s) container.
//
// It can be used as follows:
// reg := NewRegistry().
//
//	RegisterPrinter(NewPrinter("err", os.Stderr)).
//	RegisterPrinter(NewPrinter("default", os.Stdout)).
//	Print("something")
type Registry struct {
	// can change via `Register` or `RegisterPrinter` with mutex.
	// whenever a tool needs an `io.Writer` to do something
	// end-developers can pass this `Printer`.
	printers []*Printer
	mu       sync.Mutex
	once     sync.Once
}

// NewRegistry returns an empty printer Registry.
//
// Note that:
// Registry have a zero value, so it can be
// declared with a simple `var` keyword and without pointer.
func NewRegistry() *Registry {
	return new(Registry)
}

// RegisterPrinter registers an already-created printer to the
// registry.
//
// If `Printer#Name` is empty then it will be filled with
// "printer_$printers.len".
//
// If a printer with the same `Printer#Name` is already
// registered then it will be overridden by
// this new "printer".
//
// Returns this Registry, therefore it can be used as builder.
func (reg *Registry) RegisterPrinter(printer *Printer) *Registry {
	// if exists then remove first and then add the new one.
	if printerName := printer.Name; reg.Get(printerName) != nil {
		reg.Remove(printerName)
	}
	reg.mu.Lock()
	// no printer.Handle(s.handlers...)
	reg.printers = append(reg.printers, printer)
	reg.mu.Unlock()
	return reg
}

// Register creates and registers a new Printer
// based on a name(string) and an "output"(io.Writer).
//
// If "printerName" is empty then it will be filled with
// "printer_$printers.len".
//
// If a printer with the same `Printer#Name` is already
// registered then it will be overridden by
// this new "printer".
//
// Look `OutputFrom` too.
//
// Returns the just created Printer.
func (reg *Registry) Register(printerName string, output io.Writer) *Printer {
	p := NewPrinter(printerName, output)
	reg.RegisterPrinter(p)
	return p
}

// Get returns a Printer based on the "printerName".
// If printer with this name can't be found then
// this function will return nil, so a check for
// nil is always a good practice.
func (reg *Registry) Get(printerName string) *Printer {
	reg.mu.Lock()
	defer reg.mu.Unlock()
	for _, p := range reg.printers {
		if p.Name == printerName {
			return p
		}
	}
	return nil
}

// Remove deletes a printer item from the printers collection
// by its name.
//
// Returns this Registry, so it can be used as builder.
func (reg *Registry) Remove(printerName string) *Registry {
	reg.mu.Lock()
	for i, p := range reg.printers {
		if p.Name == printerName {
			reg.printers = append(reg.printers[:i], reg.printers[i+1:]...)
			break
		}
	}
	reg.mu.Unlock()
	return reg
}

// Print accepts a value of "v",
// tries to marshal its contents and flushes the result
// to all available printers.
func (reg *Registry) Print(v interface{}) (n int, err error) {
	return reg.printAll(v, false)
}

// Println accepts a value of "v",
// tries to marshal its contents and flushes the result
// to all available printers, it adds a new line at the ending,
// the result doesn't contain this new line, therefore result's contents kept as expected.
func (reg *Registry) Println(v interface{}) (n int, err error) {
	return reg.printAll(v, true)
}

func (reg *Registry) printAll(v interface{}, appendNewLine bool) (n int, err error) {
	// order once at first print.
	reg.once.Do(func() {
		reg.mu.Lock()
		sort.Slice(reg.printers, func(i, j int) bool {
			return reg.printers[i].priority > reg.printers[j].priority
		})
		reg.mu.Unlock()
	})

	for _, p := range reg.printers {
		prevErr := err

		printFunc := p.Print
		if appendNewLine {
			printFunc = p.Println
		}

		n, err = printFunc(v)

		if !p.Chained && n > 0 {
			break
		}
		n, err = combineOutputResult(n, err, prevErr)
	}
	return
}

func combineOutputResult(n int, err error, prevErr error) (totalN int, totalErr error) {
	if err != nil {
		if prevErr != nil {
			totalErr = errors.New(prevErr.Error() + string(NewLine) + err.Error())
		}
	}

	totalN += n
	return
}

// Scan scans everything from "r" and prints
// its new contents to the printers,
// forever or until the returning "cancel" is fired, once.
func (reg *Registry) Scan(r io.Reader, addNewLine bool) (cancel func()) {
	lp := len(reg.printers)
	if lp == 0 {
		return func() {}
	}

	cancelFuncs := make([]func(), lp, lp)
	cancel = func() {
		for _, c := range cancelFuncs {
			c()
		}
	}

	for i, p := range reg.printers {
		cancelFuncs[i] = p.Scan(r, addNewLine)
	}

	return cancel
}

func (reg *Registry) restore(b []byte) {
	for _, p := range reg.printers {
		p.restore(b)
	}
}
