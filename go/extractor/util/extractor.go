package util

import (
	"encoding/json"
	"log"
	"os"
	"path/filepath"
)

// Gets the path of the JSON file in the database scratch directory that is used
// to store extraction results.
func extractionResultsPath() string {
	return filepath.Join(ScratchDir(), "extraction.json")
}

// Represents results of an extractor run that are of interest to the autobuilder.
type ExtractionResult struct {
	PackageCount int `json:"packageCount"`
}

// Represents a mapping of module roots to extraction results.
type ExtractionResults map[string]ExtractionResult

/* Returns the total number of packages extracted */
func (results ExtractionResults) TotalPackageCount() int {
	result := 0
	for _, v := range results {
		result += v.PackageCount
	}
	return result
}

// Reads extraction results produced by the extractor from a well-known location in the
// database scratch directory and stores them in `results`. Returns `nil` if successful
// or an error if not. Note that if the file does not exist, `results` are not modified
// and `nil` is returned. If it matters whether the file was created by an extractor
// run, then this should be checked explicitly.
func ReadExtractionResults(results *ExtractionResults) error {
	path := extractionResultsPath()

	if FileExists(path) {
		contents, err := os.ReadFile(path)

		if err != nil {
			log.Printf("Found %s, but could not read it: %s\n", path, err)
			return err
		}

		if err = json.Unmarshal(contents, results); err != nil {
			log.Printf("Failed to unmarshal JSON from %s: %s\n", path, err)
			return err
		}
	}

	return nil
}

// Writes an extraction `result` for the module at root `wd` to a well-known location in the
// database scratch directory. If the file with extraction results exists already, it is updated.
// Note: this assumes that multiple copies of the extractor are not run concurrently.
func WriteExtractionResult(wd string, result ExtractionResult) {
	path := extractionResultsPath()
	results := make(ExtractionResults)

	// Create the scratch directory, if needed.
	if !DirExists(ScratchDir()) {
		os.Mkdir(ScratchDir(), 0755)
	}

	// Read existing extraction results, if there are any.
	ReadExtractionResults(&results)

	// Store the new extraction result.
	results[wd] = result

	// Write all results to the file as JSON.
	bytes, err := json.Marshal(results)

	if err != nil {
		log.Printf("Unable to marshal: %s\n", err)
	}

	err = os.WriteFile(path, bytes, 0644)

	if err != nil {
		log.Printf("Failed to write to %s: %s\n", path, err)
	}
}
