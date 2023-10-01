// MIT License
//
// Copyright (c) 2017 José Santos <henrique_1609@me.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package fastprinter

import (
	"fmt"
	"io"
	"reflect"
	"sync"
)

const (
	stringBufferSize  = 4096
	integerBufferSize = 20
)

var (
	_trueBytes  = ([]byte)("true")
	_falseBytes = ([]byte)("false")

	pool_integerBuffer = newByteSliceBufferPool(integerBufferSize)
	pool_stringBuffer  = newByteSliceBufferPool(stringBufferSize)

	errorType       = reflect.TypeOf((*error)(nil)).Elem()
	fmtStringerType = reflect.TypeOf((*fmt.Stringer)(nil)).Elem()
)

type byteSliceBuffer struct {
	bytes []byte
}

func newByteSliceBufferPool(size int) sync.Pool {
	return sync.Pool{
		New: func() interface{} {
			return &byteSliceBuffer{make([]byte, size, size)}
		},
	}
}

func Print(w io.Writer, i interface{}) (int, error) {
	return PrintValue(w, reflect.ValueOf(i))
}

func PrintPtr(w io.Writer, i interface{}) (int, error) {
	return PrintValue(w, reflect.ValueOf(i).Elem())
}

func PrintBool(w io.Writer, b bool) (int, error) {
	if b {
		return w.Write(_trueBytes)
	}
	return w.Write(_falseBytes)
}

func PrintString(ww io.Writer, st string) (c int, err error) {
	if st == "" {
		return 0, nil
	}

	numI := len(st) / stringBufferSize
	nextBucket := 0
	written := 0

	a := pool_stringBuffer.Get().(*byteSliceBuffer)
	for i := 0; i < numI; i++ {
		copy(a.bytes[:], st[nextBucket:nextBucket+stringBufferSize])
		nextBucket += stringBufferSize
		written, err = ww.Write(a.bytes[:])
		c += written
		if err != nil {
			return
		}
	}

	smallBucket := len(st) % stringBufferSize
	if smallBucket > 0 {
		copy(a.bytes[:], st[nextBucket:])
		written, err = ww.Write(a.bytes[:smallBucket])
		c += written
	}
	pool_stringBuffer.Put(a)
	return
}

func PrintUint(w io.Writer, i uint64) (int, error) {
	return formatBits(w, i, false)
}

func PrintInt(w io.Writer, i int64) (int, error) {
	return formatBits(w, uint64(i), i < 0)
}

// formatBits computes the string representation of u in the given base.
// If neg is set, u is treated as negative int64 value.
// Extracted from std package strconv
func formatBits(dst io.Writer, u uint64, neg bool) (int, error) {

	var a = pool_integerBuffer.Get().(*byteSliceBuffer)

	i := integerBufferSize

	if neg {
		u = -u
	}

	// common case: use constants for / because
	// the compiler can optimize it into a multiply+shift

	if ^uintptr(0)>>32 == 0 {
		for u > uint64(^uintptr(0)) {
			q := u / 1e9
			us := uintptr(u - q*1e9) // us % 1e9 fits into a uintptr
			for j := 9; j > 0; j-- {
				i--
				qs := us / 10
				a.bytes[i] = byte(us - qs*10 + '0')
				us = qs
			}
			u = q
		}
	}

	// u guaranteed to fit into a uintptr
	us := uintptr(u)
	for us >= 10 {
		i--
		q := us / 10
		a.bytes[i] = byte(us - q*10 + '0')
		us = q
	}
	// u < 10
	i--
	a.bytes[i] = byte(us + '0')

	// add sign, if any
	if neg {
		i--
		a.bytes[i] = '-'
	}
	counter, err := dst.Write(a.bytes[i:])
	pool_integerBuffer.Put(a)
	return counter, err
}

// PrintValue prints a reflect.Value
func PrintValue(w io.Writer, v reflect.Value) (int, error) {
	v = maybeDereference(v, 2)

	if v.Type().Implements(fmtStringerType) {
		return PrintString(w, v.Interface().(fmt.Stringer).String())
	}

	if v.Type().Implements(errorType) {
		return PrintString(w, v.Interface().(error).Error())
	}

	k := v.Kind()

	if k == reflect.String {
		return PrintString(w, v.String())
	}

	if k >= reflect.Int && k <= reflect.Int64 {
		return PrintInt(w, v.Int())
	}

	if k >= reflect.Uint && k <= reflect.Uint64 {
		return PrintUint(w, v.Uint())
	}

	if k == reflect.Float64 || k == reflect.Float32 {
		return PrintFloat(w, v.Float())
	}

	if k == reflect.Bool {
		return PrintBool(w, v.Bool())
	}

	if k == reflect.Slice && v.Type().Elem().Kind() == reflect.Uint8 {
		return w.Write(v.Bytes())
	}

	return fmt.Fprint(w, v.Interface())
}

// dereference a certain depth of pointer indirection
func maybeDereference(v reflect.Value, depth int) reflect.Value {
	if depth <= 0 {
		return v
	}

	if !v.IsValid() {
		return v
	}

	if v.Kind() != reflect.Ptr || v.IsNil() {
		return v
	}

	if v.Type().Implements(fmtStringerType) || v.Type().Implements(errorType) {
		return v
	}

	return maybeDereference(reflect.Indirect(v), depth-1)
}
