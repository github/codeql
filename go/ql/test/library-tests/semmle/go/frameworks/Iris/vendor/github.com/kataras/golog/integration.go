package golog

// ExternalLogger is a typical logger interface.
// Any logger or printer that completes this interface
// can be used to intercept and handle the golog's messages.
//
// See `Logger#Install` and `Logger#Handle` for more.
type ExternalLogger interface {
	Print(...interface{})
	Println(...interface{})
	Error(...interface{})
	Warn(...interface{})
	Info(...interface{})
	Debug(...interface{})
}

// integrateExternalLogger is a Handler which
// intercepts all messages from print functions,
// between print action and actual write to the output,
// and sends these (messages) to the external "logger".
//
// In short terms, when this handler is passed via `Handle`
// then, instead of printing from the logger's Printer
// it prints from the given "logger".
func integrateExternalLogger(logger ExternalLogger) Handler {
	return func(log *Log) bool {
		printFunc := getExternalPrintFunc(logger, log)
		printFunc(log.Message)
		return true
	}
}

func getExternalPrintFunc(logger ExternalLogger, log *Log) func(...interface{}) {
	switch log.Level {
	case ErrorLevel:
		return logger.Error
	case WarnLevel:
		return logger.Warn
	case InfoLevel:
		return logger.Info
	case DebugLevel:
		return logger.Debug
	}

	// disable level or use of golog#Print/Println functions:

	// passed with Println
	if log.NewLine {
		return logger.Println
	}

	return logger.Print
}

// StdLogger is the standard log.Logger interface.
// Any logger or printer that completes this interface
// can be used to intercept and handle the golog's messages.
//
// See `Logger#Install` and `Logger#Handle` for more.
type StdLogger interface {
	Printf(format string, v ...interface{})
	Print(v ...interface{})
	Println(v ...interface{})
}

func integrateStdLogger(logger StdLogger) Handler {
	return func(log *Log) bool {
		printFunc := getStdPrintFunc(logger, log)
		printFunc(log.Message)
		return true
	}
}

func getStdPrintFunc(logger StdLogger, log *Log) func(...interface{}) {
	// no levels here

	// passed with Println
	if log.NewLine {
		return logger.Println
	}

	return logger.Print
}
