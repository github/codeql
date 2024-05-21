package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

func OutOfMemoryGood1(w http.ResponseWriter, r *http.Request) {
	source := r.URL.Query()
	MaxValue := 6
	sourceStr := source.Get("n")
	sink, err := strconv.Atoi(sourceStr)
	if err != nil || sink < 0 {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}
	if sink > MaxValue {
		return
	}
	result := make([]string, sink)
	for i := 0; i < sink; i++ {
		result[i] = fmt.Sprintf("Item %d", i+1)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}

func OutOfMemoryGood2(w http.ResponseWriter, r *http.Request) {
	source := r.URL.Query()
	MaxValue := 6
	sourceStr := source.Get("n")
	sink, err := strconv.Atoi(sourceStr)
	if err != nil || sink < 0 {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}
	if sink <= MaxValue {
		result := make([]string, sink)
		for i := 0; i < sink; i++ {
			result[i] = fmt.Sprintf("Item %d", i+1)
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(result)
	}
}

func OutOfMemoryGood3(w http.ResponseWriter, r *http.Request) {
	source := r.URL.Query()
	MaxValue := 6
	sourceStr := source.Get("n")
	sink, err := strconv.Atoi(sourceStr)
	if err != nil || sink < 0 {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}
	if sink > MaxValue {
		sink = MaxValue
		result := make([]string, sink)
		for i := 0; i < sink; i++ {
			result[i] = fmt.Sprintf("Item %d", i+1)
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(result)
	}
}

func OutOfMemoryGood4(w http.ResponseWriter, r *http.Request) {
	source := r.URL.Query()
	MaxValue := 6
	sourceStr := source.Get("n")
	sink, err := strconv.Atoi(sourceStr)
	if err != nil || sink < 0 {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}
	if sink > MaxValue {
		sink = MaxValue
	} else {
		tmp := sink
		sink = tmp
	}
	result := make([]string, sink)
	for i := 0; i < sink; i++ {
		result[i] = fmt.Sprintf("Item %d", i+1)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}
