private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

module SmtpLib {
  private API::Node smtpLib() { result = API::moduleImport("smtplib") }

  private API::Node smtpConnectionInstance() { result = smtpLib().getMember("SMTP_SSL") }

  API::Node smtpMimeMultipartInstance() {
    result = API::moduleImport("email.mime.multipart").getMember("MIMEMultipart")
  }

  API::Node smtpMimeTextInstance() {
    result = API::moduleImport("email.mime.text").getMember("MIMEText")
  }

  DataFlow::Node smtpMimeTextHTMLInstance() {
    // select SmtpLib::smtpMimeTextInstance().getAUse().getALocalSource().getACall()
    exists(API::Node mimeTextInstance, DataFlow::CallCfgNode callNode |
      mimeTextInstance = smtpMimeTextInstance().getReturn() and
      callNode = mimeTextInstance.getACall() and
      callNode.getArg(1).asExpr().(Unicode).getText() = "html" and
      result = callNode
    )
  }

  class SmtpLibSendMail extends DataFlow::CallCfgNode, EmailSender {
    SmtpLibSendMail() { this = smtpConnectionInstance().getMember("sendmail").getACall() }

    override DataFlow::Node getPlainTextBody() {
      result in [this.getArg(1), this.getArgByName("message")]
    }

    override DataFlow::Node getHtmlBody() {
      result in [this.getArg(8), this.getArgByName("html_message")]
    }

    override DataFlow::Node getTo() {
      result in [this.getArg(3), this.getArgByName("recipient_list")]
    }

    override DataFlow::Node getFrom() {
      result in [this.getArg(2), this.getArgByName("from_email")]
    }

    override DataFlow::Node getSubject() {
      result in [this.getArg(0), this.getArgByName("subject")]
    }
  }
}

// MIMEMultipart has two ways it can add tainted data:
//    MIMEMultipart(_subparts=(part1, part2))
//    or
//    message = MIMEMultipart("alternative")
//    message.attach(part1)
//
//
// select SmtpLib::smtpMimeTextHTMLInstance()
// select API::moduleImport("email.mime.multipart")
//       .getMember("MIMEMultipart")
//       .getACall()
//       .getArgByName("_subparts")
//
// from DataFlow::Node arg1
// where
//   arg1 =
//     API::moduleImport("email.mime.multipart")
//         .getMember("MIMEMultipart")
//         .getReturn()
//         .getMember("attach")
//         .getACall()
//         .getArg(0)
//
// select SmtpLib::smtpMimeTextHTMLInstance() //.getReturn()
//
//.getArg(1) //.getAUse()
//
// Work on the smtpMimeTextHTMLInstance function
from DataFlow::CallCfgNode result1
where
  exists(API::Node mimeTextInstance, DataFlow::CallCfgNode callNode |
    mimeTextInstance = SmtpLib::smtpMimeTextInstance().getReturn() and
    callNode = mimeTextInstance.getACall() and
    callNode.getArg(1).asExpr().(Unicode).getText() = "html" and
    result1 = callNode
  )
select result1
