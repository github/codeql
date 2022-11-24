package test

import (
	"errors"
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
}

func notDeferred() {
	res, err := returnsPair()
	err2 := checkSomething()
}
