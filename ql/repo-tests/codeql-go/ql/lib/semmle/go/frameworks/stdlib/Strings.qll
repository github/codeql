/**
 * Provides classes modeling security-relevant aspects of the `strings` package.
 */

import go

/** Provides models of commonly used functions in the `strings` package. */
module Strings {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Fields(s string) []string
      hasQualifiedName("strings", "Fields") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func FieldsFunc(s string, f func(rune) bool) []string
      hasQualifiedName("strings", "FieldsFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Join(elems []string, sep string) string
      hasQualifiedName("strings", "Join") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Map(mapping func(rune) rune, s string) string
      hasQualifiedName("strings", "Map") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func NewReader(s string) *Reader
      hasQualifiedName("strings", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewReplacer(oldnew ...string) *Replacer
      hasQualifiedName("strings", "NewReplacer") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Repeat(s string, count int) string
      hasQualifiedName("strings", "Repeat") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Replace(s string, old string, new string, n int) string
      hasQualifiedName("strings", "Replace") and
      (inp.isParameter([0, 2]) and outp.isResult())
      or
      // signature: func ReplaceAll(s string, old string, new string) string
      hasQualifiedName("strings", "ReplaceAll") and
      (inp.isParameter([0, 2]) and outp.isResult())
      or
      // signature: func Split(s string, sep string) []string
      hasQualifiedName("strings", "Split") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func SplitAfter(s string, sep string) []string
      hasQualifiedName("strings", "SplitAfter") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func SplitAfterN(s string, sep string, n int) []string
      hasQualifiedName("strings", "SplitAfterN") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func SplitN(s string, sep string, n int) []string
      hasQualifiedName("strings", "SplitN") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Title(s string) string
      hasQualifiedName("strings", "Title") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToLower(s string) string
      hasQualifiedName("strings", "ToLower") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToLowerSpecial(c unicode.SpecialCase, s string) string
      hasQualifiedName("strings", "ToLowerSpecial") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func ToTitle(s string) string
      hasQualifiedName("strings", "ToTitle") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToTitleSpecial(c unicode.SpecialCase, s string) string
      hasQualifiedName("strings", "ToTitleSpecial") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func ToUpper(s string) string
      hasQualifiedName("strings", "ToUpper") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToUpperSpecial(c unicode.SpecialCase, s string) string
      hasQualifiedName("strings", "ToUpperSpecial") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func ToValidUTF8(s string, replacement string) string
      hasQualifiedName("strings", "ToValidUTF8") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Trim(s string, cutset string) string
      hasQualifiedName("strings", "Trim") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimFunc(s string, f func(rune) bool) string
      hasQualifiedName("strings", "TrimFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimLeft(s string, cutset string) string
      hasQualifiedName("strings", "TrimLeft") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimLeftFunc(s string, f func(rune) bool) string
      hasQualifiedName("strings", "TrimLeftFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimPrefix(s string, prefix string) string
      hasQualifiedName("strings", "TrimPrefix") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimRight(s string, cutset string) string
      hasQualifiedName("strings", "TrimRight") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimRightFunc(s string, f func(rune) bool) string
      hasQualifiedName("strings", "TrimRightFunc") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimSpace(s string) string
      hasQualifiedName("strings", "TrimSpace") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimSuffix(s string, suffix string) string
      hasQualifiedName("strings", "TrimSuffix") and
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
      // signature: func (*Reader) Reset(s string)
      hasQualifiedName("strings", "Reader", "Reset") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Replacer) Replace(s string) string
      hasQualifiedName("strings", "Replacer", "Replace") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Replacer) WriteString(w io.Writer, s string) (n int, err error)
      hasQualifiedName("strings", "Replacer", "WriteString") and
      (inp.isParameter(1) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
