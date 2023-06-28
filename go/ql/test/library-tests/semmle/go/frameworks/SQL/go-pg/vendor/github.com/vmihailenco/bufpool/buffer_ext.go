package bufpool

import "bytes"

// Reset resets the buffer to be empty,
// but it retains the underlying storage for use by future writes.
// Reset is the same as Truncate(0).
func (b *Buffer) Reset() {
	if b.off > cap(b.buf) {
		panic("Buffer is used after Put")
	}
	b.buf = b.buf[:0]
	b.off = 0
	b.lastRead = opInvalid
}

func (b *Buffer) ResetBuf(buf []byte) {
	if b.off > cap(b.buf) {
		panic("Buffer is used after Put")
	}
	b.buf = buf[:0]
	b.off = 0
	b.lastRead = opInvalid
}

// grow grows the buffer to guarantee space for n more bytes.
// It returns the index where bytes should be written.
// If the buffer can't grow it will panic with ErrTooLarge.
func (b *Buffer) grow(n int) int {
	if b.off > cap(b.buf) {
		panic("Buffer is used after Put")
	}
	m := b.Len()
	// If buffer is empty, reset to recover space.
	if m == 0 && b.off != 0 {
		b.Reset()
	}
	// Try to grow by means of a reslice.
	if i, ok := b.tryGrowByReslice(n); ok {
		return i
	}
	if b.buf == nil && n <= smallBufferSize {
		b.buf = make([]byte, n, smallBufferSize)
		return 0
	}
	c := cap(b.buf)
	if n <= c/2-m {
		// We can slide things down instead of allocating a new
		// slice. We only need m+n <= c to slide, but
		// we instead let capacity get twice as large so we
		// don't spend all our time copying.
		copy(b.buf, b.buf[b.off:])
	} else if c > maxInt-c-n {
		panic(bytes.ErrTooLarge)
	} else {
		// Not enough space anywhere, we need to allocate.
		tmp := Get(2*c + n)
		copy(tmp.buf, b.buf[b.off:])
		b.buf, tmp.buf = tmp.buf, b.buf
		Put(tmp)
	}
	// Restore b.off and len(b.buf).
	b.off = 0
	b.buf = b.buf[:m+n]
	return m
}
