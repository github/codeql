// WARNING: This file was automatically generated. DO NOT EDIT.

package main

import (
	"archive/tar"
	"io"
	"os"
)

func TaintStepTest_ArchiveTarFileInfoHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileInfo656` into `intoHeader414`.

	// Assume that `sourceCQL` has the underlying type of `fromFileInfo656`:
	fromFileInfo656 := sourceCQL.(os.FileInfo)

	// Call the function that transfers the taint
	// from the parameter `fromFileInfo656` to result `intoHeader414`
	// (`intoHeader414` is now tainted).
	intoHeader414, _ := tar.FileInfoHeader(fromFileInfo656, "")

	// Return the tainted `intoHeader414`:
	return intoHeader414
}

func TaintStepTest_ArchiveTarNewReader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReader518` into `intoReader650`.

	// Assume that `sourceCQL` has the underlying type of `fromReader518`:
	fromReader518 := sourceCQL.(io.Reader)

	// Call the function that transfers the taint
	// from the parameter `fromReader518` to result `intoReader650`
	// (`intoReader650` is now tainted).
	intoReader650 := tar.NewReader(fromReader518)

	// Return the tainted `intoReader650`:
	return intoReader650
}

func TaintStepTest_ArchiveTarNewWriter_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter784` into `intoWriter957`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter784`:
	fromWriter784 := sourceCQL.(*tar.Writer)

	// Declare `intoWriter957` variable:
	var intoWriter957 io.Writer

	// Call the function that will transfer the taint
	// from the result `intermediateCQL` to parameter `intoWriter957`:
	intermediateCQL := tar.NewWriter(intoWriter957)

	// Extra step (`fromWriter784` taints `intermediateCQL`, which taints `intoWriter957`:
	link(fromWriter784, intermediateCQL)

	// Return the tainted `intoWriter957`:
	return intoWriter957
}

func TaintStepTest_ArchiveTarHeaderFileInfo_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromHeader520` into `intoFileInfo443`.

	// Assume that `sourceCQL` has the underlying type of `fromHeader520`:
	fromHeader520 := sourceCQL.(tar.Header)

	// Call the method that transfers the taint
	// from the receiver `fromHeader520` to the result `intoFileInfo443`
	// (`intoFileInfo443` is now tainted).
	intoFileInfo443 := fromHeader520.FileInfo()

	// Return the tainted `intoFileInfo443`:
	return intoFileInfo443
}

func TaintStepTest_ArchiveTarReaderNext_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReader127` into `intoHeader483`.

	// Assume that `sourceCQL` has the underlying type of `fromReader127`:
	fromReader127 := sourceCQL.(tar.Reader)

	// Call the method that transfers the taint
	// from the receiver `fromReader127` to the result `intoHeader483`
	// (`intoHeader483` is now tainted).
	intoHeader483, _ := fromReader127.Next()

	// Return the tainted `intoHeader483`:
	return intoHeader483
}

func TaintStepTest_ArchiveTarReaderRead_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReader989` into `intoByte982`.

	// Assume that `sourceCQL` has the underlying type of `fromReader989`:
	fromReader989 := sourceCQL.(tar.Reader)

	// Declare `intoByte982` variable:
	var intoByte982 []byte

	// Call the method that transfers the taint
	// from the receiver `fromReader989` to the argument `intoByte982`
	// (`intoByte982` is now tainted).
	fromReader989.Read(intoByte982)

	// Return the tainted `intoByte982`:
	return intoByte982
}

func TaintStepTest_ArchiveTarWriterWrite_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromByte417` into `intoWriter584`.

	// Assume that `sourceCQL` has the underlying type of `fromByte417`:
	fromByte417 := sourceCQL.([]byte)

	// Declare `intoWriter584` variable:
	var intoWriter584 tar.Writer

	// Call the method that transfers the taint
	// from the parameter `fromByte417` to the receiver `intoWriter584`
	// (`intoWriter584` is now tainted).
	intoWriter584.Write(fromByte417)

	// Return the tainted `intoWriter584`:
	return intoWriter584
}

func TaintStepTest_ArchiveTarWriterWriteHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromHeader991` into `intoWriter881`.

	// Assume that `sourceCQL` has the underlying type of `fromHeader991`:
	fromHeader991 := sourceCQL.(*tar.Header)

	// Declare `intoWriter881` variable:
	var intoWriter881 tar.Writer

	// Call the method that transfers the taint
	// from the parameter `fromHeader991` to the receiver `intoWriter881`
	// (`intoWriter881` is now tainted).
	intoWriter881.WriteHeader(fromHeader991)

	// Return the tainted `intoWriter881`:
	return intoWriter881
}

func RunAllTaints_ArchiveTar() {
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarFileInfoHeader_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarNewReader_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarNewWriter_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarHeaderFileInfo_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarReaderNext_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarReaderRead_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarWriterWrite_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_ArchiveTarWriterWriteHeader_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
}
