package schema

import (
	"reflect"
	"strconv"
	"strings"

	"github.com/uptrace/bun/dialect"
	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/internal/parser"
)

var nopFormatter = Formatter{
	dialect: newNopDialect(),
}

type Formatter struct {
	dialect Dialect
	args    *namedArgList
}

func NewFormatter(dialect Dialect) Formatter {
	return Formatter{
		dialect: dialect,
	}
}

func NewNopFormatter() Formatter {
	return nopFormatter
}

func (f Formatter) IsNop() bool {
	return f.dialect.Name() == dialect.Invalid
}

func (f Formatter) Dialect() Dialect {
	return f.dialect
}

func (f Formatter) IdentQuote() byte {
	return f.dialect.IdentQuote()
}

func (f Formatter) AppendIdent(b []byte, ident string) []byte {
	return dialect.AppendIdent(b, ident, f.IdentQuote())
}

func (f Formatter) AppendValue(b []byte, v reflect.Value) []byte {
	if v.Kind() == reflect.Ptr && v.IsNil() {
		return dialect.AppendNull(b)
	}
	appender := Appender(f.dialect, v.Type())
	return appender(f, b, v)
}

func (f Formatter) HasFeature(feature feature.Feature) bool {
	return f.dialect.Features().Has(feature)
}

func (f Formatter) WithArg(arg NamedArgAppender) Formatter {
	return Formatter{
		dialect: f.dialect,
		args:    f.args.WithArg(arg),
	}
}

func (f Formatter) WithNamedArg(name string, value interface{}) Formatter {
	return Formatter{
		dialect: f.dialect,
		args:    f.args.WithArg(&namedArg{name: name, value: value}),
	}
}

func (f Formatter) FormatQuery(query string, args ...interface{}) string {
	if f.IsNop() || (args == nil && f.args == nil) || strings.IndexByte(query, '?') == -1 {
		return query
	}
	return internal.String(f.AppendQuery(nil, query, args...))
}

func (f Formatter) AppendQuery(dst []byte, query string, args ...interface{}) []byte {
	if f.IsNop() || (args == nil && f.args == nil) || strings.IndexByte(query, '?') == -1 {
		return append(dst, query...)
	}
	return f.append(dst, parser.NewString(query), args)
}

func (f Formatter) append(dst []byte, p *parser.Parser, args []interface{}) []byte {
	var namedArgs NamedArgAppender
	if len(args) == 1 {
		if v, ok := args[0].(NamedArgAppender); ok {
			namedArgs = v
		} else if v, ok := newStructArgs(f, args[0]); ok {
			namedArgs = v
		}
	}

	var argIndex int
	for p.Valid() {
		b, ok := p.ReadSep('?')
		if !ok {
			dst = append(dst, b...)
			continue
		}
		if len(b) > 0 && b[len(b)-1] == '\\' {
			dst = append(dst, b[:len(b)-1]...)
			dst = append(dst, '?')
			continue
		}
		dst = append(dst, b...)

		name, numeric := p.ReadIdentifier()
		if name != "" {
			if numeric {
				idx, err := strconv.Atoi(name)
				if err != nil {
					goto restore_arg
				}

				if idx >= len(args) {
					goto restore_arg
				}

				dst = f.appendArg(dst, args[idx])
				continue
			}

			if namedArgs != nil {
				dst, ok = namedArgs.AppendNamedArg(f, dst, name)
				if ok {
					continue
				}
			}

			dst, ok = f.args.AppendNamedArg(f, dst, name)
			if ok {
				continue
			}

		restore_arg:
			dst = append(dst, '?')
			dst = append(dst, name...)
			continue
		}

		if argIndex >= len(args) {
			dst = append(dst, '?')
			continue
		}

		arg := args[argIndex]
		argIndex++

		dst = f.appendArg(dst, arg)
	}

	return dst
}

func (f Formatter) appendArg(b []byte, arg interface{}) []byte {
	switch arg := arg.(type) {
	case QueryAppender:
		bb, err := arg.AppendQuery(f, b)
		if err != nil {
			return dialect.AppendError(b, err)
		}
		return bb
	default:
		return Append(f, b, arg)
	}
}

//------------------------------------------------------------------------------

type NamedArgAppender interface {
	AppendNamedArg(fmter Formatter, b []byte, name string) ([]byte, bool)
}

type namedArgList struct {
	arg  NamedArgAppender
	next *namedArgList
}

func (l *namedArgList) WithArg(arg NamedArgAppender) *namedArgList {
	return &namedArgList{
		arg:  arg,
		next: l,
	}
}

func (l *namedArgList) AppendNamedArg(fmter Formatter, b []byte, name string) ([]byte, bool) {
	for l != nil && l.arg != nil {
		if b, ok := l.arg.AppendNamedArg(fmter, b, name); ok {
			return b, true
		}
		l = l.next
	}
	return b, false
}

//------------------------------------------------------------------------------

type namedArg struct {
	name  string
	value interface{}
}

var _ NamedArgAppender = (*namedArg)(nil)

func (a *namedArg) AppendNamedArg(fmter Formatter, b []byte, name string) ([]byte, bool) {
	if a.name == name {
		return fmter.appendArg(b, a.value), true
	}
	return b, false
}

//------------------------------------------------------------------------------

type structArgs struct {
	table *Table
	strct reflect.Value
}

var _ NamedArgAppender = (*structArgs)(nil)

func newStructArgs(fmter Formatter, strct interface{}) (*structArgs, bool) {
	v := reflect.ValueOf(strct)
	if !v.IsValid() {
		return nil, false
	}

	v = reflect.Indirect(v)
	if v.Kind() != reflect.Struct {
		return nil, false
	}

	return &structArgs{
		table: fmter.Dialect().Tables().Get(v.Type()),
		strct: v,
	}, true
}

func (m *structArgs) AppendNamedArg(fmter Formatter, b []byte, name string) ([]byte, bool) {
	return m.table.AppendNamedArg(fmter, b, name, m.strct)
}
