package main

import "encoding/json"

func testSanitizers(s string) {
	jsonData, _ := json.Marshal(s)
	ignore(make([]byte, len(jsonData)+1)) // NOT OK: data might be big

	ignore(make([]byte, int64(len(jsonData))+1)) // OK: sanitized by widening to 64 bits

	if len(jsonData) < 1000 {
		ignore(make([]byte, len(jsonData)+1)) // OK: there is an upper bound check on len(jsonData)
	}

	{
		newlength := len(jsonData) + 2 // OK: there is an upper bound check which dominates `make`
		ignore(newlength - 1)
		if newlength < 1000 {
			ignore(make([]byte, newlength))
		}
	}

	{
		newlength := len(jsonData) + 3 // NOT OK: newlength is changed after the upper bound check (even though it's made smaller)
		if newlength < 1000 {
			newlength = newlength - 1
			ignore(make([]byte, newlength))
		}
	}

	{
		newlength := len(jsonData) + 4 // NOT OK: there is an upper bound check but it doesn't dominate `make`
		if newlength < 1000 {
			ignore(newlength + 2)
		}
		ignore(make([]byte, newlength))
	}

	{
		newlength := len(jsonData) + 5 // OK: there is an upper bound check which dominates `make`
		if newlength > 1000 {
			return
		}
		ignore(make([]byte, newlength))
	}
}
