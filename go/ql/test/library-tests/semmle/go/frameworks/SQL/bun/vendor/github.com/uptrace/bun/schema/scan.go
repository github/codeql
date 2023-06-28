package schema

import (
	"bytes"
	"database/sql"
	"fmt"
	"net"
	"reflect"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/vmihailenco/msgpack/v5"

	"github.com/uptrace/bun/dialect/sqltype"
	"github.com/uptrace/bun/extra/bunjson"
	"github.com/uptrace/bun/internal"
)

var scannerType = reflect.TypeOf((*sql.Scanner)(nil)).Elem()

type ScannerFunc func(dest reflect.Value, src interface{}) error

var scanners []ScannerFunc

func init() {
	scanners = []ScannerFunc{
		reflect.Bool:          scanBool,
		reflect.Int:           scanInt64,
		reflect.Int8:          scanInt64,
		reflect.Int16:         scanInt64,
		reflect.Int32:         scanInt64,
		reflect.Int64:         scanInt64,
		reflect.Uint:          scanUint64,
		reflect.Uint8:         scanUint64,
		reflect.Uint16:        scanUint64,
		reflect.Uint32:        scanUint64,
		reflect.Uint64:        scanUint64,
		reflect.Uintptr:       scanUint64,
		reflect.Float32:       scanFloat64,
		reflect.Float64:       scanFloat64,
		reflect.Complex64:     nil,
		reflect.Complex128:    nil,
		reflect.Array:         nil,
		reflect.Interface:     scanInterface,
		reflect.Map:           scanJSON,
		reflect.Ptr:           nil,
		reflect.Slice:         scanJSON,
		reflect.String:        scanString,
		reflect.Struct:        scanJSON,
		reflect.UnsafePointer: nil,
	}
}

var scannerMap sync.Map

func FieldScanner(dialect Dialect, field *Field) ScannerFunc {
	if field.Tag.HasOption("msgpack") {
		return scanMsgpack
	}
	if field.Tag.HasOption("json_use_number") {
		return scanJSONUseNumber
	}
	if field.StructField.Type.Kind() == reflect.Interface {
		switch strings.ToUpper(field.UserSQLType) {
		case sqltype.JSON, sqltype.JSONB:
			return scanJSONIntoInterface
		}
	}
	return Scanner(field.StructField.Type)
}

func Scanner(typ reflect.Type) ScannerFunc {
	if v, ok := scannerMap.Load(typ); ok {
		return v.(ScannerFunc)
	}

	fn := scanner(typ)

	if v, ok := scannerMap.LoadOrStore(typ, fn); ok {
		return v.(ScannerFunc)
	}
	return fn
}

func scanner(typ reflect.Type) ScannerFunc {
	kind := typ.Kind()

	if kind == reflect.Ptr {
		if fn := Scanner(typ.Elem()); fn != nil {
			return PtrScanner(fn)
		}
	}

	switch typ {
	case bytesType:
		return scanBytes
	case timeType:
		return scanTime
	case ipType:
		return scanIP
	case ipNetType:
		return scanIPNet
	case jsonRawMessageType:
		return scanBytes
	}

	if typ.Implements(scannerType) {
		return scanScanner
	}

	if kind != reflect.Ptr {
		ptr := reflect.PtrTo(typ)
		if ptr.Implements(scannerType) {
			return addrScanner(scanScanner)
		}
	}

	if typ.Kind() == reflect.Slice && typ.Elem().Kind() == reflect.Uint8 {
		return scanBytes
	}

	return scanners[kind]
}

func scanBool(dest reflect.Value, src interface{}) error {
	switch src := src.(type) {
	case nil:
		dest.SetBool(false)
		return nil
	case bool:
		dest.SetBool(src)
		return nil
	case int64:
		dest.SetBool(src != 0)
		return nil
	case []byte:
		f, err := strconv.ParseBool(internal.String(src))
		if err != nil {
			return err
		}
		dest.SetBool(f)
		return nil
	case string:
		f, err := strconv.ParseBool(src)
		if err != nil {
			return err
		}
		dest.SetBool(f)
		return nil
	default:
		return scanError(dest.Type(), src)
	}
}

func scanInt64(dest reflect.Value, src interface{}) error {
	switch src := src.(type) {
	case nil:
		dest.SetInt(0)
		return nil
	case int64:
		dest.SetInt(src)
		return nil
	case uint64:
		dest.SetInt(int64(src))
		return nil
	case []byte:
		n, err := strconv.ParseInt(internal.String(src), 10, 64)
		if err != nil {
			return err
		}
		dest.SetInt(n)
		return nil
	case string:
		n, err := strconv.ParseInt(src, 10, 64)
		if err != nil {
			return err
		}
		dest.SetInt(n)
		return nil
	default:
		return scanError(dest.Type(), src)
	}
}

func scanUint64(dest reflect.Value, src interface{}) error {
	switch src := src.(type) {
	case nil:
		dest.SetUint(0)
		return nil
	case uint64:
		dest.SetUint(src)
		return nil
	case int64:
		dest.SetUint(uint64(src))
		return nil
	case []byte:
		n, err := strconv.ParseUint(internal.String(src), 10, 64)
		if err != nil {
			return err
		}
		dest.SetUint(n)
		return nil
	case string:
		n, err := strconv.ParseUint(src, 10, 64)
		if err != nil {
			return err
		}
		dest.SetUint(n)
		return nil
	default:
		return scanError(dest.Type(), src)
	}
}

func scanFloat64(dest reflect.Value, src interface{}) error {
	switch src := src.(type) {
	case nil:
		dest.SetFloat(0)
		return nil
	case float64:
		dest.SetFloat(src)
		return nil
	case []byte:
		f, err := strconv.ParseFloat(internal.String(src), 64)
		if err != nil {
			return err
		}
		dest.SetFloat(f)
		return nil
	case string:
		f, err := strconv.ParseFloat(src, 64)
		if err != nil {
			return err
		}
		dest.SetFloat(f)
		return nil
	default:
		return scanError(dest.Type(), src)
	}
}

func scanString(dest reflect.Value, src interface{}) error {
	switch src := src.(type) {
	case nil:
		dest.SetString("")
		return nil
	case string:
		dest.SetString(src)
		return nil
	case []byte:
		dest.SetString(string(src))
		return nil
	case time.Time:
		dest.SetString(src.Format(time.RFC3339Nano))
		return nil
	case int64:
		dest.SetString(strconv.FormatInt(src, 10))
		return nil
	case uint64:
		dest.SetString(strconv.FormatUint(src, 10))
		return nil
	case float64:
		dest.SetString(strconv.FormatFloat(src, 'G', -1, 64))
		return nil
	default:
		return scanError(dest.Type(), src)
	}
}

func scanBytes(dest reflect.Value, src interface{}) error {
	switch src := src.(type) {
	case nil:
		dest.SetBytes(nil)
		return nil
	case string:
		dest.SetBytes([]byte(src))
		return nil
	case []byte:
		clone := make([]byte, len(src))
		copy(clone, src)

		dest.SetBytes(clone)
		return nil
	default:
		return scanError(dest.Type(), src)
	}
}

func scanTime(dest reflect.Value, src interface{}) error {
	switch src := src.(type) {
	case nil:
		destTime := dest.Addr().Interface().(*time.Time)
		*destTime = time.Time{}
		return nil
	case time.Time:
		destTime := dest.Addr().Interface().(*time.Time)
		*destTime = src
		return nil
	case string:
		srcTime, err := internal.ParseTime(src)
		if err != nil {
			return err
		}
		destTime := dest.Addr().Interface().(*time.Time)
		*destTime = srcTime
		return nil
	case []byte:
		srcTime, err := internal.ParseTime(internal.String(src))
		if err != nil {
			return err
		}
		destTime := dest.Addr().Interface().(*time.Time)
		*destTime = srcTime
		return nil
	default:
		return scanError(dest.Type(), src)
	}
}

func scanScanner(dest reflect.Value, src interface{}) error {
	return dest.Interface().(sql.Scanner).Scan(src)
}

func scanMsgpack(dest reflect.Value, src interface{}) error {
	if src == nil {
		return scanNull(dest)
	}

	b, err := toBytes(src)
	if err != nil {
		return err
	}

	dec := msgpack.GetDecoder()
	defer msgpack.PutDecoder(dec)

	dec.Reset(bytes.NewReader(b))
	return dec.DecodeValue(dest)
}

func scanJSON(dest reflect.Value, src interface{}) error {
	if src == nil {
		return scanNull(dest)
	}

	b, err := toBytes(src)
	if err != nil {
		return err
	}

	return bunjson.Unmarshal(b, dest.Addr().Interface())
}

func scanJSONUseNumber(dest reflect.Value, src interface{}) error {
	if src == nil {
		return scanNull(dest)
	}

	b, err := toBytes(src)
	if err != nil {
		return err
	}

	dec := bunjson.NewDecoder(bytes.NewReader(b))
	dec.UseNumber()
	return dec.Decode(dest.Addr().Interface())
}

func scanIP(dest reflect.Value, src interface{}) error {
	if src == nil {
		return scanNull(dest)
	}

	b, err := toBytes(src)
	if err != nil {
		return err
	}

	ip := net.ParseIP(internal.String(b))
	if ip == nil {
		return fmt.Errorf("bun: invalid ip: %q", b)
	}

	ptr := dest.Addr().Interface().(*net.IP)
	*ptr = ip

	return nil
}

func scanIPNet(dest reflect.Value, src interface{}) error {
	if src == nil {
		return scanNull(dest)
	}

	b, err := toBytes(src)
	if err != nil {
		return err
	}

	_, ipnet, err := net.ParseCIDR(internal.String(b))
	if err != nil {
		return err
	}

	ptr := dest.Addr().Interface().(*net.IPNet)
	*ptr = *ipnet

	return nil
}

func addrScanner(fn ScannerFunc) ScannerFunc {
	return func(dest reflect.Value, src interface{}) error {
		if !dest.CanAddr() {
			return fmt.Errorf("bun: Scan(nonaddressable %T)", dest.Interface())
		}
		return fn(dest.Addr(), src)
	}
}

func toBytes(src interface{}) ([]byte, error) {
	switch src := src.(type) {
	case string:
		return internal.Bytes(src), nil
	case []byte:
		return src, nil
	default:
		return nil, fmt.Errorf("bun: got %T, wanted []byte or string", src)
	}
}

func PtrScanner(fn ScannerFunc) ScannerFunc {
	return func(dest reflect.Value, src interface{}) error {
		if src == nil {
			if !dest.CanAddr() {
				if dest.IsNil() {
					return nil
				}
				return fn(dest.Elem(), src)
			}

			if !dest.IsNil() {
				dest.Set(reflect.New(dest.Type().Elem()))
			}
			return nil
		}

		if dest.IsNil() {
			dest.Set(reflect.New(dest.Type().Elem()))
		}

		if dest.Kind() == reflect.Map {
			return fn(dest, src)
		}

		return fn(dest.Elem(), src)
	}
}

func scanNull(dest reflect.Value) error {
	if nilable(dest.Kind()) && dest.IsNil() {
		return nil
	}
	dest.Set(reflect.New(dest.Type()).Elem())
	return nil
}

func scanJSONIntoInterface(dest reflect.Value, src interface{}) error {
	if dest.IsNil() {
		if src == nil {
			return nil
		}

		b, err := toBytes(src)
		if err != nil {
			return err
		}

		return bunjson.Unmarshal(b, dest.Addr().Interface())
	}

	dest = dest.Elem()
	if fn := Scanner(dest.Type()); fn != nil {
		return fn(dest, src)
	}
	return scanError(dest.Type(), src)
}

func scanInterface(dest reflect.Value, src interface{}) error {
	if dest.IsNil() {
		if src == nil {
			return nil
		}
		dest.Set(reflect.ValueOf(src))
		return nil
	}

	dest = dest.Elem()
	if fn := Scanner(dest.Type()); fn != nil {
		return fn(dest, src)
	}
	return scanError(dest.Type(), src)
}

func nilable(kind reflect.Kind) bool {
	switch kind {
	case reflect.Chan, reflect.Func, reflect.Interface, reflect.Map, reflect.Ptr, reflect.Slice:
		return true
	}
	return false
}

func scanError(dest reflect.Type, src interface{}) error {
	return fmt.Errorf("bun: can't scan %#v (%T) into %s", src, src, dest.String())
}
