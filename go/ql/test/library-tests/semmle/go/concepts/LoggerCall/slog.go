package main

import (
	"context"
	"log/slog"
)

func slogTest() {
	ctx := context.Background()
	var logger *slog.Logger

	// Methods on *slog.Logger: Debug/Info/Warn/Error(msg string, args ...any).
	logger.Debug(text)       // $ logger=text
	logger.Info(text)        // $ logger=text
	logger.Warn(text)        // $ logger=text
	logger.Error(text)       // $ logger=text
	logger.Info(text, key, v) // $ logger=text logger=key logger=v

	// Context variants: (ctx, msg string, args ...any).
	logger.DebugContext(ctx, text)       // $ logger=text
	logger.InfoContext(ctx, text)        // $ logger=text
	logger.WarnContext(ctx, text)        // $ logger=text
	logger.ErrorContext(ctx, text)       // $ logger=text
	logger.InfoContext(ctx, text, key, v) // $ logger=text logger=key logger=v

	// Log/LogAttrs: (ctx, level, msg string, args/attrs ...).
	logger.Log(ctx, slog.LevelInfo, text, key, v) // $ logger=text logger=key logger=v
	logger.LogAttrs(ctx, slog.LevelInfo, text)     // $ logger=text

	// Package-level convenience functions.
	slog.Debug(text)       // $ logger=text
	slog.Info(text)        // $ logger=text
	slog.Warn(text)        // $ logger=text
	slog.Error(text)       // $ logger=text
	slog.Info(text, key, v) // $ logger=text logger=key logger=v
	slog.InfoContext(ctx, text, key, v) // $ logger=text logger=key logger=v
	slog.Log(ctx, slog.LevelInfo, text) // $ logger=text
	slog.LogAttrs(ctx, slog.LevelInfo, text) // $ logger=text
}
