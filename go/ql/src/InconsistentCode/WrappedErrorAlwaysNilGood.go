package main

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
		return errors.Wrap(err, "input is the first non-negative integer")
	}
	if ok2, _ := f2(input); !ok2 {
		return errors.New("input is the second non-negative integer")
	}
	return nil
}
