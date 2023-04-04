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
	"io"
	"math"
)

type floatInfo struct {
	mantbits uint
	expbits  uint
	bias     int
}

var (
	float64info      = floatInfo{52, 11, -1023}
	floatNaN         = []byte("Nan")
	floatNinf        = []byte("-Inf")
	floatPinf        = []byte("+Inf")
	pool_floatBuffer = newByteSliceBufferPool(800)
)

func PrintFloat(w io.Writer, f float64) (int, error) {
	return PrintFloatPrecision(w, f, -1)
}

func PrintFloatPrecision(dst io.Writer, val float64, prec int) (int, error) {
	var bits uint64
	var flt *floatInfo

	bits = math.Float64bits(val)
	flt = &float64info

	neg := bits>>(flt.expbits+flt.mantbits) != 0
	exp := int(bits>>flt.mantbits) & (1<<flt.expbits - 1)
	mant := bits & (uint64(1)<<flt.mantbits - 1)

	switch exp {
	case 1<<flt.expbits - 1:
		switch {
		case mant != 0:
			return dst.Write(floatNaN)
		case neg:
			return dst.Write(floatNinf)
		default:
			return dst.Write(floatPinf)
		}
	case 0:
		// denormalized
		exp++
	default:
		// add implicit top bit
		mant |= uint64(1) << flt.mantbits
	}

	exp += flt.bias
	var digs decimalSlice
	ok := false

	// Negative precision means "only as much as needed to be exact."
	shortest := prec < 0
	if shortest {
		// Try Grisu3 algorithm.
		f := new(extFloat)
		lower, upper := f.AssignComputeBounds(mant, exp, neg, flt)
		var buf [32]byte
		digs.d = buf[:]
		ok = f.ShortestDecimal(&digs, &lower, &upper)
		if !ok {
			return bigFtoa(dst, prec, neg, mant, exp, flt)
		}
		// Precision for shortest representation mode.
		prec = max(digs.nd-digs.dp, 0)
	}
	if !ok {
		return bigFtoa(dst, prec, neg, mant, exp, flt)
	}
	return fmtF(dst, neg, digs, prec)
}

// bigFtoa uses multiprecision computations to format a float.
func bigFtoa(dst io.Writer, prec int, neg bool, mant uint64, exp int, flt *floatInfo) (int, error) {
	d := new(decimal)
	d.Assign(mant)
	d.Shift(exp - int(flt.mantbits))
	var digs decimalSlice
	shortest := prec < 0
	if shortest {
		roundShortest(d, mant, exp, flt)
		digs = decimalSlice{d: d.d[:], nd: d.nd, dp: d.dp}
		prec = max(digs.nd-digs.dp, 0)
	} else {
		d.Round(d.dp + prec)
		digs = decimalSlice{d: d.d[:], nd: d.nd, dp: d.dp}
	}
	return fmtF(dst, neg, digs, prec)
}

// roundShortest rounds d (= mant * 2^exp) to the shortest number of digits
// that will let the original floating point value be precisely reconstructed.
func roundShortest(d *decimal, mant uint64, exp int, flt *floatInfo) {
	// If mantissa is zero, the number is zero; stop now.
	if mant == 0 {
		d.nd = 0
		return
	}

	// Compute upper and lower such that any decimal number
	// between upper and lower (possibly inclusive)
	// will round to the original floating point number.

	// We may see at once that the number is already shortest.
	//
	// Suppose d is not denormal, so that 2^exp <= d < 10^dp.
	// The closest shorter number is at least 10^(dp-nd) away.
	// The lower/upper bounds computed below are at distance
	// at most 2^(exp-mantbits).
	//
	// So the number is already shortest if 10^(dp-nd) > 2^(exp-mantbits),
	// or equivalently log2(10)*(dp-nd) > exp-mantbits.
	// It is true if 332/100*(dp-nd) >= exp-mantbits (log2(10) > 3.32).
	minexp := flt.bias + 1 // minimum possible exponent
	if exp > minexp && 332*(d.dp-d.nd) >= 100*(exp-int(flt.mantbits)) {
		// The number is already shortest.
		return
	}

	// d = mant << (exp - mantbits)
	// Next highest floating point number is mant+1 << exp-mantbits.
	// Our upper bound is halfway between, mant*2+1 << exp-mantbits-1.
	upper := new(decimal)
	upper.Assign(mant*2 + 1)
	upper.Shift(exp - int(flt.mantbits) - 1)

	// d = mant << (exp - mantbits)
	// Next lowest floating point number is mant-1 << exp-mantbits,
	// unless mant-1 drops the significant bit and exp is not the minimum exp,
	// in which case the next lowest is mant*2-1 << exp-mantbits-1.
	// Either way, call it mantlo << explo-mantbits.
	// Our lower bound is halfway between, mantlo*2+1 << explo-mantbits-1.
	var mantlo uint64
	var explo int
	if mant > 1<<flt.mantbits || exp == minexp {
		mantlo = mant - 1
		explo = exp
	} else {
		mantlo = mant*2 - 1
		explo = exp - 1
	}
	lower := new(decimal)
	lower.Assign(mantlo*2 + 1)
	lower.Shift(explo - int(flt.mantbits) - 1)

	// The upper and lower bounds are possible outputs only if
	// the original mantissa is even, so that IEEE round-to-even
	// would round to the original mantissa and not the neighbors.
	inclusive := mant%2 == 0

	// Now we can figure out the minimum number of digits required.
	// Walk along until d has distinguished itself from upper and lower.
	for i := 0; i < d.nd; i++ {
		l := byte('0') // lower digit
		if i < lower.nd {
			l = lower.d[i]
		}
		m := d.d[i]    // middle digit
		u := byte('0') // upper digit
		if i < upper.nd {
			u = upper.d[i]
		}

		// Okay to round down (truncate) if lower has a different digit
		// or if lower is inclusive and is exactly the result of rounding
		// down (i.e., and we have reached the final digit of lower).
		okdown := l != m || inclusive && i+1 == lower.nd

		// Okay to round up if upper has a different digit and either upper
		// is inclusive or upper is bigger than the result of rounding up.
		okup := m != u && (inclusive || m+1 < u || i+1 < upper.nd)

		// If it's okay to do either, then round to the nearest one.
		// If it's okay to do only one, do it.
		switch {
		case okdown && okup:
			d.Round(i + 1)
			return
		case okdown:
			d.RoundDown(i + 1)
			return
		case okup:
			d.RoundUp(i + 1)
			return
		}
	}
}

type decimalSlice struct {
	d      []byte
	nd, dp int
	neg    bool
}

// %f: -ddddddd.ddddd
func fmtF(dst io.Writer, neg bool, d decimalSlice, prec int) (n int, err error) {
	a := pool_floatBuffer.Get().(*byteSliceBuffer)
	i := 0

	// sign
	if neg {
		a.bytes[i] = '-'
		i++
	}
	// integer, padded with zeros as needed.
	if d.dp > 0 {
		m := min(d.nd, d.dp)
		copy(a.bytes[i:], d.d[:m])
		i += m
		for ; m < d.dp; m++ {
			a.bytes[i] = '0'
			i++
		}
	} else {
		a.bytes[i] = '0'
		i++
	}

	// fraction
	if prec > 0 {
		a.bytes[i] = '.'
		i++
		for j := 0; j < prec; j++ {
			ch := byte('0')
			if j := d.dp + j; 0 <= j && j < d.nd {
				ch = d.d[j]
			}
			a.bytes[i] = ch
			i++
		}
	}
	n, err = dst.Write(a.bytes[0:i])
	pool_floatBuffer.Put(a)
	return
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
