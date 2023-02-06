package main

import (
	"encoding/json"
	"io"
)

func test7(data interface{}) (io.Writer, error) {
	var w io.Writer
	err := json.NewEncoder(w).Encode(data)
	return w, err
}
