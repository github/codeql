/**
 * Provides classes modeling security-relevant aspects of the `sendgrid` PyPI package.
 * See https://github.com/sendgrid/sendgrid-python.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module Sendgrid {
  /** Gets a reference to the `sendgrid` module. */
  private API::Node sendgrid() { result = API::moduleImport("sendgrid") }

  /** Gets a reference to `sendgrid.helpers.mail` */
  private API::Node sendgridMailHelper() {
    result = sendgrid().getMember("helpers").getMember("mail")
  }

  /** Gets a reference to `sendgrid.helpers.mail.Mail` */
  private API::Node sendgridMailInstance() { result = sendgridMailHelper().getMember("Mail") }

  /** Gets a reference to a `SendGridAPIClient` instance. */
  private API::Node sendgridApiClient() {
    result = sendgrid().getMember("SendGridAPIClient").getReturn()
  }

  /** Gets a reference to a `SendGridAPIClient` instance call with `send` or `post`. */
  private API::CallNode sendgridApiSendCall() {
    result = sendgridApiClient().getMember("send").getACall()
    or
    result =
      sendgridApiClient()
          .getMember("client")
          .getMember("mail")
          .getMember("send")
          .getMember("post")
          .getACall()
  }

  /**
   * Gets a reference to `sg.send()` and `sg.client.mail.send.post()`.
   *
   * Given the following example:
   *
   * ```py
   *  from_email = Email("from@example.com")
   *  to_email = To("to@example.com")
   *  subject = "Sending with SendGrid is Fun"
   *  content = Content("text/html", request.args["html_content"])
   *
   *  mail = Mail(from_email, to_email, subject, content)
   *
   *  sg = SendGridAPIClient(api_key='SENDGRID_API_KEY')
   *  response = sg.client.mail.send.post(request_body=mail.get())
   *  ```
   *
   * * `this` would be `sg.client.mail.send.post(request_body=mail.get())`.
   * * `getPlainTextBody()`'s result would be `none()`.
   * * `getHtmlBody()`'s result would be `request.args["html_content"]`.
   * * `getTo()`'s result would be `"to@example.com"`.
   * * `getFrom()`'s result would be `"from@example.com"`.
   * * `getSubject()`'s result would be `"Sending with SendGrid is Fun"`.
   */
  private class SendGridMail extends API::CallNode, EmailSender::Range {
    SendGridMail() { this = sendgridApiSendCall() }

    private DataFlow::CallCfgNode getMailCall() {
      exists(DataFlow::Node n |
        n in [this.getArg(0), this.getArgByName("request_body")] and
        result = [n, n.(DataFlow::MethodCallNode).getObject()].getALocalSource()
      )
    }

    private DataFlow::Node sendgridContent(DataFlow::CallCfgNode contentCall, string mime) {
      mime in ["text/plain", "text/html", "text/x-amp-html"] and
      exists(StringLiteral mimeNode |
        mimeNode.getText() = mime and
        DataFlow::exprNode(mimeNode).(DataFlow::LocalSourceNode).flowsTo(contentCall.getArg(0)) and
        result = contentCall.getArg(1)
      )
    }

    private DataFlow::Node sendgridWrite(string attributeName) {
      attributeName in ["plain_text_content", "html_content", "from_email", "subject"] and
      exists(DataFlow::AttrWrite attrWrite |
        attrWrite.getObject().getALocalSource() = this.getMailCall() and
        attrWrite.getAttributeName() = attributeName and
        result = attrWrite.getValue()
      )
    }

    override DataFlow::Node getPlainTextBody() {
      result in [
          this.getMailCall().getArg(3), this.getMailCall().getArgByName("plain_text_content")
        ]
      or
      result in [
          this.sendgridContent([
              this.getMailCall().getArg(3), this.getMailCall().getArgByName("plain_text_content")
            ].getALocalSource(), "text/plain"),
          this.sendgridContent(sendgridMailInstance().getMember("add_content").getACall(),
            "text/plain")
        ]
      or
      result = this.sendgridWrite("plain_text_content")
    }

    override DataFlow::Node getHtmlBody() {
      result in [this.getMailCall().getArg(4), this.getMailCall().getArgByName("html_content")]
      or
      result = this.getMailCall().getAMethodCall("set_html").getArg(0)
      or
      result =
        this.sendgridContent([
            this.getMailCall().getArg(4), this.getMailCall().getArgByName("html_content")
          ].getALocalSource(), ["text/html", "text/x-amp-html"])
      or
      result = this.sendgridWrite("html_content")
      or
      exists(API::Node contentElement |
        contentElement =
          this.getKeywordParameter("request_body").getSubscript("content").getASubscript()
      |
        contentElement
            .getSubscript("type")
            .getAValueReachingSink()
            .asExpr()
            .(StringLiteral)
            .getText() = ["text/html", "text/x-amp-html"] and
        result = contentElement.getSubscript("value").getAValueReachingSink()
      )
      or
      exists(API::Node html |
        html =
          this.getKeywordParameter("request_body")
              .getSubscript("tracking_settings")
              .getSubscript("subscription_tracking")
        or
        html =
          this.getKeywordParameter("request_body")
              .getSubscript("mail_settings")
              .getSubscript("footer")
      |
        html.getSubscript("enable").getAValueReachingSink().asExpr() instanceof True and
        result = html.getSubscript("html").getAValueReachingSink()
      )
    }

    override DataFlow::Node getTo() {
      result in [this.getMailCall().getArg(1), this.getMailCall().getArgByName("to_emails")]
      or
      result = this.getMailCall().getAMethodCall("To").getArg(0)
      or
      result =
        this.getMailCall()
            .getAMethodCall(["to", "add_to", "cc", "add_cc", "bcc", "add_bcc"])
            .getArg(0)
    }

    override DataFlow::Node getFrom() {
      result in [this.getMailCall().getArg(0), this.getMailCall().getArgByName("from_email")]
      or
      result = this.getMailCall().getAMethodCall("Email").getArg(0)
      or
      result = this.getMailCall().getAMethodCall(["from_email", "set_from"]).getArg(0)
      or
      result = this.sendgridWrite("from_email")
    }

    override DataFlow::Node getSubject() {
      result in [this.getMailCall().getArg(2), this.getMailCall().getArgByName("subject")]
      or
      result = this.getMailCall().getAMethodCall(["subject", "set_subject"]).getArg(0)
      or
      result = this.sendgridWrite("subject")
    }
  }
}
