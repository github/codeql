package test

import (
	"errors"
	"fmt"
	"os"
)

func returnsNonNil(input int) (*int, error) {

	newp := new(int)
	*newp = 5

	if input%2 == 0 {
		return newp, nil
	} else {
		return newp, errors.New("oh no")
	}

}

func userDefinedDie() {

	os.Exit(1)

}

func makesCheckUsingSwitch(fname string) {

	result, err := os.Open(fname)

	switch {
	case len(os.Args) >= 3:
		fmt.Println("Too many args")
		return
	case err != nil:
		fmt.Println("Open failed")
		return
	}

	fmt.Printf("Opened: %v\n", *result) // OK

}

func definesValueInIf(fname string) {

	var result *os.File
	var err error
	if result, err = os.Open(fname); err != nil {
		return
	}

	fmt.Printf("Opened: %v\n", *result) // OK

}

func missingCheckMayFail(fname string) {

	result, err := os.Open(fname)

	fmt.Printf("Opened: %v\n", *result) // NOT OK
	fmt.Printf("%v\n", err)             // use err

}

func missingCheckSafe(input int) {

	result, err := returnsNonNil(input)

	fmt.Printf("Got: %d\n", *result) // OK
	fmt.Printf("%v\n", err)          // use err

}

func usesUserExitFn(fname string) {

	result, err := os.Open(fname)
	if err != nil {
		userDefinedDie()
	}

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

func userTestFn(e error) bool {
	return e != nil
}

func usesUserTestFn(fname string) {

	result, err := os.Open(fname)
	if userTestFn(err) {
		return
	}

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

func userRequireFn(e error) {
	if e != nil {
		os.Exit(1)
	}
}

func usesUserRequireFn(fname string) {

	result, err := os.Open(fname)
	userRequireFn(err)

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

func userPtrTestFn(ptr *os.File) bool {
	return ptr != nil
}

func usesUserPtrTestFn(fname string) {

	result, err := os.Open(fname)
	if userPtrTestFn(result) {
		return
	}

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

func userPtrRequireFn(ptr *os.File) {
	if ptr != nil {
		os.Exit(1)
	}
}

func usesUserPtrRequireFn(fname string) {

	result, err := os.Open(fname)
	userPtrRequireFn(result)

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

func reusesErrorVar(fname string) {

	result, err := os.Open(fname)
	if err == nil {
		_, err = os.Open(fname)
	}
	if err != nil {
		return
	}

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

func neverReallyErrors() (*int, error) {

	newp := new(int)
	*newp = 1
	return newp, nil

}

func callsNeverReallyErrors() {

	result, err := neverReallyErrors()

	fmt.Printf("Got: %d\n", *result) // OK
	fmt.Printf("%v\n", err)          // use err

}

func checksErrorViaPhiNode(fname string) {

	// Note 'result' must not be forwarded via a phi;
	// the deref has to be of exactly the definition
	// we're investigating, whereas the error check can
	// be of any downstream SSA or ordinary copy.
	result, err := os.Open(fname)
	if len(fname)%3 == 0 {
		_, err = os.Open(fname)
	}
	if err != nil {
		return
	}

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

func checksErrorViaCopy(fname string) {

	var result *os.File
	var err error
	var err2 error
	result, err2 = os.Open(fname)
	err = err2
	if err != nil {
		return
	}

	fmt.Printf("Opened: %v\n", *result) // OK
	fmt.Printf("%v\n", err)             // use err

}

type myError struct {
	field int
}

// Implement error interface:
func (err *myError) Error() string {
	return "myError"
}

func returnsMyError(input int) (*int, *myError) {

	if input%2 == 0 {
		newp := new(int)
		*newp = 5
		return newp, nil
	} else {
		return nil, &myError{}
	}

}

func mishandlesMyError(input int) {

	result, err := returnsMyError(input)

	fmt.Printf("Got: %d\n", *result) // NOT OK
	fmt.Printf("%v\n", err)          // use err

}
