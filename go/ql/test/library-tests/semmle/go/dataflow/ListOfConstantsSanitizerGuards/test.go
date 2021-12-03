package main

import (
	"crypto/rand"
	"fmt"
)

const constantGlobalVariable string = "constant global variable"

// Utilities: a source, a sink and an error struct:

func source() string {
	return "tainted"
}

func sink(s string) {}

func getRandomString() string {
	buff := make([]byte, 10)
	rand.Read(buff)
	return fmt.Sprintf("%x", buff)
}

func getConstantString() string {
	return "constant return value"
}

type errorString struct {
	s string
}

func (e *errorString) Error() string {
	return e.s
}

// Candidate functions which compare the input against a list of constants:

func switchStatementReturningTrueOnlyWhenConstant(s string) bool {
	switch s {
	case constantGlobalVariable, "string literal":
		return true
	case getRandomString():
		return false
	case "another string literal":
		return false
	default:
		return false
	}
}

func switchStatementReturningFalseOnlyWhenConstant(r string, s string) bool {
	switch s {
	case "string literal":
		return false
	case constantGlobalVariable:
		return false
	case "another string literal":
		return true
	}
	return true
}

func switchStatementReturningNonNilOnlyWhenConstant(s string) (string, error) {
	switch s {
	case constantGlobalVariable, "string literal":
		return "error", &errorString{"a"}
	case getRandomString():
		return "no error", nil
	case "another string literal":
		fallthrough
	default:
		return "no error", nil
	}
}

func switchStatementReturningNilOnlyWhenConstant(s string) *string {
	t := s
	switch t {
	case "string literal":
		fallthrough
	case constantGlobalVariable:
		return nil
	case "another string literal":
		str := "matches random string"
		return &str
	}
	str := "no matches"
	return &str
}

func multipleSwitchStatementReturningTrueOnlyWhenConstant(s string, t string) bool {
	switch s {
	case constantGlobalVariable, "string literal":
		return true
	case getRandomString():
		return false
	}
	switch s {
	case "another string literal":
		return true
	}
	switch t {
	case "another string literal":
		return false
	default:
		return false
	}
}

func switchStatementWithoutUsefulInfo(s string) bool {
	switch s {
	case constantGlobalVariable, "string literal":
		return false
	case getRandomString():
		return true
	default:
		return false
	}
}

func switchStatementOverRandomString(s string) bool {
	switch getRandomString() {
	case "string literal":
		return true
	default:
		return false
	}
}

// Tests

func main() {

	// Switch statements in functions

	{
		s := source()
		if switchStatementReturningTrueOnlyWhenConstant(s) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if switchStatementReturningFalseOnlyWhenConstant("", s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s)
		}
	}

	{
		s := source()
		_, err := switchStatementReturningNonNilOnlyWhenConstant(s)
		if err != nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if switchStatementReturningNilOnlyWhenConstant(s) == nil {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if multipleSwitchStatementReturningTrueOnlyWhenConstant(s, getRandomString()) {
			sink(s)
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if switchStatementWithoutUsefulInfo(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

	{
		s := source()
		if switchStatementOverRandomString(s) {
			sink(s) // $ dataflow=s
		} else {
			sink(s) // $ dataflow=s
		}
	}

}
