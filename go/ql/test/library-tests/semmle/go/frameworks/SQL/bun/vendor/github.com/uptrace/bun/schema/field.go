package schema

import (
	"fmt"
	"reflect"

	"github.com/uptrace/bun/dialect"
	"github.com/uptrace/bun/internal/tagparser"
)

type Field struct {
	StructField reflect.StructField
	IsPtr       bool

	Tag          tagparser.Tag
	IndirectType reflect.Type
	Index        []int

	Name    string // SQL name, .e.g. id
	SQLName Safe   // escaped SQL name, e.g. "id"
	GoName  string // struct field name, e.g. Id

	DiscoveredSQLType  string
	UserSQLType        string
	CreateTableSQLType string
	SQLDefault         string

	OnDelete string
	OnUpdate string

	IsPK          bool
	NotNull       bool
	NullZero      bool
	AutoIncrement bool
	Identity      bool

	Append AppenderFunc
	Scan   ScannerFunc
	IsZero IsZeroerFunc
}

func (f *Field) String() string {
	return f.Name
}

func (f *Field) Clone() *Field {
	cp := *f
	cp.Index = cp.Index[:len(f.Index):len(f.Index)]
	return &cp
}

func (f *Field) Value(strct reflect.Value) reflect.Value {
	return fieldByIndexAlloc(strct, f.Index)
}

func (f *Field) HasNilValue(v reflect.Value) bool {
	if len(f.Index) == 1 {
		return v.Field(f.Index[0]).IsNil()
	}

	for _, index := range f.Index {
		if v.Kind() == reflect.Ptr {
			if v.IsNil() {
				return true
			}
			v = v.Elem()
		}
		v = v.Field(index)
	}
	return v.IsNil()
}

func (f *Field) HasZeroValue(v reflect.Value) bool {
	if len(f.Index) == 1 {
		return f.IsZero(v.Field(f.Index[0]))
	}

	for _, index := range f.Index {
		if v.Kind() == reflect.Ptr {
			if v.IsNil() {
				return true
			}
			v = v.Elem()
		}
		v = v.Field(index)
	}
	return f.IsZero(v)
}

func (f *Field) AppendValue(fmter Formatter, b []byte, strct reflect.Value) []byte {
	fv, ok := fieldByIndex(strct, f.Index)
	if !ok {
		return dialect.AppendNull(b)
	}

	if (f.IsPtr && fv.IsNil()) || (f.NullZero && f.IsZero(fv)) {
		return dialect.AppendNull(b)
	}
	if f.Append == nil {
		panic(fmt.Errorf("bun: AppendValue(unsupported %s)", fv.Type()))
	}
	return f.Append(fmter, b, fv)
}

func (f *Field) ScanWithCheck(fv reflect.Value, src interface{}) error {
	if f.Scan == nil {
		return fmt.Errorf("bun: Scan(unsupported %s)", f.IndirectType)
	}
	return f.Scan(fv, src)
}

func (f *Field) ScanValue(strct reflect.Value, src interface{}) error {
	if src == nil {
		if fv, ok := fieldByIndex(strct, f.Index); ok {
			return f.ScanWithCheck(fv, src)
		}
		return nil
	}

	fv := fieldByIndexAlloc(strct, f.Index)
	return f.ScanWithCheck(fv, src)
}

func (f *Field) SkipUpdate() bool {
	return f.Tag.HasOption("skipupdate")
}

func indexEqual(ind1, ind2 []int) bool {
	if len(ind1) != len(ind2) {
		return false
	}
	for i, ind := range ind1 {
		if ind != ind2[i] {
			return false
		}
	}
	return true
}
