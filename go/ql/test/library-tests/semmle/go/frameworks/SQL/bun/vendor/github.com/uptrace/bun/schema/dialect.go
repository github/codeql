package schema

import (
	"database/sql"
	"encoding/hex"
	"strconv"
	"time"
	"unicode/utf8"

	"github.com/uptrace/bun/dialect"
	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/internal/parser"
)

type Dialect interface {
	Init(db *sql.DB)

	Name() dialect.Name
	Features() feature.Feature

	Tables() *Tables
	OnTable(table *Table)

	IdentQuote() byte

	AppendUint32(b []byte, n uint32) []byte
	AppendUint64(b []byte, n uint64) []byte
	AppendTime(b []byte, tm time.Time) []byte
	AppendString(b []byte, s string) []byte
	AppendBytes(b []byte, bs []byte) []byte
	AppendJSON(b, jsonb []byte) []byte
	AppendBool(b []byte, v bool) []byte

	// DefaultVarcharLen should be returned for dialects in which specifying VARCHAR length
	// is mandatory in queries that modify the schema (CREATE TABLE / ADD COLUMN, etc).
	// Dialects that do not have such requirement may return 0, which should be interpreted so by the caller.
	DefaultVarcharLen() int
}

// ------------------------------------------------------------------------------

type BaseDialect struct{}

func (BaseDialect) AppendUint32(b []byte, n uint32) []byte {
	return strconv.AppendUint(b, uint64(n), 10)
}

func (BaseDialect) AppendUint64(b []byte, n uint64) []byte {
	return strconv.AppendUint(b, n, 10)
}

func (BaseDialect) AppendTime(b []byte, tm time.Time) []byte {
	b = append(b, '\'')
	b = tm.UTC().AppendFormat(b, "2006-01-02 15:04:05.999999-07:00")
	b = append(b, '\'')
	return b
}

func (BaseDialect) AppendString(b []byte, s string) []byte {
	b = append(b, '\'')
	for _, r := range s {
		if r == '\000' {
			continue
		}

		if r == '\'' {
			b = append(b, '\'', '\'')
			continue
		}

		if r < utf8.RuneSelf {
			b = append(b, byte(r))
			continue
		}

		l := len(b)
		if cap(b)-l < utf8.UTFMax {
			b = append(b, make([]byte, utf8.UTFMax)...)
		}
		n := utf8.EncodeRune(b[l:l+utf8.UTFMax], r)
		b = b[:l+n]
	}
	b = append(b, '\'')
	return b
}

func (BaseDialect) AppendBytes(b, bs []byte) []byte {
	if bs == nil {
		return dialect.AppendNull(b)
	}

	b = append(b, `'\x`...)

	s := len(b)
	b = append(b, make([]byte, hex.EncodedLen(len(bs)))...)
	hex.Encode(b[s:], bs)

	b = append(b, '\'')

	return b
}

func (BaseDialect) AppendJSON(b, jsonb []byte) []byte {
	b = append(b, '\'')

	p := parser.New(jsonb)
	for p.Valid() {
		c := p.Read()
		switch c {
		case '"':
			b = append(b, '"')
		case '\'':
			b = append(b, "''"...)
		case '\000':
			continue
		case '\\':
			if p.SkipBytes([]byte("u0000")) {
				b = append(b, `\\u0000`...)
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

	b = append(b, '\'')

	return b
}

func (BaseDialect) AppendBool(b []byte, v bool) []byte {
	return dialect.AppendBool(b, v)
}

// ------------------------------------------------------------------------------

type nopDialect struct {
	BaseDialect

	tables   *Tables
	features feature.Feature
}

func newNopDialect() *nopDialect {
	d := new(nopDialect)
	d.tables = NewTables(d)
	d.features = feature.Returning
	return d
}

func (d *nopDialect) Init(*sql.DB) {}

func (d *nopDialect) Name() dialect.Name {
	return dialect.Invalid
}

func (d *nopDialect) Features() feature.Feature {
	return d.features
}

func (d *nopDialect) Tables() *Tables {
	return d.tables
}

func (d *nopDialect) OnField(field *Field) {}

func (d *nopDialect) OnTable(table *Table) {}

func (d *nopDialect) IdentQuote() byte {
	return '"'
}

func (d *nopDialect) DefaultVarcharLen() int {
	return 0
}
