package main

import (
	"regexp"
)

func main() {
	regexp.Match(`^a|`, []byte(""))     // OK
	regexp.Match(`^a|b`, []byte(""))    // NOT OK
	regexp.Match(`a|^b`, []byte(""))    // OK
	regexp.Match(`^a|^b`, []byte(""))   // OK
	regexp.Match(`^a|b|c`, []byte(""))  // NOT OK
	regexp.Match(`a|^b|c`, []byte(""))  // OK
	regexp.Match(`a|b|^c`, []byte(""))  // OK
	regexp.Match(`^a|^b|c`, []byte("")) // OK

	regexp.Match(`(^a)|b`, []byte(""))   // OK
	regexp.Match(`^a|(b)`, []byte(""))   // NOT OK
	regexp.Match(`^a|(^b)`, []byte(""))  // OK
	regexp.Match(`^(a)|(b)`, []byte("")) // NOT OK

	regexp.Match(`a|b$`, []byte(""))    // NOT OK
	regexp.Match(`a$|b`, []byte(""))    // OK
	regexp.Match(`a$|b$`, []byte(""))   // OK
	regexp.Match(`a|b|c$`, []byte(""))  // NOT OK
	regexp.Match(`a|b$|c`, []byte(""))  // OK
	regexp.Match(`a$|b|c`, []byte(""))  // OK
	regexp.Match(`a|b$|c$`, []byte("")) // OK

	regexp.Match(`a|(b$)`, []byte(""))   // OK
	regexp.Match(`(a)|b$`, []byte(""))   // NOT OK
	regexp.Match(`(a$)|b$`, []byte(""))  // OK
	regexp.Match(`(a)|(b)$`, []byte("")) // NOT OK

	regexp.Match(`https?://good.com`, []byte("http://evil.com/?http://good.com"))  // NOT OK
	regexp.Match(`^https?://good.com`, []byte("http://evil.com/?http://good.com")) // OK
}
