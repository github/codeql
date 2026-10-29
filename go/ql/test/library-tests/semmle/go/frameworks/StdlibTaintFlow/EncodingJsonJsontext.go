package main

import (
	"encoding/json/jsontext"
	"io"
)

func TaintStepTest_JsontextAppendFloat_I0(sourceCQL interface{}) interface{} {
	fromByte := sourceCQL.([]byte)
	intoByte := jsontext.AppendFloat(fromByte, 0, 64)
	return intoByte
}

func TaintStepTest_JsontextAppendFloat_I1(sourceCQL interface{}) interface{} {
	fromFloat := sourceCQL.(float64)
	intoByte := jsontext.AppendFloat(nil, fromFloat, 64)
	return intoByte
}

func TaintStepTest_JsontextAppendFormat_I0(sourceCQL interface{}) interface{} {
	fromByte := sourceCQL.([]byte)
	intoByte, _ := jsontext.AppendFormat(fromByte, []byte{})
	return intoByte
}

func TaintStepTest_JsontextAppendFormat_I1(sourceCQL interface{}) interface{} {
	fromByte := sourceCQL.([]byte)
	intoByte, _ := jsontext.AppendFormat(nil, fromByte)
	return intoByte
}

func TaintStepTest_JsontextAppendQuote_I0(sourceCQL interface{}) interface{} {
	fromByte := sourceCQL.([]byte)
	intoByte, _ := jsontext.AppendQuote(fromByte, []byte{})
	return intoByte
}

func TaintStepTest_JsontextAppendQuote_I1(sourceCQL interface{}) interface{} {
	fromString := sourceCQL.(string)
	intoByte, _ := jsontext.AppendQuote(nil, fromString)
	return intoByte
}

func TaintStepTest_JsontextAppendUnquote_I0(sourceCQL interface{}) interface{} {
	fromByte := sourceCQL.([]byte)
	intoByte, _ := jsontext.AppendUnquote(fromByte, []byte{})
	return intoByte
}

func TaintStepTest_JsontextAppendUnquote_I1(sourceCQL interface{}) interface{} {
	fromString := sourceCQL.(string)
	intoByte, _ := jsontext.AppendUnquote(nil, fromString)
	return intoByte
}

func TaintStepTest_JsontextNewDecoder(sourceCQL interface{}) interface{} {
	fromReader := sourceCQL.(io.Reader)
	intoDecoder := jsontext.NewDecoder(fromReader)
	return intoDecoder
}

func TaintStepTest_JsontextNewEncoder(sourceCQL interface{}) interface{} {
	fromEncoder := sourceCQL.(*jsontext.Encoder)
	var intoWriter io.Writer
	intermediateCQL := jsontext.NewEncoder(intoWriter)
	link(fromEncoder, intermediateCQL)
	return intoWriter
}

func TaintStepTest_JsontextFloat(sourceCQL interface{}) interface{} {
	fromFloat := sourceCQL.(float64)
	intoToken := jsontext.Float(fromFloat)
	return intoToken
}

func TaintStepTest_JsontextFloat32(sourceCQL interface{}) interface{} {
	fromFloat := sourceCQL.(float32)
	intoToken := jsontext.Float32(fromFloat)
	return intoToken
}

func TaintStepTest_JsontextInt(sourceCQL interface{}) interface{} {
	fromInt := sourceCQL.(int64)
	intoToken := jsontext.Int(fromInt)
	return intoToken
}

func TaintStepTest_JsontextString(sourceCQL interface{}) interface{} {
	fromString := sourceCQL.(string)
	intoToken := jsontext.String(fromString)
	return intoToken
}

func TaintStepTest_JsontextUint(sourceCQL interface{}) interface{} {
	fromUint := sourceCQL.(uint64)
	intoToken := jsontext.Uint(fromUint)
	return intoToken
}

func TaintStepTest_JsontextDecoderReadToken(sourceCQL interface{}) interface{} {
	fromDecoder := sourceCQL.(jsontext.Decoder)
	intoToken, _ := fromDecoder.ReadToken()
	return intoToken
}

func TaintStepTest_JsontextDecoderReadValue(sourceCQL interface{}) interface{} {
	fromDecoder := sourceCQL.(jsontext.Decoder)
	intoValue, _ := fromDecoder.ReadValue()
	return intoValue
}

func TaintStepTest_JsontextDecoderReset(sourceCQL interface{}) interface{} {
	fromReader := sourceCQL.(io.Reader)
	var intoDecoder jsontext.Decoder
	intoDecoder.Reset(fromReader)
	return intoDecoder
}

func TaintStepTest_JsontextDecoderUnreadBuffer(sourceCQL interface{}) interface{} {
	fromDecoder := sourceCQL.(jsontext.Decoder)
	intoByte := fromDecoder.UnreadBuffer()
	return intoByte
}

func TaintStepTest_JsontextEncoderReset(sourceCQL interface{}) interface{} {
	fromEncoder := sourceCQL.(jsontext.Encoder)
	var intoWriter io.Writer
	fromEncoder.Reset(intoWriter)
	return intoWriter
}

func TaintStepTest_JsontextEncoderWriteToken(sourceCQL interface{}) interface{} {
	fromToken := sourceCQL.(jsontext.Token)
	var intoEncoder jsontext.Encoder
	intoEncoder.WriteToken(fromToken)
	return intoEncoder
}

func TaintStepTest_JsontextEncoderWriteValue(sourceCQL interface{}) interface{} {
	fromValue := sourceCQL.(jsontext.Value)
	var intoEncoder jsontext.Encoder
	intoEncoder.WriteValue(fromValue)
	return intoEncoder
}

func TaintStepTest_JsontextPointerAppendToken_Receiver(sourceCQL interface{}) interface{} {
	fromPointer := sourceCQL.(jsontext.Pointer)
	intoPointer := fromPointer.AppendToken("")
	return intoPointer
}

func TaintStepTest_JsontextPointerAppendToken_I0(sourceCQL interface{}) interface{} {
	fromString := sourceCQL.(string)
	var pointer jsontext.Pointer
	intoPointer := pointer.AppendToken(fromString)
	return intoPointer
}

func TaintStepTest_JsontextPointerLastToken(sourceCQL interface{}) interface{} {
	fromPointer := sourceCQL.(jsontext.Pointer)
	intoString := fromPointer.LastToken()
	return intoString
}

func TaintStepTest_JsontextPointerParent(sourceCQL interface{}) interface{} {
	fromPointer := sourceCQL.(jsontext.Pointer)
	intoPointer := fromPointer.Parent()
	return intoPointer
}

func TaintStepTest_JsontextTokenClone(sourceCQL interface{}) interface{} {
	fromToken := sourceCQL.(jsontext.Token)
	intoToken := fromToken.Clone()
	return intoToken
}

func TaintStepTest_JsontextTokenFloat(sourceCQL interface{}) interface{} {
	fromToken := sourceCQL.(jsontext.Token)
	intoFloat, _ := fromToken.Float()
	return intoFloat
}

func TaintStepTest_JsontextTokenFloat32(sourceCQL interface{}) interface{} {
	fromToken := sourceCQL.(jsontext.Token)
	intoFloat, _ := fromToken.Float32()
	return intoFloat
}

func TaintStepTest_JsontextTokenInt(sourceCQL interface{}) interface{} {
	fromToken := sourceCQL.(jsontext.Token)
	intoInt, _ := fromToken.Int()
	return intoInt
}

func TaintStepTest_JsontextTokenString(sourceCQL interface{}) interface{} {
	fromToken := sourceCQL.(jsontext.Token)
	intoString := fromToken.String()
	return intoString
}

func TaintStepTest_JsontextTokenUint(sourceCQL interface{}) interface{} {
	fromToken := sourceCQL.(jsontext.Token)
	intoUint, _ := fromToken.Uint()
	return intoUint
}

func TaintStepTest_JsontextValueClone(sourceCQL interface{}) interface{} {
	fromValue := sourceCQL.(jsontext.Value)
	intoValue := fromValue.Clone()
	return intoValue
}

func TaintStepTest_JsontextValueMarshalJSON(sourceCQL interface{}) interface{} {
	fromValue := sourceCQL.(jsontext.Value)
	intoByte, _ := fromValue.MarshalJSON()
	return intoByte
}

func TaintStepTest_JsontextValueString(sourceCQL interface{}) interface{} {
	fromValue := sourceCQL.(jsontext.Value)
	intoString := fromValue.String()
	return intoString
}

func TaintStepTest_JsontextValueUnmarshalJSON(sourceCQL interface{}) interface{} {
	fromByte := sourceCQL.([]byte)
	var intoValue jsontext.Value
	intoValue.UnmarshalJSON(fromByte)
	return intoValue
}

func RunAllTaints_EncodingJsonJsontext() {
	{
		source := newSource(0)
		out := TaintStepTest_JsontextAppendFloat_I0(source)
		sink(0, out)
	}
	{
		source := newSource(1)
		out := TaintStepTest_JsontextAppendFloat_I1(source)
		sink(1, out)
	}
	{
		source := newSource(2)
		out := TaintStepTest_JsontextAppendFormat_I0(source)
		sink(2, out)
	}
	{
		source := newSource(3)
		out := TaintStepTest_JsontextAppendFormat_I1(source)
		sink(3, out)
	}
	{
		source := newSource(4)
		out := TaintStepTest_JsontextAppendQuote_I0(source)
		sink(4, out)
	}
	{
		source := newSource(5)
		out := TaintStepTest_JsontextAppendQuote_I1(source)
		sink(5, out)
	}
	{
		source := newSource(6)
		out := TaintStepTest_JsontextAppendUnquote_I0(source)
		sink(6, out)
	}
	{
		source := newSource(7)
		out := TaintStepTest_JsontextAppendUnquote_I1(source)
		sink(7, out)
	}
	{
		source := newSource(8)
		out := TaintStepTest_JsontextNewDecoder(source)
		sink(8, out)
	}
	{
		source := newSource(9)
		out := TaintStepTest_JsontextNewEncoder(source)
		sink(9, out)
	}
	{
		source := newSource(10)
		out := TaintStepTest_JsontextFloat(source)
		sink(10, out)
	}
	{
		source := newSource(11)
		out := TaintStepTest_JsontextFloat32(source)
		sink(11, out)
	}
	{
		source := newSource(12)
		out := TaintStepTest_JsontextInt(source)
		sink(12, out)
	}
	{
		source := newSource(13)
		out := TaintStepTest_JsontextString(source)
		sink(13, out)
	}
	{
		source := newSource(14)
		out := TaintStepTest_JsontextUint(source)
		sink(14, out)
	}
	{
		source := newSource(15)
		out := TaintStepTest_JsontextDecoderReadToken(source)
		sink(15, out)
	}
	{
		source := newSource(16)
		out := TaintStepTest_JsontextDecoderReadValue(source)
		sink(16, out)
	}
	{
		source := newSource(17)
		out := TaintStepTest_JsontextDecoderReset(source)
		sink(17, out)
	}
	{
		source := newSource(18)
		out := TaintStepTest_JsontextDecoderUnreadBuffer(source)
		sink(18, out)
	}
	{
		source := newSource(19)
		out := TaintStepTest_JsontextEncoderReset(source)
		sink(19, out)
	}
	{
		source := newSource(20)
		out := TaintStepTest_JsontextEncoderWriteToken(source)
		sink(20, out)
	}
	{
		source := newSource(21)
		out := TaintStepTest_JsontextEncoderWriteValue(source)
		sink(21, out)
	}
	{
		source := newSource(22)
		out := TaintStepTest_JsontextPointerAppendToken_Receiver(source)
		sink(22, out)
	}
	{
		source := newSource(23)
		out := TaintStepTest_JsontextPointerAppendToken_I0(source)
		sink(23, out)
	}
	{
		source := newSource(24)
		out := TaintStepTest_JsontextPointerLastToken(source)
		sink(24, out)
	}
	{
		source := newSource(25)
		out := TaintStepTest_JsontextPointerParent(source)
		sink(25, out)
	}
	{
		source := newSource(26)
		out := TaintStepTest_JsontextTokenClone(source)
		sink(26, out)
	}
	{
		source := newSource(27)
		out := TaintStepTest_JsontextTokenFloat(source)
		sink(27, out)
	}
	{
		source := newSource(28)
		out := TaintStepTest_JsontextTokenFloat32(source)
		sink(28, out)
	}
	{
		source := newSource(29)
		out := TaintStepTest_JsontextTokenInt(source)
		sink(29, out)
	}
	{
		source := newSource(30)
		out := TaintStepTest_JsontextTokenString(source)
		sink(30, out)
	}
	{
		source := newSource(31)
		out := TaintStepTest_JsontextTokenUint(source)
		sink(31, out)
	}
	{
		source := newSource(32)
		out := TaintStepTest_JsontextValueClone(source)
		sink(32, out)
	}
	{
		source := newSource(33)
		out := TaintStepTest_JsontextValueMarshalJSON(source)
		sink(33, out)
	}
	{
		source := newSource(34)
		out := TaintStepTest_JsontextValueString(source)
		sink(34, out)
	}
	{
		source := newSource(35)
		out := TaintStepTest_JsontextValueUnmarshalJSON(source)
		sink(35, out)
	}
}
