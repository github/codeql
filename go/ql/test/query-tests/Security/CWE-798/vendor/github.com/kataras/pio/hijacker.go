package pio

import (
	"errors"
	"sync"
)

// Hijacker is the signature implemented by callers
// that want to hijack the Print method.
//
// Look `Printer#Hijack` for more.
type Hijacker func(*Ctx)

var (
	// ErrCanceled is returned when a hijacker canceled a specific print action.
	ErrCanceled = errors.New("canceled")
	// ErrSkipped it returned from marshaler or hijacker
	// when the content should be skipped and printer should avoid printing it.
	ErrSkipped = errors.New("skipped")
	// ErrHandled can be returned from a hijacker to specify
	// that the hijacker handled the write operation itself,
	// therefore pio does not need to do anything else.
	ErrHandled = errors.New("handled")
)

var cPool = sync.Pool{New: func() interface{} { return &Ctx{} }}

func acquireCtx(v interface{}, printer *Printer) *Ctx {
	ctx := cPool.Get().(*Ctx)
	ctx.Printer = printer
	ctx.Value = v

	ctx.marshalResult.b = ctx.marshalResult.b[0:0]
	ctx.marshalResult.err = nil
	ctx.canceled = false
	ctx.continueToNext = false
	return ctx
}

func releaseCtx(ctx *Ctx) {
	cPool.Put(ctx)
}

// Ctx is the current context of the Printer's hijacker,
// should not be used inside goroutines,
// exiting this hijacker allows the Printer to continue its execution.
type Ctx struct {
	// Printer is the current Printer which this ctx is owned by.
	Printer *Printer
	// Value is the argument passed to the `Printer#Print`.
	//
	// Value shoult not be changed.
	Value interface{}

	marshalResult struct {
		b   []byte
		err error
	}
	continueToNext bool
	canceled       bool
}

// MarshalValue marshals the `Value`
// and skips the marshal operation on the `Printer#Print` state.
//
// Remember that if `MarshalValue` called after a `SetResult`
// then it will not operate a marshaling and return the
// stored result instead.
func (ctx *Ctx) MarshalValue() ([]byte, error) {
	if len(ctx.marshalResult.b) > 0 {
		return ctx.marshalResult.b, ctx.marshalResult.err
	}

	if ctx.Printer.marshal == nil {
		return nil, ErrSkipped
	}

	b, err := ctx.Printer.marshal(ctx.Value)
	ctx.marshalResult.b = b
	ctx.marshalResult.err = err
	return b, err
}

// Store bypasses the marshaler and sets the result explicitly.
// If any of the next hijackers try to call the `MarshalValue` then it will
// return the results that had set here.
func (ctx *Ctx) Store(result []byte, err error) {
	ctx.marshalResult.b = result
	ctx.marshalResult.err = err
}

// Cancel cancels the printing of this `Value`.
func (ctx *Ctx) Cancel() {
	ctx.canceled = true
}

// Next allows to continue to the next hijacker,if available, when this hijacker finished.
func (ctx *Ctx) Next() {
	ctx.continueToNext = true
}
