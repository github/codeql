/**
 * Provides classes modeling security-relevant aspects of the `net/textproto` package.
 */

import go

/** Provides models of commonly used functions in the `net/textproto` package. */
module NetTextproto {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func CanonicalMIMEHeaderKey(s string) string
      hasQualifiedName("net/textproto", "CanonicalMIMEHeaderKey") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewConn(conn io.ReadWriteCloser) *Conn
      hasQualifiedName("net/textproto", "NewConn") and
      (
        inp.isParameter(0) and outp.isResult()
        or
        inp.isResult() and outp.isParameter(0)
      )
      or
      // signature: func NewReader(r *bufio.Reader) *Reader
      hasQualifiedName("net/textproto", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w *bufio.Writer) *Writer
      hasQualifiedName("net/textproto", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func TrimBytes(b []byte) []byte
      hasQualifiedName("net/textproto", "TrimBytes") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func TrimString(s string) string
      hasQualifiedName("net/textproto", "TrimString") and
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
      // signature: func (MIMEHeader) Add(key string, value string)
      hasQualifiedName("net/textproto", "MIMEHeader", "Add") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (MIMEHeader) Get(key string) string
      hasQualifiedName("net/textproto", "MIMEHeader", "Get") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (MIMEHeader) Set(key string, value string)
      hasQualifiedName("net/textproto", "MIMEHeader", "Set") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (MIMEHeader) Values(key string) []string
      hasQualifiedName("net/textproto", "MIMEHeader", "Values") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Reader) DotReader() io.Reader
      hasQualifiedName("net/textproto", "Reader", "DotReader") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Reader) ReadCodeLine(expectCode int) (code int, message string, err error)
      hasQualifiedName("net/textproto", "Reader", "ReadCodeLine") and
      (inp.isReceiver() and outp.isResult(1))
      or
      // signature: func (*Reader) ReadContinuedLine() (string, error)
      hasQualifiedName("net/textproto", "Reader", "ReadContinuedLine") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadContinuedLineBytes() ([]byte, error)
      hasQualifiedName("net/textproto", "Reader", "ReadContinuedLineBytes") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadDotBytes() ([]byte, error)
      hasQualifiedName("net/textproto", "Reader", "ReadDotBytes") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadDotLines() ([]string, error)
      hasQualifiedName("net/textproto", "Reader", "ReadDotLines") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadLine() (string, error)
      hasQualifiedName("net/textproto", "Reader", "ReadLine") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadLineBytes() ([]byte, error)
      hasQualifiedName("net/textproto", "Reader", "ReadLineBytes") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadMIMEHeader() (MIMEHeader, error)
      hasQualifiedName("net/textproto", "Reader", "ReadMIMEHeader") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadResponse(expectCode int) (code int, message string, err error)
      hasQualifiedName("net/textproto", "Reader", "ReadResponse") and
      (inp.isReceiver() and outp.isResult(1))
      or
      // signature: func (*Writer) DotWriter() io.WriteCloser
      hasQualifiedName("net/textproto", "Writer", "DotWriter") and
      (inp.isResult() and outp.isReceiver())
      or
      // signature: func (*Writer) PrintfLine(format string, args ...interface{}) error
      hasQualifiedName("net/textproto", "Writer", "PrintfLine") and
      (inp.isParameter(_) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
