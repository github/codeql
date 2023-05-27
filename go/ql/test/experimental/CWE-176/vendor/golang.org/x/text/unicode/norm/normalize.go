// Copyright 2011 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package norm contains types and functions for normalizing Unicode strings.
package norm // import "golang.org/x/text/unicode/norm"

// A Form denotes a canonical representation of Unicode code points.
// The Unicode-defined normalization and equivalence forms are:
//
//	NFC   Unicode Normalization Form C
//	NFD   Unicode Normalization Form D
//	NFKC  Unicode Normalization Form KC
//	NFKD  Unicode Normalization Form KD
//
// For a Form f, this documentation uses the notation f(x) to mean
// the bytes or string x converted to the given form.
// A position n in x is called a boundary if conversion to the form can
// proceed independently on both sides:
//
//	f(x) == append(f(x[0:n]), f(x[n:])...)
//
// References: https://unicode.org/reports/tr15/ and
// https://unicode.org/notes/tn5/.
type Form int

const (
	NFC Form = iota
	NFD
	NFKC
	NFKD
)

// String returns f(s).
func (f Form) String(s string) string {
	return ""
}
