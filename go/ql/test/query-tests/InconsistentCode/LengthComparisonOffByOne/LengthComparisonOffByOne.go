package main

import "strings"

func containsBad(searchName string, names string) bool {
	values := strings.Split(names, ",")
	// BAD: index could be equal to length
	for i := 0; i <= len(values); i++ { // $ Alert
		// When i = length, this access will be out of bounds
		if values[i] == searchName { // $ Source
			return true
		}
	}
	return false
}
