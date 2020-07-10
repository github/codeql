// WARNING: This file was automatically generated. DO NOT EDIT.

package main

import (
	"archive/zip"
	"io"
	"os"
)

func TaintStepTest_ArchiveZipFileInfoHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileInfo785` into `intoFileHeader724`.

	// Assume that `sourceCQL` has the underlying type of `fromFileInfo785`:
	fromFileInfo785 := sourceCQL.(os.FileInfo)

	// Call the function that transfers the taint
	// from the parameter `fromFileInfo785` to result `intoFileHeader724`
	// (`intoFileHeader724` is now tainted).
	intoFileHeader724, _ := zip.FileInfoHeader(fromFileInfo785)

	// Return the tainted `intoFileHeader724`:
	return intoFileHeader724
}

func TaintStepTest_ArchiveZipNewReader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReaderAt469` into `intoReader991`.

	// Assume that `sourceCQL` has the underlying type of `fromReaderAt469`:
	fromReaderAt469 := sourceCQL.(io.ReaderAt)

	// Call the function that transfers the taint
	// from the parameter `fromReaderAt469` to result `intoReader991`
	// (`intoReader991` is now tainted).
	intoReader991, _ := zip.NewReader(fromReaderAt469, 0)

	// Return the tainted `intoReader991`:
	return intoReader991
}

func TaintStepTest_ArchiveZipNewWriter_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter132` into `intoWriter263`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter132`:
	fromWriter132 := sourceCQL.(*zip.Writer)

	// Declare `intoWriter263` variable:
	var intoWriter263 io.Writer

	// Call the function that will transfer the taint
	// from the result `intermediateCQL` to parameter `intoWriter263`:
	intermediateCQL := zip.NewWriter(intoWriter263)

	// Extra step (`fromWriter132` taints `intermediateCQL`, which taints `intoWriter263`:
	link(fromWriter132, intermediateCQL)

	// Return the tainted `intoWriter263`:
	return intoWriter263
}

func TaintStepTest_ArchiveZipOpenReader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromString370` into `intoReadCloser611`.

	// Assume that `sourceCQL` has the underlying type of `fromString370`:
	fromString370 := sourceCQL.(string)

	// Call the function that transfers the taint
	// from the parameter `fromString370` to result `intoReadCloser611`
	// (`intoReadCloser611` is now tainted).
	intoReadCloser611, _ := zip.OpenReader(fromString370)

	// Return the tainted `intoReadCloser611`:
	return intoReadCloser611
}

func TaintStepTest_ArchiveZipFileOpen_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFile148` into `intoReadCloser252`.

	// Assume that `sourceCQL` has the underlying type of `fromFile148`:
	fromFile148 := sourceCQL.(zip.File)

	// Call the method that transfers the taint
	// from the receiver `fromFile148` to the result `intoReadCloser252`
	// (`intoReadCloser252` is now tainted).
	intoReadCloser252, _ := fromFile148.Open()

	// Return the tainted `intoReadCloser252`:
	return intoReadCloser252
}

func TaintStepTest_ArchiveZipWriterCreate_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter910` into `intoWriter583`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter910`:
	fromWriter910 := sourceCQL.(io.Writer)

	// Declare `intoWriter583` variable:
	var intoWriter583 zip.Writer

	// Call the method that will transfer the taint
	// from the result `intermediateCQL` to receiver `intoWriter583`:
	intermediateCQL, _ := intoWriter583.Create("")

	// Extra step (`fromWriter910` taints `intermediateCQL`, which taints `intoWriter583`:
	link(fromWriter910, intermediateCQL)

	// Return the tainted `intoWriter583`:
	return intoWriter583
}

func TaintStepTest_ArchiveZipWriterCreateHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter564` into `intoWriter189`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter564`:
	fromWriter564 := sourceCQL.(io.Writer)

	// Declare `intoWriter189` variable:
	var intoWriter189 zip.Writer

	// Call the method that will transfer the taint
	// from the result `intermediateCQL` to receiver `intoWriter189`:
	intermediateCQL, _ := intoWriter189.CreateHeader(nil)

	// Extra step (`fromWriter564` taints `intermediateCQL`, which taints `intoWriter189`:
	link(fromWriter564, intermediateCQL)

	// Return the tainted `intoWriter189`:
	return intoWriter189
}

func RunAllTaints_ArchiveZip() {
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipFileInfoHeader_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipNewReader_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipNewWriter_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipOpenReader_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipFileOpen_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipWriterCreate_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipWriterCreateHeader_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
}
