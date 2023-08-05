import go
import semmle.go.dataflow.Properties
import semmle.go.security.FlowSources

class MimeMultipartFileHeader extends UntrustedFlowSource::Range {
  MimeMultipartFileHeader() {
    exists(DataFlow::Variable v |
      v.hasQualifiedName("mime/multipart.FileHeader", ["Filename", "Header"]) and
      this = v.getARead()
    )
    or
    exists(DataFlow::Method m |
      m.hasQualifiedName("mime/multipart.FileHeader", "Open") and
      this = m.getACall()
    )
    or
    exists(DataFlow::Variable v |
      v.hasQualifiedName("mime/multipart.Form", "Value") and
      this = v.getARead()
    )
  }
}
