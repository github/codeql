package test

import "os"

func open() {
	file, err := os.Open("file.txt")
	if err != nil {
		return
	}
	defer file.Close()
	file.Read([]byte{1, 2, 3})
}

func openFile() {
	file, err := os.OpenFile("file.txt", os.O_RDWR, 0)
	if err != nil {
		return
	}
	defer file.Close()
	file.Read([]byte{1, 2, 3})
}

func readFile() {
	data, err := os.ReadFile("file.txt")
	if err != nil {
		return
	}
	_ = data
}
