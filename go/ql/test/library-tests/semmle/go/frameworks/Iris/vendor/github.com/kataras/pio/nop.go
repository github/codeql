package pio

import (
	"io"
)

// IsNop can check wether an `w` io.Writer
// is a NopOutput.
func IsNop(w io.Writer) bool {
	if isN, ok := w.(interface {
		IsNop() bool
	}); ok {
		return isN.IsNop()
	}
	return false
}

type nopOutput struct{}

func (w *nopOutput) Write(b []byte) (n int, err error) {
	// return the actual length in order to `AddPrinter(...)` to be work with io.MultiWriter
	return len(b), nil
}

// IsNop defines this wrriter as a nop writer.
func (w *nopOutput) IsNop() bool {
	return true
}

// NopOutput returns an `io.Writer` which writes nothing.
func NopOutput() io.Writer {
	return &nopOutput{}
}

type nopCloser struct{}

func (c *nopCloser) Close() error {
	return nil
}

// NopCloser returns an `io.Closer` which
// does nothing.
func NopCloser() io.Closer {
	return &nopCloser{}
}
