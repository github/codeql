package types

import (
	"encoding/json"

	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/pgjson"
)

const (
	pgBool = 16

	pgInt2 = 21
	pgInt4 = 23
	pgInt8 = 20

	pgFloat4 = 700
	pgFloat8 = 701

	pgText    = 25
	pgVarchar = 1043
	pgBytea   = 17
	pgJSON    = 114
	pgJSONB   = 3802

	pgTimestamp   = 1114
	pgTimestamptz = 1184

	// pgInt2Array = 1005
	pgInt32Array  = 1007
	pgInt8Array   = 1016
	pgFloat8Array = 1022
	pgStringArray = 1009

	pgUUID = 2950
)

type ColumnInfo = pool.ColumnInfo

type RawValue struct {
	Type  int32
	Value string
}

func (v RawValue) AppendValue(b []byte, flags int) ([]byte, error) {
	return AppendString(b, v.Value, flags), nil
}

func (v RawValue) MarshalJSON() ([]byte, error) {
	return pgjson.Marshal(v.Value)
}

func ReadColumnValue(col ColumnInfo, rd Reader, n int) (interface{}, error) {
	switch col.DataType {
	case pgBool:
		return ScanBool(rd, n)

	case pgInt2:
		n, err := scanInt64(rd, n, 16)
		if err != nil {
			return nil, err
		}
		return int16(n), nil
	case pgInt4:
		n, err := scanInt64(rd, n, 32)
		if err != nil {
			return nil, err
		}
		return int32(n), nil
	case pgInt8:
		return ScanInt64(rd, n)

	case pgFloat4:
		return ScanFloat32(rd, n)
	case pgFloat8:
		return ScanFloat64(rd, n)

	case pgBytea:
		return ScanBytes(rd, n)
	case pgText, pgVarchar, pgUUID:
		return ScanString(rd, n)
	case pgJSON, pgJSONB:
		s, err := ScanString(rd, n)
		if err != nil {
			return nil, err
		}
		return json.RawMessage(s), nil

	case pgTimestamp:
		return ScanTime(rd, n)
	case pgTimestamptz:
		return ScanTime(rd, n)

	case pgInt32Array:
		return scanInt64Array(rd, n)
	case pgInt8Array:
		return scanInt64Array(rd, n)
	case pgFloat8Array:
		return scanFloat64Array(rd, n)
	case pgStringArray:
		return scanStringArray(rd, n)

	default:
		s, err := ScanString(rd, n)
		if err != nil {
			return nil, err
		}
		return RawValue{
			Type:  col.DataType,
			Value: s,
		}, nil
	}
}
