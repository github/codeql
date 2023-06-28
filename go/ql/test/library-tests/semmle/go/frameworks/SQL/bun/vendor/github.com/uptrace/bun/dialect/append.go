package dialect

import (
	"math"
	"strconv"

	"github.com/uptrace/bun/internal"
)

func AppendError(b []byte, err error) []byte {
	b = append(b, "?!("...)
	b = append(b, err.Error()...)
	b = append(b, ')')
	return b
}

func AppendNull(b []byte) []byte {
	return append(b, "NULL"...)
}

func AppendBool(b []byte, v bool) []byte {
	if v {
		return append(b, "TRUE"...)
	}
	return append(b, "FALSE"...)
}

func AppendFloat32(b []byte, v float32) []byte {
	return appendFloat(b, float64(v), 32)
}

func AppendFloat64(b []byte, v float64) []byte {
	return appendFloat(b, v, 64)
}

func appendFloat(b []byte, v float64, bitSize int) []byte {
	switch {
	case math.IsNaN(v):
		return append(b, "'NaN'"...)
	case math.IsInf(v, 1):
		return append(b, "'Infinity'"...)
	case math.IsInf(v, -1):
		return append(b, "'-Infinity'"...)
	default:
		return strconv.AppendFloat(b, v, 'f', -1, bitSize)
	}
}

//------------------------------------------------------------------------------

func AppendIdent(b []byte, field string, quote byte) []byte {
	return appendIdent(b, internal.Bytes(field), quote)
}

func appendIdent(b, src []byte, quote byte) []byte {
	var quoted bool
loop:
	for _, c := range src {
		switch c {
		case '*':
			if !quoted {
				b = append(b, '*')
				continue loop
			}
		case '.':
			if quoted {
				b = append(b, quote)
				quoted = false
			}
			b = append(b, '.')
			continue loop
		}

		if !quoted {
			b = append(b, quote)
			quoted = true
		}
		if c == quote {
			b = append(b, quote, quote)
		} else {
			b = append(b, c)
		}
	}
	if quoted {
		b = append(b, quote)
	}
	return b
}
