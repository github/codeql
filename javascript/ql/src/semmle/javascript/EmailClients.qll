import javascript

/**
 * An operation that sends an email.
 */
abstract class EmailSender extends DataFlow::SourceNode {
  /**
   * Gets a data flow node holding the plaintext version of the email body.
   */
  abstract DataFlow::Node getPlainTextBody();

  /**
   * Gets a data flow node holding the HTML body of the email.
   */
  abstract DataFlow::Node getHtmlBody();

  /**
   * Gets a data flow node holding the address of the email recipient(s).
   */
  abstract DataFlow::Node getTo();

  /**
   * Gets a data flow node holding the address of the email sender.
   */
  abstract DataFlow::Node getFrom();

  /**
   * Gets a data flow node holding the email subject.
   */
  abstract DataFlow::Node getSubject();

  /**
   * Gets a data flow node that refers to the HTML body or plaintext body of the email.
   */
  DataFlow::Node getABody() {
    result = getPlainTextBody() or
    result = getHtmlBody()
  }
}

/**
 * An email-sending call based on the `nodemailer` package.
 */
private class NodemailerEmailSender extends EmailSender, DataFlow::MethodCallNode {
  NodemailerEmailSender() {
    this =
      DataFlow::moduleMember("nodemailer", "createTransport").getACall().getAMethodCall("sendMail")
  }

  override DataFlow::Node getPlainTextBody() { result = getOptionArgument(0, "text") }

  override DataFlow::Node getHtmlBody() { result = getOptionArgument(0, "html") }

  override DataFlow::Node getTo() { result = getOptionArgument(0, "to") }

  override DataFlow::Node getFrom() { result = getOptionArgument(0, "from") }

  override DataFlow::Node getSubject() { result = getOptionArgument(0, "subject") }
}
