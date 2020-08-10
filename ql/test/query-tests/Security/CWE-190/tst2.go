package main

import (
	"io"
	"io/ioutil"
)

func test2(filename string) {
	data, _ := ioutil.ReadFile(filename)
	ignore(make([]byte, len(data)+1)) // NOT OK
}

func test3(r io.Reader) {
	data, _ := ioutil.ReadAll(r)
	ignore(make([]byte, len(data)+1)) // NOT OK
}

func test4(r io.Reader, ws []io.Writer) {
	mw := io.MultiWriter(ws...)
	ignore(make([]error, len(ws)+1)) // OK
	data, _ := ioutil.ReadAll(r)
	mw.Write(data)
}
