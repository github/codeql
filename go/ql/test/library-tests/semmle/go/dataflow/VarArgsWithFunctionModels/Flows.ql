import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineFlowTest
import DefaultFlowTest

class SummaryModelTest extends DataFlow::FunctionModel {
  FunctionInput inp;
  FunctionOutput outp;

  SummaryModelTest() {
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithParameter") and
    (inp.isParameter(0) and outp.isResult())
    or
    // Cannot model this correctly for data flow, but it should work for taint flow
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithSliceParameter") and
    (inp.isParameter(0) and outp.isResult())
    or
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithVarArgsParameter") and
    (inp.isParameter(_) and outp.isResult())
    or
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithSliceOfStructsParameter") and
    (inp.isParameter(0) and outp.isResult())
    or
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithVarArgsOfStructsParameter") and
    (inp.isParameter(0) and outp.isResult())
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input = inp and output = outp
  }
}
