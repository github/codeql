package main

import "encoding"

func TaintStepTest_EncodingBinaryMarshalerMarshalBinary_B0I0O0(sourceCQL interface{}) interface{} {
	fromBinaryMarshaler656 := sourceCQL.(encoding.BinaryMarshaler)
	intoByte414, _ := fromBinaryMarshaler656.MarshalBinary()
	return intoByte414
}

func TaintStepTest_EncodingTextMarshalerMarshalText_B0I0O0(sourceCQL interface{}) interface{} {
	fromTextMarshaler518 := sourceCQL.(encoding.TextMarshaler)
	intoByte650, _ := fromTextMarshaler518.MarshalText()
	return intoByte650
}

func TaintStepTest_EncodingBinaryUnmarshalerUnmarshalBinary_B0I0O0(sourceCQL interface{}) interface{} {
	fromByte784 := sourceCQL.([]byte)
	var intoBinaryUnmarshaler957 encoding.BinaryUnmarshaler
	intoBinaryUnmarshaler957.UnmarshalBinary(fromByte784)
	return intoBinaryUnmarshaler957
}

func TaintStepTest_EncodingTextUnmarshalerUnmarshalText_B0I0O0(sourceCQL interface{}) interface{} {
	fromByte520 := sourceCQL.([]byte)
	var intoTextUnmarshaler443 encoding.TextUnmarshaler
	intoTextUnmarshaler443.UnmarshalText(fromByte520)
	return intoTextUnmarshaler443
}

func TaintStepTest_EncodingBinaryAppenderAppendBinary_manual1(sourceCQL interface{}) interface{} {
	fromBinaryAppender := sourceCQL.(encoding.BinaryAppender)
	var arg0 []byte
	intoByte, _ := fromBinaryAppender.AppendBinary(arg0)
	return intoByte
}

func TaintStepTest_EncodingBinaryAppenderAppendBinary_manual2(sourceCQL interface{}) interface{} {
	var recv encoding.BinaryAppender
	fromByteSlice := sourceCQL.([]byte)
	intoByte, _ := recv.AppendBinary(fromByteSlice)
	return intoByte
}

func TaintStepTest_EncodingTextAppenderAppendText_manual1(sourceCQL interface{}) interface{} {
	fromTextAppender := sourceCQL.(encoding.TextAppender)
	var arg0 []byte
	intoByte, _ := fromTextAppender.AppendText(arg0)
	return intoByte
}

func TaintStepTest_EncodingTextAppenderAppendText_manual2(sourceCQL interface{}) interface{} {
	var recv encoding.TextAppender
	fromByteSlice := sourceCQL.([]byte)
	intoByte, _ := recv.AppendText(fromByteSlice)
	return intoByte
}

func RunAllTaints_Encoding() {
	{
		source := newSource(0)
		out := TaintStepTest_EncodingBinaryMarshalerMarshalBinary_B0I0O0(source)
		sink(0, out)
	}
	{
		source := newSource(1)
		out := TaintStepTest_EncodingTextMarshalerMarshalText_B0I0O0(source)
		sink(1, out)
	}
	{
		source := newSource(2)
		out := TaintStepTest_EncodingBinaryUnmarshalerUnmarshalBinary_B0I0O0(source)
		sink(2, out)
	}
	{
		source := newSource(3)
		out := TaintStepTest_EncodingTextUnmarshalerUnmarshalText_B0I0O0(source)
		sink(3, out)
	}
	{
		source := newSource(4)
		out := TaintStepTest_EncodingBinaryAppenderAppendBinary_manual1(source)
		sink(4, out)
	}
	{
		source := newSource(5)
		out := TaintStepTest_EncodingBinaryAppenderAppendBinary_manual2(source)
		sink(5, out)
	}
	{
		source := newSource(6)
		out := TaintStepTest_EncodingTextAppenderAppendText_manual1(source)
		sink(6, out)
	}
	{
		source := newSource(7)
		out := TaintStepTest_EncodingTextAppenderAppendText_manual2(source)
		sink(7, out)
	}
}
