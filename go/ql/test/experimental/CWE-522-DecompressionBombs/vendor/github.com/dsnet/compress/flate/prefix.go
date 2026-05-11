// Copyright 2015, Joe Tsai. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE.md file.

package flate

import (
	"io"

	"github.com/dsnet/compress/internal/errors"
	"github.com/dsnet/compress/internal/prefix"
)

const (
	maxPrefixBits = 15

	maxNumCLenSyms = 19
	maxNumLitSyms  = 286
	maxNumDistSyms = 30
)

// RFC section 3.2.5.
var lenRanges = func() prefix.RangeCodes {
	return append(prefix.MakeRangeCodes(3, []uint{
		0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5,
	}), prefix.RangeCode{Base: 258, Len: 0})
}()
var distRanges = func() prefix.RangeCodes {
	return prefix.MakeRangeCodes(1, []uint{
		0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13,
	})
}()

// RFC section 3.2.6.
var encLit, decLit = func() (e prefix.Encoder, d prefix.Decoder) {
	var litCodes [288]prefix.PrefixCode
	for i := 0; i < 144; i++ {
		litCodes[i] = prefix.PrefixCode{Sym: uint32(i), Len: 8}
	}
	for i := 144; i < 256; i++ {
		litCodes[i] = prefix.PrefixCode{Sym: uint32(i), Len: 9}
	}
	for i := 256; i < 280; i++ {
		litCodes[i] = prefix.PrefixCode{Sym: uint32(i), Len: 7}
	}
	for i := 280; i < 288; i++ {
		litCodes[i] = prefix.PrefixCode{Sym: uint32(i), Len: 8}
	}
	prefix.GeneratePrefixes(litCodes[:])
	e.Init(litCodes[:])
	d.Init(litCodes[:])
	return
}()
var encDist, decDist = func() (e prefix.Encoder, d prefix.Decoder) {
	var distCodes [32]prefix.PrefixCode
	for i := 0; i < 32; i++ {
		distCodes[i] = prefix.PrefixCode{Sym: uint32(i), Len: 5}
	}
	prefix.GeneratePrefixes(distCodes[:])
	e.Init(distCodes[:])
	d.Init(distCodes[:])
	return
}()

// RFC section 3.2.7.
// Prefix code lengths for code lengths alphabet.
var clenLens = [maxNumCLenSyms]uint{
	16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15,
}

type prefixReader struct {
	prefix.Reader

	clenTree prefix.Decoder
}

func (pr *prefixReader) Init(r io.Reader) {
	pr.Reader.Init(r, false)
}

// ReadPrefixCodes reads the literal and distance prefix codes according to
// RFC section 3.2.7.
func (pr *prefixReader) ReadPrefixCodes(hl, hd *prefix.Decoder) {
	numLitSyms := pr.ReadBits(5) + 257
	numDistSyms := pr.ReadBits(5) + 1
	numCLenSyms := pr.ReadBits(4) + 4
	if numLitSyms > maxNumLitSyms || numDistSyms > maxNumDistSyms {
		panicf(errors.Corrupted, "invalid number of prefix symbols")
	}

	// Read the code-lengths prefix table.
	var codeCLensArr [maxNumCLenSyms]prefix.PrefixCode // Sorted, but may have holes
	for _, sym := range clenLens[:numCLenSyms] {
		clen := pr.ReadBits(3)
		if clen > 0 {
			codeCLensArr[sym] = prefix.PrefixCode{Sym: uint32(sym), Len: uint32(clen)}
		}
	}
	codeCLens := codeCLensArr[:0] // Compact the array to have no holes
	for _, c := range codeCLensArr {
		if c.Len > 0 {
			codeCLens = append(codeCLens, c)
		}
	}
	codeCLens = handleDegenerateCodes(codeCLens, maxNumCLenSyms)
	if err := prefix.GeneratePrefixes(codeCLens); err != nil {
		errors.Panic(err)
	}
	pr.clenTree.Init(codeCLens)

	// Use code-lengths table to decode HLIT and HDIST prefix tables.
	var codesArr [maxNumLitSyms + maxNumDistSyms]prefix.PrefixCode
	var clenLast uint
	codeLits := codesArr[:0]
	codeDists := codesArr[maxNumLitSyms:maxNumLitSyms]
	appendCode := func(sym, clen uint) {
		if sym < numLitSyms {
			pc := prefix.PrefixCode{Sym: uint32(sym), Len: uint32(clen)}
			codeLits = append(codeLits, pc)
		} else {
			pc := prefix.PrefixCode{Sym: uint32(sym - numLitSyms), Len: uint32(clen)}
			codeDists = append(codeDists, pc)
		}
	}
	for sym, maxSyms := uint(0), numLitSyms+numDistSyms; sym < maxSyms; {
		clen := pr.ReadSymbol(&pr.clenTree)
		if clen < 16 {
			// Literal bit-length symbol used.
			if clen > 0 {
				appendCode(sym, clen)
			}
			clenLast = clen
			sym++
		} else {
			// Repeater symbol used.
			var repCnt uint
			switch repSym := clen; repSym {
			case 16:
				if sym == 0 {
					panicf(errors.Corrupted, "invalid first use of repeator code")
				}
				clen = clenLast
				repCnt = 3 + pr.ReadBits(2)
			case 17:
				clen = 0
				repCnt = 3 + pr.ReadBits(3)
			case 18:
				clen = 0
				repCnt = 11 + pr.ReadBits(7)
			default:
				panicf(errors.Corrupted, "invalid code symbol: %d", clen)
			}

			if clen > 0 {
				for symEnd := sym + repCnt; sym < symEnd; sym++ {
					appendCode(sym, clen)
				}
			} else {
				sym += repCnt
			}
			if sym > maxSyms {
				panicf(errors.Corrupted, "excessive number of code symbols")
			}
		}
	}

	codeLits = handleDegenerateCodes(codeLits, maxNumLitSyms)
	if err := prefix.GeneratePrefixes(codeLits); err != nil {
		errors.Panic(err)
	}
	hl.Init(codeLits)

	codeDists = handleDegenerateCodes(codeDists, maxNumDistSyms)
	if err := prefix.GeneratePrefixes(codeDists); err != nil {
		errors.Panic(err)
	}
	hd.Init(codeDists)

	// As an optimization, we can initialize minBits to read at a time for the
	// HLIT tree to the length of the EOB marker since we know that every block
	// must terminate with one. This preserves the property that we never read
	// any extra bytes after the end of the DEFLATE stream.
	//
	// This optimization is not helpful if the underlying reader is a
	// compress.BufferedReader since PullBits always fill the entire bit buffer.
	if !pr.IsBufferedReader() {
		for i := len(codeLits) - 1; i >= 0; i-- {
			if codeLits[i].Sym == 256 && codeLits[i].Len > 0 {
				hl.MinBits = codeLits[i].Len
				break
			}
		}
	}
}

// RFC section 3.2.7 allows degenerate prefix trees with only node, but requires
// a single bit for that node. This causes an unbalanced tree where the "1" code
// is unused. The canonical prefix code generation algorithm breaks with this.
//
// To handle this case, we artificially insert another node for the "1" code
// that uses a symbol larger than the alphabet to force an error later if
// the code ends up getting used.
func handleDegenerateCodes(codes prefix.PrefixCodes, maxSyms uint) prefix.PrefixCodes {
	if len(codes) != 1 {
		return codes
	}
	return append(codes, prefix.PrefixCode{Sym: uint32(maxSyms), Len: 1})
}
