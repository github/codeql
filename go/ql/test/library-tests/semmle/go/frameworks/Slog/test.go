package main

import (
	"context"
	"log/slog"
)

func main() {}

func getUntrustedData() interface{} { return nil }

func getUntrustedString() string {
	return "tainted string"
}

// Package-level convenience functions.

func testSlogDebug() {
	slog.Debug(getUntrustedString())                            // $ hasValueFlow="call to getUntrustedString"
	slog.Debug("msg", "key", getUntrustedData())                // $ hasValueFlow="call to getUntrustedData"
	slog.Debug("msg", slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
}

func testSlogInfo() {
	slog.Info(getUntrustedString())                            // $ hasValueFlow="call to getUntrustedString"
	slog.Info("msg", slog.Any("key", getUntrustedData()))      // $ hasTaintFlow="call to Any"
	slog.Info("msg", slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
}

func testSlogWarn() {
	slog.Warn(getUntrustedString())                            // $ hasValueFlow="call to getUntrustedString"
	slog.Warn("msg", slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
}

func testSlogError() {
	slog.Error(getUntrustedString())                            // $ hasValueFlow="call to getUntrustedString"
	slog.Error("msg", slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
}

func testSlogContextVariants(ctx context.Context) {
	slog.DebugContext(ctx, getUntrustedString())                           // $ hasValueFlow="call to getUntrustedString"
	slog.InfoContext(ctx, getUntrustedString())                            // $ hasValueFlow="call to getUntrustedString"
	slog.WarnContext(ctx, getUntrustedString())                            // $ hasValueFlow="call to getUntrustedString"
	slog.ErrorContext(ctx, getUntrustedString())                           // $ hasValueFlow="call to getUntrustedString"
	slog.InfoContext(ctx, "msg", slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
}

func testSlogLog(ctx context.Context) {
	slog.Log(ctx, slog.LevelInfo, getUntrustedString())                                 // $ hasValueFlow="call to getUntrustedString"
	slog.Log(ctx, slog.LevelInfo, "msg", slog.String("key", getUntrustedString()))      // $ hasTaintFlow="call to String"
	slog.LogAttrs(ctx, slog.LevelInfo, getUntrustedString())                            // $ hasValueFlow="call to getUntrustedString"
	slog.LogAttrs(ctx, slog.LevelInfo, "msg", slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
}

// Methods on *slog.Logger.

func testLoggerMethods(logger *slog.Logger, ctx context.Context) {
	logger.Debug(getUntrustedString())                                                    // $ hasValueFlow="call to getUntrustedString"
	logger.Info(getUntrustedString())                                                     // $ hasValueFlow="call to getUntrustedString"
	logger.Warn(getUntrustedString())                                                     // $ hasValueFlow="call to getUntrustedString"
	logger.Error(getUntrustedString())                                                    // $ hasValueFlow="call to getUntrustedString"
	logger.Info("msg", slog.Any("key", getUntrustedData()))                               // $ hasTaintFlow="call to Any"
	logger.InfoContext(ctx, getUntrustedString())                                         // $ hasValueFlow="call to getUntrustedString"
	logger.Log(ctx, slog.LevelInfo, getUntrustedString())                                 // $ hasValueFlow="call to getUntrustedString"
	logger.LogAttrs(ctx, slog.LevelInfo, "msg", slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
}

// With, Logger.With and Logger.WithGroup. Note that for ease of modeling we make these functions
// sinks, although strictly speaking we should consider logging functions called on the returned
// loggers as the sinks.

func testWith(logger *slog.Logger) {
	logger1 := logger.With(slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
	logger1.Info("hello world")
	logger2 := logger.With(slog.Any(getUntrustedString(), nil)) // $ hasTaintFlow="call to Any"
	logger2.Info("hello world")
	logger.With("key", getUntrustedData()).Info("hello world") // $ hasValueFlow="call to getUntrustedData"
}

func testPackageWith() {
	logger := slog.With(slog.String("key", getUntrustedString())) // $ hasTaintFlow="call to String"
	logger.Info("hello world")
	slog.With("key", getUntrustedData()).Info("hello world") // $ hasValueFlow="call to getUntrustedData"
}

func testWithGroup(logger *slog.Logger) {
	grouped := logger.WithGroup(getUntrustedString()) // $ hasValueFlow="call to getUntrustedString"
	grouped.Info("hello world")
}

// Summary models: functions relating to Attr/Value that propagate strings.

func testAttrConstructors(logger *slog.Logger) {
	logger.Info("msg", slog.Group("group", slog.String("key", getUntrustedString())))      // $ hasTaintFlow="call to Group"
	logger.Info("msg", slog.GroupAttrs("group", slog.String("key", getUntrustedString()))) // $ hasTaintFlow="call to GroupAttrs"
}

func testValueConstructors(logger *slog.Logger) {
	logger.Info("msg", "key", slog.AnyValue(getUntrustedString()))    // $ hasTaintFlow="call to AnyValue"
	logger.Info("msg", "key", slog.StringValue(getUntrustedString())) // $ hasTaintFlow="call to StringValue"
	attr := slog.String("key", getUntrustedString())
	logger.Info("msg", "key", slog.GroupValue(attr)) // $ hasTaintFlow="call to GroupValue"
}

func testAttrAndValueAccessors(logger *slog.Logger) {
	attr := slog.String("key", getUntrustedString())
	logger.Info("msg", "key", attr.String()) // $ hasTaintFlow="call to String"

	v := slog.AnyValue(getUntrustedString())
	logger.Info("msg", "key", v.Any())    // $ hasTaintFlow="call to Any"
	logger.Info("msg", "key", v.String()) // $ hasTaintFlow="call to String"

	group := slog.GroupValue(slog.String("key", getUntrustedString()))
	logger.Info("msg", group.Group()[0]) // $ hasTaintFlow="index expression"
}
