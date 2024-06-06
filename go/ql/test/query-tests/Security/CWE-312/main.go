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

	log.Print(password)
	log.Printf("", password)
	log.Printf(password, "")
	log.Println(password)
	log.Fatal(password)
	log.Fatalf("", password)
	log.Fatalf(password, "")
	log.Fatalln(password)
	log.Panic(password)
	log.Panicf("", password)
	log.Panicf(password, "")
	log.Panicln(password)
	log.Output(0, password)

	l := log.Default()
	l.Print(password)
	l.Printf("", password)
	l.Printf(password, "")
	l.Println(password)
	l.Fatal(password)
	l.Fatalf("", password)
	l.Fatalf(password, "")
	l.Fatalln(password)
	l.Panic(password)
	l.Panicf("", password)
	l.Panicf(password, "")
	l.Panicln(password)
	l.Output(0, password)

	glog.Info(password)
	logrus.Warning(password)

	fields := make(logrus.Fields)
	fields["pass"] = password
	entry := logrus.WithFields(fields)
	entry.Errorf("")

	entry = logrus.WithField("pass", password)
	entry.Panic("")
}
