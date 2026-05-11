// Copyright 2015, Joe Tsai. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE.md file.

package flate

// The dictDecoder implements the LZ77 sliding dictionary that is commonly used
// in various compression formats. For performance reasons, this implementation
// performs little to no sanity checks about the arguments. As such, the
// invariants documented for each method call must be respected. Furthermore,
// to reduce the memory footprint decompressing short streams, the dictionary
// starts with a relatively small size and then lazily grows.

const (
	initSize   = 4096 // Initial size allocated for sliding dictionary
	growFactor = 4    // Rate the dictionary is grown to match expected size
)

type dictDecoder struct {
	// Invariant: len(hist) <= size
	size int    // Sliding window size
	hist []byte // Sliding window history, dynamically grown to match size

	// Invariant: 0 <= rdPos <= wrPos <= len(hist)
	wrPos int  // Current output position in buffer
	rdPos int  // Have emitted hist[:rdPos] already
	full  bool // Has a full window length been written yet?
}

func (dd *dictDecoder) Init(size int) {
	*dd = dictDecoder{hist: dd.hist}

	// Regardless of what size claims, start with a small dictionary to avoid
	// denial-of-service attacks with large memory allocation.
	dd.size = size
	if dd.hist == nil {
		dd.hist = make([]byte, initSize)
	}
	dd.hist = dd.hist[:cap(dd.hist)]
	if len(dd.hist) > dd.size {
		dd.hist = dd.hist[:dd.size]
	}
}

// HistSize reports the total amount of historical data in the dictionary.
func (dd *dictDecoder) HistSize() int {
	if dd.full {
		return dd.size
	}
	return dd.wrPos
}

// AvailSize reports the available amount of output buffer space.
func (dd *dictDecoder) AvailSize() int {
	return len(dd.hist) - dd.wrPos
}

// WriteSlice returns a slice of the available buffer to write data to.
//
// This invariant will be kept: len(s) <= AvailSize()
func (dd *dictDecoder) WriteSlice() []byte {
	return dd.hist[dd.wrPos:]
}

// WriteMark advances the write pointer by cnt.
//
// This invariant must be kept: 0 <= cnt <= AvailSize()
func (dd *dictDecoder) WriteMark(cnt int) {
	dd.wrPos += cnt
}

// WriteByte writes a single byte to the dictionary.
//
// This invariant must be kept: 0 < AvailSize()
func (dd *dictDecoder) WriteByte(c byte) {
	dd.hist[dd.wrPos] = c
	dd.wrPos++
}

// TryWriteCopy tries to copy a string at a given (distance, length) to the
// output. This specialized version is optimized for short distances.
//
// This method is designed to be inlined for performance reasons.
//
// This invariant must be kept: 0 < dist <= HistSize()
func (dd *dictDecoder) TryWriteCopy(dist, length int) int {
	wrPos := dd.wrPos
	wrEnd := wrPos + length
	if wrPos < dist || wrEnd > len(dd.hist) {
		return 0
	}

	// Copy overlapping section before destination.
	wrBase := wrPos
	rdPos := wrPos - dist
loop:
	wrPos += copy(dd.hist[wrPos:wrEnd], dd.hist[rdPos:wrPos])
	if wrPos < wrEnd {
		goto loop // Avoid for-loop so that this function can be inlined
	}
	dd.wrPos = wrPos
	return wrPos - wrBase
}

// WriteCopy copies a string at a given (distance, length) to the output.
// This returns the number of bytes copied and may be less than the requested
// length if the available space in the output buffer is too small.
//
// This invariant must be kept: 0 < dist <= HistSize()
func (dd *dictDecoder) WriteCopy(dist, length int) int {
	wrBase := dd.wrPos
	wrPos := wrBase
	rdPos := wrPos - dist
	wrEnd := wrPos + length
	if wrEnd > len(dd.hist) {
		wrEnd = len(dd.hist)
	}

	// Copy non-overlapping section after destination.
	if rdPos < 0 {
		rdPos += len(dd.hist)
		wrPos += copy(dd.hist[wrPos:wrEnd], dd.hist[rdPos:])
		rdPos = 0
	}

	// Copy overlapping section before destination.
	for wrPos < wrEnd {
		wrPos += copy(dd.hist[wrPos:wrEnd], dd.hist[rdPos:wrPos])
	}
	dd.wrPos = wrPos
	return wrPos - wrBase
}

// ReadFlush returns a slice of the historical buffer that is ready to be
// emitted to the user. A call to ReadFlush is only valid after all of the data
// from a previous call to ReadFlush has been consumed.
func (dd *dictDecoder) ReadFlush() []byte {
	toRead := dd.hist[dd.rdPos:dd.wrPos]
	dd.rdPos = dd.wrPos
	if dd.wrPos == len(dd.hist) {
		if len(dd.hist) == dd.size {
			dd.wrPos, dd.rdPos = 0, 0
			dd.full = true
		} else {
			// Allocate a larger history buffer.
			size := cap(dd.hist) * growFactor
			if size > dd.size {
				size = dd.size
			}
			hist := make([]byte, size)
			copy(hist, dd.hist)
			dd.hist = hist
		}
	}
	return toRead
}
