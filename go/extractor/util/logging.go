package util

import (
	"log/slog"
	"os"
	"strings"
)

// Mirrors the verbosity definitions in the CodeQL CLI, which are passed to us
// in the `CODEQL_VERBOSITY` environment variable.
type Verbosity string

const (
	// Only print error messages.
	Errors Verbosity = "errors"
	// Print warnings and error messages.
	Warnings Verbosity = "warnings"
	// Default verbosity.
	Progress Verbosity = "progress"
	// More details of normal operations.
	Details Verbosity = "progress+"
	// Debug level set by e.g. the CodeQL Action.
	Spammy Verbosity = "progress++"
	// The most detailed.
	Spammier Verbosity = "progress+++"
)

func parseLogLevel(value string) slog.Level {
	value = strings.ToLower(value)
	if strings.HasPrefix(value, string(Details)) {
		return slog.LevelDebug
	} else if value == string(Errors) {
		return slog.LevelError
	} else if value == string(Warnings) {
		return slog.LevelWarn
	} else {
		// Default
		return slog.LevelInfo
	}
}

// Sets the log level for the default `slog` logger, based on `CODEQL_VERBOSITY`.
func SetLogLevel() {
	slog.SetLogLoggerLevel(parseLogLevel(os.Getenv("CODEQL_VERBOSITY")))
}
