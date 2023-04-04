package pio

import (
	"bufio"
	"bytes"
	"io"
	"io/ioutil"
	"strconv"
	"sync"
	"sync/atomic"

	"github.com/kataras/pio/terminal"
)

type (
	// Handler is the signature implemented by callers
	// that want to be notified about the results
	// that are being printed to the Printer's output.
	//
	// Look `Printer#Handle` for more.
	Handler func(PrintResult)
)

// Printer is responsible to print the end result.
type Printer struct {
	Name       string
	IsTerminal bool
	priority   int // higher means try to print first from this printer, from `Registry#Print`
	// if Chained is true then the parent `Registry#Print`
	// will continue to search for a compatible printer
	// even if this printer succeed to print the contents.
	Chained bool
	Output  io.Writer

	// The "outputs" field holds the total writers,
	// the "Output" and any writer added by an `AddOutput` call.
	// The `AddOutput` method sets the Output to a new `io.MultiWriter`
	// but the underline struct is unexported therefore we don't have access to
	// to the total writers. However sometimes, we need those writers.
	// E.g. for the `WriteRich` feature;
	// in order to write color symbols in the writers that support 256-bit colors
	// and write raw text to those that do not (e.g. files).
	// Note: we could implementing our own multi writer and skip the use
	// of the std package, but let's don't do that unless is requested.
	outputs []*outputWriter

	mu       sync.Mutex
	marshal  MarshalerFunc
	hijack   Hijacker
	handlers []Handler

	// These three will complete the interface of the:
	// https://golang.org/pkg/io/#ReadWriteCloser
	// in order to make possible to use everything inside the `io` package.
	// i.e
	// https://golang.org/pkg/io/#example_MultiWriter
	// https://golang.org/pkg/io/#example_TeeReader (piping)
	io.Reader
	io.Writer
	io.Closer
	// DirectOutput will output the contents and flush them as fast as possible,
	// without storing them to the buffer to complete the `ReadWriteCloser` std interface.
	// Enable this if you need performance and you don't use the standard functions like `TeeReader`.
	DirectOutput bool
	sync         bool // See `SetSync`.
}

var (
	// TotalPrinters holds the number of
	// the total printers created, either by
	// `NewPrinter`, `NewTextPrinter`, `Register` or `RegisterPrinter`
	TotalPrinters int32
)

// NewPrinter returns a new named printer
// if "output" is nil then it doesn't prints anywhere.
//
// If "name" is empty then it will be filled with
// "printer_$printers.len".
//
// If the marshaler is nil, meaning that this writer's
// result will never being proceed, caller should
// add a marshaler using the `Marshal` function.
//
// Look `OutputFrom` too.
func NewPrinter(name string, output io.Writer) *Printer {
	if output == nil {
		output = NopOutput()
	}

	atomic.AddInt32(&TotalPrinters, 1)

	if name == "" {
		totalPrinters := atomic.LoadInt32(&TotalPrinters)
		lens := strconv.Itoa(int(totalPrinters))
		name = "printer_" + lens
	}

	buf := &bytes.Buffer{}

	isOuputTerminal := SupportColors(output)

	p := &Printer{
		Name:       name,
		Output:     output,
		outputs:    wrapWriters(output),
		Writer:     buf,
		Reader:     buf,
		Closer:     NopCloser(),
		IsTerminal: isOuputTerminal,
	}

	// If "output" is terminal then a text marshaler will be
	// added to the Printer's marshalers.
	//
	// if p.IsTerminal {
	// 	 p.Marshal(Text)
	// }
	//
	// let's think of it
	// if a user don't want it we can't force this printer
	// to print texts too, the end-developer
	// may have split his logic about logging
	// so don't do it automatically, instead
	// create a new function which will return a text printer
	// and allow this printer to accept more than one marshalers.

	return p
}

// NewTextPrinter same as NewPrinter but registers
// a text marshaler, no matter what kind of "output",
// which converts string type
// to a compatible form of slice of bytes.
//
// If "name" is empty then it will be filled with
// "printer_$printers.len".
//
// Look `OutputFrom` too.
func NewTextPrinter(name string, output io.Writer) *Printer {
	p := NewPrinter(name, output)
	p.Marshal(Text)
	return p
}

// Priority changes the order of this printer.
// Higher value means that the `Registry#Print`
// will try to print first from this printer.
// Default order is 0 for all printers.
//
// Returns it self.
func (p *Printer) Priority(prio int) *Printer {
	p.mu.Lock()
	p.priority = prio
	p.mu.Unlock()
	return p
}

// Marshal adds a "marshaler" to the printer.
// Returns itself.
func (p *Printer) Marshal(marshaler Marshaler) *Printer {
	return p.MarshalFunc(marshaler.Marshal)
}

// MarshalFunc adds a "marshaler" to the printer.
// Returns itself.
func (p *Printer) MarshalFunc(marshaler func(v interface{}) ([]byte, error)) *Printer {
	p.mu.Lock()
	defer p.mu.Unlock()

	if p.marshal == nil {
		p.marshal = marshaler
		return p
	}

	oldM := p.marshal
	newM := marshaler

	// false on first failure
	p.marshal = func(v interface{}) ([]byte, error) {
		b, err := oldM(v)

		// check if we can continue to the next marshal func
		if err != nil && err.Error() == ErrMarshalNotResponsible.Error() {
			b, err = newM(v)
		}

		// if no data return but err is nil, then something went wrong
		if len(b) <= 0 && err == nil {
			return b, ErrSkipped
		}

		return b, err //  p.addNewLineInneed(b), err
	}

	return p
}

// WithMarshalers same as `Marshal` but accepts more than one marshalers
// and returns the Printer itself in order to be used side by side with the creational
// function.
func (p *Printer) WithMarshalers(marshalers ...Marshaler) *Printer {
	if len(marshalers) == 0 {
		return p
	}

	for _, marshaler := range marshalers {
		p.Marshal(marshaler)
	}

	return p
}

// AddOutput adds one or more io.Writer to the Printer.
// Returns itself.
//
// Look `OutputFrom` and `Wrap` too.
func (p *Printer) AddOutput(writers ...io.Writer) *Printer {
	p.mu.Lock()
	defer p.mu.Unlock()

	for _, w := range writers {
		// set is terminal to false
		// if at least one of the writers
		// is not a terminal-based.
		if !terminal.IsTerminal(w) {
			p.IsTerminal = false
			break
		}
	}

	p.outputs = append(p.outputs, wrapWriters(writers...)...)

	w := io.MultiWriter(append(writers, p.Output)...)

	p.Output = w
	return p
}

// SetOutput sets accepts one or more io.Writer
// and set a multi-writter instance to the Printer's Output.
// Returns itself.
//
// Look `OutputFrom` too.
func (p *Printer) SetOutput(writers ...io.Writer) *Printer {
	var w io.Writer
	if l := len(writers); l == 0 {
		return p
	} else if l == 1 {
		w = writers[0]
	} else {
		w = io.MultiWriter(writers...)
	}

	p.mu.Lock()
	p.outputs = wrapWriters(writers...)
	p.Output = w
	p.IsTerminal = terminal.IsTerminal(w)
	p.mu.Unlock()
	return p
}

// EnableDirectOutput will output the contents and flush them as fast as possible,
// without storing them to the buffer to complete the `ReadWriteCloser` std interface.
// Enable this if you need performance and you don't use the standard functions like `TeeReader`.
// Returns itself.
func (p *Printer) EnableDirectOutput() *Printer {
	p.mu.Lock()
	p.DirectOutput = true
	p.mu.Unlock()
	return p
}

// SetSync protects the output writer(s) with a lock.
func (p *Printer) SetSync(useLocks bool) *Printer {
	p.mu.Lock()
	p.sync = true
	p.mu.Unlock()
	return p
}

func (p *Printer) lock() {
	if p.sync {
		p.mu.Lock()
	}
}

func (p *Printer) unlock() {
	if p.sync {
		p.mu.Unlock()
	}
}

// Print of a Printer accepts a value of "v",
// tries to marshal its contents and flushes the result
// to the Printer's output.
//
// If "v" implements the `Marshaler` type, then this marshaler
// is called automatically, first.
//
// Print -> Store[Marshal -> err != nil && result -> Hijack(result) -> Write(result)] -> Flush[Printer.Write(buf) and Handle(buf)]
//
// Returns how much written and an error on failure.
func (p *Printer) Print(v interface{}) (int, error) {
	return p.print(v, false)
}

// Println accepts a value of "v",
// tries to marshal its contents and flushes the result
// to this "p" Printer, it adds a new line at the ending,
// the result doesn't contain this new line, therefore result's contents kept as expected.
func (p *Printer) Println(v interface{}) (int, error) {
	return p.print(v, true)
}

func (p *Printer) print(v interface{}, appendNewLine bool) (int, error) {
	var (
		b   []byte
		err error
	)

	if p.DirectOutput {
		b, err = p.WriteTo(v, p.Output, appendNewLine)
	} else {
		_, err = p.WriteTo(v, p.Writer, appendNewLine)
		if err != nil {
			return -1, err
		}

		b, err = p.Flush()
	}

	// flush error return last,
	// we should call handlers even if the result is a failure.
	if len(p.handlers) > 0 {
		// create the print result instance
		// only when printer uses handlers, so we can reduce the factory calls.
		res := withValue(v).withErr(err).withContents(b)
		for _, h := range p.handlers {
			// do NOT run each handler on its own goroutine because we need sync with the messages.
			// let end-developer decide the pattern.
			h(res)
		}
	}

	return len(b), err
}

func (p *Printer) readAndConsume() ([]byte, error) {
	b, err := ioutil.ReadAll(p.Reader)
	if err != nil && err != io.EOF {
		return b, err
	}
	return b, nil
}

// Flush will consume and flush the Printer's current contents.
func (p *Printer) Flush() ([]byte, error) {
	p.lock()
	defer p.unlock()

	b, err := p.readAndConsume()
	if err != nil {
		return nil, err
	}

	_, err = p.Output.Write(b)
	return b, err
}

// Store will store-only the contents of "v".
// Returns a PrintResult type in order to the final contents
// be accessible by third-party tools.
//
// If you want to Print and Flush to the Printer's Output use `Print` instead.
//
// If "appendNewLine" is true then it writes a new line to the
// Printer's output. Note that it doesn't concat it to the
// returning PrintResult, therefore the "appendNewLine" it is not affect the rest
// of the implementation like custom hijackers and handlers.
func (p *Printer) Store(v interface{}, appendNewLine bool) error {
	_, err := p.WriteTo(v, p.Writer, appendNewLine)
	return err
}

// Write implements the io.Writer for the `Printer`.
func (p *Printer) Write(b []byte) (n int, err error) {
	p.lock()
	if p.DirectOutput {
		n, err = p.Output.Write(b)
	} else {
		n, err = p.Writer.Write(b)
	}
	p.unlock()
	return
}

// WriteTo marshals and writes the "v" to the "w" writer.
//
// Returns this WriteTo's result information such as error, written.
func (p *Printer) WriteTo(v interface{}, w io.Writer, appendNewLine bool) ([]byte, error) {
	var (
		b   []byte
		err error
	)

	if hijack := p.hijack; hijack != nil {
		ctx := acquireCtx(v, p)
		defer releaseCtx(ctx)

		hijack(ctx)

		if ctx.canceled {
			return nil, ErrCanceled
		}

		b, err = ctx.marshalResult.b, ctx.marshalResult.err
		if err != nil {
			if err == ErrHandled {
				return b, nil
			}

			return b, err
		}
	}

	// needs marshal
	if len(b) == 0 {
		var marshaler Marshaler

		// check if implements the Marshaled
		if m, ok := v.(Marshaled); ok {
			marshaler = fromMarshaled(m)
			// check if implements the Marshaler
		} else if m, ok := v.(Marshaler); ok {
			marshaler = m
			// otherwise make check if printer has a marshaler
			// if not skip this WriteTo operation,
			// else set the marshaler to that (most common).
		} else {
			if p.marshal != nil {
				marshaler = p.marshal
			}
		}

		if marshaler == nil {
			return nil, ErrSkipped
		}

		b, err = marshaler.Marshal(v)
		if err != nil {
			return b, err
		}
	}

	p.lock()
	_, err = w.Write(b)
	if appendNewLine && err == nil {
		w.Write(NewLine) // we don't care about this error.
	}
	p.unlock()
	return b, err
}

// Hijack registers a callback which is executed
// when ever `Print` or `WriteTo` is called,
// this callback can intercept the final result
// which will be written or be printed.
//
// Returns itself.
func (p *Printer) Hijack(cb func(ctx *Ctx)) *Printer {
	p.mu.Lock()
	defer p.mu.Unlock()

	if p.hijack == nil {
		p.hijack = cb
		return p
	}

	oldCb := p.hijack
	newCb := cb

	// return the first failure
	p.hijack = func(ctx *Ctx) {
		oldCb(ctx)
		if ctx.continueToNext {
			newCb(ctx)
		}
	}

	return p
}

// PrintResult contains some useful information for a `Print` or `WriteTo` action that
// are available inside handlers.
type PrintResult struct {
	Written  int
	Error    error
	Contents []byte
	Value    interface{}
}

// IsOK returns true if result's content is available,
// otherwise false.
func (p PrintResult) IsOK() bool {
	return p.Error == nil && len(p.Contents) > 0
}

// IsFailure returns true if result's content is not safe to read or it's available,
// otherwise false.
func (p PrintResult) IsFailure() bool {
	return !p.IsOK()
}

var printResult = PrintResult{}

func withValue(v interface{}) PrintResult {
	printResult.Value = v
	return printResult
}

func (p PrintResult) withErr(err error) PrintResult {
	if err != nil {
		p.Written = -1
	}
	p.Error = err
	return p
}

func (p PrintResult) withContents(b []byte) PrintResult {
	if p.Error != nil {
		p.Written = -1
	} else {
		p.Written = len(b)
		p.Contents = b
	}
	return p
}

// Handle adds a callback which is called
// whenever a `Print` is successfully executed, it's being executed
// after the contents are written to its output.
//
// The callback accepts the final result,
// can be used as an easy, pluggable, access to all the logs passed to the `Print`.
// i.e: `Handle(func(result PrintResult){ fmt.Printf("%s\n", result.Contents)})`
//
// Returns itself.
func (p *Printer) Handle(h func(PrintResult)) *Printer {
	p.mu.Lock()
	p.handlers = append(p.handlers, h)
	p.mu.Unlock()
	return p
}

func (p *Printer) restore(b []byte) {
	p.Writer.Write(b)
}

// Scan scans everything from "r" and prints
// its new contents to the "p" Printer,
// forever or until the returning "cancel" is fired, once.
func (p *Printer) Scan(r io.Reader, addNewLine bool) (cancel func()) {
	var canceled uint32
	shouldCancel := func() bool {
		return atomic.LoadUint32(&canceled) > 0
	}
	cancel = func() {
		atomic.StoreUint32(&canceled, 1)
	}

	go func() {
		scanner := bufio.NewScanner(r)

		for {
			if shouldCancel() {
				break
			}
			if scanner.Scan() {
				if shouldCancel() {
					// re-store the bytes?
					p.restore(scanner.Bytes())
					break
				}
				text := scanner.Bytes()
				if addNewLine {
					text = append(text, NewLine...)
				}
				p.Print(text)
			}

			if err := scanner.Err(); err != nil {
				// TODO: do something with that or ignore it.
			}
		}
	}()

	return cancel
}
