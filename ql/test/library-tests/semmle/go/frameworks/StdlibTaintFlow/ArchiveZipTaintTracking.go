// WARNING: This file was automatically generated. DO NOT EDIT.

package main

import (
	"archive/zip"
	"io"
	"os"
)

func TaintStepTest_ArchiveZipFileInfoHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileInfo656` into `intoFileHeader414`.

	// Assume that `sourceCQL` has the underlying type of `fromFileInfo656`:
	fromFileInfo656 := sourceCQL.(os.FileInfo)

	// Call the function that transfers the taint
	// from the parameter `fromFileInfo656` to result `intoFileHeader414`
	// (`intoFileHeader414` is now tainted).
	intoFileHeader414, _ := zip.FileInfoHeader(fromFileInfo656)

	// Return the tainted `intoFileHeader414`:
	return intoFileHeader414
}

func TaintStepTest_ArchiveZipNewReader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReaderAt518` into `intoReader650`.

	// Assume that `sourceCQL` has the underlying type of `fromReaderAt518`:
	fromReaderAt518 := sourceCQL.(io.ReaderAt)

	// Call the function that transfers the taint
	// from the parameter `fromReaderAt518` to result `intoReader650`
	// (`intoReader650` is now tainted).
	intoReader650, _ := zip.NewReader(fromReaderAt518, 0)

	// Return the tainted `intoReader650`:
	return intoReader650
}

func TaintStepTest_ArchiveZipNewWriter_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter784` into `intoWriter957`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter784`:
	fromWriter784 := sourceCQL.(*zip.Writer)

	// Declare `intoWriter957` variable:
	var intoWriter957 io.Writer

	// Call the function that will transfer the taint
	// from the result `intermediateCQL` to parameter `intoWriter957`:
	intermediateCQL := zip.NewWriter(intoWriter957)

	// Extra step (`fromWriter784` taints `intermediateCQL`, which taints `intoWriter957`:
	link(fromWriter784, intermediateCQL)

	// Return the tainted `intoWriter957`:
	return intoWriter957
}

func TaintStepTest_ArchiveZipOpenReader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromString520` into `intoReadCloser443`.

	// Assume that `sourceCQL` has the underlying type of `fromString520`:
	fromString520 := sourceCQL.(string)

	// Call the function that transfers the taint
	// from the parameter `fromString520` to result `intoReadCloser443`
	// (`intoReadCloser443` is now tainted).
	intoReadCloser443, _ := zip.OpenReader(fromString520)

	// Return the tainted `intoReadCloser443`:
	return intoReadCloser443
}

func TaintStepTest_ArchiveZipFileOpen_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFile127` into `intoReadCloser483`.

	// Assume that `sourceCQL` has the underlying type of `fromFile127`:
	fromFile127 := sourceCQL.(zip.File)

	// Call the method that transfers the taint
	// from the receiver `fromFile127` to the result `intoReadCloser483`
	// (`intoReadCloser483` is now tainted).
	intoReadCloser483, _ := fromFile127.Open()

	// Return the tainted `intoReadCloser483`:
	return intoReadCloser483
}

func TaintStepTest_ArchiveZipFileHeaderFileInfo_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileHeader989` into `intoFileInfo982`.

	// Assume that `sourceCQL` has the underlying type of `fromFileHeader989`:
	fromFileHeader989 := sourceCQL.(zip.FileHeader)

	// Call the method that transfers the taint
	// from the receiver `fromFileHeader989` to the result `intoFileInfo982`
	// (`intoFileInfo982` is now tainted).
	intoFileInfo982 := fromFileHeader989.FileInfo()

	// Return the tainted `intoFileInfo982`:
	return intoFileInfo982
}

func TaintStepTest_ArchiveZipFileHeaderMode_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileHeader417` into `intoFileMode584`.

	// Assume that `sourceCQL` has the underlying type of `fromFileHeader417`:
	fromFileHeader417 := sourceCQL.(zip.FileHeader)

	// Call the method that transfers the taint
	// from the receiver `fromFileHeader417` to the result `intoFileMode584`
	// (`intoFileMode584` is now tainted).
	intoFileMode584 := fromFileHeader417.Mode()

	// Return the tainted `intoFileMode584`:
	return intoFileMode584
}

func TaintStepTest_ArchiveZipFileHeaderSetMode_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileMode991` into `intoFileHeader881`.

	// Assume that `sourceCQL` has the underlying type of `fromFileMode991`:
	fromFileMode991 := sourceCQL.(os.FileMode)

	// Declare `intoFileHeader881` variable:
	var intoFileHeader881 zip.FileHeader

	// Call the method that transfers the taint
	// from the parameter `fromFileMode991` to the receiver `intoFileHeader881`
	// (`intoFileHeader881` is now tainted).
	intoFileHeader881.SetMode(fromFileMode991)

	// Return the tainted `intoFileHeader881`:
	return intoFileHeader881
}

func TaintStepTest_ArchiveZipReaderRegisterDecompressor_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromDecompressor186` into `intoReader284`.

	// Assume that `sourceCQL` has the underlying type of `fromDecompressor186`:
	fromDecompressor186 := sourceCQL.(zip.Decompressor)

	// Declare `intoReader284` variable:
	var intoReader284 zip.Reader

	// Call the method that transfers the taint
	// from the parameter `fromDecompressor186` to the receiver `intoReader284`
	// (`intoReader284` is now tainted).
	intoReader284.RegisterDecompressor(0, fromDecompressor186)

	// Return the tainted `intoReader284`:
	return intoReader284
}

func TaintStepTest_ArchiveZipWriterCreate_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter908` into `intoWriter137`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter908`:
	fromWriter908 := sourceCQL.(io.Writer)

	// Declare `intoWriter137` variable:
	var intoWriter137 zip.Writer

	// Call the method that will transfer the taint
	// from the result `intermediateCQL` to receiver `intoWriter137`:
	intermediateCQL, _ := intoWriter137.Create("")

	// Extra step (`fromWriter908` taints `intermediateCQL`, which taints `intoWriter137`:
	link(fromWriter908, intermediateCQL)

	// Return the tainted `intoWriter137`:
	return intoWriter137
}

func TaintStepTest_ArchiveZipWriterCreateHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileHeader494` into `intoWriter873`.

	// Assume that `sourceCQL` has the underlying type of `fromFileHeader494`:
	fromFileHeader494 := sourceCQL.(*zip.FileHeader)

	// Declare `intoWriter873` variable:
	var intoWriter873 zip.Writer

	// Call the method that transfers the taint
	// from the parameter `fromFileHeader494` to the receiver `intoWriter873`
	// (`intoWriter873` is now tainted).
	intoWriter873.CreateHeader(fromFileHeader494)

	// Return the tainted `intoWriter873`:
	return intoWriter873
}

func TaintStepTest_ArchiveZipWriterCreateHeader_B0I1O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter599` into `intoWriter409`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter599`:
	fromWriter599 := sourceCQL.(io.Writer)

	// Declare `intoWriter409` variable:
	var intoWriter409 zip.Writer

	// Call the method that will transfer the taint
	// from the result `intermediateCQL` to receiver `intoWriter409`:
	intermediateCQL, _ := intoWriter409.CreateHeader(nil)

	// Extra step (`fromWriter599` taints `intermediateCQL`, which taints `intoWriter409`:
	link(fromWriter599, intermediateCQL)

	// Return the tainted `intoWriter409`:
	return intoWriter409
}

func TaintStepTest_ArchiveZipWriterRegisterCompressor_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromCompressor246` into `intoWriter898`.

	// Assume that `sourceCQL` has the underlying type of `fromCompressor246`:
	fromCompressor246 := sourceCQL.(zip.Compressor)

	// Declare `intoWriter898` variable:
	var intoWriter898 zip.Writer

	// Call the method that transfers the taint
	// from the parameter `fromCompressor246` to the receiver `intoWriter898`
	// (`intoWriter898` is now tainted).
	intoWriter898.RegisterCompressor(0, fromCompressor246)

	// Return the tainted `intoWriter898`:
	return intoWriter898
}

func TaintStepTest_ArchiveZipWriterSetComment_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromString598` into `intoWriter631`.

	// Assume that `sourceCQL` has the underlying type of `fromString598`:
	fromString598 := sourceCQL.(string)

	// Declare `intoWriter631` variable:
	var intoWriter631 zip.Writer

	// Call the method that transfers the taint
	// from the parameter `fromString598` to the receiver `intoWriter631`
	// (`intoWriter631` is now tainted).
	intoWriter631.SetComment(fromString598)

	// Return the tainted `intoWriter631`:
	return intoWriter631
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
		out := TaintStepTest_ArchiveZipFileHeaderFileInfo_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipFileHeaderMode_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipFileHeaderSetMode_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipReaderRegisterDecompressor_B0I0O0(source)
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
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipWriterCreateHeader_B0I1O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipWriterRegisterCompressor_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveZipWriterSetComment_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
}
