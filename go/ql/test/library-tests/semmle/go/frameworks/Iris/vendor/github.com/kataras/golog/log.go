package golog

import (
	"fmt"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

// A Log represents a log line.
type Log struct {
	// Logger is the original printer of this Log.
	Logger *Logger `json:"-"`
	// Time is the time of fired.
	Time time.Time `json:"-"`
	// Timestamp is the unix time in second of fired.
	Timestamp int64 `json:"timestamp,omitempty"`
	// Level is the log level.
	Level Level `json:"level"`
	// Message is the string reprensetation of the log's main body.
	Message string `json:"message"`
	// Fields any data information useful to represent this log.
	Fields Fields `json:"fields,omitempty"`
	// Stacktrace contains the stack callers when on `Debug` level.
	// The first one should be the Logger's direct caller function.
	Stacktrace []Frame `json:"stacktrace,omitempty"`
	// NewLine returns false if this Log
	// derives from a `Print` function,
	// otherwise true if derives from a `Println`, `Error`, `Errorf`, `Warn`, etc...
	//
	// This NewLine does not mean that `Message` ends with "\n" (or `pio#NewLine`).
	// NewLine has to do with the methods called,
	// not the original content of the `Message`.
	NewLine bool `json:"-"`
}

// Frame represents the log's caller.
type Frame struct {
	// Function is the package path-qualified function name of
	// this call frame. If non-empty, this string uniquely
	// identifies a single function in the program.
	// This may be the empty string if not known.
	Function string `json:"function"`
	// Source contains the file name and line number of the
	// location in this frame. For non-leaf frames, this will be
	// the location of a call.
	Source string `json:"source"`
}

// String method returns the concat value of "file:line".
// Implements the `fmt.Stringer` interface.
func (f Frame) String() string {
	return f.Source
}

// FormatTime returns the formatted `Time`.
func (l *Log) FormatTime() string {
	if l.Logger.TimeFormat == "" {
		return ""
	}
	return l.Time.Format(l.Logger.TimeFormat)
}

var funcNameReplacer = strings.NewReplacer(")", "", "(", "", "*", "")

// GetStacktrace tries to return the callers of this function.
func GetStacktrace(limit int) (callerFrames []Frame) {
	if limit < 0 {
		return nil
	}

	var pcs [32]uintptr
	n := runtime.Callers(1, pcs[:])
	frames := runtime.CallersFrames(pcs[:n])

	for {
		f, more := frames.Next()
		file := filepath.ToSlash(f.File)

		if strings.Contains(file, "go/src/") {
			continue
		}

		if strings.Contains(file, "github.com/kataras/golog") &&
			!(strings.Contains(file, "_examples") ||
				strings.Contains(file, "_test.go") ||
				strings.Contains(file, "integration.go")) {
			continue
		}

		if file != "" { // keep it here, break should be respected.
			funcName := f.Function
			if idx := strings.Index(funcName, ".("); idx > 1 {
				funcName = funcNameReplacer.Replace(funcName[idx+1:])
				// e.g. method: github.com/kataras/iris/v12.(*Application).Listen to:
				//      Application.Listen
			} else if idx = strings.LastIndexByte(funcName, '/'); idx >= 0 && len(funcName) > idx+1 {
				funcName = strings.Replace(funcName[idx+1:], ".", "/", 1)
				// e.g. package-level function: github.com/kataras/iris/v12/context.Do to
				// context/Do
			}

			callerFrames = append(callerFrames, Frame{
				Function: funcName,
				Source:   fmt.Sprintf("%s:%d", f.File, f.Line),
			})

			if limit > 0 && len(callerFrames) >= limit {
				break
			}
		}

		if !more {
			break
		}
	}

	return
}
