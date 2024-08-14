package configurebaseline

import (
	"encoding/json"
	"io/fs"
	"os"
	"path"
	"path/filepath"
)

func fileExists(path string) bool {
	stat, err := os.Stat(path)
	return err == nil && stat.Mode().IsRegular()
}

func isGolangVendorDirectory(dirPath string) bool {
	// Call a directory a Golang vendor directory if it contains a modules.txt file.
	return path.Base(dirPath) == "vendor" && fileExists(path.Join(dirPath, "modules.txt"))
}

type PathsIgnoreStruct struct {
	PathsIgnore []string `json:"paths-ignore"`
}

func GetConfigBaselineAsJSON(rootDir string) ([]byte, error) {
	vendorDirs := make([]string, 0)

	// If CODEQL_EXTRACTOR_GO_EXTRACT_VENDOR_DIRS is "true":
	if os.Getenv("CODEQL_EXTRACTOR_GO_EXTRACT_VENDOR_DIRS") == "true" {
		// The user wants vendor directories scanned; emit an empty report.
	} else {
		filepath.WalkDir(rootDir, func(dirPath string, d fs.DirEntry, err error) error {
			if err != nil {
				// Mask any unreadable paths.
				return nil
			}
			if isGolangVendorDirectory(dirPath) {
				vendorDirs = append(vendorDirs, path.Join(dirPath, "**"))
				return filepath.SkipDir
			} else {
				return nil
			}
		})
	}

	outputStruct := PathsIgnoreStruct{PathsIgnore: vendorDirs}
	return json.Marshal(outputStruct)
}
