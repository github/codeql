/** Provides classes for working with email-related APIs. */

import go

/**
 * A data-flow node that represents data written to an email.
 * Data in this case includes the email headers and the mail body
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `MailDataCall::Range` instead.
 */
class MailData extends DataFlow::Node {
  MailDataCall::Range self;

  MailData() { this = self.getData() }
}

/** Provides classes for working with calls which write data to an email. */
module MailDataCall {
  /**
   * A data-flow node that represents a call which writes data to an email.
   * Data in this case refers to email headers and the mail body
   *
   */
  abstract class Range extends DataFlow::CallNode {
    /** Gets data written to an email connection. */
    abstract DataFlow::Node getData();
  }

  /** Get the package name `github.com/sendgrid/sendgrid-go/helpers/mail`. */
  bindingset[result]
  private string sendgridMail() { result = "github.com/sendgrid/sendgrid-go/helpers/mail" }

  /** A Client.Data expression string used in an API function of the net/smtp package. */
  private class SmtpData extends Range {
    SmtpData() {
      // func (c *Client) Data() (io.WriteCloser, error)
      this.getTarget().(Method).hasQualifiedName("net/smtp", "Client", "Data")
    }

    override DataFlow::Node getData() {
      exists(DataFlow::CallNode write, DataFlow::Node writer, int i |
        this.getResult(0) = writer and
        (
          write.getTarget().hasQualifiedName("fmt", "Fprintf")
          or
          write.getTarget().hasQualifiedName("io", "WriteString")
        ) and
        writer.getASuccessor*() = write.getArgument(0) and
        i > 0 and
        write.getArgument(i) = result
      )
    }
  }

  /** A send mail expression string used in an API function of the net/smtp package. */
  private class SmtpSendMail extends Range {
    SmtpSendMail() {
      // func SendMail(addr string, a Auth, from string, to []string, msg []byte) error
      this.getTarget().hasQualifiedName("net/smtp", "SendMail")
    }

    override DataFlow::Node getData() { result = this.getArgument(4) }
  }

  /** A call to `NewSingleEmail` API function of the Sendgrid mail package. */
  private class SendGridSingleEmail extends Range {
    SendGridSingleEmail() {
      // func NewSingleEmail(from *Email, subject string, to *Email, plainTextContent string, htmlContent string) *SGMailV3
      this.getTarget().hasQualifiedName(sendgridMail(), "NewSingleEmail")
    }

    override DataFlow::Node getData() { result = this.getArgument([1, 3, 4]) }
  }

  /* Gets the value of the `i`-th content parameter of the given `call` */
  private DataFlow::Node getContent(DataFlow::CallNode call, int i) {
    exists(DataFlow::CallNode cn, DataFlow::Node content |
      // func NewContent(contentType string, value string) *Content
      cn.getTarget().hasQualifiedName(sendgridMail(), "NewContent") and
      cn.getResult() = content and
      content.getASuccessor*() = call.getArgument(i) and
      result = cn.getArgument(1)
    )
  }

  /** A call to `NewV3MailInit` API function of the Sendgrid mail package. */
  private class SendGridV3Init extends Range {
    SendGridV3Init() {
      // func NewV3MailInit(from *Email, subject string, to *Email, content ...*Content) *SGMailV3
      this.getTarget().hasQualifiedName(sendgridMail(), "NewV3MailInit")
    }

    override DataFlow::Node getData() {
      exists(int i | result = getContent(this, i) and i >= 3)
      or
      result = this.getArgument(1)
    }
  }

  /** A call to `AddContent` API function of the Sendgrid mail package. */
  private class SendGridAddContent extends Range {
    SendGridAddContent() {
      // func (s *SGMailV3) AddContent(c ...*Content) *SGMailV3
      this.getTarget().(Method).hasQualifiedName(sendgridMail(), "SGMailV3", "AddContent")
    }

    override DataFlow::Node getData() { result = getContent(this, _) }
  }
}
