package main

import (
	"encoding/json"
	"fmt"
)

func marshal(version interface{}) string {
	versionJSON, err := json.Marshal(version)
	if err != nil {
		return fmt.Sprintf("error: '%v'", err) // OK
	}
	return versionJSON
}
