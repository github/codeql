// Code generated by depstubber. DO NOT EDIT.
// This is a simple stub for github.com/klauspost/pgzip, strictly for use in testing.

// See the LICENSE file for information about the licensing of the original library.
// Source: github.com/klauspost/pgzip (exports: Reader; functions: NewReader)

// Package pgzip is a stub of github.com/klauspost/pgzip, generated by depstubber.
package pgzip

import (
	io "io"
	time "time"
)

type Header struct {
	Comment string
	Extra   []byte
	ModTime time.Time
	Name    string
	OS      byte
}

func NewReader(_ io.Reader) (*Reader, error) {
	return nil, nil
}

type Reader struct {
	Header Header
}

func (_ *Reader) Close() error {
	return nil
}

func (_ *Reader) Multistream(_ bool) {}

func (_ *Reader) Read(_ []byte) (int, error) {
	return 0, nil
}

func (_ *Reader) Reset(_ io.Reader) error {
	return nil
}

func (_ *Reader) WriteTo(_ io.Writer) (int64, error) {
	return 0, nil
}
