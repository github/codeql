package strconv

import (
	"math"
)

func ParseDecimal(b []byte) (float64, int) {
	i := 0
	start := i
	dot := -1
	trunk := -1
	n := uint64(0)
	for ; i < len(b); i++ {
		c := b[i]
		if '0' <= c && c <= '9' {
			if trunk == -1 {
				if math.MaxUint64/10 < n {
					trunk = i
				} else {
					n *= 10
					n += uint64(c - '0')
				}
			}
		} else if dot == -1 && c == '.' {
			dot = i
		} else {
			break
		}
	}
	if i == start || i == start+1 && dot == start {
		return 0.0, 0
	}

	f := float64(n)
	mantExp := int64(0)
	if dot != -1 {
		if trunk == -1 {
			trunk = i
		}
		mantExp = int64(trunk - dot - 1)
	} else if trunk != -1 {
		mantExp = int64(trunk - i)
	}
	exp := -mantExp

	// copied from strconv/atof.go
	if exp == 0 {
		return f, i
	} else if 0 < exp && exp <= 15+22 { // int * 10^k
		// If exponent is big but number of digits is not,
		// can move a few zeros into the integer part.
		if 22 < exp {
			f *= float64pow10[exp-22]
			exp = 22
		}
		if -1e15 <= f && f <= 1e15 {
			return f * float64pow10[exp], i
		}
	} else if exp < 0 && -22 <= exp { // int / 10^k
		return f / float64pow10[-exp], i
	}
	return f * math.Pow10(int(-mantExp)), i
}
