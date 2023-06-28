// Copyright 2022 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

//go:build go1.20

package sasl

import (
	"crypto/subtle"
)

func goXORBytes(dst, x, y []byte) int {
	return subtle.XORBytes(dst, x, y)
}
