package main

import (
	"regexp"
)

func main() {
	regexp.Match(`^a|`, []byte(""))     // OK
	regexp.Match(`^a|b`, []byte(""))    // $ Alert // NOT OK
	regexp.Match(`a|^b`, []byte(""))    // OK
	regexp.Match(`^a|^b`, []byte(""))   // OK
	regexp.Match(`^a|b|c`, []byte(""))  // $ Alert // NOT OK
	regexp.Match(`a|^b|c`, []byte(""))  // OK
	regexp.Match(`a|b|^c`, []byte(""))  // OK
	regexp.Match(`^a|^b|c`, []byte("")) // OK

	regexp.Match(`(^a)|b`, []byte(""))   // OK
	regexp.Match(`^a|(b)`, []byte(""))   // $ Alert // NOT OK
	regexp.Match(`^a|(^b)`, []byte(""))  // OK
	regexp.Match(`^(a)|(b)`, []byte("")) // $ Alert // NOT OK

	regexp.Match(`a|b$`, []byte(""))    // $ Alert // NOT OK
	regexp.Match(`a$|b`, []byte(""))    // OK
	regexp.Match(`a$|b$`, []byte(""))   // OK
	regexp.Match(`a|b|c$`, []byte(""))  // $ Alert // NOT OK
	regexp.Match(`a|b$|c`, []byte(""))  // OK
	regexp.Match(`a$|b|c`, []byte(""))  // OK
	regexp.Match(`a|b$|c$`, []byte("")) // OK

	regexp.Match(`a|(b$)`, []byte(""))   // OK
	regexp.Match(`(a)|b$`, []byte(""))   // $ Alert // NOT OK
	regexp.Match(`(a$)|b$`, []byte(""))  // OK
	regexp.Match(`(a)|(b)$`, []byte("")) // $ Alert // NOT OK

	regexp.Match(`https?://good.com`, []byte("http://evil.com/?http://good.com"))  // $ Alert // NOT OK
	regexp.Match(`^https?://good.com`, []byte("http://evil.com/?http://good.com")) // OK

	regexp.Match(`www\.example\.com`, []byte(""))   // $ Alert // NOT OK
	regexp.Match(`^www\.example\.com`, []byte(""))  // OK
	regexp.Match(`\Awww\.example\.com`, []byte("")) // OK
	regexp.Match(`www\.example\.com$`, []byte(""))  // OK
	regexp.Match(`www\.example\.com\z`, []byte("")) // OK
}
