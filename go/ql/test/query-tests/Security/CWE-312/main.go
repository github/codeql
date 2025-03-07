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
	password := "P4ssw0rd"

	log.Print(password)
	log.Printf("", password)
	log.Printf(password, "")
	log.Println(password)
	if i == 0 {
		log.Fatal(password)
	}
	if i == 1 {
		log.Fatalf("", password)
	}
	if i == 2 {
		log.Fatalf(password, "")
	}
	if i == 3 {
		log.Fatalln(password)
	}
	if i == 4 {
		log.Panic(password)
	}
	if i == 5 {
		log.Panicf("", password)
	}
	if i == 6 {
		log.Panicf(password, "")
	}
	if i == 7 {
		log.Panicln(password)
	}
	log.Output(0, password)

	l := log.Default()
	l.Print(password)
	l.Printf("", password)
	l.Printf(password, "")
	l.Println(password)
	if i == 10 {
		l.Fatal(password)
	}
	if i == 11 {
		l.Fatalf("", password)
	}
	if i == 12 {
		l.Fatalf(password, "")
	}
	if i == 13 {
		l.Fatalln(password)
	}
	if i == 14 {
		l.Panic(password)
	}
	if i == 15 {
		l.Panicf("", password)
	}
	if i == 16 {
		l.Panicf(password, "")
	}
	if i == 17 {
		l.Panicln(password)
	}
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
