package configurebaseline

import (
	"encoding/json"
	"io/fs"
	"os"
	"path"
	"path/filepath"

	"github.com/github/codeql-go/extractor/util"
)

func fileExists(path string) bool {
	stat, err := os.Stat(path)
	return err == nil && stat.Mode().IsRegular()
}

// Decides if `dirPath` is a vendor directory by testing whether it is called `vendor`
// and contains a `modules.txt` file.
func isGolangVendorDirectory(dirPath string) bool {
	return filepath.Base(dirPath) == "vendor" && fileExists(filepath.Join(dirPath, "modules.txt"))
}

type BaselineConfig struct {
	PathsIgnore []string `json:"paths-ignore"`
}

func GetConfigBaselineAsJSON(rootDir string) ([]byte, error) {
	vendorDirs := make([]string, 0)

	extractVendorDirs, _ := util.IsVendorDirExtractionEnabled()
	if extractVendorDirs {
		// The user wants vendor directories scanned; emit an empty report.
	} else {
		filepath.WalkDir(rootDir, func(dirPath string, d fs.DirEntry, err error) error {
			if err != nil {
				// Ignore any unreadable paths -- if this script can't see it, very likely
				// it will not be extracted either.
				return nil
			}
			if isGolangVendorDirectory(dirPath) {
				// Note that CodeQL expects a forward-slash-separated path, even on Windows.
				vendorDirs = append(vendorDirs, path.Join(filepath.ToSlash(dirPath), "**"))
				return filepath.SkipDir
			} else {
				return nil
			}
		})
	}

	outputStruct := BaselineConfig{PathsIgnore: vendorDirs}
	return json.Marshal(outputStruct)
}
