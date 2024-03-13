package pio

import (
	"io"
)

// Available sources.
type (
	printFunc         func(interface{})
	printVariadicFunc func(...interface{})
	printfFunc        func(string, ...interface{})
	printlnFunc       func(string)
)

type writerFunc func([]byte) (int, error)

func (w writerFunc) Write(p []byte) (n int, err error) {
	return w(p)
}

// Wrap returns a new output based on the "printfFn"
// if not a compatible output found then it will
// return a writer which writes nothing.
//
// To check if the wrapping worked
// you can check if the result `io.Writer`
// `IsNop`, i.e:
// std's log.Panicf is not a compatible interface
//
// output := Output(log.Panicf)
//
//	if IsNop(output) {
//		// conversation failed, do something or panic.
//	}
func Wrap(printFn interface{}) io.Writer {
	switch printFn.(type) {
	case io.Writer:
		return printFn.(io.Writer)
	case writerFunc:
		return printFn.(io.Writer)
	case printFunc:
		return OutputFrom.Print(printFn.(printFunc))
	case printVariadicFunc:
		return OutputFrom.PrintVardiadic(printFn.(printVariadicFunc))
	case printfFunc:
		return OutputFrom.Printf(printFn.(printfFunc))
	case printlnFunc:
		return OutputFrom.Println(printFn.(printlnFunc), false)

	}

	return NopOutput()
}

// OutputFrom is a variable
// which contains some helpers that can
// convert some forms of output to compatible `io.Writer`
// in order to be passed to the `NewPrinter` or `Register` functions.
var OutputFrom = OutputAdapters{}

// OutputAdapters is a struct
// which contains some forms of output
// and convert them to a compatible `io.Writer`
// in order to be passed to the `NewPrinter` or `Register` functions.
type OutputAdapters struct{}

// Print converts a func(v interface{}) to a compatible `io.Writer`.
func (a *OutputAdapters) Print(print func(v interface{})) io.Writer {
	return &printAdapter{
		print: print,
	}
}

// PrintVardiadic converts a func(v ...interface{}) to a compatible `io.Writer`.
func (a *OutputAdapters) PrintVardiadic(print func(v ...interface{})) io.Writer {
	return &printVariadicAdapter{
		printVariadic: print,
	}
}

// Printf converts a func(string, ...interface{}) to a compatible `io.Writer`.
func (a *OutputAdapters) Printf(printf func(format string, args ...interface{})) io.Writer {
	return &printfAdapter{
		printf: printf,
	}
}

// Println converts a func(string) to a compatible `io.Writer`.
// if "newLine" is true then "\n" will be appended to the "s".
func (a *OutputAdapters) Println(println func(s string), newLine bool) io.Writer {
	return &printlnAdapter{
		println: println,
		newLine: newLine,
	}
}

type (
	printAdapter struct {
		print printFunc
	}
	printVariadicAdapter struct {
		printVariadic printVariadicFunc
	}
	printfAdapter struct {
		printf printfFunc
	}
	printlnAdapter struct {
		println printlnFunc
		newLine bool
	}
)

func (p *printAdapter) Write(b []byte) (int, error) {
	p.print(string(b))
	return len(b), nil
}

func (p *printVariadicAdapter) Write(b []byte) (int, error) {
	p.printVariadic(string(b))
	return len(b), nil
}

func (p *printfAdapter) Write(b []byte) (int, error) {
	p.printf(string(b))
	return len(b), nil
}

func (p *printlnAdapter) Write(b []byte) (int, error) {
	if p.newLine {
		b = append(b, NewLine...)
	}
	p.println(string(b))
	return len(b), nil
}
