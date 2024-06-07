/**
 * Provides classes modeling security-relevant aspects of the `bufio` package.
 */

import go

/** Provides models of commonly used functions in the `bufio` package. */
module Bufio {
  /**
   * The function `bufio.NewScanner`.
   */
  class NewScanner extends Function {
    NewScanner() { this.hasQualifiedName("bufio", "NewScanner") }

    /**
     * Gets the input corresponding to the `io.Reader`
     * argument provided in the call.
     */
    FunctionInput getReader() { result.isParameter(0) }
  }

  // These models are not implemented using Models-as-Data because they represent reverse flow.
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReadWriter(r *Reader, w *Writer) *ReadWriter
      this.hasQualifiedName("bufio", "NewReadWriter") and
      (inp.isResult() and outp.isParameter(1))
      or
      // signature: func NewWriter(w io.Writer) *Writer
      this.hasQualifiedName("bufio", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewWriterSize(w io.Writer, size int) *Writer
      this.hasQualifiedName("bufio", "NewWriterSize") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
