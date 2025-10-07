package util

import (
	"log/slog"
	"strings"
	"testing"
)

func assertLogLevel(t *testing.T, value string, level slog.Level) {
	actual := parseLogLevel(value)
	if actual != level {
		t.Errorf("Expected %s to parse as %s, but got %s", value, level, actual)
	}
}

func TestParseLogLevel(t *testing.T) {
	// Known verbosity levels.
	assertLogLevel(t, string(Errors), slog.LevelError)
	assertLogLevel(t, string(Warnings), slog.LevelWarn)
	assertLogLevel(t, string(Progress), slog.LevelInfo)
	assertLogLevel(t, string(Details), slog.LevelDebug)
	assertLogLevel(t, string(Spammy), slog.LevelDebug)
	assertLogLevel(t, string(Spammier), slog.LevelDebug)

	// Ignore case
	assertLogLevel(t, strings.ToUpper(string(Spammier)), slog.LevelDebug)
	assertLogLevel(t, strings.ToUpper(string(Errors)), slog.LevelError)

	// Other values default to LevelInfo
	assertLogLevel(t, "", slog.LevelInfo)
	assertLogLevel(t, "unknown", slog.LevelInfo)
	assertLogLevel(t, "none", slog.LevelInfo)
}
