package internal

import (
	"fmt"
	"log"
	"os"
)

var Warn = log.New(os.Stderr, "WARN: bun: ", log.LstdFlags)

var Deprecated = log.New(os.Stderr, "DEPRECATED: bun: ", log.LstdFlags)

type Logging interface {
	Printf(format string, v ...interface{})
}

type logger struct {
	log *log.Logger
}

func (l *logger) Printf(format string, v ...interface{}) {
	_ = l.log.Output(2, fmt.Sprintf(format, v...))
}

var Logger Logging = &logger{
	log: log.New(os.Stderr, "bun: ", log.LstdFlags|log.Lshortfile),
}
