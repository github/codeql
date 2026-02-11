package main

import (
	"regexp"

	"codeql-go-types/pkg1"
)

func test(r *regexp.Regexp) {}

func swap(x int, y int) (int, int) {
	return y, x
}

func main() {}

type EmbedsNameClash struct {
	pkg1.NameClash
}
