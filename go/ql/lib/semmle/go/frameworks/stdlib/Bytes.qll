/**
 * Provides classes modeling security-relevant aspects of the `bytes` package.
 */

import go

/** Provides models of commonly used functions in the `bytes` package. */
module Bytes {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Fields(s []byte) [][]byte
      hasQualifiedName("bytes", "Fields") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func FieldsFunc(s []byte, f func(rune) bool) [][]byte
      hasQualifiedName("bytes", "FieldsFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Join(s [][]byte, sep []byte) []byte
      hasQualifiedName("bytes", "Join") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Map(mapping func(r rune) rune, s []byte) []byte
      hasQualifiedName("bytes", "Map") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func NewBuffer(buf []byte) *Buffer
      hasQualifiedName("bytes", "NewBuffer") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewBufferString(s string) *Buffer
      hasQualifiedName("bytes", "NewBufferString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewReader(b []byte) *Reader
      hasQualifiedName("bytes", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Repeat(b []byte, count int) []byte
      hasQualifiedName("bytes", "Repeat") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Replace(s []byte, old []byte, new []byte, n int) []byte
      hasQualifiedName("bytes", "Replace") and
      (inp.isParameter([0, 2]) and outp.isResult())
      or
      // signature: func ReplaceAll(s []byte, old []byte, new []byte) []byte
      hasQualifiedName("bytes", "ReplaceAll") and
      (inp.isParameter([0, 2]) and outp.isResult())
      or
      // signature: func Runes(s []byte) []rune
      hasQualifiedName("bytes", "Runes") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Split(s []byte, sep []byte) [][]byte
      hasQualifiedName("bytes", "Split") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func SplitAfter(s []byte, sep []byte) [][]byte
      hasQualifiedName("bytes", "SplitAfter") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func SplitAfterN(s []byte, sep []byte, n int) [][]byte
      hasQualifiedName("bytes", "SplitAfterN") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func SplitN(s []byte, sep []byte, n int) [][]byte
      hasQualifiedName("bytes", "SplitN") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Title(s []byte) []byte
      hasQualifiedName("bytes", "Title") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToLower(s []byte) []byte
      hasQualifiedName("bytes", "ToLower") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToLowerSpecial(c unicode.SpecialCase, s []byte) []byte
      hasQualifiedName("bytes", "ToLowerSpecial") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func ToTitle(s []byte) []byte
      hasQualifiedName("bytes", "ToTitle") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToTitleSpecial(c unicode.SpecialCase, s []byte) []byte
      hasQualifiedName("bytes", "ToTitleSpecial") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func ToUpper(s []byte) []byte
      hasQualifiedName("bytes", "ToUpper") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToUpperSpecial(c unicode.SpecialCase, s []byte) []byte
      hasQualifiedName("bytes", "ToUpperSpecial") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func ToValidUTF8(s []byte, replacement []byte) []byte
      hasQualifiedName("bytes", "ToValidUTF8") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Trim(s []byte, cutset string) []byte
      hasQualifiedName("bytes", "Trim") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimFunc(s []byte, f func(r rune) bool) []byte
      hasQualifiedName("bytes", "TrimFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimLeft(s []byte, cutset string) []byte
      hasQualifiedName("bytes", "TrimLeft") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimLeftFunc(s []byte, f func(r rune) bool) []byte
      hasQualifiedName("bytes", "TrimLeftFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimPrefix(s []byte, prefix []byte) []byte
      hasQualifiedName("bytes", "TrimPrefix") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimRight(s []byte, cutset string) []byte
      hasQualifiedName("bytes", "TrimRight") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimRightFunc(s []byte, f func(r rune) bool) []byte
      hasQualifiedName("bytes", "TrimRightFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimSpace(s []byte) []byte
      hasQualifiedName("bytes", "TrimSpace") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimSuffix(s []byte, suffix []byte) []byte
      hasQualifiedName("bytes", "TrimSuffix") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Buffer) Bytes() []byte
      hasQualifiedName("bytes", "Buffer", "Bytes") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Buffer) Next(n int) []byte
      hasQualifiedName("bytes", "Buffer", "Next") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Buffer) ReadBytes(delim byte) (line []byte, err error)
      hasQualifiedName("bytes", "Buffer", "ReadBytes") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Buffer) ReadString(delim byte) (line string, err error)
      hasQualifiedName("bytes", "Buffer", "ReadString") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) Reset(b []byte)
      hasQualifiedName("bytes", "Reader", "Reset") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
