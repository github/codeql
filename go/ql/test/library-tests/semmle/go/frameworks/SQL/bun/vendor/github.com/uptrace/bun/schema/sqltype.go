package schema

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"reflect"
	"time"

	"github.com/uptrace/bun/dialect"
	"github.com/uptrace/bun/dialect/sqltype"
	"github.com/uptrace/bun/internal"
)

var (
	bunNullTimeType = reflect.TypeOf((*NullTime)(nil)).Elem()
	nullTimeType    = reflect.TypeOf((*sql.NullTime)(nil)).Elem()
	nullBoolType    = reflect.TypeOf((*sql.NullBool)(nil)).Elem()
	nullFloatType   = reflect.TypeOf((*sql.NullFloat64)(nil)).Elem()
	nullIntType     = reflect.TypeOf((*sql.NullInt64)(nil)).Elem()
	nullStringType  = reflect.TypeOf((*sql.NullString)(nil)).Elem()
)

var sqlTypes = []string{
	reflect.Bool:       sqltype.Boolean,
	reflect.Int:        sqltype.BigInt,
	reflect.Int8:       sqltype.SmallInt,
	reflect.Int16:      sqltype.SmallInt,
	reflect.Int32:      sqltype.Integer,
	reflect.Int64:      sqltype.BigInt,
	reflect.Uint:       sqltype.BigInt,
	reflect.Uint8:      sqltype.SmallInt,
	reflect.Uint16:     sqltype.SmallInt,
	reflect.Uint32:     sqltype.Integer,
	reflect.Uint64:     sqltype.BigInt,
	reflect.Uintptr:    sqltype.BigInt,
	reflect.Float32:    sqltype.Real,
	reflect.Float64:    sqltype.DoublePrecision,
	reflect.Complex64:  "",
	reflect.Complex128: "",
	reflect.Array:      "",
	reflect.Interface:  "",
	reflect.Map:        sqltype.VarChar,
	reflect.Ptr:        "",
	reflect.Slice:      sqltype.VarChar,
	reflect.String:     sqltype.VarChar,
	reflect.Struct:     sqltype.VarChar,
}

func DiscoverSQLType(typ reflect.Type) string {
	switch typ {
	case timeType, nullTimeType, bunNullTimeType:
		return sqltype.Timestamp
	case nullBoolType:
		return sqltype.Boolean
	case nullFloatType:
		return sqltype.DoublePrecision
	case nullIntType:
		return sqltype.BigInt
	case nullStringType:
		return sqltype.VarChar
	case jsonRawMessageType:
		return sqltype.JSON
	}

	switch typ.Kind() {
	case reflect.Slice:
		if typ.Elem().Kind() == reflect.Uint8 {
			return sqltype.Blob
		}
	}

	return sqlTypes[typ.Kind()]
}

//------------------------------------------------------------------------------

var jsonNull = []byte("null")

// NullTime is a time.Time wrapper that marshals zero time as JSON null and SQL NULL.
type NullTime struct {
	time.Time
}

var (
	_ json.Marshaler   = (*NullTime)(nil)
	_ json.Unmarshaler = (*NullTime)(nil)
	_ sql.Scanner      = (*NullTime)(nil)
	_ QueryAppender    = (*NullTime)(nil)
)

func (tm NullTime) MarshalJSON() ([]byte, error) {
	if tm.IsZero() {
		return jsonNull, nil
	}
	return tm.Time.MarshalJSON()
}

func (tm *NullTime) UnmarshalJSON(b []byte) error {
	if bytes.Equal(b, jsonNull) {
		tm.Time = time.Time{}
		return nil
	}
	return tm.Time.UnmarshalJSON(b)
}

func (tm NullTime) AppendQuery(fmter Formatter, b []byte) ([]byte, error) {
	if tm.IsZero() {
		return dialect.AppendNull(b), nil
	}
	return fmter.Dialect().AppendTime(b, tm.Time), nil
}

func (tm *NullTime) Scan(src interface{}) error {
	if src == nil {
		tm.Time = time.Time{}
		return nil
	}

	switch src := src.(type) {
	case time.Time:
		tm.Time = src
		return nil
	case string:
		newtm, err := internal.ParseTime(src)
		if err != nil {
			return err
		}
		tm.Time = newtm
		return nil
	case []byte:
		newtm, err := internal.ParseTime(internal.String(src))
		if err != nil {
			return err
		}
		tm.Time = newtm
		return nil
	default:
		return scanError(bunNullTimeType, src)
	}
}
