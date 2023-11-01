/**
 * Provides classes modeling security-relevant aspects of the `mime/multipart` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `mime/multipart` package. */
module MimeMultipart {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewWriter(w io.Writer) *Writer
      this.hasQualifiedName("mime/multipart", "NewWriter") and
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
      // signature: func (*Writer) CreateFormField(fieldname string) (io.Writer, error)
      this.hasQualifiedName("mime/multipart", "Writer", "CreateFormField") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreateFormFile(fieldname string, filename string) (io.Writer, error)
      this.hasQualifiedName("mime/multipart", "Writer", "CreateFormFile") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreatePart(header net/textproto.MIMEHeader) (io.Writer, error)
      this.hasQualifiedName("mime/multipart", "Writer", "CreatePart") and
      (inp.isResult(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
