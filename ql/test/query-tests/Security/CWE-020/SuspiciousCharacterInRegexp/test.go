package main

import "regexp"

func main() {

	// BAD: probably a mistake:
	regexp.MustCompile("hello\aworld")
	regexp.MustCompile("hello\\\aworld")
	regexp.MustCompile("hello\bworld")
	regexp.MustCompile("hello\\\bworld")
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
