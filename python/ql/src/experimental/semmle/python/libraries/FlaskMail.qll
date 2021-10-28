/**
 * Provides classes modeling security-relevant aspects of the `flask` PyPI package.
 * See https://flask.palletsprojects.com/en/1.1.x/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

/** https://pythonhosted.org/Flask-Mail/#module-flask_mail */
private module FlaskMail {
  /** Gets a reference to `flask_mail`, `flask_sendmail` and `flask.ext.sendmail`. */
  private API::Node flaskMail() {
    result = API::moduleImport(["flask_mail", "flask_sendmail", "flask.ext.sendmail"])
  }

  /** Gets a reference to `flask_mail.Mail()`, `flask_sendmail.Mail()` and `flask.ext.sendmail.Mail()`. */
  private API::Node flaskMailInstance() { result = flaskMail().getMember("Mail").getReturn() }

  /** Gets a reference to `flask_mail.Message`, `flask_sendmail.Message` and `flask.ext.sendmail.Message`. */
  private API::Node flaskMessageInstance() { result = flaskMail().getMember("Message") }

  /** Gets a call to `flask_mail.Message`, `flask_sendmail.Message` and `flask.ext.sendmail.Message`. */
  private DataFlow::CallCfgNode flaskMessageCall() { result = flaskMessageInstance().getACall() }

  /**
   * Gets a reference to an argument from `flask_mail.Message`, `flask_sendmail.Message` and `flask.ext.sendmail.Message`.
   */
  bindingset[argumentPosition, argumentName]
  private DataFlow::Node getFlaskMailArgument(int argumentPosition, string argumentName) {
    result in [
        flaskMessageCall().getArg(argumentPosition), flaskMessageCall().getArgByName(argumentName)
      ]
    or
    exists(DataFlow::AttrWrite write |
      write.getObject().getALocalSource() = flaskMessageCall() and
      write.getAttributeName() = argumentName and
      result = write.getValue()
    )
  }

  /**
   * Gets a call to `mail.send()`.
   *
   * Given the following example:
   *
   * ```py
   * msg = Message(subject="Subject",
   *                sender="from@example.com",
   *                recipients=["to@example.com"],
   *                body="plain-text body",
   *                html=request.args["html"])
   * mail.send(msg)
   *  ```
   *
   * * `this` would be `mail.send(msg)`.
   * * `getPlainTextBody()`'s result would be `"plain-text body"`.
   * * `getHtmlBody()`'s result would be `request.args["html"]`.
   * * `getTo()`'s result would be `["to@example.com"]`.
   * * `getFrom()`'s result would be `"from@example.com"`.
   * * `getSubject()`'s result would be `"Subject"`.
   */
  private class FlaskMail extends DataFlow::CallCfgNode, EmailSender {
    FlaskMail() {
      this =
        [flaskMailInstance(), flaskMailInstance().getMember("connect").getReturn()]
            .getMember(["send", "send_message"])
            .getACall()
    }

    override DataFlow::Node getPlainTextBody() { result = getFlaskMailArgument(2, "body") }

    override DataFlow::Node getHtmlBody() { result = getFlaskMailArgument(3, "html") }

    override DataFlow::Node getTo() {
      result = getFlaskMailArgument(1, "recipients")
      or
      result = flaskMessageInstance().getMember("add_recipient").getACall().getArg(0)
    }

    override DataFlow::Node getFrom() { result = getFlaskMailArgument(5, "sender") }

    override DataFlow::Node getSubject() { result = getFlaskMailArgument(0, "subject") }
  }
}
