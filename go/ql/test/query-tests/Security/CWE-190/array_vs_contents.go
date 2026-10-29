package main

import (
	"io/ioutil"
	"net/http"
)

// Two cases exposing the difference between tainted array contents
// and the array itself being tainted. One uses an explicitly allocated
// array, the other the implicit array allocated to hold varargs; in both
// cases the array has fixed small size but has a tainted integer written
// to one of its cells.

func f(request *http.Request) []byte {

	f, _ := ioutil.ReadAll(request.Body)
	array := make([]int, 1)
	array[0] = len(f)
	alloc := make([]byte, len(array)+3) // GOOD: len(array) == 1
	return alloc

}

func takesBoundedVarargs(args ...interface{}) []byte {

	alloc := make([]byte, len(args)+1) // GOOD (when called from `callsVarargs`): len(args) == 1
	return alloc

}

func callsVarargs(request *http.Request) []byte {

	f, _ := ioutil.ReadAll(request.Body)
	return takesBoundedVarargs(len(f))

}
