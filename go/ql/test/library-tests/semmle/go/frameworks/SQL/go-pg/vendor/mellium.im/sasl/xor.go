// Copyright 2022 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build !go1.20

package sasl

// TODO: remove all the specialized XOR code and use "crypto/subtle".XORBytes
// when Go v1.21 comes out. For more information see:
// https://mellium.im/issue/338

func goXORBytes(dst, x, y []byte) int {
	n := len(x)
	if len(y) < n {
		n = len(y)
	}
	if n == 0 {
		return 0
	}
	if n > len(dst) {
		panic("subtle.XORBytes: dst too short")
	}
	xorBytes(&dst[0], &x[0], &y[0], n) // arch-specific
	return n
}
