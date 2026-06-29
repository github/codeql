package main

import (
	"log"
)

func stdlib(selector int) {
	var logger log.Logger
	logger.SetPrefix("prefix: ")
	switch selector {
	case 0:
		logger.Fatal(text) // $ logger=text
	case 1:
		logger.Fatalf(fmt, text) // $ logger=fmt logger=text
	case 2:
		logger.Fatalln(text) // $ logger=text
	case 3:
		logger.Panic(text) // $ logger=text
	case 4:
		logger.Panicf(fmt, text) // $ logger=fmt logger=text
	case 5:
		logger.Panicln(text) // $ logger=text
	case 6:
		logger.Print(text) // $ logger=text
	case 7:
		logger.Printf(fmt, text) // $ logger=fmt logger=text
	case 8:
		logger.Println(text) // $ logger=text
	}

	// components corresponding to the format specifier "%T" are not considered vulnerable
	switch selector {
	case 9:
		logger.Fatalf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	case 10:
		logger.Panicf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	case 11:
		logger.Printf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}

	log.SetPrefix("prefix: ")
	switch selector {
	case 12:
		log.Fatal(text) // $ logger=text
	case 13:
		log.Fatalf(fmt, text) // $ logger=fmt logger=text
	case 14:
		log.Fatalln(text) // $ logger=text
	case 15:
		log.Panic(text) // $ logger=text
	case 16:
		log.Panicf(fmt, text) // $ logger=fmt logger=text
	case 17:
		log.Panicln(text) // $ logger=text
	case 18:
		log.Print(text) // $ logger=text
	case 19:
		log.Printf(fmt, text) // $ logger=fmt logger=text
	case 20:
		log.Println(text) // $ logger=text
	}

	// components corresponding to the format specifier "%T" are not considered vulnerable
	switch selector {
	case 21:
		log.Fatalf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	case 22:
		log.Panicf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	case 23:
		log.Printf("%s: found type %T", text, v) // $ logger="%s: found type %T" logger=text type-logger=v
	}
}
