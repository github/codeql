/**
 * Provides classes modeling security-relevant aspects of the `mime/multipart` package.
 */

import go

/** Provides models of commonly used functions in the `mime/multipart` package. */
module MimeMultipart {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader, boundary string) *Reader
      hasQualifiedName("mime/multipart", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("mime/multipart", "NewWriter") and
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
      // signature: func (*FileHeader) Open() (File, error)
      hasQualifiedName("mime/multipart", "FileHeader", "Open") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Part) FileName() string
      hasQualifiedName("mime/multipart", "Part", "FileName") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Part) FormName() string
      hasQualifiedName("mime/multipart", "Part", "FormName") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) NextPart() (*Part, error)
      hasQualifiedName("mime/multipart", "Reader", "NextPart") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) NextRawPart() (*Part, error)
      hasQualifiedName("mime/multipart", "Reader", "NextRawPart") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadForm(maxMemory int64) (*Form, error)
      hasQualifiedName("mime/multipart", "Reader", "ReadForm") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Writer) CreateFormField(fieldname string) (io.Writer, error)
      hasQualifiedName("mime/multipart", "Writer", "CreateFormField") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreateFormFile(fieldname string, filename string) (io.Writer, error)
      hasQualifiedName("mime/multipart", "Writer", "CreateFormFile") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreatePart(header net/textproto.MIMEHeader) (io.Writer, error)
      hasQualifiedName("mime/multipart", "Writer", "CreatePart") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) WriteField(fieldname string, value string) error
      hasQualifiedName("mime/multipart", "Writer", "WriteField") and
      (inp.isParameter(_) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
