//go:generate depstubber --vendor --auto
package main

func main() {}

func source() interface{} {
	return nil
}

func sink(v interface{}) {}

func link(from interface{}, into interface{}) {}
