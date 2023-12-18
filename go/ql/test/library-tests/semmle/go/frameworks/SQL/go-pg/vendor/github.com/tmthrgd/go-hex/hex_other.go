// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build !amd64 gccgo appengine

package hex

// RawEncode encodes src into EncodedLen(len(src))
// bytes of dst.  As a convenience, it returns the number
// of bytes written to dst, but this value is always EncodedLen(len(src)).
// RawEncode implements hexadecimal encoding for a given alphabet.
func RawEncode(dst, src, alpha []byte) int {
	if len(alpha) != 16 {
		panic("invalid alphabet")
	}

	encodeGeneric(dst, src, alpha)
	return len(src) * 2
}

// Decode decodes src into DecodedLen(len(src)) bytes, returning the actual
// number of bytes written to dst.
//
// If Decode encounters invalid input, it returns an error describing the failure.
func Decode(dst, src []byte) (int, error) {
	if len(src)%2 == 1 {
		return 0, errLength
	}

	if n, ok := decodeGeneric(dst, src); !ok {
		return 0, InvalidByteError(src[n])
	}

	return len(src) / 2, nil
}
