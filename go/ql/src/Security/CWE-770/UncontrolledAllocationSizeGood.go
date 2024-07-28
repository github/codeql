package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

func OutOfMemoryGood(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
	MaxValue := 6
	queryStr := query.Get("n")
	collectionSize, err := strconv.Atoi(queryStr)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if collectionSize < 0 || collectionSize > MaxValue {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}
	result := make([]string, collectionSize)
	for i := 0; i < collectionSize; i++ {
		result[i] = fmt.Sprintf("Item %d", i+1)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}
