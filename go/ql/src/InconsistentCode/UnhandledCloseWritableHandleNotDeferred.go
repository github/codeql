package main

import (
	"os"
)

func example() error {
	f, err := os.OpenFile("file.txt", os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		return err
	}

	if _, err := f.WriteString("Hello"); err != nil {
		f.Close()
		return err
	}

	f.Close()

	return nil
}
