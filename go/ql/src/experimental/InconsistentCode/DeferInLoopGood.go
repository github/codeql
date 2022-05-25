package main

import "os"

func openFile(filename string) {
	file, err := os.Open(filename)
	defer file.Close()
	if err != nil {
		// handle error
	}
	// work on file
}

func openFilesGood(filenames []string) {
	for _, filename := range filenames {
		openFile(filename)
	}
}
