package main

//go:generate depstubber -vendor github.com/sirupsen/logrus Fields,Entry Warning,WithFields,WithField
//go:generate depstubber -vendor github.com/golang/glog "" Info

import (
	"log"
	"math/rand"

	"github.com/golang/glog"
	"github.com/sirupsen/logrus"
)

var i int = rand.Int()

func main() {
	password := "P4ssw0rd" // $ Source

	log.Print(password)        // $ Alert
	log.Printf("%s", password) // $ Alert
	log.Printf(password, "")   // $ Alert
	log.Println(password)      // $ Alert
	if i == 0 {
		log.Fatal(password) // $ Alert
	}
	if i == 1 {
		log.Fatalf("%s", password) // $ Alert
	}
	if i == 2 {
		log.Fatalf(password, "") // $ Alert
	}
	if i == 3 {
		log.Fatalln(password) // $ Alert
	}
	if i == 4 {
		log.Panic(password) // $ Alert
	}
	if i == 5 {
		log.Panicf("%s", password) // $ Alert
	}
	if i == 6 {
		log.Panicf(password, "") // $ Alert
	}
	if i == 7 {
		log.Panicln(password) // $ Alert
	}
	log.Output(0, password) // $ Alert
	log.Printf("%T", password)

	l := log.Default()
	l.Print(password)        // $ Alert
	l.Printf("%s", password) // $ Alert
	l.Printf(password, "")   // $ Alert
	l.Println(password)      // $ Alert
	if i == 100 {
		l.Fatal(password) // $ Alert
	}
	if i == 101 {
		l.Fatalf("%s", password) // $ Alert
	}
	if i == 102 {
		l.Fatalf(password, "") // $ Alert
	}
	if i == 103 {
		l.Fatalln(password) // $ Alert
	}
	if i == 104 {
		l.Panic(password) // $ Alert
	}
	if i == 105 {
		l.Panicf("%s", password) // $ Alert
	}
	if i == 106 {
		l.Panicf(password, "") // $ Alert
	}
	if i == 107 {
		l.Panicln(password) // $ Alert
	}
	l.Output(0, password) // $ Alert
	l.Printf("%T", password)

	glog.Info(password)      // $ Alert
	logrus.Warning(password) // $ Alert

	fields := make(logrus.Fields)
	fields["pass"] = password
	entry := logrus.WithFields(fields) // $ Alert
	entry.Errorf("")

	entry = logrus.WithField("pass", password) // $ Alert
	entry.Panic("")
}
