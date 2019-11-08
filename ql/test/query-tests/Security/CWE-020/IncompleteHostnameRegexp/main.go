package main

import (
	"regexp"
)

func Match(notARegex string) bool {
	return notARegex != ""
}

func main() {
	regexp.Match(`https://www.example.com`, []byte(""))   // NOT OK
	regexp.Match(`https://www\.example\.com`, []byte("")) // OK
}
