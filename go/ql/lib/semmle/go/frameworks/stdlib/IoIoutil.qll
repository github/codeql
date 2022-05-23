/**
 * Provides classes modeling security-relevant aspects of the `io/ioutil` package.
 */

import go

/** Provides models of commonly used functions in the `io/ioutil` package. */
module IoIoutil {
  private class IoUtilFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    IoUtilFileSystemAccess() {
      exists(string fn | getTarget().hasQualifiedName("io/ioutil", fn) |
        fn = ["ReadDir", "ReadFile", "TempDir", "TempFile", "WriteFile"]
      )
    }

    override DataFlow::Node getAPathArgument() { result = getAnArgument() }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NopCloser(r io.Reader) io.ReadCloser
      hasQualifiedName("io/ioutil", "NopCloser") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ReadAll(r io.Reader) ([]byte, error)
      hasQualifiedName("io/ioutil", "ReadAll") and
      (inp.isParameter(0) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
