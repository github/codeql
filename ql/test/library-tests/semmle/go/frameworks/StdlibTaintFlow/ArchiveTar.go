// WARNING: This file was automatically generated. DO NOT EDIT.

package main

import (
	"archive/tar"
	"io"
	"os"
)

func TaintStepTest_ArchiveTarFileInfoHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromFileInfo291` into `intoHeader926`.

	// Assume that `sourceCQL` has the underlying type of `fromFileInfo291`:
	fromFileInfo291 := sourceCQL.(os.FileInfo)

	// Call the function that transfers the taint
	// from the parameter `fromFileInfo291` to result `intoHeader926`
	// (`intoHeader926` is now tainted).
	intoHeader926, _ := tar.FileInfoHeader(fromFileInfo291, "")

	// Return the tainted `intoHeader926`:
	return intoHeader926
}

func TaintStepTest_ArchiveTarNewReader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReader527` into `intoReader503`.

	// Assume that `sourceCQL` has the underlying type of `fromReader527`:
	fromReader527 := sourceCQL.(io.Reader)

	// Call the function that transfers the taint
	// from the parameter `fromReader527` to result `intoReader503`
	// (`intoReader503` is now tainted).
	intoReader503 := tar.NewReader(fromReader527)

	// Return the tainted `intoReader503`:
	return intoReader503
}

func TaintStepTest_ArchiveTarNewWriter_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromWriter907` into `intoWriter317`.

	// Assume that `sourceCQL` has the underlying type of `fromWriter907`:
	fromWriter907 := sourceCQL.(*tar.Writer)

	// Declare `intoWriter317` variable:
	var intoWriter317 io.Writer

	// Call the function that will transfer the taint
	// from the result `intermediateCQL` to parameter `intoWriter317`:
	intermediateCQL := tar.NewWriter(intoWriter317)

	// Extra step (`fromWriter907` taints `intermediateCQL`, which taints `intoWriter317`:
	link(fromWriter907, intermediateCQL)

	// Return the tainted `intoWriter317`:
	return intoWriter317
}

func TaintStepTest_ArchiveTarHeaderFileInfo_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromHeader460` into `intoFileInfo402`.

	// Assume that `sourceCQL` has the underlying type of `fromHeader460`:
	fromHeader460 := sourceCQL.(tar.Header)

	// Call the method that transfers the taint
	// from the receiver `fromHeader460` to the result `intoFileInfo402`
	// (`intoFileInfo402` is now tainted).
	intoFileInfo402 := fromHeader460.FileInfo()

	// Return the tainted `intoFileInfo402`:
	return intoFileInfo402
}

func TaintStepTest_ArchiveTarReaderNext_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReader994` into `intoHeader183`.

	// Assume that `sourceCQL` has the underlying type of `fromReader994`:
	fromReader994 := sourceCQL.(tar.Reader)

	// Call the method that transfers the taint
	// from the receiver `fromReader994` to the result `intoHeader183`
	// (`intoHeader183` is now tainted).
	intoHeader183, _ := fromReader994.Next()

	// Return the tainted `intoHeader183`:
	return intoHeader183
}

func TaintStepTest_ArchiveTarReaderRead_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromReader746` into `intoByte905`.

	// Assume that `sourceCQL` has the underlying type of `fromReader746`:
	fromReader746 := sourceCQL.(tar.Reader)

	// Declare `intoByte905` variable:
	var intoByte905 []byte

	// Call the method that transfers the taint
	// from the receiver `fromReader746` to the argument `intoByte905`
	// (`intoByte905` is now tainted).
	fromReader746.Read(intoByte905)

	// Return the tainted `intoByte905`:
	return intoByte905
}

func TaintStepTest_ArchiveTarWriterWrite_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromByte262` into `intoWriter837`.

	// Assume that `sourceCQL` has the underlying type of `fromByte262`:
	fromByte262 := sourceCQL.([]byte)

	// Declare `intoWriter837` variable:
	var intoWriter837 tar.Writer

	// Call the method that transfers the taint
	// from the parameter `fromByte262` to the receiver `intoWriter837`
	// (`intoWriter837` is now tainted).
	intoWriter837.Write(fromByte262)

	// Return the tainted `intoWriter837`:
	return intoWriter837
}

func TaintStepTest_ArchiveTarWriterWriteHeader_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromHeader798` into `intoWriter568`.

	// Assume that `sourceCQL` has the underlying type of `fromHeader798`:
	fromHeader798 := sourceCQL.(*tar.Header)

	// Declare `intoWriter568` variable:
	var intoWriter568 tar.Writer

	// Call the method that transfers the taint
	// from the parameter `fromHeader798` to the receiver `intoWriter568`
	// (`intoWriter568` is now tainted).
	intoWriter568.WriteHeader(fromHeader798)

	// Return the tainted `intoWriter568`:
	return intoWriter568
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
