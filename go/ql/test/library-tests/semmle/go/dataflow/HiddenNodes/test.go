package test

import (
	"archive/tar"
	"os"
)

func source() interface{} { return nil }

func sink(x interface{}) {}

func test() {

	fi := source().(os.FileInfo)
	header, _ := tar.FileInfoHeader(fi, "link")
	sink(header)

}
