package types

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"reflect"
	"sync"
	"time"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/pgjson"
)

var (
	valueScannerType   = reflect.TypeOf((*ValueScanner)(nil)).Elem()
	sqlScannerType     = reflect.TypeOf((*sql.Scanner)(nil)).Elem()
	timeType           = reflect.TypeOf((*time.Time)(nil)).Elem()
	ipType             = reflect.TypeOf((*net.IP)(nil)).Elem()
	ipNetType          = reflect.TypeOf((*net.IPNet)(nil)).Elem()
	jsonRawMessageType = reflect.TypeOf((*json.RawMessage)(nil)).Elem()
)

type ScannerFunc func(reflect.Value, Reader, int) error

var valueScanners []ScannerFunc

//nolint
func init() {
	valueScanners = []ScannerFunc{
		reflect.Bool:          scanBoolValue,
		reflect.Int:           scanInt64Value,
		reflect.Int8:          scanInt64Value,
		reflect.Int16:         scanInt64Value,
		reflect.Int32:         scanInt64Value,
		reflect.Int64:         scanInt64Value,
		reflect.Uint:          scanUint64Value,
		reflect.Uint8:         scanUint64Value,
		reflect.Uint16:        scanUint64Value,
		reflect.Uint32:        scanUint64Value,
		reflect.Uint64:        scanUint64Value,
		reflect.Uintptr:       nil,
		reflect.Float32:       scanFloat32Value,
		reflect.Float64:       scanFloat64Value,
		reflect.Complex64:     nil,
		reflect.Complex128:    nil,
		reflect.Array:         scanJSONValue,
		reflect.Chan:          nil,
		reflect.Func:          nil,
		reflect.Interface:     scanIfaceValue,
		reflect.Map:           scanJSONValue,
		reflect.Ptr:           nil,
		reflect.Slice:         scanJSONValue,
		reflect.String:        scanStringValue,
		reflect.Struct:        scanJSONValue,
		reflect.UnsafePointer: nil,
	}
}

var scannersMap sync.Map

// RegisterScanner registers an scanner func for the type.
// Expecting to be used only during initialization, it panics
// if there is already a registered scanner for the given type.
func RegisterScanner(value interface{}, fn ScannerFunc) {
	registerScanner(reflect.TypeOf(value), fn)
}

func registerScanner(typ reflect.Type, fn ScannerFunc) {
	_, loaded := scannersMap.LoadOrStore(typ, fn)
	if loaded {
		err := fmt.Errorf("pg: scanner for the type=%s is already registered",
			typ.String())
		panic(err)
	}
}

func Scanner(typ reflect.Type) ScannerFunc {
	if v, ok := scannersMap.Load(typ); ok {
		return v.(ScannerFunc)
	}
	fn := scanner(typ, false)
	_, _ = scannersMap.LoadOrStore(typ, fn)
	return fn
}

func scanner(typ reflect.Type, pgArray bool) ScannerFunc {
	switch typ {
	case timeType:
		return scanTimeValue
	case ipType:
		return scanIPValue
	case ipNetType:
		return scanIPNetValue
	case jsonRawMessageType:
		return scanJSONRawMessageValue
	}

	if typ.Implements(valueScannerType) {
		return scanValueScannerValue
	}
	if reflect.PtrTo(typ).Implements(valueScannerType) {
		return scanValueScannerAddrValue
	}

	if typ.Implements(sqlScannerType) {
		return scanSQLScannerValue
	}
	if reflect.PtrTo(typ).Implements(sqlScannerType) {
		return scanSQLScannerAddrValue
	}

	kind := typ.Kind()
	switch kind {
	case reflect.Ptr:
		return ptrScannerFunc(typ)
	case reflect.Slice:
		if typ.Elem().Kind() == reflect.Uint8 {
			return scanBytesValue
		}
		if pgArray {
			return ArrayScanner(typ)
		}
	case reflect.Array:
		if typ.Elem().Kind() == reflect.Uint8 {
			return scanArrayBytesValue
		}
	}
	return valueScanners[kind]
}

func ptrScannerFunc(typ reflect.Type) ScannerFunc {
	scanner := Scanner(typ.Elem())
	return func(v reflect.Value, rd Reader, n int) error {
		if scanner == nil {
			return fmt.Errorf("pg: Scan(unsupported %s)", v.Type())
		}

		if n == -1 {
			if v.IsNil() {
				return nil
			}
			if !v.CanSet() {
				return fmt.Errorf("pg: Scan(non-settable %s)", v.Type())
			}
			v.Set(reflect.Zero(v.Type()))
			return nil
		}

		if v.IsNil() {
			if !v.CanSet() {
				return fmt.Errorf("pg: Scan(non-settable %s)", v.Type())
			}
			v.Set(reflect.New(v.Type().Elem()))
		}

		return scanner(v.Elem(), rd, n)
	}
}

func scanIfaceValue(v reflect.Value, rd Reader, n int) error {
	if v.IsNil() {
		return scanJSONValue(v, rd, n)
	}
	return ScanValue(v.Elem(), rd, n)
}

func ScanValue(v reflect.Value, rd Reader, n int) error {
	if !v.IsValid() {
		return errors.New("pg: Scan(nil)")
	}

	scanner := Scanner(v.Type())
	if scanner != nil {
		return scanner(v, rd, n)
	}

	if v.Kind() == reflect.Interface {
		return errors.New("pg: Scan(nil)")
	}
	return fmt.Errorf("pg: Scan(unsupported %s)", v.Type())
}

func scanBoolValue(v reflect.Value, rd Reader, n int) error {
	if n == -1 {
		v.SetBool(false)
		return nil
	}

	flag, err := ScanBool(rd, n)
	if err != nil {
		return err
	}

	v.SetBool(flag)
	return nil
}

func scanInt64Value(v reflect.Value, rd Reader, n int) error {
	num, err := ScanInt64(rd, n)
	if err != nil {
		return err
	}

	v.SetInt(num)
	return nil
}

func scanUint64Value(v reflect.Value, rd Reader, n int) error {
	num, err := ScanUint64(rd, n)
	if err != nil {
		return err
	}

	v.SetUint(num)
	return nil
}

func scanFloat32Value(v reflect.Value, rd Reader, n int) error {
	num, err := ScanFloat32(rd, n)
	if err != nil {
		return err
	}

	v.SetFloat(float64(num))
	return nil
}

func scanFloat64Value(v reflect.Value, rd Reader, n int) error {
	num, err := ScanFloat64(rd, n)
	if err != nil {
		return err
	}

	v.SetFloat(num)
	return nil
}

func scanStringValue(v reflect.Value, rd Reader, n int) error {
	s, err := ScanString(rd, n)
	if err != nil {
		return err
	}

	v.SetString(s)
	return nil
}

func scanJSONValue(v reflect.Value, rd Reader, n int) error {
	// Zero value so it works with SelectOrInsert.
	// TODO: better handle slices
	v.Set(reflect.New(v.Type()).Elem())

	if n == -1 {
		return nil
	}

	dec := pgjson.NewDecoder(rd)
	return dec.Decode(v.Addr().Interface())
}

func scanTimeValue(v reflect.Value, rd Reader, n int) error {
	tm, err := ScanTime(rd, n)
	if err != nil {
		return err
	}

	ptr := v.Addr().Interface().(*time.Time)
	*ptr = tm

	return nil
}

func scanIPValue(v reflect.Value, rd Reader, n int) error {
	if n == -1 {
		return nil
	}

	tmp, err := rd.ReadFullTemp()
	if err != nil {
		return err
	}

	ip := net.ParseIP(internal.BytesToString(tmp))
	if ip == nil {
		return fmt.Errorf("pg: invalid ip=%q", tmp)
	}

	ptr := v.Addr().Interface().(*net.IP)
	*ptr = ip

	return nil
}

var zeroIPNetValue = reflect.ValueOf(net.IPNet{})

func scanIPNetValue(v reflect.Value, rd Reader, n int) error {
	if n == -1 {
		v.Set(zeroIPNetValue)
		return nil
	}

	tmp, err := rd.ReadFullTemp()
	if err != nil {
		return err
	}

	_, ipnet, err := net.ParseCIDR(internal.BytesToString(tmp))
	if err != nil {
		return err
	}

	ptr := v.Addr().Interface().(*net.IPNet)
	*ptr = *ipnet

	return nil
}

func scanJSONRawMessageValue(v reflect.Value, rd Reader, n int) error {
	if n == -1 {
		v.SetBytes(nil)
		return nil
	}

	b, err := rd.ReadFull()
	if err != nil {
		return err
	}

	v.SetBytes(b)
	return nil
}

func scanBytesValue(v reflect.Value, rd Reader, n int) error {
	if n == -1 {
		v.SetBytes(nil)
		return nil
	}

	b, err := ScanBytes(rd, n)
	if err != nil {
		return err
	}

	v.SetBytes(b)
	return nil
}

func scanArrayBytesValue(v reflect.Value, rd Reader, n int) error {
	b := v.Slice(0, v.Len()).Bytes()

	if n == -1 {
		for i := range b {
			b[i] = 0
		}
		return nil
	}

	return ReadBytes(rd, b)
}

func scanValueScannerValue(v reflect.Value, rd Reader, n int) error {
	if n == -1 {
		if v.IsNil() {
			return nil
		}
		return v.Interface().(ValueScanner).ScanValue(rd, n)
	}

	if v.IsNil() {
		v.Set(reflect.New(v.Type().Elem()))
	}

	return v.Interface().(ValueScanner).ScanValue(rd, n)
}

func scanValueScannerAddrValue(v reflect.Value, rd Reader, n int) error {
	if !v.CanAddr() {
		return fmt.Errorf("pg: Scan(non-settable %s)", v.Type())
	}
	return v.Addr().Interface().(ValueScanner).ScanValue(rd, n)
}

func scanSQLScannerValue(v reflect.Value, rd Reader, n int) error {
	if n == -1 {
		if nilable(v) && v.IsNil() {
			return nil
		}
		return scanSQLScanner(v.Interface().(sql.Scanner), rd, n)
	}

	if nilable(v) && v.IsNil() {
		v.Set(reflect.New(v.Type().Elem()))
	}

	return scanSQLScanner(v.Interface().(sql.Scanner), rd, n)
}

func scanSQLScannerAddrValue(v reflect.Value, rd Reader, n int) error {
	if !v.CanAddr() {
		return fmt.Errorf("pg: Scan(non-settable %s)", v.Type())
	}
	return scanSQLScanner(v.Addr().Interface().(sql.Scanner), rd, n)
}

func scanSQLScanner(scanner sql.Scanner, rd Reader, n int) error {
	if n == -1 {
		return scanner.Scan(nil)
	}

	tmp, err := rd.ReadFullTemp()
	if err != nil {
		return err
	}
	return scanner.Scan(tmp)
}
