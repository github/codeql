package pio

import (
	"fmt"
	"io"
	"strings"
)

// Standard color codes, any color code can be passed to `Rich` package-level function,
// when the destination terminal supports.
const (
	Black = 30 + iota
	Red
	Green
	Yellow
	Blue
	Magenta
	Cyan
	White
	Gray = White

	ColorReset = 0
)

const (
	toBase8         = "\x1b[%dm%s\x1b[0m"
	toBase16Bright  = "\x1b[%d;1m%s\x1b[0m"
	toBase256       = "\x1b[38;5;%dm%s\x1b[0m"
	toBase256Bright = "\x1b[38;5;%d;1m%s\x1b[0m"
)

// RichOption declares a function which can be passed to the `Rich` function
// to modify a text.
//
// Builtin options are defined below:
// - `Bright`
// - `Background`
// - `Bold`
// - `Underline` and
// - `Reversed`.
type RichOption func(s *string, colorCode *int, format *string)

// Rich accepts "s" text and a "colorCode" (e.g. `Black`, `Green`, `Magenta`, `Cyan`...)
// and optional formatters and returns a colorized (and decorated) string text that it's ready
// to be printed through a compatible terminal.
//
// Look:
// - Bright
// - Background
// - Bold
// - Underline
// - Reversed
func Rich(s string, colorCode int, options ...RichOption) string {
	if s == "" {
		return ""
	}

	format := toBase8

	if colorCode < Black || colorCode > 10+White {
		format = toBase256
	}

	for _, opt := range options {
		opt(&s, &colorCode, &format)
	}

	return fmt.Sprintf(format, colorCode, s)
}

// WriteRich same as `Rich` but it accepts an `io.Writer` to write to, e.g. a `StringBuilder` or a `pio.Printer`.
func WriteRich(w io.Writer, s string, colorCode int, options ...RichOption) {
	if s == "" {
		return
	}

	if p, ok := w.(*Printer); ok {
		var (
			richBytes, rawBytes []byte
		)

		for _, output := range p.outputs {
			if SupportColors(output) {
				if len(richBytes) == 0 {
					richBytes = []byte(Rich(s, colorCode, options...)) // no strToBytes; colors are conflicting with --race detector.
				}

				_, _ = output.Write(richBytes)
			} else {
				if len(rawBytes) == 0 {
					rawBytes = []byte(s)
				}

				_, _ = output.Write(rawBytes)
			}
		}

		return
	}

	if SupportColors(w) {
		s = Rich(s, colorCode, options...)
	}

	_, _ = fmt.Fprint(w, s)
}

// Bright sets a "bright" or "bold" style to the colorful text.
func Bright(s *string, colorCode *int, format *string) {
	if strings.Contains(*format, "38;5;%d") {
		*format = toBase256Bright
		return
	}

	*format = toBase16Bright
}

// Background marks the color to background.
// See `Reversed` too.
func Background(s *string, colorCode *int, format *string) {
	*colorCode += 10
}

// Bold adds a "bold" decoration to the colorful text.
// See `Underline` and `Reversed` too.
func Bold(s *string, colorCode *int, format *string) {
	*s = "\x1b[1m" + *s
}

// Underline adds an "underline" decoration to the colorful text.
// See `Bold` and `Reversed` too.
func Underline(s *string, colorCode *int, format *string) {
	*s = "\x1b[4m" + *s
}

// Reversed adds a "reversed" decoration to the colorful text.
// This means that the background will be the foreground and the
// foreground will be the background color.
//
// See `Bold` and `Underline` too.
func Reversed(s *string, colorCode *int, format *string) {
	*s = "\x1b[7m" + *s
}
