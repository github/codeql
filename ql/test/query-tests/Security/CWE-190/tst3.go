package main

import "encoding/json"

func testSanitizers(s string) {
	jsonData, _ := json.Marshal(s)
	ignore(make([]byte, len(jsonData)+1)) // NOT OK: data might be big

	ignore(make([]byte, int64(len(jsonData))+1)) // OK: sanitized by widening to 64 bits

	if len(jsonData) < 1000 {
		ignore(make([]byte, len(jsonData)+1)) // OK: there is an upper bound check on len(jsonData)
	}
}
