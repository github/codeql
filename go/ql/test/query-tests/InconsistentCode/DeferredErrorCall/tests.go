package test

import (
	"errors"
	"log"
)

func returnsPair() (string, error) {
	return "", errors.New("Test error")
}

func checkSomething() error {
	return nil
}

func deferredCalls() {
	defer returnsPair()
	defer checkSomething()

	var fun = checkSomething
	defer fun()

	defer func() error { return nil }()
}

func notDeferred() {
	if _, err := returnsPair(); err != nil {
		log.Fatal(err)
	}

	if err := checkSomething(); err != nil {
		log.Fatal(err)
	}

	var fun = checkSomething
	if err := fun(); err != nil {
		log.Fatal(err)
	}

	if err := func() error { return nil }(); err != nil {
		log.Fatal(err)
	}
}
