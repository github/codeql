package golog

import (
	"encoding/json"
	"io"
	"sync"
)

// Formatter is responsible to print a log to the logger's writer.
type Formatter interface {
	// The name of the formatter.
	String() string
	// Set any options and return a clone,
	// generic. See `Logger.SetFormat`.
	Options(opts ...interface{}) Formatter
	// Writes the "log" to "dest" logger.
	Format(dest io.Writer, log *Log) bool
}

// JSONFormatter is a Formatter type for JSON logs.
type JSONFormatter struct {
	Indent string

	// Use one encoder per level, do not create new each time.
	// Even if the jser can set a different formatter for each level
	// on SetLevelFormat, the encoding's writers may be different
	// if that ^ is not called but SetLevelOutput did provide a different writer.
	encoders map[Level]*json.Encoder
	mu       sync.RWMutex // encoders locker.
	encMu    sync.Mutex   // encode action locker.
}

// String returns the name of the Formatter.
// In this case it returns "json".
// It's used to map the formatter names with their implementations.
func (f *JSONFormatter) String() string {
	return "json"
}

// Options sets the options for the JSON Formatter (currently only indent).
func (f *JSONFormatter) Options(opts ...interface{}) Formatter {
	formatter := &JSONFormatter{
		Indent:   "  ",
		encoders: make(map[Level]*json.Encoder, len(Levels)),
	}

	for _, opt := range opts {
		if opt == nil {
			continue
		}

		if indent, ok := opt.(string); ok {
			formatter.Indent = indent
			break
		}
	}

	return formatter
}

// Format prints the logs in JSON format.
//
// Usage:
// logger.SetFormat("json") or
// logger.SetLevelFormat("info", "json")
func (f *JSONFormatter) Format(dest io.Writer, log *Log) bool {
	f.mu.RLock()
	enc, ok := f.encoders[log.Level]
	f.mu.RUnlock()

	if !ok {
		enc = json.NewEncoder(dest)
		enc.SetIndent("", f.Indent)
		f.mu.Lock()
		f.encoders[log.Level] = enc
		f.mu.Unlock()
	}

	f.encMu.Lock()
	err := enc.Encode(log)
	f.encMu.Unlock()
	return err == nil
}
