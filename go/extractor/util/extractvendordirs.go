package util

import (
	"os"
)

func IsVendorDirExtractionEnabled() (bool, bool) {
	oldOptionVal := os.Getenv("CODEQL_EXTRACTOR_GO_EXTRACT_VENDOR_DIRS")
	return (oldOptionVal == "true" ||
		os.Getenv("CODEQL_EXTRACTOR_GO_OPTION_EXTRACT_VENDOR_DIRS") == "true"), oldOptionVal != ""
}
