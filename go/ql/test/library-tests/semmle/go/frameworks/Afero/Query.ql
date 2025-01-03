import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module FileSystemAccessTest implements TestSig {
  string getARelevantTag() { result = ["FileSystemAccess", "succ", "pred"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FileSystemAccess fsa |
      fsa.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = fsa.getAPathArgument().toString() and
      value = fsa.getAPathArgument().toString() and
      tag = "FileSystemAccess"
    )
    or
    exists(DataFlow::Node succ, DataFlow::Node pred |
      any(Afero::AdditionalTaintStep adts).step(pred, succ)
    |
      succ.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = succ.toString() and
      value = succ.asExpr().(StructLit).getType().getName() and
      tag = "succ"
      or
      pred.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = pred.toString() and
      value = pred.toString() and
      tag = "pred"
    )
  }
}

import MakeTest<FileSystemAccessTest>
