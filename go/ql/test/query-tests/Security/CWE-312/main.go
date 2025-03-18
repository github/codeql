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

	log.Print(password)      // $ Alert
	log.Printf("", password) // $ Alert
	log.Printf(password, "") // $ Alert
	log.Println(password)    // $ Alert
	log.Fatal(password)      // $ Alert
	log.Fatalf("", password) // $ Alert
	log.Fatalf(password, "") // $ Alert
	log.Fatalln(password)    // $ Alert
	log.Panic(password)      // $ Alert
	log.Panicf("", password) // $ Alert
	log.Panicf(password, "") // $ Alert
	log.Panicln(password)    // $ Alert
	log.Output(0, password)  // $ Alert

	l := log.Default()
	l.Print(password)      // $ Alert
	l.Printf("", password) // $ Alert
	l.Printf(password, "") // $ Alert
	l.Println(password)    // $ Alert
	l.Fatal(password)      // $ Alert
	l.Fatalf("", password) // $ Alert
	l.Fatalf(password, "") // $ Alert
	l.Fatalln(password)    // $ Alert
	l.Panic(password)      // $ Alert
	l.Panicf("", password) // $ Alert
	l.Panicf(password, "") // $ Alert
	l.Panicln(password)    // $ Alert
	l.Output(0, password)  // $ Alert

	glog.Info(password)      // $ Alert
	logrus.Warning(password) // $ Alert

	fields := make(logrus.Fields)
	fields["pass"] = password
	entry := logrus.WithFields(fields)
	entry.Errorf("")

	entry = logrus.WithField("pass", password) // $ Alert
	entry.Panic("")
}
