package main

import (
	"encoding/json"
)

func encryptValueGood2(v interface{}) ([]byte, error) {
	jsonData, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	size := uint64(len(jsonData)) + (uint64(len(jsonData)) % 16)
	buffer := make([]byte, size)
	copy(buffer, jsonData)
	return encryptBuffer(buffer)
}
