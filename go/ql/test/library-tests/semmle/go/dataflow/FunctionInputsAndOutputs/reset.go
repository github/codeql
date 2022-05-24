package main

import (
	"bufio"
	"io"
)

func bufioReaderResetTest(r io.Reader) bufio.Reader {
	source := r

	var reader bufio.Reader
	reader.Reset(source)
	sink := reader

	return sink
}
