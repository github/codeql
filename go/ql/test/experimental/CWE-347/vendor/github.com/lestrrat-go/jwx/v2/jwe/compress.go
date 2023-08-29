package jwe

import (
	"bytes"
	"compress/flate"
	"fmt"
	"io"

	"github.com/lestrrat-go/jwx/v2/internal/pool"
)

func uncompress(plaintext []byte) ([]byte, error) {
	return io.ReadAll(flate.NewReader(bytes.NewReader(plaintext)))
}

func compress(plaintext []byte) ([]byte, error) {
	buf := pool.GetBytesBuffer()
	defer pool.ReleaseBytesBuffer(buf)

	w, _ := flate.NewWriter(buf, 1)
	in := plaintext
	for len(in) > 0 {
		n, err := w.Write(in)
		if err != nil {
			return nil, fmt.Errorf(`failed to write to compression writer: %w`, err)
		}
		in = in[n:]
	}
	if err := w.Close(); err != nil {
		return nil, fmt.Errorf(`failed to close compression writer: %w`, err)
	}

	ret := make([]byte, buf.Len())
	copy(ret, buf.Bytes())
	return ret, nil
}
