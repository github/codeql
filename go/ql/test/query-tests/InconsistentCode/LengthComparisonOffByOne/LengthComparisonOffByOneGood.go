package main

import "strings"

func containsGood(searchName string, names string) bool {
	values := strings.Split(names, ",")
	// GOOD: Avoid using indexes, use range loop instead
	for _, name := range values {
		if name == searchName {
			return true
		}
	}
	return true
}
