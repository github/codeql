import go

class MimeMultipartFileHeader extends UntrustedFlowSource::Range {
  MimeMultipartFileHeader() {
    exists(DataFlow::FieldReadNode frn | this = frn |
      frn.getField().hasQualifiedName("mime/multipart", "FileHeader", ["Filename", "Header"])
    )
    or
    exists(DataFlow::Method m |
      m.hasQualifiedName("mime/multipart", "FileHeader", "Open") and
      this = m.getACall().getResult(0)
    )
    or
    exists(DataFlow::FieldReadNode frn |
      frn.getField().hasQualifiedName("mime/multipart", "Form", "Value")
    )
  }
}
