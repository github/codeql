package pio

import (
	"io"
	"runtime"

	"github.com/kataras/pio/terminal"
)

// outputWriter just caches the "supportColors"
// in order to reduce syscalls for known printers.
type outputWriter struct {
	io.Writer
	supportColors bool
}

func wrapWriters(output ...io.Writer) []*outputWriter {
	outs := make([]*outputWriter, 0, len(output))
	for _, w := range output {
		outs = append(outs, &outputWriter{
			Writer:        w,
			supportColors: SupportColors(w),
		})
	}

	return outs
}

// SupportColors reports whether the "w" io.Writer is not a file and it does support colors.
func SupportColors(w io.Writer) bool {
	if w == nil {
		return false
	}

	if sc, ok := w.(*outputWriter); ok {
		return sc.supportColors
	}

	isTerminal := !IsNop(w) && terminal.IsTerminal(w)
	if isTerminal && runtime.GOOS == "windows" {
		// if on windows then return true only when it does support 256-bit colors,
		// this is why we initially do that terminal check for the "w" writer.
		return terminal.SupportColors
	}

	return isTerminal
}
