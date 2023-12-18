package types

import "github.com/go-pg/pg/v10/internal"

func AppendIdent(b []byte, field string, flags int) []byte {
	return appendIdent(b, internal.StringToBytes(field), flags)
}

func AppendIdentBytes(b []byte, field []byte, flags int) []byte {
	return appendIdent(b, field, flags)
}

func appendIdent(b, src []byte, flags int) []byte {
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
			if quoted && hasFlag(flags, quoteFlag) {
				b = append(b, '"')
				quoted = false
			}
			b = append(b, '.')
			continue loop
		}

		if !quoted && hasFlag(flags, quoteFlag) {
			b = append(b, '"')
			quoted = true
		}
		if c == '"' {
			b = append(b, '"', '"')
		} else {
			b = append(b, c)
		}
	}
	if quoted && hasFlag(flags, quoteFlag) {
		b = append(b, '"')
	}
	return b
}
