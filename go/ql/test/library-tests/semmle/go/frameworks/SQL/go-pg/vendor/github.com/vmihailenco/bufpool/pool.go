package bufpool

import (
	"math/bits"
	"sync/atomic"
)

const (
	minBitSize = 6 // 2**6=64 is a CPU cache line size
	steps      = 20

	minSize     = 1 << minBitSize               // 64 bytes
	maxSize     = 1 << (minBitSize + steps - 1) // 32 mb
	maxPoolSize = maxSize << 1                  // 64 mb

	defaultServePctile      = 0.95
	calibrateCallsThreshold = 42000
	defaultSize             = 4096
)

// Pool represents byte buffer pool.
//
// Different pools should be used for different usage patterns to achieve better
// performance and lower memory usage.
type Pool struct {
	calls       [steps]uint32
	calibrating uint32

	ServePctile float64 // default is 0.95
	serveSize   uint32
}

func (p *Pool) getServeSize() int {
	size := atomic.LoadUint32(&p.serveSize)
	if size > 0 {
		return int(size)
	}

	for i := 0; i < len(p.calls); i++ {
		calls := atomic.LoadUint32(&p.calls[i])
		if calls > 10 {
			size := indexSize(i)
			atomic.CompareAndSwapUint32(&p.serveSize, 0, uint32(size))
			return size
		}
	}

	return defaultSize
}

// Get returns an empty buffer from the pool. Returned buffer capacity
// is determined by accumulated usage stats and changes over time.
//
// The buffer may be returned to the pool using Put or retained for further
// usage. In latter case buffer length must be updated using UpdateLen.
func (p *Pool) Get() *Buffer {
	buf := Get(p.getServeSize())
	buf.Reset()
	return buf
}

// New returns an empty buffer bypassing the pool. Returned buffer capacity
// is determined by accumulated usage stats and changes over time.
func (p *Pool) New() *Buffer {
	return NewBuffer(make([]byte, 0, p.getServeSize()))
}

// Put returns buffer to the pool.
func (p *Pool) Put(buf *Buffer) {
	length := buf.Len()
	if length == 0 {
		length = buf.Cap()
	}

	p.UpdateLen(length)

	// Always put buf to the pool.
	Put(buf)
}

// UpdateLen updates stats about buffer length.
func (p *Pool) UpdateLen(bufLen int) {
	idx := index(bufLen)
	if atomic.AddUint32(&p.calls[idx], 1) > calibrateCallsThreshold {
		p.calibrate()
	}
}

func (p *Pool) calibrate() {
	if !atomic.CompareAndSwapUint32(&p.calibrating, 0, 1) {
		return
	}

	var callSum uint64
	var calls [steps]uint32

	for i := 0; i < len(p.calls); i++ {
		n := atomic.SwapUint32(&p.calls[i], 0)
		calls[i] = n
		callSum += uint64(n)
	}

	serveSum := uint64(float64(callSum) * p.getServePctile())
	var serveSize int

	callSum = 0
	for i, numCall := range &calls {
		callSum += uint64(numCall)

		if serveSize == 0 && callSum >= serveSum {
			serveSize = indexSize(i)
			break
		}
	}

	atomic.StoreUint32(&p.serveSize, uint32(serveSize))
	atomic.StoreUint32(&p.calibrating, 0)
}

func (p *Pool) getServePctile() float64 {
	if p.ServePctile > 0 {
		return p.ServePctile
	}
	return defaultServePctile
}

func index(n int) int {
	if n == 0 {
		return 0
	}
	idx := bits.Len32(uint32((n - 1) >> minBitSize))
	if idx >= steps {
		idx = steps - 1
	}
	return idx
}

func prevIndex(n int) int {
	next := index(n)
	if next == 0 || n == indexSize(next) {
		return next
	}
	return next - 1
}

func indexSize(idx int) int {
	return minSize << uint(idx)
}
