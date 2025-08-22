package main

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"
)

func io2() {
	{
		reader := strings.NewReader("some string")
		var buf1, buf2 bytes.Buffer
		w := io.MultiWriter(&buf1, &buf2)

		io.Copy(w, reader)
	}

	{
		reader := strings.NewReader("some string")
		var buf1 bytes.Buffer
		buf := make([]byte, 512)
		w2 := io.Writer(&buf1)

		io.CopyBuffer(w2, reader, buf)
	}

	{
		reader := strings.NewReader("some string")
		var buf1 bytes.Buffer
		w2 := io.Writer(&buf1)

		io.CopyN(w2, reader, 512)
	}

	{
		r, w := io.Pipe()
		fmt.Fprint(w, "some string\n")

		buf := new(bytes.Buffer)
		buf.ReadFrom(r)
		fmt.Print(buf.String())
	}

	{
		reader := strings.NewReader("some string")
		buf := make([]byte, 512)
		io.ReadAtLeast(reader, buf, 512)
	}

	{
		reader := strings.NewReader("some string")
		buf := make([]byte, 512)
		io.ReadFull(reader, buf)
	}

	{
		var buf bytes.Buffer
		w := io.Writer(&buf)
		io.WriteString(w, "test")
	}
	{
		reader := strings.NewReader("some string")
		buf := make([]byte, 512)
		reader.Read(buf)
	}
	{
		reader := strings.NewReader("some string")
		buf := make([]byte, 512)
		reader.ReadAt(buf, 10)
	}

	{
		reader := strings.NewReader("some string")
		lr := io.LimitReader(reader, 4)
		io.Copy(os.Stdout, lr)
	}

	{
		r1 := strings.NewReader("reader1 ")
		r2 := strings.NewReader("reader2 ")
		r3 := strings.NewReader("reader3")
		r := io.MultiReader(r1, r2, r3)
		io.Copy(os.Stdout, r)
	}
	{
		r := strings.NewReader("some string")
		var buf bytes.Buffer
		tee := io.TeeReader(r, &buf)

		io.Copy(os.Stdout, tee)
	}
	{
		r := strings.NewReader("some string")
		s := io.NewSectionReader(r, 5, 17)
		io.Copy(os.Stdout, s)
	}
	{
		r := strings.NewReader("some string")
		r.WriteTo(os.Stdout)
	}

}

func utiltest() {
	reader := strings.NewReader("some string")
	buf, _ := ioutil.ReadAll(reader)
	os.Stdout.Write(buf)
}
