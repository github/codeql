/**
 * Provides classes modeling security-relevant aspects of the `net/textproto` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `net/textproto` package. */
module NetTextproto {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewConn(conn io.ReadWriteCloser) *Conn
      hasQualifiedName("net/textproto", "NewConn") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewWriter(w *bufio.Writer) *Writer
      hasQualifiedName("net/textproto", "NewWriter") and
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
      // signature: func (*Writer) DotWriter() io.WriteCloser
      hasQualifiedName("net/textproto", "Writer", "DotWriter") and
      (inp.isResult() and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
