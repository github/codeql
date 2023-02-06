package main

//go:generate depstubber -vendor go.uber.org/zap/zapcore Core
//go:generate depstubber -vendor go.uber.org/zap Logger,SugaredLogger Any,Binary,ByteString,ByteStrings,Error,Errors,Fields,L,NamedError,New,NewDevelopment,NewExample,NewNop,NewProduction,Reflect,S,String,Stringp,Strings

import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func main() {}

func getUntrustedData() interface{} { return nil }

func getUntrustedString() string {
	return "tainted string"
}

func testZapLoggerDPanic() {
	logger, _ := zap.NewProduction()
	logger.DPanic(getUntrustedString()) // $ zap="call to getUntrustedString"
}

func testZapLoggerFatal() {
	logger := zap.NewExample()
	logger.Fatal("msg", zap.String(getUntrustedString(), "value")) // $ zap="call to String"
}

func testZapLoggerPanic() {
	logger, _ := zap.NewDevelopment()
	logger.Panic("msg", zap.Any("key", getUntrustedData())) // $ zap="call to Any"
}

func testZapLoggerDebug(core zapcore.Core, byteArray []byte) {
	logger := zap.New(core)
	logger.Debug(getUntrustedString())                                      // $ zap="call to getUntrustedString"
	logger.Debug("msg", zap.Binary(getUntrustedString(), byteArray))        // $ zap="call to Binary"
	logger.Debug("msg", zap.ByteString("key", getUntrustedData().([]byte))) // $ zap="call to ByteString"
}

func testZapLoggerError(bss [][]byte) {
	logger := zap.L()
	logger.Error(getUntrustedString())                              // $ zap="call to getUntrustedString"
	logger.Error("msg", zap.ByteStrings(getUntrustedString(), bss)) // $ zap="call to ByteStrings"
	logger.Error("msg", zap.Error(getUntrustedData().(error)))      // $ zap="call to Error"
}

func testZapLoggerInfo(logger *zap.Logger, errs []error) {
	logger.Info(getUntrustedString())                                     // $ zap="call to getUntrustedString"
	logger.Info("msg", zap.Errors(getUntrustedString(), errs))            // $ zap="call to Errors"
	logger.Info("msg", zap.NamedError("key", getUntrustedData().(error))) // $ zap="call to NamedError"
}

func testZapLoggerWarn(logger *zap.Logger) {
	logger.Warn(getUntrustedString())                                     // $ zap="call to getUntrustedString"
	logger.Warn("msg", zap.Reflect(getUntrustedString(), nil))            // $ zap="call to Reflect"
	logger.Warn("msg", zap.Stringp("key", getUntrustedData().(*string)))  // $ zap="call to Stringp"
	logger.Warn("msg", zap.Strings("key", getUntrustedData().([]string))) // $ zap="call to Strings"
}

func testZapLoggerNop() {
	// We do not currently recognise that a logger made using NewNop() does not actually do any logging
	logger := zap.NewNop()
	logger.Debug(getUntrustedString()) // $ SPURIOUS: zap="call to getUntrustedString"
}

func testLoggerNamed(logger *zap.Logger) {
	namedLogger := logger.Named(getUntrustedString()) // $ zap="call to getUntrustedString"
	namedLogger.Info("hello world")
}

func testLoggerWith(logger *zap.Logger) *zap.Logger {
	logger1 := logger.With(zap.Any(getUntrustedString(), nil)) // $ zap="call to Any"
	logger1.Info("hello world")
	logger2 := logger.With(zap.String("key", getUntrustedString())) // $ zap="call to String"
	logger2.Info("hello world")
	logger3 := logger.With(zap.String("key", getUntrustedString())) // $ SPURIOUS: zap="call to String"
	return logger3
}

func getLoggerWithUntrustedField() *zap.Logger {
	return zap.NewExample().With(zap.NamedError("key", getUntrustedData().(error))) // $ zap="call to NamedError"
}

func getLoggerWithUntrustedFieldUnused() *zap.Logger {
	return zap.NewExample().With(zap.NamedError("key", getUntrustedData().(error))) // $ SPURIOUS: zap="call to NamedError"
}

func testLoggerWithAcrossFunctionBoundary() {
	getLoggerWithUntrustedField().Info("hello world")
}

func testLoggerWithOptions(logger *zap.Logger) *zap.Logger {
	logger1 := logger.WithOptions(zap.Fields(zap.Any(getUntrustedString(), nil))) // $ zap="call to Fields"
	logger1.Info("hello world")
	logger2 := logger.WithOptions(zap.Fields(zap.String("key", getUntrustedString()))) // $ zap="call to Fields"
	logger2.Info("hello world")
	logger3 := logger.WithOptions(zap.Fields(zap.String("key", getUntrustedString()))) // $ SPURIOUS: zap="call to Fields"
	return logger3
}

func testZapSugaredLoggerDPanic(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.DPanic(getUntrustedData()) // $ zap="call to getUntrustedData"
}

func testZapSugaredLoggerDPanicf(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.DPanicf(getUntrustedString()) // $ zap="call to getUntrustedString"
}

func testZapSugaredLoggerDPanicw(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.DPanicw(getUntrustedString()) // $ zap="call to getUntrustedString"
}

func testZapSugaredLoggerFatal(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.Fatal(getUntrustedData()) // $ zap="call to getUntrustedData"
}

func testZapSugaredLoggerFatalf(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.Fatalf(getUntrustedString()) // $ zap="call to getUntrustedString"
}

func testZapSugaredLoggerFatalw(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.Fatalw(getUntrustedString()) // $ zap="call to getUntrustedString"
}

func testZapSugaredLoggerPanic(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.Panic(getUntrustedData()) // $ zap="call to getUntrustedData"
}

func testZapSugaredLoggerPanicf(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.Panicf(getUntrustedString()) // $ zap="call to getUntrustedString"
}

func testZapSugaredLoggerPanicw(sugaredLogger *zap.SugaredLogger) {
	sugaredLogger.Panicw(getUntrustedString()) // $ zap="call to getUntrustedString"
}

func testZapSugaredLoggerDebug() {
	sugaredLogger := zap.S()
	sugaredLogger.Debug(getUntrustedData())                // $ zap="call to getUntrustedData"
	sugaredLogger.Debugf("msg", getUntrustedData())        // $ zap="call to getUntrustedData"
	sugaredLogger.Debugw("msg", "key", getUntrustedData()) // $ zap="call to getUntrustedData"
}

func testZapSugaredLoggerError() {
	logger, _ := zap.NewProduction()
	sugaredLogger := logger.Sugar()
	sugaredLogger.Error(getUntrustedData())                // $ zap="call to getUntrustedData"
	sugaredLogger.Errorf("msg", getUntrustedData())        // $ zap="call to getUntrustedData"
	sugaredLogger.Errorw("msg", "key", getUntrustedData()) // $ zap="call to getUntrustedData"
}

func testZapSugaredLoggerInfo() {
	logger := zap.NewExample()
	sugaredLogger := logger.Sugar()
	sugaredLogger.Info(getUntrustedData())                // $ zap="call to getUntrustedData"
	sugaredLogger.Infof("msg", getUntrustedData())        // $ zap="call to getUntrustedData"
	sugaredLogger.Infow("msg", "key", getUntrustedData()) // $ zap="call to getUntrustedData"
}

func testZapSugaredLoggerWarn() {
	logger, _ := zap.NewDevelopment()
	sugaredLogger := logger.Sugar()
	sugaredLogger.Warn(getUntrustedData())                // $ zap="call to getUntrustedData"
	sugaredLogger.Warnf("msg", getUntrustedData())        // $ zap="call to getUntrustedData"
	sugaredLogger.Warnw("msg", "key", getUntrustedData()) // $ zap="call to getUntrustedData"
}

func testZapSugaredLoggerNamed() {
	logger := zap.L()
	sugaredLogger := logger.Sugar()
	sugaredLogger.Named(getUntrustedString()) // $ zap="call to getUntrustedString"
	sugaredLogger.Info("msg")
}

func testZapSugaredLoggerWith() {
	logger := zap.L()
	sugaredLogger := logger.Sugar()
	sugaredLogger.With("key", getUntrustedData()) // $ zap="call to getUntrustedData"
	sugaredLogger.Info("msg")
}
