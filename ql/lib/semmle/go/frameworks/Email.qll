/** Provides classes for working with email-related APIs. */

import go

/**
 * A data-flow node that represents data written to an email, either as part
 * of the headers or as part of the body.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `EmailData::Range` instead.
 */
class EmailData extends DataFlow::Node {
  EmailData::Range self;

  EmailData() { this = self }
}

/** Provides classes for working with data that is incorporated into an email. */
module EmailData {
  /**
   * A data-flow node that represents data which is written to an email, either as part
   * of the headers or as part of the body.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `EmailData` instead.
   */
  abstract class Range extends DataFlow::Node { }

  /** A data-flow node that is written to an email using the net/smtp package. */
  private class SmtpData extends Range {
    SmtpData() {
      // func (c *Client) Data() (io.WriteCloser, error)
      exists(Method data |
        data.hasQualifiedName("net/smtp", "Client", "Data") and
        this.(DataFlow::SsaNode).getInit() = data.getACall().getResult(0)
      )
      or
      // func SendMail(addr string, a Auth, from string, to []string, msg []byte) error
      exists(Function sendMail |
        sendMail.hasQualifiedName("net/smtp", "SendMail") and
        this = sendMail.getACall().getArgument(4)
      )
    }
  }

  /** Gets the package name `github.com/sendgrid/sendgrid-go/helpers/mail`. */
  private string sendgridMail() {
    result = package("github.com/sendgrid/sendgrid-go", "helpers/mail")
  }

  private class NewContent extends TaintTracking::FunctionModel {
    NewContent() {
      // func NewContent(contentType string, value string) *Content
      this.hasQualifiedName(sendgridMail(), "NewContent")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(1) and output.isResult()
    }
  }

  /** A data-flow node that is written to an email using the sendgrid/sendgrid-go package. */
  private class SendGridEmail extends Range {
    SendGridEmail() {
      // func NewSingleEmail(from *Email, subject string, to *Email, plainTextContent string, htmlContent string) *SGMailV3
      exists(Function newSingleEmail |
        newSingleEmail.hasQualifiedName(sendgridMail(), "NewSingleEmail") and
        this = newSingleEmail.getACall().getArgument([1, 3, 4])
      )
      or
      // func NewV3MailInit(from *Email, subject string, to *Email, content ...*Content) *SGMailV3
      exists(Function newv3MailInit |
        newv3MailInit.hasQualifiedName(sendgridMail(), "NewV3MailInit") and
        this = newv3MailInit.getACall().getArgument(any(int i | i = 1 or i >= 3))
      )
      or
      // func (s *SGMailV3) AddContent(c ...*Content) *SGMailV3
      exists(Method addContent |
        addContent.hasQualifiedName(sendgridMail(), "SGMailV3", "AddContent") and
        this = addContent.getACall().getAnArgument()
      )
    }
  }
}

/**
 * A taint model of the `Writer.CreatePart` method from `mime/multipart`.
 *
 * If tainted data is written to the multipart section created by this method, the underlying writer
 * should be considered tainted as well.
 */
private class MultipartWriterCreatePartModel extends TaintTracking::FunctionModel, Method {
  MultipartWriterCreatePartModel() {
    this.hasQualifiedName("mime/multipart", "Writer", "CreatePart")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isResult(0) and output.isReceiver()
  }
}

/**
 * A taint model of the `NewWriter` function from `mime/multipart`.
 *
 * If tainted data is written to the writer created by this function, the underlying writer
 * should be considered tainted as well.
 */
private class MultipartNewWriterModel extends TaintTracking::FunctionModel {
  MultipartNewWriterModel() { this.hasQualifiedName("mime/multipart", "NewWriter") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isResult() and output.isParameter(0)
  }
}
