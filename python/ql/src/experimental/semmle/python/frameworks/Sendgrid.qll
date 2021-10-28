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

  /** Gets a call to `sendgrid.helpers.mail.Mail()`. */
  private DataFlow::CallCfgNode sendgridMailCall() { result = sendgridMailInstance().getACall() }

  /** Gets a reference to a `SendGridAPIClient` instance. */
  private DataFlow::LocalSourceNode sendgridApiClient(DataFlow::TypeTracker t) {
    t.start() and
    result.(DataFlow::AttrRead).getObject*().getALocalSource() =
      sendgrid().getMember("SendGridAPIClient").getReturn().getAUse()
    or
    exists(DataFlow::TypeTracker t2 | result = sendgridApiClient(t2).track(t2, t))
  }

  /** Gets a reference to a `SendGridAPIClient` instance use. */
  private DataFlow::Node sendgridApiClient() {
    sendgridApiClient(DataFlow::TypeTracker::end()).flowsTo(result)
  }

  /** Gets a reference to a `SendGridAPIClient` instance call with `send` or `post`. */
  private DataFlow::Node sendgridApiSendCall() {
    result = sendgridApiClient() and
    result.(DataFlow::AttrRead).getAttributeName() in ["send", "post"]
  }

  /**
   * https://github.com/sendgrid/sendgrid-python
   * https://github.com/sendgrid/sendgrid-python/blob/cf0924c35c37bbec8e5ca39e963a55f54f0eec11/sendgrid/helpers/mail/mail.py#L20
   */
  private class SendGridMail extends DataFlow::CallCfgNode, EmailSender {
    SendGridMail() { this.getFunction() = sendgridApiSendCall() }

    override DataFlow::Node getPlainTextBody() {
      result in [
          sendgridMailCall().getArg(3), sendgridMailCall().getArgByName("plain_text_content")
        ]
      or
      exists(DataFlow::CallCfgNode contentCall, StrConst mime |
        contentCall = sendgridMailHelper().getMember("Content").getACall() and
        mime.getText() = "text/plain" and
        DataFlow::exprNode(mime).(DataFlow::LocalSourceNode).flowsTo(contentCall.getArg(0)) and
        result = contentCall.getArg(1)
      )
      or
      exists(DataFlow::CallCfgNode addContentCall, StrConst mime |
        addContentCall = sendgridMailInstance().getMember("add_content").getACall() and
        mime.getText() = "text/plain" and
        DataFlow::exprNode(mime).(DataFlow::LocalSourceNode).flowsTo(addContentCall.getArg(1)) and
        result = addContentCall.getArg(0)
      )
      or
      exists(DataFlow::AttrWrite bodyWrite |
        bodyWrite.getObject().getALocalSource() = sendgridMailCall() and
        bodyWrite.getAttributeName() = "plain_text_content" and
        result = bodyWrite.getValue()
      )
    }

    override DataFlow::Node getHtmlBody() {
      result in [sendgridMailCall().getArg(4), sendgridMailCall().getArgByName("html_content")]
      or
      result = sendgridMailInstance().getMember("set_html").getACall().getArg(0)
      or
      exists(DataFlow::CallCfgNode contentCall, StrConst mime |
        contentCall = sendgridMailHelper().getMember("Content").getACall() and
        mime.getText() = "text/html" and
        DataFlow::exprNode(mime).(DataFlow::LocalSourceNode).flowsTo(contentCall.getArg(0)) and
        result = contentCall.getArg(1)
      )
      or
      exists(DataFlow::CallCfgNode addContentCall, StrConst mime |
        addContentCall = sendgridMailInstance().getMember("add_content").getACall() and
        mime.getText() = "text/html" and
        DataFlow::exprNode(mime).(DataFlow::LocalSourceNode).flowsTo(addContentCall.getArg(1)) and
        result = addContentCall.getArg(0)
      )
      or
      exists(DataFlow::AttrWrite htmlWrite |
        htmlWrite.getObject().getALocalSource() = sendgridMailCall() and
        htmlWrite.getAttributeName() = "html_content" and
        result = htmlWrite.getValue()
      )
    }

    override DataFlow::Node getTo() {
      result in [sendgridMailCall().getArg(1), sendgridMailCall().getArgByName("to_emails")]
      or
      result = sendgridMailHelper().getMember("To").getACall().getArg(0)
      or
      result =
        sendgridMailInstance()
            .getMember(["to", "add_to", "cc", "add_cc", "bcc", "add_bcc"])
            .getACall()
            .getArg(0)
    }

    override DataFlow::Node getFrom() {
      result in [sendgridMailCall().getArg(0), sendgridMailCall().getArgByName("from_email")]
      or
      result = sendgridMailHelper().getMember("Email").getACall().getArg(0)
      or
      result = sendgridMailInstance().getMember(["from_email", "set_from"]).getACall().getArg(0)
      or
      exists(DataFlow::AttrWrite fromWrite |
        fromWrite.getObject().getALocalSource() = sendgridMailCall() and
        fromWrite.getAttributeName() = "from_email" and
        result = fromWrite.getValue()
      )
    }

    override DataFlow::Node getSubject() {
      result in [sendgridMailCall().getArg(2), sendgridMailCall().getArgByName("subject")]
      or
      result = sendgridMailInstance().getMember(["subject", "set_subject"]).getACall().getArg(0)
      or
      exists(DataFlow::AttrWrite subjectWrite |
        subjectWrite.getObject().getALocalSource() = sendgridMailCall() and
        subjectWrite.getAttributeName() = "subject" and
        result = subjectWrite.getValue()
      )
    }
  }
}
