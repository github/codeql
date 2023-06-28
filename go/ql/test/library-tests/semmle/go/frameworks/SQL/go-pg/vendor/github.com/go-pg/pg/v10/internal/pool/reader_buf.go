// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package pool

import (
	"bufio"
	"bytes"
	"io"
)

type BufReader struct {
	rd io.Reader // reader provided by the client

	buf       []byte
	r, w      int // buf read and write positions
	lastByte  int
	bytesRead int64
	err       error

	available int         // bytes available for reading
	brd       BytesReader // reusable bytes reader
}

func NewBufReader(bufSize int) *BufReader {
	return &BufReader{
		buf:       make([]byte, bufSize),
		available: -1,
	}
}

func (b *BufReader) BytesReader(n int) *BytesReader {
	if n == -1 {
		n = 0
	}
	buf := b.buf[b.r : b.r+n]
	b.r += n
	b.brd.Reset(buf)
	return &b.brd
}

func (b *BufReader) SetAvailable(n int) {
	b.available = n
}

func (b *BufReader) Available() int {
	return b.available
}

func (b *BufReader) changeAvailable(n int) {
	if b.available != -1 {
		b.available += n
	}
}

func (b *BufReader) Reset(rd io.Reader) {
	b.rd = rd
	b.r, b.w = 0, 0
	b.err = nil
}

// Buffered returns the number of bytes that can be read from the current buffer.
func (b *BufReader) Buffered() int {
	buffered := b.w - b.r
	if b.available == -1 || buffered <= b.available {
		return buffered
	}
	return b.available
}

func (b *BufReader) Bytes() []byte {
	if b.available == -1 {
		return b.buf[b.r:b.w]
	}
	w := b.r + b.available
	if w > b.w {
		w = b.w
	}
	return b.buf[b.r:w]
}

func (b *BufReader) flush() []byte {
	if b.available == -1 {
		buf := b.buf[b.r:b.w]
		b.r = b.w
		return buf
	}

	w := b.r + b.available
	if w > b.w {
		w = b.w
	}
	buf := b.buf[b.r:w]
	b.r = w
	b.changeAvailable(-len(buf))
	return buf
}

// fill reads a new chunk into the buffer.
func (b *BufReader) fill() {
	// Slide existing data to beginning.
	if b.r > 0 {
		copy(b.buf, b.buf[b.r:b.w])
		b.w -= b.r
		b.r = 0
	}

	if b.w >= len(b.buf) {
		panic("bufio: tried to fill full buffer")
	}
	if b.available == 0 {
		b.err = io.EOF
		return
	}

	// Read new data: try a limited number of times.
	const maxConsecutiveEmptyReads = 100
	for i := maxConsecutiveEmptyReads; i > 0; i-- {
		n, err := b.read(b.buf[b.w:])
		b.w += n
		if err != nil {
			b.err = err
			return
		}
		if n > 0 {
			return
		}
	}
	b.err = io.ErrNoProgress
}

func (b *BufReader) readErr() error {
	err := b.err
	b.err = nil
	return err
}

func (b *BufReader) Read(p []byte) (n int, err error) {
	if len(p) == 0 {
		return 0, b.readErr()
	}

	if b.available != -1 {
		if b.available == 0 {
			return 0, io.EOF
		}
		if len(p) > b.available {
			p = p[:b.available]
		}
	}

	if b.r == b.w {
		if b.err != nil {
			return 0, b.readErr()
		}

		if len(p) >= len(b.buf) {
			// Large read, empty buffer.
			// Read directly into p to avoid copy.
			n, err = b.read(p)
			if n > 0 {
				b.changeAvailable(-n)
				b.lastByte = int(p[n-1])
			}
			return n, err
		}

		// One read.
		// Do not use b.fill, which will loop.
		b.r = 0
		b.w = 0
		n, b.err = b.read(b.buf)
		if n == 0 {
			return 0, b.readErr()
		}
		b.w += n
	}

	// copy as much as we can
	n = copy(p, b.Bytes())
	b.r += n
	b.changeAvailable(-n)
	b.lastByte = int(b.buf[b.r-1])
	return n, nil
}

// ReadSlice reads until the first occurrence of delim in the input,
// returning a slice pointing at the bytes in the buffer.
// The bytes stop being valid at the next read.
// If ReadSlice encounters an error before finding a delimiter,
// it returns all the data in the buffer and the error itself (often io.EOF).
// ReadSlice fails with error ErrBufferFull if the buffer fills without a delim.
// Because the data returned from ReadSlice will be overwritten
// by the next I/O operation, most clients should use
// ReadBytes or ReadString instead.
// ReadSlice returns err != nil if and only if line does not end in delim.
func (b *BufReader) ReadSlice(delim byte) (line []byte, err error) {
	for {
		// Search buffer.
		if i := bytes.IndexByte(b.Bytes(), delim); i >= 0 {
			i++
			line = b.buf[b.r : b.r+i]
			b.r += i
			b.changeAvailable(-i)
			break
		}

		// Pending error?
		if b.err != nil {
			line = b.flush()
			err = b.readErr()
			break
		}

		buffered := b.Buffered()

		// Out of available.
		if b.available != -1 && buffered >= b.available {
			line = b.flush()
			err = io.EOF
			break
		}

		// Buffer full?
		if buffered >= len(b.buf) {
			line = b.flush()
			err = bufio.ErrBufferFull
			break
		}

		b.fill() // buffer is not full
	}

	// Handle last byte, if any.
	if i := len(line) - 1; i >= 0 {
		b.lastByte = int(line[i])
	}

	return line, err
}

func (b *BufReader) ReadBytes(fn func(byte) bool) (line []byte, err error) {
	for {
		for i, c := range b.Bytes() {
			if !fn(c) {
				i--
				line = b.buf[b.r : b.r+i] //nolint
				b.r += i
				b.changeAvailable(-i)
				break
			}
		}

		// Pending error?
		if b.err != nil {
			line = b.flush()
			err = b.readErr()
			break
		}

		buffered := b.Buffered()

		// Out of available.
		if b.available != -1 && buffered >= b.available {
			line = b.flush()
			err = io.EOF
			break
		}

		// Buffer full?
		if buffered >= len(b.buf) {
			line = b.flush()
			err = bufio.ErrBufferFull
			break
		}

		b.fill() // buffer is not full
	}

	// Handle last byte, if any.
	if i := len(line) - 1; i >= 0 {
		b.lastByte = int(line[i])
	}

	return line, err
}

func (b *BufReader) ReadByte() (byte, error) {
	if b.available == 0 {
		return 0, io.EOF
	}
	for b.r == b.w {
		if b.err != nil {
			return 0, b.readErr()
		}
		b.fill() // buffer is empty
	}
	c := b.buf[b.r]
	b.r++
	b.lastByte = int(c)
	b.changeAvailable(-1)
	return c, nil
}

func (b *BufReader) UnreadByte() error {
	if b.lastByte < 0 || b.r == 0 && b.w > 0 {
		return bufio.ErrInvalidUnreadByte
	}
	// b.r > 0 || b.w == 0
	if b.r > 0 {
		b.r--
	} else {
		// b.r == 0 && b.w == 0
		b.w = 1
	}
	b.buf[b.r] = byte(b.lastByte)
	b.lastByte = -1
	b.changeAvailable(+1)
	return nil
}

// Discard skips the next n bytes, returning the number of bytes discarded.
//
// If Discard skips fewer than n bytes, it also returns an error.
// If 0 <= n <= b.Buffered(), Discard is guaranteed to succeed without
// reading from the underlying io.BufReader.
func (b *BufReader) Discard(n int) (discarded int, err error) {
	if n < 0 {
		return 0, bufio.ErrNegativeCount
	}
	if n == 0 {
		return
	}
	remain := n
	for {
		skip := b.Buffered()
		if skip == 0 {
			b.fill()
			skip = b.Buffered()
		}
		if skip > remain {
			skip = remain
		}
		b.r += skip
		b.changeAvailable(-skip)
		remain -= skip
		if remain == 0 {
			return n, nil
		}
		if b.err != nil {
			return n - remain, b.readErr()
		}
	}
}

func (b *BufReader) ReadN(n int) (line []byte, err error) {
	if n < 0 {
		return nil, bufio.ErrNegativeCount
	}
	if n == 0 {
		return
	}

	nn := n
	if b.available != -1 && nn > b.available {
		nn = b.available
	}

	for {
		buffered := b.Buffered()

		if buffered >= nn {
			line = b.buf[b.r : b.r+nn]
			b.r += nn
			b.changeAvailable(-nn)
			if n > nn {
				err = io.EOF
			}
			break
		}

		// Pending error?
		if b.err != nil {
			line = b.flush()
			err = b.readErr()
			break
		}

		// Buffer full?
		if buffered >= len(b.buf) {
			line = b.flush()
			err = bufio.ErrBufferFull
			break
		}

		b.fill() // buffer is not full
	}

	// Handle last byte, if any.
	if i := len(line) - 1; i >= 0 {
		b.lastByte = int(line[i])
	}

	return line, err
}

func (b *BufReader) ReadFull() ([]byte, error) {
	if b.available == -1 {
		panic("not reached")
	}
	buf := make([]byte, b.available)
	_, err := io.ReadFull(b, buf)
	return buf, err
}

func (b *BufReader) ReadFullTemp() ([]byte, error) {
	if b.available == -1 {
		panic("not reached")
	}
	if b.available <= len(b.buf) {
		return b.ReadN(b.available)
	}
	return b.ReadFull()
}

func (b *BufReader) read(buf []byte) (int, error) {
	n, err := b.rd.Read(buf)
	b.bytesRead += int64(n)
	return n, err
}
