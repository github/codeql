package main

import "regexp"

func main() {
	// many backslashes
	regexp.MustCompile("\a") // $ Alert // BAD
	regexp.MustCompile("\\a")
	regexp.MustCompile("\\\a")  // $ Alert // BAD
	regexp.MustCompile("x\\\a") // $ Alert // BAD
	regexp.MustCompile("\\\\a")
	regexp.MustCompile("\\\\\a") // $ Alert // BAD
	regexp.MustCompile("\\\\\\a")
	regexp.MustCompile("\\\\\\\a") // $ Alert // BAD
	regexp.MustCompile("\\\\\\\\a")
	regexp.MustCompile("\\\\\\\\\a") // $ Alert // BAD
	regexp.MustCompile("\\\\\\\\\\a")

	// BAD: probably a mistake:
	regexp.MustCompile("hello\aworld")   // $ Alert
	regexp.MustCompile("hello\\\aworld") // $ Alert
	regexp.MustCompile("hello\bworld")   // $ Alert
	regexp.MustCompile("hello\\\bworld") // $ Alert
	// GOOD: more likely deliberate:
	regexp.MustCompile("hello\\aworld")
	regexp.MustCompile("hello\x07world")
	regexp.MustCompile("hello\007world")
	regexp.MustCompile("hello\u0007world")
	regexp.MustCompile("hello\U00000007world")
	regexp.MustCompile("hello\\bworld")
	regexp.MustCompile("hello\x08world")
	regexp.MustCompile("hello\010world")
	regexp.MustCompile("hello\u0008world")
	regexp.MustCompile("hello\U00000008world")
	// GOOD: use of a raw string literal
	regexp.MustCompile(`hello\b\sworld`)
}
