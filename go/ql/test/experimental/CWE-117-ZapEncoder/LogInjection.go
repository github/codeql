package main

import (
    "go.uber.org/zap"
    "go.uber.org/zap/zapcore"
    "os"
)

func LogWithSafeZapEncoder() {
    unsafeInput := os.Getenv("UNTRUSTED")  // treat this as “source”

    // Create a safe JSON encoder (that we whitelist)
    encoderCfg := zap.NewProductionEncoderConfig()
    jsonEncoder := zapcore.NewJSONEncoder(encoderCfg)

    // Build logger using that encoder
    core := zapcore.NewCore(jsonEncoder, zapcore.AddSync(os.Stdout), zapcore.DebugLevel)
    logger := zap.New(core)

    logger.Info("user input", zap.String("data", unsafeInput))
}

func LogWithUnsafeZapEncoder() {
    unsafeInput := os.Getenv("UNTRUSTED")  // source

    // Suppose a “custom” encoder that does *not* sanitize newline
    // For test purposes, just use console encoder but pretend it’s unsafe
    encoderCfg := zap.NewProductionEncoderConfig()
    consoleEncoder := zapcore.NewConsoleEncoder(encoderCfg)

    core := zapcore.NewCore(consoleEncoder, zapcore.AddSync(os.Stdout), zapcore.DebugLevel)
    logger := zap.New(core)

    logger.Info("user input", zap.String("data", unsafeInput))
}
