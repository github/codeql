package main

import "encoding/json"

type header struct {
	version int
	key     [4]byte
}

func test(x int, s string, xs []int, ys [16]int, ss [16]string, h *header) {
	jsonData, _ := json.Marshal(x)
	ignore(make([]byte, len(jsonData)+1)) // OK: data is small

	jsonData, _ = json.Marshal(s)         // $ Source
	ignore(make([]byte, len(jsonData)+1)) // $ Alert // NOT OK: data might be big

	jsonData, _ = json.Marshal("hi there")
	ignore(make([]byte, len(jsonData)+1)) // OK: data is small

	jsonData, _ = json.Marshal(xs)        // $ Source
	ignore(make([]byte, len(jsonData)+1)) // $ Alert // NOT OK: data might be big

	jsonData, _ = json.Marshal(ys)
	ignore(make([]byte, len(jsonData)+1)) // OK: data is small

	jsonData, _ = json.Marshal(ss)            // $ Source
	ignore(make([]byte, 10, len(jsonData)+1)) // $ Alert // NOT OK: data might be big

	jsonData, _ = json.Marshal(h)
	ignore(make([]byte, len(jsonData)+1)) // OK: data is small

	var i interface{}
	i = h
	jsonData, _ = json.Marshal(i)         // $ Source
	ignore(make([]byte, len(jsonData)+1)) // $ Alert // NOT OK: data might be big
}

func ignore(_ interface{}) {}
