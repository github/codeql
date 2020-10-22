//go:generate depstubber -vendor github.com/sirupsen/logrus Fields,LogFunction,Entry WithContext,WithError,WithFields,Error,Fatalf,Panicln,Infof,FatalFn

package main

import (
	"context"
	"errors"
	"github.com/sirupsen/logrus"
)

func logSomething(entry *logrus.Entry) {
	entry.Traceln(text) // $logger=text $f-:logger=fields
}

func logrusCalls() {
	err := errors.New("Error")
	var fields logrus.Fields = nil
	var fn logrus.LogFunction = nil
	var ctx context.Context
	tmp := logrus.WithContext(ctx)  //
	tmp.Debugf(fmt, text)           // $logger=ctx $logger=fmt $logger=text
	tmp = logrus.WithError(err)     //
	tmp.Warn(text)                  // $logger=err $logger=text
	tmp = logrus.WithFields(fields) //
	tmp.Infoln(text)                // $logger=fields $logger=text
	tmp = logrus.WithFields(fields) //
	logSomething(tmp)

	logrus.Error(text)       // $logger=text
	logrus.Fatalf(fmt, text) // $logger=fmt $logger=text
	logrus.Panicln(text)     // $logger=text
	logrus.Infof(fmt, text)  // $logger=fmt $logger=text
	logrus.FatalFn(fn)       // $logger=fn
}
