package main

import "os"

func openFiles(filenames []string) {
	for _, filename := range filenames {
		file, err := os.Open(filename)
		defer file.Close()
		if err != nil {
			// handle error
		}
		// work on file
	}
}
