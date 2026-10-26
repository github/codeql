package main

import (
	"os"
)

func example() (exampleError error) {
	f, err := os.OpenFile("file.txt", os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		return err
	}

	defer func() {
		// try to close the file; if an error occurs, set the error returned by `example`
		// to that error, but only if `WriteString` didn't already set it to something first
		if err := f.Close(); exampleError == nil && err != nil {
			exampleError = err
		}
	}()

	if _, err := f.WriteString("Hello"); err != nil {
		exampleError = err
	}

	return
}
