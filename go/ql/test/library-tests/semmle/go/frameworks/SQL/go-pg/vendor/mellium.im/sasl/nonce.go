// Copyright 2016 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

package sasl

import (
	"encoding/base64"
	"io"
)

// Generates a nonce with n random bytes base64 encoded to ensure that it meets
// the criteria for inclusion in a SCRAM message.
func nonce(n int, r io.Reader) []byte {
	if n < 1 {
		panic("Cannot generate zero or negative length nonce")
	}
	b := make([]byte, n)
	n2, err := r.Read(b)
	switch {
	case err != nil:
		panic(err)
	case n2 != n:
		panic("Could not read enough randomness to generate nonce")
	}
	val := make([]byte, base64.RawStdEncoding.EncodedLen(n))
	base64.RawStdEncoding.Encode(val, b)

	return val
}
