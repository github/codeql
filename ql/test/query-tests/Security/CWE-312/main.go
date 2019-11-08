// +build ignore

package main

import (
	"fmt"
	"github.com/google/glog"
	"github.com/sirupsen/logrus"
	"log"
)

func main() {
	password := "P4ssw0rd"

	log.Println(password)

	glog.Info(password)
	logrus.Warning(password)

	fields := make(logrus.Fields)
	fields["pass"] = password
	entry := logrus.WithFields(fields)
	entry.Errorf("")

	entry = logrus.WithField("pass", password)
	entry.Panic("")
}
