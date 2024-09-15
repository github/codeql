package util

import (
	"os"
)

func IsVendorDirExtractionEnabled() bool {
	return os.Getenv("CODEQL_EXTRACTOR_GO_EXTRACT_VENDOR_DIRS") == "true"
}
