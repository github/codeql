package main

//go:generate depstubber -vendor github.com/sirupsen/logrus Fields,Entry Warning,WithFields,WithField
//go:generate depstubber -vendor github.com/golang/glog "" Info

import (
	"github.com/golang/glog"
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
