/**
 * Provides classes modeling security-relevant aspects of the `text/tabwriter` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `text/tabwriter` package. */
module TextTabwriter {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewWriter(output io.Writer, minwidth int, tabwidth int, padding int, padchar byte, flags uint) *Writer
      this.hasQualifiedName("text/tabwriter", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Writer) Init(output io.Writer, minwidth int, tabwidth int, padding int, padchar byte, flags uint) *Writer
      this.hasQualifiedName("text/tabwriter", "Writer", "Init") and
      (
        inp.isResult() and
        outp.isParameter(0)
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
