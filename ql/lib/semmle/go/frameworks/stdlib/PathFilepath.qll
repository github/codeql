/**
 * Provides classes modeling security-relevant aspects of the `path/filepath` package.
 */

import go

/** Provides models of commonly used functions in the `path/filepath` package. */
module PathFilepath {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Abs(path string) (string, error)
      hasQualifiedName("path/filepath", "Abs") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func Base(path string) string
      hasQualifiedName("path/filepath", "Base") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Clean(path string) string
      hasQualifiedName("path/filepath", "Clean") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Dir(path string) string
      hasQualifiedName("path/filepath", "Dir") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func EvalSymlinks(path string) (string, error)
      hasQualifiedName("path/filepath", "EvalSymlinks") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func Ext(path string) string
      hasQualifiedName("path/filepath", "Ext") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func FromSlash(path string) string
      hasQualifiedName("path/filepath", "FromSlash") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Glob(pattern string) (matches []string, err error)
      hasQualifiedName("path/filepath", "Glob") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func Join(elem ...string) string
      hasQualifiedName("path/filepath", "Join") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Rel(basepath string, targpath string) (string, error)
      hasQualifiedName("path/filepath", "Rel") and
      (inp.isParameter(_) and outp.isResult(0))
      or
      // signature: func Split(path string) (dir string, file string)
      hasQualifiedName("path/filepath", "Split") and
      (inp.isParameter(0) and outp.isResult(_))
      or
      // signature: func SplitList(path string) []string
      hasQualifiedName("path/filepath", "SplitList") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ToSlash(path string) string
      hasQualifiedName("path/filepath", "ToSlash") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func VolumeName(path string) string
      hasQualifiedName("path/filepath", "VolumeName") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
