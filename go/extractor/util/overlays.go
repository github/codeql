package util

import (
	"encoding/json"
	"log"
	"os"
)

// If the relevant environment variable is set, indicating that we are extracting an overlay
// database, GetOverlayChanges returns the list of relative paths of files that have changed (or
// been deleted). Otherwise, it returns `nil`.
func GetOverlayChanges() []string {
	if overlayChangesJsonPath, present := os.LookupEnv("CODEQL_EXTRACTOR_GO_OVERLAY_CHANGES"); present {
		log.Printf("Reading overlay changes from: %s", overlayChangesJsonPath)

		file, err := os.Open(overlayChangesJsonPath)
		if err != nil {
			log.Fatalf("Failed to open overlay changes JSON file: %s", err)
		}
		defer file.Close()

		var overlayData struct {
			Changes []string `json:"changes"`
		}

		decoder := json.NewDecoder(file)
		if err := decoder.Decode(&overlayData); err != nil {
			log.Fatalf("Failed to decode overlay changes JSON file: %s", err)
		}

		return overlayData.Changes
	} else {
		return nil
	}
}

// WriteOverlayBaseMetadata creates an empty metadata file if we are extracting an overlay base;
// otherwise, it does nothing.
func WriteOverlayBaseMetadata() {
	if metadataPath, present := os.LookupEnv("CODEQL_EXTRACTOR_GO_OVERLAY_BASE_METADATA_OUT"); present {
		log.Printf("Writing overlay base metadata to: %s", metadataPath)

		// In principle, we could store some metadata here and read it back when extracting the
		// overlay. For now, we don't need to store anything, but the CLI still requires us to write
		// something, so just create an empty file.
		file, err := os.Create(metadataPath)
		if err != nil {
			log.Fatalf("Failed to create overlay base metadata file: %s", err)
		}
		file.Close()
	}
}
