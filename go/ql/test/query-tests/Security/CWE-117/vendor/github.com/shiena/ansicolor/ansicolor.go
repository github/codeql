// Copyright 2014 shiena Authors. All rights reserved.
// Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

// Package ansicolor provides color console in Windows as ANSICON.
package ansicolor

import "io"

type outputMode int

// DiscardNonColorEscSeq supports the divided color escape sequence.
// But non-color escape sequence is not output.
// Please use the OutputNonColorEscSeq If you want to output a non-color
// escape sequences such as ncurses. However, it does not support the divided
// color escape sequence.
const (
	_ outputMode = iota
	DiscardNonColorEscSeq
	OutputNonColorEscSeq
)

// NewAnsiColorWriter creates and initializes a new ansiColorWriter
// using io.Writer w as its initial contents.
// In the console of Windows, which change the foreground and background
// colors of the text by the escape sequence.
// In the console of other systems, which writes to w all text.
func NewAnsiColorWriter(w io.Writer) io.Writer {
	return NewModeAnsiColorWriter(w, DiscardNonColorEscSeq)
}

// NewModeAnsiColorWriter create and initializes a new ansiColorWriter
// by specifying the outputMode.
func NewModeAnsiColorWriter(w io.Writer, mode outputMode) io.Writer {
	if _, ok := w.(*ansiColorWriter); !ok {
		return &ansiColorWriter{
			w:    w,
			mode: mode,
		}
	}
	return w
}
