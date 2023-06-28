// Copyright 2016 Tom Thorogood. All rights reserved.
// Use of this source code is governed by a
// Modified BSD License license that can be found in
// the LICENSE file.

// +build amd64,!gccgo,!appengine

package hex

import "golang.org/x/sys/cpu"

// RawEncode encodes src into EncodedLen(len(src))
// bytes of dst.  As a convenience, it returns the number
// of bytes written to dst, but this value is always EncodedLen(len(src)).
// RawEncode implements hexadecimal encoding for a given alphabet.
func RawEncode(dst, src, alpha []byte) int {
	if len(alpha) != 16 {
		panic("invalid alphabet")
	}

	if len(dst) < len(src)*2 {
		panic("dst buffer is too small")
	}

	if len(src) == 0 {
		return 0
	}

	switch {
	case cpu.X86.HasAVX:
		encodeAVX(&dst[0], &src[0], uint64(len(src)), &alpha[0])
	case cpu.X86.HasSSE41:
		encodeSSE(&dst[0], &src[0], uint64(len(src)), &alpha[0])
	default:
		encodeGeneric(dst, src, alpha)
	}

	return len(src) * 2
}

// Decode decodes src into DecodedLen(len(src)) bytes, returning the actual
// number of bytes written to dst.
//
// If Decode encounters invalid input, it returns an error describing the failure.
func Decode(dst, src []byte) (int, error) {
	if len(src)%2 != 0 {
		return 0, errLength
	}

	if len(dst) < len(src)/2 {
		panic("dst buffer is too small")
	}

	if len(src) == 0 {
		return 0, nil
	}

	var (
		n  uint64
		ok bool
	)
	switch {
	case cpu.X86.HasAVX:
		n, ok = decodeAVX(&dst[0], &src[0], uint64(len(src)))
	case cpu.X86.HasSSE41:
		n, ok = decodeSSE(&dst[0], &src[0], uint64(len(src)))
	default:
		n, ok = decodeGeneric(dst, src)
	}

	if !ok {
		return 0, InvalidByteError(src[n])
	}

	return len(src) / 2, nil
}

//go:generate go run asm_gen.go

// This function is implemented in hex_encode_amd64.s
//go:noescape
func encodeAVX(dst *byte, src *byte, len uint64, alpha *byte)

// This function is implemented in hex_encode_amd64.s
//go:noescape
func encodeSSE(dst *byte, src *byte, len uint64, alpha *byte)

// This function is implemented in hex_decode_amd64.s
//go:noescape
func decodeAVX(dst *byte, src *byte, len uint64) (n uint64, ok bool)

// This function is implemented in hex_decode_amd64.s
//go:noescape
func decodeSSE(dst *byte, src *byte, len uint64) (n uint64, ok bool)
