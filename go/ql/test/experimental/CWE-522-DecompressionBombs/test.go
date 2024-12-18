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
	GZipOpenReaderSafe(request.PostFormValue("test"))
	ZipOpenReaderSafe(request.PostFormValue("test"))
	ZipOpenReader(request.FormValue("filepath"))
	ZipNewReader(request.Body)
	ZipNewReaderKlauspost(request.Body)
	Bzip2Dsnet(request.Body)
	Bzip2DsnetSafe(request.Body)
	Bzip2(request.Body)
	Bzip2Safe(request.Body)
	Flate(request.Body)
	FlateSafe(request.Body)
	FlateKlauspost(request.Body)
	FlateKlauspostSafe(request.Body)
	FlateDsnet(request.Body)
	FlateDsnetSafe(request.Body)
	ZlibKlauspost(request.Body)
	ZlibKlauspostSafe(request.Body)
	Zlib(request.Body)
	ZlibSafe(request.Body)
	Snappy(request.Body)
	SnappySafe(request.Body)
	SnappyKlauspost(request.Body)
	SnappyKlauspostSafe(request.Body)
	S2(request.Body)
	S2Safe(request.Body)
	Gzip(request.Body)
	GzipSafe(request.Body)
	GZipIoReader(request.Body, "dest")
	GzipKlauspost(request.Body)
	GzipKlauspostSafe(request.Body)
	PzipKlauspost(request.Body)
	PzipKlauspostSafe(request.Body)
	Zstd_Klauspost(request.Body)
	Zstd_KlauspostSafe(request.Body)
	Zstd_DataDog(request.Body)
	Zstd_DataDogSafe(request.Body)
	Xz(request.Body)
	XzSafe(request.Body)
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
				fmt.Print(totalBytes, "exceeded")
				break
			}
		}
	}
}

func ZipOpenReader(filename string) {
	// Open the zip file
	zipReader, _ := zip.OpenReader(filename)
	for _, f := range zipReader.File {
		rc, _ := f.Open()
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68) // $ hasValueFlow="rc"
			if result == 0 {
				_ = rc.Close()
				break
			}
			fmt.Print(result)
			_ = rc.Close()
		}
	}
	zipKlauspostReader, _ := zipKlauspost.OpenReader(filename)
	for _, f := range zipKlauspostReader.File {
		rc, _ := f.Open()
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68) // $ hasValueFlow="rc"
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
		result, _ := io.Copy(fileWriter, fileReaderCloser) // $ hasValueFlow="fileReaderCloser"
		fmt.Print(result)
	}
}

func ZipNewReaderKlauspost(file io.Reader) {
	file2, _ := io.ReadAll(file)
	zipReader, _ := zipKlauspost.NewReader(bytes.NewReader(file2), int64(32<<20))
	for _, file := range zipReader.File {
		fileWriter := bytes.NewBuffer([]byte{})
		// file.OpenRaw()
		fileReaderCloser, _ := file.Open()
		result, _ := io.Copy(fileWriter, fileReaderCloser) // $ hasValueFlow="fileReaderCloser"
		fmt.Print(result)
	}
}

func Bzip2Dsnet(file io.Reader) {
	var tarRead *tar.Reader

	bzip2Reader, _ := bzip2Dsnet.NewReader(file, &bzip2Dsnet.ReaderConfig{})
	var out []byte = make([]byte, 70)
	bzip2Reader.Read(out) // $ hasValueFlow="bzip2Reader"
	tarRead = tar.NewReader(bzip2Reader)

	TarDecompressor(tarRead)

}
func Bzip2DsnetSafe(file io.Reader) {
	bzip2Reader, _ := bzip2Dsnet.NewReader(file, &bzip2Dsnet.ReaderConfig{})
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = bzip2Reader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", bzip2Reader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}

}
func Bzip2(file io.Reader) {
	var tarRead *tar.Reader

	bzip2Reader := bzip2.NewReader(file)
	var out []byte = make([]byte, 70)
	bzip2Reader.Read(out) // $ hasValueFlow="bzip2Reader"
	tarRead = tar.NewReader(bzip2Reader)

	TarDecompressor(tarRead)
}
func Bzip2Safe(file io.Reader) {
	bzip2Reader := bzip2.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = bzip2Reader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", bzip2Reader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func Flate(file io.Reader) {
	var tarRead *tar.Reader

	flateReader := flate.NewReader(file)
	var out []byte = make([]byte, 70)
	flateReader.Read(out) // $ hasValueFlow="flateReader"
	tarRead = tar.NewReader(flateReader)

	TarDecompressor(tarRead)
}
func FlateSafe(file io.Reader) {
	flateReader := flate.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = flateReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", flateReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func FlateKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	flateReader := flateKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	flateReader.Read(out) // $ hasValueFlow="flateReader"
	tarRead = tar.NewReader(flateReader)

	TarDecompressor(tarRead)
}
func FlateKlauspostSafe(file io.Reader) {
	flateReader := flateKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = flateReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", flateReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func FlateDsnet(file io.Reader) {
	var tarRead *tar.Reader

	flateReader, _ := flateDsnet.NewReader(file, &flateDsnet.ReaderConfig{})
	var out []byte = make([]byte, 70)
	flateReader.Read(out) // $ hasValueFlow="flateReader"
	tarRead = tar.NewReader(flateReader)

	TarDecompressor(tarRead)
}
func FlateDsnetSafe(file io.Reader) {
	flateReader, _ := flateDsnet.NewReader(file, &flateDsnet.ReaderConfig{})
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = flateReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", flateReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func ZlibKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	zlibReader, _ := zlibKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	zlibReader.Read(out) // $ hasValueFlow="zlibReader"
	tarRead = tar.NewReader(zlibReader)

	TarDecompressor(tarRead)
}
func ZlibKlauspostSafe(file io.Reader) {
	zlibReader, _ := zlibKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = zlibReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", zlibReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func Zlib(file io.Reader) {
	var tarRead *tar.Reader

	zlibReader, _ := zlib.NewReader(file)
	var out []byte = make([]byte, 70)
	zlibReader.Read(out) // $ hasValueFlow="zlibReader"
	tarRead = tar.NewReader(zlibReader)

	TarDecompressor(tarRead)
}
func ZlibSafe(file io.Reader) {
	zlibReader, _ := zlib.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = zlibReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", zlibReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func Snappy(file io.Reader) {
	var tarRead *tar.Reader

	snappyReader := snappy.NewReader(file)
	var out []byte = make([]byte, 70)
	snappyReader.Read(out)  // $ hasValueFlow="snappyReader"
	snappyReader.ReadByte() // $ hasValueFlow="snappyReader"
	tarRead = tar.NewReader(snappyReader)

	TarDecompressor(tarRead)
}
func SnappySafe(file io.Reader) {
	snappyReader := snappy.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = snappyReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", snappyReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func SnappyKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	snappyReader := snappyKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	snappyReader.Read(out) // $ hasValueFlow="snappyReader"
	var buf bytes.Buffer
	snappyReader.DecodeConcurrent(&buf, 2) // $ hasValueFlow="snappyReader"
	snappyReader.ReadByte()                // $ hasValueFlow="snappyReader"
	tarRead = tar.NewReader(snappyReader)

	TarDecompressor(tarRead)
}
func SnappyKlauspostSafe(file io.Reader) {
	snappyReader := snappyKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = snappyReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", snappyReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func S2(file io.Reader) {
	var tarRead *tar.Reader

	s2Reader := s2.NewReader(file)
	var out []byte = make([]byte, 70)
	s2Reader.Read(out)  // $ hasValueFlow="s2Reader"
	s2Reader.ReadByte() // $ hasValueFlow="s2Reader"
	var buf bytes.Buffer
	s2Reader.DecodeConcurrent(&buf, 2) // $ hasValueFlow="s2Reader"
	tarRead = tar.NewReader(s2Reader)

	TarDecompressor(tarRead)
}
func S2Safe(file io.Reader) {
	s2Reader := s2.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = s2Reader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", s2Reader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func GZipIoReader(src io.Reader, dst string) {
	gzipReader, _ := gzip.NewReader(src)
	dstF, _ := os.OpenFile(dst, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0755)
	defer dstF.Close()
	newSrc := io.Reader(gzipReader)
	_, _ = io.Copy(dstF, newSrc) // $ hasValueFlow="newSrc"
}
func Gzip(file io.Reader) {
	var tarRead *tar.Reader

	gzipReader, _ := gzip.NewReader(file)
	var out []byte = make([]byte, 70)
	gzipReader.Read(out) // $ hasValueFlow="gzipReader"
	tarRead = tar.NewReader(gzipReader)

	TarDecompressor(tarRead)
}
func GzipSafe(file io.Reader) {
	gzipReader, _ := gzip.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = gzipReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", gzipReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func GzipKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	gzipReader, _ := gzipKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	gzipReader.Read(out) // $ hasValueFlow="gzipReader"
	var buf bytes.Buffer
	gzipReader.WriteTo(&buf) // $ hasValueFlow="gzipReader"
	tarRead = tar.NewReader(gzipReader)

	TarDecompressor(tarRead)
}
func GzipKlauspostSafe(file io.Reader) {
	gzipReader, _ := gzipKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = gzipReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", gzipReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func PzipKlauspost(file io.Reader) {
	var tarRead *tar.Reader

	pgzipReader, _ := pgzipKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	pgzipReader.Read(out) // $ hasValueFlow="pgzipReader"
	var buf bytes.Buffer
	pgzipReader.WriteTo(&buf) // $ hasValueFlow="pgzipReader"
	tarRead = tar.NewReader(pgzipReader)

	TarDecompressor(tarRead)
}
func PzipKlauspostSafe(file io.Reader) {
	pgzipReader, _ := pgzipKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = pgzipReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", pgzipReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func Zstd_Klauspost(file io.Reader) {
	var tarRead *tar.Reader

	zstdReader, _ := zstdKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	zstdReader.Read(out) // $ hasValueFlow="zstdReader"
	var buf bytes.Buffer
	zstdReader.WriteTo(&buf) // $ hasValueFlow="zstdReader"
	var src []byte
	zstdReader.DecodeAll(src, nil) // $ hasValueFlow="zstdReader"
	tarRead = tar.NewReader(zstdReader)

	TarDecompressor(tarRead)
}
func Zstd_KlauspostSafe(file io.Reader) {
	zstdReader, _ := zstdKlauspost.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = zstdReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", zstdReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func Zstd_DataDog(file io.Reader) {
	var tarRead *tar.Reader

	zstdReader := zstdDataDog.NewReader(file)
	var out []byte = make([]byte, 70)
	zstdReader.Read(out) // $ hasValueFlow="zstdReader"
	tarRead = tar.NewReader(zstdReader)

	TarDecompressor(tarRead)
}
func Zstd_DataDogSafe(file io.Reader) {
	zstdReader := zstdDataDog.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = zstdReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", zstdReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
func Xz(file io.Reader) {
	var tarRead *tar.Reader

	xzReader, _ := xz.NewReader(file)
	var out []byte = make([]byte, 70)
	xzReader.Read(out) // $ hasValueFlow="xzReader"
	tarRead = tar.NewReader(xzReader)
	fmt.Println(io.SeekStart)

	TarDecompressor(tarRead)
	TarDecompressor2(tarRead)
	TarDecompressorSafe(tarRead)
	TarDecompressorTN(tarRead)
}

func XzSafe(file io.Reader) {
	xzReader, _ := xz.NewReader(file)
	var out []byte = make([]byte, 70)
	var totalBytes int64 = 0
	i := 1
	for i > 0 {
		i, _ = xzReader.Read(out) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", xzReader)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}

func TarDecompressor(tarRead *tar.Reader) {
	files := make(fstest.MapFS)
	for {
		cur, err := tarRead.Next()
		if err == io.EOF {
			break
		}
		if cur.Typeflag != tar.TypeReg {
			continue
		}
		data, _ := io.ReadAll(tarRead) // $ hasValueFlow="tarRead"
		files[cur.Name] = &fstest.MapFile{Data: data}
	}
	fmt.Print(files)
}

func TarDecompressor2(tarRead *tar.Reader) {
	var tarOut []byte = make([]byte, 70)
	tarRead.Read(tarOut) // $ hasValueFlow="tarRead"
	fmt.Println("do sth with output:", tarOut)
}

func TarDecompressorTN(tarRead *tar.Reader) {
	var tarOut []byte = make([]byte, 70)
	i := 1
	for i > 0 {
		i, _ = tarRead.Read(tarOut) // GOOD: the output size is being controlled
		fmt.Println("do sth with output:", tarOut)
	}
}

func TarDecompressorSafe(tarRead *tar.Reader) {
	var tarOut []byte = make([]byte, 70)
	i := 1
	var totalBytes int64 = 0
	for i > 0 {
		i, _ = tarRead.Read(tarOut) // GOOD: The output size is being controlled
		fmt.Println("do sth with output:", tarOut)
		totalBytes = totalBytes + int64(i)
		if totalBytes > 1024*1024*1024*5 {
			fmt.Print(totalBytes, "exceeded")
			break
		}
	}
}
