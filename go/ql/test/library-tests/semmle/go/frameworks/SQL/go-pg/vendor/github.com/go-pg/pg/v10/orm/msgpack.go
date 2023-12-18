package orm

import (
	"reflect"

	"github.com/vmihailenco/msgpack/v5"

	"github.com/go-pg/pg/v10/types"
)

func msgpackAppender(_ reflect.Type) types.AppenderFunc {
	return func(b []byte, v reflect.Value, flags int) []byte {
		hexEnc := types.NewHexEncoder(b, flags)

		enc := msgpack.GetEncoder()
		defer msgpack.PutEncoder(enc)

		enc.Reset(hexEnc)
		if err := enc.EncodeValue(v); err != nil {
			return types.AppendError(b, err)
		}

		if err := hexEnc.Close(); err != nil {
			return types.AppendError(b, err)
		}

		return hexEnc.Bytes()
	}
}

func msgpackScanner(_ reflect.Type) types.ScannerFunc {
	return func(v reflect.Value, rd types.Reader, n int) error {
		if n <= 0 {
			return nil
		}

		hexDec, err := types.NewHexDecoder(rd, n)
		if err != nil {
			return err
		}

		dec := msgpack.GetDecoder()
		defer msgpack.PutDecoder(dec)

		dec.Reset(hexDec)
		if err := dec.DecodeValue(v); err != nil {
			return err
		}

		return nil
	}
}
