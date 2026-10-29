package main

//go:generate depstubber -vendor github.com/Masterminds/squirrel "" Expr,StatementBuilder

import (
	"encoding/json"
	"fmt"
)

func marshal(version interface{}) string {
	versionJSON, err := json.Marshal(version)
	if err != nil {
		return fmt.Sprintf("error: '%v'", err) // OK
	}
	return string(versionJSON)
}

type StringWrapper struct {
	s string
}

func marshalUnmarshal(w1 StringWrapper) (string, error) {
	buf, err := json.Marshal(w1)
	if err != nil {
		return "", err
	}
	var w2 StringWrapper
	json.Unmarshal(buf, &w2)
	return fmt.Sprintf("wrapped string: '%s'", w2.s), nil // OK
}
