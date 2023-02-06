package main

//go:generate depstubber -vendor github.com/pkg/errors "" Errorf,Wrap

import (
	"github.com/pkg/errors"
)

func f1(input string) error {
	if input == "1" {
		return errors.Errorf("error in f1")
	}
	return nil
}

func f2(input string) (bool, error) {
	if input == "2" {
		return false, errors.Errorf("error in f2")
	}
	return true, nil
}

func test1(input string) error {
	err := f1(input)
	if err != nil {
		// GOOD: Wrapped error is always non-nil
		return errors.Wrap(err, "")
	}
	if ok2, _ := f2(input); !ok2 {
		// BAD: Wrapped error is always nil
		return errors.Wrap(err, "")
	}
	return nil
}

func test2(err error) {
	// GOOD: Wrapped error is not always nil
	errors.Wrap(err, "")

	// BAD: Wrapped error is always nil
	errors.Wrap(nil, "")

	err = nil
	// BAD: Wrapped error is always nil
	errors.Wrap(err, "")

	var localErr error = nil
	// BAD: Wrapped error is always nil
	errors.Wrap(localErr, "")
}
