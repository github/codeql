package types

import "github.com/go-pg/pg/v10/internal/parser"

func AppendJSONB(b, jsonb []byte, flags int) []byte {
	if hasFlag(flags, arrayFlag) {
		b = append(b, '"')
	} else if hasFlag(flags, quoteFlag) {
		b = append(b, '\'')
	}

	p := parser.New(jsonb)
	for p.Valid() {
		c := p.Read()
		switch c {
		case '"':
			if hasFlag(flags, arrayFlag) {
				b = append(b, '\\')
			}
			b = append(b, '"')
		case '\'':
			if hasFlag(flags, quoteFlag) {
				b = append(b, '\'')
			}
			b = append(b, '\'')
		case '\000':
			continue
		case '\\':
			if p.SkipBytes([]byte("u0000")) {
				b = append(b, "\\\\u0000"...)
			} else {
				b = append(b, '\\')
				if p.Valid() {
					b = append(b, p.Read())
				}
			}
		default:
			b = append(b, c)
		}
	}

	if hasFlag(flags, arrayFlag) {
		b = append(b, '"')
	} else if hasFlag(flags, quoteFlag) {
		b = append(b, '\'')
	}

	return b
}
