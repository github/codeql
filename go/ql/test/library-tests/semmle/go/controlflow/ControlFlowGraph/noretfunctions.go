package main

import (
	"log"
	"os"
)

func isNoRet() {
	os.Exit(1)
}

func mayRet(x int) {
	if x != 0 {
		os.Exit(x)
	}
}

func doesRet() {}

func noRetUsesLogFatal() {
	log.Fatal("Oh no")
}

func noRetUsesLogFatalf() {
	log.Fatalf("It's as I feared")
}
