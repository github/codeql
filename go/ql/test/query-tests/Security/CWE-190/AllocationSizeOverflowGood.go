package main

import (
	"encoding/json"
	"errors"
)

func encryptValueGood(v interface{}) ([]byte, error) {
	jsonData, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	if len(jsonData) > 64*1024*1024 {
		return nil, errors.New("value too large")
	}
	size := len(jsonData) + (len(jsonData) % 16)
	buffer := make([]byte, size)
	copy(buffer, jsonData)
	return encryptBuffer(buffer)
}
