package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

func OutOfMemoryBad(w http.ResponseWriter, r *http.Request) {
	source := r.URL.Query()

	sourceStr := source.Get("n")
	sink, err := strconv.Atoi(sourceStr)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	result := make([]string, sink) // $hasTaintFlow="sink"
	for i := 0; i < sink; i++ {
		result[i] = fmt.Sprintf("Item %d", i+1)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}
