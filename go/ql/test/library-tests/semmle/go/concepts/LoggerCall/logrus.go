//go:generate depstubber -vendor github.com/sirupsen/logrus Fields,LogFunction,Entry WithContext,WithError,WithFields,Error,Fatalf,Panicln,Infof,FatalFn

package main

import (
	"context"
	"errors"

	"github.com/sirupsen/logrus"
)

func logSomething(entry *logrus.Entry) {
	entry.Traceln(text) // $ logger=text
}

func logrusCalls() {
	err := errors.New("Error")
	var fields logrus.Fields = nil
	var fn logrus.LogFunction = nil
	var ctx context.Context
	tmp := logrus.WithContext(ctx)  // ctx isn't output, so no match here
	tmp.Debugf(fmt, text)           // $ logger=fmt logger=text
	tmp = logrus.WithError(err)     // $ logger=err
	tmp.Warn(text)                  // $ logger=text
	tmp = logrus.WithFields(fields) // $ logger=fields
	tmp.Infoln(text)                // $ logger=text
	tmp = logrus.WithFields(fields) // $ logger=fields
	logSomething(tmp)

	logrus.Error(text)       // $ logger=text
	logrus.Fatalf(fmt, text) // $ logger=fmt logger=text
	logrus.Panicln(text)     // $ logger=text
	logrus.Infof(fmt, text)  // $ logger=fmt logger=text
	logrus.FatalFn(fn)       // $ logger=fn
}
