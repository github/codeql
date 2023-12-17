package main

//go:generate depstubber -vendor  github.com/dsnet/compress/bzip2 Reader NewReader
//go:generate depstubber -vendor  github.com/klauspost/compress/flate "" NewReader
//go:generate depstubber -vendor  github.com/dsnet/compress/flate Reader  NewReader
//go:generate depstubber -vendor  github.com/klauspost/compress/zlib  "" NewReader
//go:generate depstubber -vendor  github.com/golang/snappy Reader NewReader
//go:generate depstubber -vendor  github.com/klauspost/compress/snappy "" NewReader
//go:generate depstubber -vendor  github.com/klauspost/compress/s2 Reader NewReader
//go:generate depstubber -vendor  github.com/klauspost/compress/gzip Reader NewReader
//go:generate depstubber -vendor  github.com/klauspost/pgzip Reader NewReader
//go:generate depstubber -vendor  github.com/klauspost/compress/zstd Decoder NewReader
//go:generate depstubber -vendor  github.com/DataDog/zstd "" NewReader
//go:generate depstubber -vendor  github.com/ulikunitz/xz Reader NewReader
//go:generate depstubber -vendor  github.com/klauspost/compress/zip FileHeader,File,Reader,ReadCloser NewReader,OpenReader

import (
	"archive/tar"
	"archive/zip"
	"bytes"
	"compress/bzip2"
	"compress/flate"
	"compress/gzip"
	"compress/zlib"
	"fmt"
	"io"
	"net/http"
	"os"
	"testing/fstest"

	bzip2Dsnet "github.com/dsnet/compress/bzip2"
	flateDsnet "github.com/dsnet/compress/flate"
	"github.com/golang/snappy"
	flateKlauspost "github.com/klauspost/compress/flate"
	gzipKlauspost "github.com/klauspost/compress/gzip"
	"github.com/klauspost/compress/s2"
	snappyKlauspost "github.com/klauspost/compress/snappy"
	zlibKlauspost "github.com/klauspost/compress/zlib"
	pgzipKlauspost "github.com/klauspost/pgzip"
	"github.com/ulikunitz/xz"

	zstdDataDog "github.com/DataDog/zstd"
	zipKlauspost "github.com/klauspost/compress/zip"
	zstdKlauspost "github.com/klauspost/compress/zstd"
)

func main() {
	DecompressHandler := http.HandlerFunc(DecompressHandler)
	http.Handle("/Decompress", DecompressHandler)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		return
	}

}
func DecompressHandler(w http.ResponseWriter, request *http.Request) {
	ZipNewReader(request.Body)
	ZipNewReader2(request.Body)
	ZipOpenReader(request.FormValue("filepathba"))
	ZipOpenReaderSafe(request.PostFormValue("test"))
	GZipOpenReaderSafe(request.PostFormValue("test"))
	GZipReader(request.Body, "dest")
	Bzip2Dsnet(request.Body)
	Bzip2(request.Body)
	Flate(request.Body)
	FlateKlauspost(request.Body)
	FlateDsnet(request.Body)
	ZlibKlauspost(request.Body)
	Zlib(request.Body)
	Snappy(request.Body)
	SnappyKlauspost(request.Body)
	S2(request.Body)
	Gzip(request.Body)
	GzipKlauspost(request.Body)
	PzipKlauspost(request.Body)
	Zstd_Klauspost(request.Body)
	Zstd_DataDog(request.Body)
	Xz(request.Body)
}

func GZipOpenReaderSafe(filename string) {
	var src io.Reader
	src, _ = os.Open(filename)
	gzipR, _ := gzip.NewReader(src)
	dstF, _ := os.OpenFile("./test", os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0755)
	defer dstF.Close()
	var newSrc io.Reader
	newSrc = io.LimitReader(gzipR, 1024*1024*1024*5) // GOOD: The output size is being controlled
	_, _ = io.Copy(dstF, newSrc)
}

func ZipOpenReaderSafe(filename string) {
	r, _ := zip.OpenReader(filename)
	var totalBytes int64 = 0
	for _, f := range r.File {
		rc, _ := f.Open()
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68) // GOOD: The output size is being controlled
			if result == 0 {
				_ = rc.Close()
				break
			}
			totalBytes = totalBytes + result
			if totalBytes > 1024*1024*1024*5 {
				fmt.Print(totalBytes)
				break
			}
		}
	}
}

func GZipReader(src io.Reader, dst string) {
	gzipR, _ := gzip.NewReader(src)
	dstF, _ := os.OpenFile(dst, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0755)
	defer dstF.Close()
	var newSrc io.Reader
	newSrc = io.Reader(gzipR)
	_, _ = io.Copy(dstF, newSrc) // BAD
}

func ZipOpenReader(filename string) {
	// Open the zip file
	r, _ := zip.OpenReader(filename)
	for _, f := range r.File {
		rc, _ := f.Open()
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68) // BAD
			if result == 0 {
				_ = rc.Close()
				break
			}
			fmt.Print(result)
			_ = rc.Close()
		}
	}
	rKlauspost, _ := zipKlauspost.OpenReader(filename)
	for _, f := range rKlauspost.File {
		rc, _ := f.Open()
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68) // BAD
			if result == 0 {
				_ = rc.Close()
				break
			}
			fmt.Print(result)
			_ = rc.Close()
		}
	}
}

func ZipNewReader(file io.Reader) {
	file1, _ := io.ReadAll(file)
	zipReader, _ := zip.NewReader(bytes.NewReader(file1), int64(32<<20))
	for _, file := range zipReader.File {
		fileWriter := bytes.NewBuffer([]byte{})
		fileReaderCloser, _ := file.Open()
		result, _ := io.Copy(fileWriter, fileReaderCloser) // BAD
		fmt.Print(result)
	}
}

func ZipNewReader2(file io.Reader) {
	file2, _ := io.ReadAll(file)
	zipReaderKlauspost, _ := zipKlauspost.NewReader(bytes.NewReader(file2), int64(32<<20))
	for _, file := range zipReaderKlauspost.File {
		fileWriter := bytes.NewBuffer([]byte{})
		// file.OpenRaw()
		fileReaderCloser, _ := file.Open()
		result, _ := io.Copy(fileWriter, fileReaderCloser) // BAD
		fmt.Print(result)
	}
}

func Bzip2Dsnet(file io.Reader) {
	var tarRead *tar.Reader

	bzip2dsnet, _ := bzip2Dsnet.NewReader(file, &bzip2Dsnet.ReaderConfig{})
	var out []byte = make([]byte, 70)
	bzip2dsnet.Read(out) // BAD
	tarRead = tar.NewReader(bzip2dsnet)

	TarDecompressor(tarRead)

}
func Bzip2(file io.Reader) {
	var tarRead *tar.Reader

	Bzip2 := bzip2.NewReader(file)
	var out []byte = make([]byte, 70)
	Bzip2.Read(out) // BAD
	tarRead = tar.NewReader(Bzip2)

	TarDecompressor(tarRead)
}
func Flate(file io.Reader) {
	var tarRead *tar.Reader

	Flate := flate.NewReader(file)
	var out []byte = make([]byte, 70)
	Flate.Read(out) // BAD
	tarRead = tar.NewReader(Flate)

	TarDecompressor(tarRead)
}
func FlateKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	zlibklauspost := flateKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	zlibklauspost.Read(out) // BAD
	tarRead = tar.NewReader(zlibklauspost)

	TarDecompressor(tarRead)
}
func FlateDsnet(file io.Reader) {
	var tarRead *tar.Reader

	flatedsnet, _ := flateDsnet.NewReader(file, &flateDsnet.ReaderConfig{})
	var out []byte = make([]byte, 70)
	flatedsnet.Read(out) // BAD
	tarRead = tar.NewReader(flatedsnet)

	TarDecompressor(tarRead)
}
func ZlibKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	zlibklauspost, _ := zlibKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	zlibklauspost.Read(out) // BAD
	tarRead = tar.NewReader(zlibklauspost)

	TarDecompressor(tarRead)
}
func Zlib(file io.Reader) {
	var tarRead *tar.Reader

	Zlib, _ := zlib.NewReader(file)
	var out []byte = make([]byte, 70)
	Zlib.Read(out) // BAD
	tarRead = tar.NewReader(Zlib)

	TarDecompressor(tarRead)
}
func Snappy(file io.Reader) {
	var tarRead *tar.Reader

	Snappy := snappy.NewReader(file)
	var out []byte = make([]byte, 70)
	Snappy.Read(out)  // BAD
	Snappy.ReadByte() // BAD
	tarRead = tar.NewReader(Snappy)

	TarDecompressor(tarRead)
}
func SnappyKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	snappyklauspost := snappyKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	snappyklauspost.Read(out) // BAD
	var buf bytes.Buffer
	snappyklauspost.DecodeConcurrent(&buf, 2) // BAD
	snappyklauspost.ReadByte()                // BAD
	tarRead = tar.NewReader(snappyklauspost)

	TarDecompressor(tarRead)
}
func S2(file io.Reader) {
	var tarRead *tar.Reader

	S2 := s2.NewReader(file)
	var out []byte = make([]byte, 70)
	S2.Read(out) // BAD
	var buf bytes.Buffer
	S2.DecodeConcurrent(&buf, 2) // BAD
	tarRead = tar.NewReader(S2)

	TarDecompressor(tarRead)
}
func Gzip(file io.Reader) {
	var tarRead *tar.Reader

	gzipRead, _ := gzip.NewReader(file)
	var out []byte = make([]byte, 70)
	gzipRead.Read(out) // BAD
	tarRead = tar.NewReader(gzipRead)

	TarDecompressor(tarRead)
}
func GzipKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	gzipklauspost, _ := gzipKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	gzipklauspost.Read(out) // BAD
	var buf bytes.Buffer
	gzipklauspost.WriteTo(&buf) // BAD
	tarRead = tar.NewReader(gzipklauspost)

	TarDecompressor(tarRead)
}
func PzipKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	pgzippgzip, _ := pgzipKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	pgzippgzip.Read(out) // BAD
	var buf bytes.Buffer
	pgzippgzip.WriteTo(&buf) // BAD
	tarRead = tar.NewReader(pgzippgzip)

	TarDecompressor(tarRead)
}
func Zstd_Klauspost(file io.Reader) {
	var tarRead *tar.Reader

	zstd, _ := zstdKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	zstd.Read(out) // BAD
	var buf bytes.Buffer
	zstd.WriteTo(&buf) // BAD
	var src []byte
	zstd.DecodeAll(src, nil) // BAD
	tarRead = tar.NewReader(zstd)

	TarDecompressor(tarRead)
}
func Zstd_DataDog(file io.Reader) {
	var tarRead *tar.Reader

	zstd := zstdDataDog.NewReader(file)
	var out []byte = make([]byte, 70)
	zstd.Read(out) // BAD
	tarRead = tar.NewReader(zstd)

	TarDecompressor(tarRead)
}
func Xz(file io.Reader) {
	var tarRead *tar.Reader

	xzRead, _ := xz.NewReader(file)
	var out []byte = make([]byte, 70)
	xzRead.Read(out) // BAD
	tarRead = tar.NewReader(xzRead)

	TarDecompressor(tarRead)
}

func TarDecompressor(tarRead *tar.Reader) {
	var tarOut []byte = make([]byte, 70)
	tarRead.Read(tarOut) // BAD
	files := make(fstest.MapFS)
	for {
		cur, err := tarRead.Next()
		if err == io.EOF {
			break
		}
		if cur.Typeflag != tar.TypeReg {
			continue
		}
		data, _ := io.ReadAll(tarRead) // BAD
		files[cur.Name] = &fstest.MapFile{Data: data}
	}
	fmt.Print(files)
}
