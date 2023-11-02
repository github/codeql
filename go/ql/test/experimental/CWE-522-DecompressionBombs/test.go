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
	"io/ioutil"
	"net/http"
	"os"
	"testing/fstest"

	zstdDataDog "github.com/DataDog/zstd"
	bzip2Dsnet "github.com/dsnet/compress/bzip2"
	flateDsnet "github.com/dsnet/compress/flate"
	"github.com/golang/snappy"
	flateKlauspost "github.com/klauspost/compress/flate"
	gzipKlauspost "github.com/klauspost/compress/gzip"
	"github.com/klauspost/compress/s2"
	snappyKlauspost "github.com/klauspost/compress/snappy"
	zipKlauspost "github.com/klauspost/compress/zip"
	zlibKlauspost "github.com/klauspost/compress/zlib"
	zstdKlauspost "github.com/klauspost/compress/zstd"
	pzipKlauspost "github.com/klauspost/pgzip"
	"github.com/ulikunitz/xz"
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
	TarDecompressor(request.Body, "gz")
	ZipNewReader(request.Body)
	ZipNewReader2(request.Body)
	ZipOpenReader(request.FormValue("filepathba"))
	ZipOpenReaderSafe(request.PostFormValue("test"))
	GZipOpenReaderSafe(request.PostFormValue("test"))
	GZipsafeReader(request.Body, "dest")
}

func GZipOpenReaderSafe(filename string) {
	var src io.Reader
	src, _ = os.Open(filename)
	gzipR, _ := gzip.NewReader(src)
	dstF, _ := os.OpenFile("./test", os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0755)
	defer dstF.Close()
	var newSrc io.Reader
	newSrc = io.LimitReader(gzipR, 1024*1024*1024*5)
	_, _ = io.Copy(dstF, newSrc)
}

func ZipOpenReaderSafe(filename string) {
	r, _ := zip.OpenReader(filename)
	var totalBytes int64 = 0
	for _, f := range r.File {
		rc, _ := f.Open()
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68)
			if result == 0 {
				_ = rc.Close()
				break
			}
			totalBytes = totalBytes + result
			if totalBytes > 1024*1024 {
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
	_, _ = io.Copy(dstF, newSrc)
}

func ZipOpenReader(filename string) {
	// Open the zip file
	r, _ := zip.OpenReader(filename)
	for _, f := range r.File {
		rc, _ := f.Open()
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68)
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
			result, _ := io.CopyN(os.Stdout, rc, 68)
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
		result, _ := io.Copy(fileWriter, fileReaderCloser)
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
		result, _ := io.Copy(fileWriter, fileReaderCloser)
		fmt.Print(result)
	}
}
func serve(w http.ResponseWriter, r *http.Request) {
	if r.Body != nil {
		if data, err := ioutil.ReadAll(r.Body); err == nil {
			fmt.Println(data)
		}
	}
}

func TarDecompressor(file io.Reader, compressionType string) {
	var tarRead *tar.Reader
	if compressionType == "bzip2Dsnet" {
		bzip2dsnet, _ := bzip2Dsnet.NewReader(file, &bzip2Dsnet.ReaderConfig{})
		var out []byte = make([]byte, 70)
		bzip2dsnet.Read(out)
		tarRead = tar.NewReader(bzip2dsnet)
	}
	if compressionType == "bzip2" {
		Bzip2 := bzip2.NewReader(file)
		var out []byte = make([]byte, 70)
		Bzip2.Read(out)
		tarRead = tar.NewReader(Bzip2)
	}
	if compressionType == "flate" {
		//flate.NewReaderDict()
		Flate := flate.NewReader(file)
		var out []byte = make([]byte, 70)
		Flate.Read(out)
		tarRead = tar.NewReader(Flate)
	}
	if compressionType == "flateKlauspost" {
		//flateKlauspost.NewReaderDict()
		zlibklauspost := flateKlauspost.NewReader(file)
		var out []byte = make([]byte, 70)
		zlibklauspost.Read(out)
		tarRead = tar.NewReader(zlibklauspost)
	}
	if compressionType == "flateDsnet" {
		flatedsnet, _ := flateDsnet.NewReader(file, &flateDsnet.ReaderConfig{})
		var out []byte = make([]byte, 70)
		flatedsnet.Read(out)
		tarRead = tar.NewReader(flatedsnet)
	}
	if compressionType == "zlibKlauspost" {
		//zlibKlauspost.NewReaderDict()
		zlibklauspost, _ := zlibKlauspost.NewReader(file)
		var out []byte = make([]byte, 70)
		zlibklauspost.Read(out)
		tarRead = tar.NewReader(zlibklauspost)
	}
	if compressionType == "zlib" {
		//zlib.NewReaderDict()
		Zlib, _ := zlib.NewReader(file)
		var out []byte = make([]byte, 70)
		Zlib.Read(out)
		tarRead = tar.NewReader(Zlib)
	}
	if compressionType == "snappy" {
		Snappy := snappy.NewReader(file)
		var out []byte = make([]byte, 70)
		Snappy.Read(out)
		Snappy.ReadByte()
		tarRead = tar.NewReader(Snappy)
	}
	if compressionType == "snappyKlauspost" {
		snappyklauspost := snappyKlauspost.NewReader(file)
		var out []byte = make([]byte, 70)
		snappyklauspost.Read(out)
		var buf bytes.Buffer
		snappyklauspost.DecodeConcurrent(&buf, 2)
		snappyklauspost.ReadByte()
		tarRead = tar.NewReader(snappyklauspost)
	}
	if compressionType == "s2" {
		S2 := s2.NewReader(file)
		var out []byte = make([]byte, 70)
		S2.Read(out)
		var buf bytes.Buffer
		S2.DecodeConcurrent(&buf, 2)
		//S2.ReadSeeker()
		//S2.ReadByte()
		tarRead = tar.NewReader(S2)
	}
	if compressionType == "gz" {
		gzipRead, _ := gzip.NewReader(file)
		var out []byte = make([]byte, 70)
		gzipRead.Read(out)
		tarRead = tar.NewReader(gzipRead)
	}
	if compressionType == "gzipKlauspost" {
		gzipklauspost, _ := gzipKlauspost.NewReader(file)
		var out []byte = make([]byte, 70)
		gzipklauspost.Read(out)
		var buf bytes.Buffer
		gzipklauspost.WriteTo(&buf)
		tarRead = tar.NewReader(gzipklauspost)
	}
	if compressionType == "pzipKlauspost" {
		//gzipPgzip.NewReaderN()
		gzippgzip, _ := pzipKlauspost.NewReader(file)
		var out []byte = make([]byte, 70)
		gzippgzip.Read(out)
		var buf bytes.Buffer
		gzippgzip.WriteTo(&buf)
		tarRead = tar.NewReader(gzippgzip)
	}
	if compressionType == "zstd_Klauspost" {
		zstd, _ := zstdKlauspost.NewReader(file)
		var out []byte = make([]byte, 70)
		zstd.Read(out)
		var buf bytes.Buffer
		zstd.WriteTo(&buf)
		var src []byte
		zstd.DecodeAll(src, nil)
		tarRead = tar.NewReader(zstd)
	}
	if compressionType == "zstd_DataDog" {
		//zstdDataDog.NewReaderDict()
		zstd := zstdDataDog.NewReader(file)
		var out []byte = make([]byte, 70)
		zstd.Read(out)
		tarRead = tar.NewReader(zstd)
	}
	if compressionType == "xz" {
		xzRead, _ := xz.NewReader(file)
		var out []byte = make([]byte, 70)
		xzRead.Read(out)
		tarRead = tar.NewReader(xzRead)
	}
	var out []byte = make([]byte, 70)
	tarRead.Read(out)
	files := make(fstest.MapFS)
	for {
		cur, err := tarRead.Next()
		if err == io.EOF {
			break
		}
		if cur.Typeflag != tar.TypeReg {
			continue
		}
		data, _ := io.ReadAll(tarRead)
		files[cur.Name] = &fstest.MapFile{Data: data}
	}
	fmt.Print(files)
}
