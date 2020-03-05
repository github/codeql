package main

import "encoding/json"

func encryptValue(v interface{}) ([]byte, error) {
	jsonData, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	size := len(jsonData) + (len(jsonData) % 16)
	buffer := make([]byte, size)
	copy(buffer, jsonData)
	return encryptBuffer(buffer)
}
