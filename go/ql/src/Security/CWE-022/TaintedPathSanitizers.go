package main

import (
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func handleFileWithSanitizers(w http.ResponseWriter, r *http.Request) {
	userPath := r.URL.Query().Get("file")
	safeDir := "/home/user/documents"

	// Method 1: Using filepath.IsLocal to validate the path is local
	if !filepath.IsLocal(userPath) {
		http.Error(w, "Invalid path: must be local", http.StatusBadRequest)
		return
	}

	// Method 2: Using strings.Contains to check for path traversal sequences
	if strings.Contains(userPath, "..") {
		http.Error(w, "Invalid path: contains path traversal", http.StatusBadRequest)
		return
	}

	// Method 3: Using filepath.Rel to ensure path is within safe directory
	relPath, err := filepath.Rel(safeDir, filepath.Join(safeDir, userPath))
	if err != nil || strings.HasPrefix(relPath, "..") {
		http.Error(w, "Invalid path: outside safe directory", http.StatusBadRequest)
		return
	}

	// Method 4: Using filepath.Clean with absolute prefix for normalization
	cleanPath := filepath.Clean("/" + userPath)
	if strings.Contains(cleanPath, "..") {
		http.Error(w, "Invalid path after normalization", http.StatusBadRequest)
		return
	}

	// Method 5: Using strings.HasPrefix for additional validation
	finalPath := filepath.Join(safeDir, userPath)
	if !strings.HasPrefix(finalPath, safeDir) {
		http.Error(w, "Invalid path: must be within safe directory", http.StatusBadRequest)
		return
	}

	// Safe to open file
	file, err := os.Open(finalPath)
	if err != nil {
		http.Error(w, "File not found", http.StatusNotFound)
		return
	}
	defer file.Close()

	// Process file...
}
