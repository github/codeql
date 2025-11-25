package main

import (
	"go.uber.org/zap/zapcore"
)

// Custom encoder that sanitizes strings before encoding.
// The query should treat flows through AddString as sanitized.

type MySanitizingEncoder struct {
	zapcore.Encoder
}

func (e *MySanitizingEncoder) AddString(key, val string) {
	sanitized := sanitize(val)
	e.Encoder.AddString(key, sanitized)
}

func sanitize(s string) string {
	// placeholder sanitizer; replace with real escaping in production
	return s
}

func main() {
	val := readUser()
	enc := &MySanitizingEncoder{}
	enc.AddString("k", val) // flow passes through sanitizer; should not be reported
}

func readUser() string { return "line\ninjection" }