package test

import (
	"io/fs"
	"io/ioutil"
	"os"
)

func open() {
	file, err := os.Open("file.txt") // $ source
	if err != nil {
		return
	}
	defer file.Close()
	file.Read([]byte{1, 2, 3})
}

func openFile() {
	file, err := os.OpenFile("file.txt", os.O_RDWR, 0) // $source
	if err != nil {
		return
	}
	defer file.Close()
	file.Read([]byte{1, 2, 3})
}

func readFile() {
	data, err := os.ReadFile("file.txt") // $source
	if err != nil {
		return
	}
	_ = data
}

func readFileIoUtil() {
	data, err := ioutil.ReadFile("file.txt") // $source
	if err != nil {
		return
	}
	_ = data
}

func getFileFS() fs.ReadFileFS {
	return nil
}

func readFileFs() {
	data, err := fs.ReadFile(os.DirFS("."), "file.txt") // $source
	if err != nil {
		return
	}
	_ = data

	dir := getFileFS()
	data, err = dir.ReadFile("file.txt") // $source

	if err != nil {
		return
	}
	_ = data
}

func fsOpen() {
	file, err := os.DirFS(".").Open("file.txt") // $source
	if err != nil {
		return
	}
	defer file.Close()
	file.Read([]byte{1, 2, 3})
}
