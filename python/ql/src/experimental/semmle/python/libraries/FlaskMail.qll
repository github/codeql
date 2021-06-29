/**
 * Provides classes modeling security-relevant aspects of the `flask` PyPI package.
 * See https://flask.palletsprojects.com/en/1.1.x/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module FlaskMail {
  /** https://pythonhosted.org/Flask-Mail/#module-flask_mail */
  private API::Node flaskMail() {
    result = API::moduleImport(["flask_mail", "flask_sendmail", "flask.ext.sendmail"])
  }

  private API::Node flaskMailInstance() { result = flaskMail().getMember("Mail").getReturn() }

  private API::Node flaskMessageInstance() { result = flaskMail().getMember("Message") }

  private DataFlow::CallCfgNode flaskMessageCall() { result = flaskMessageInstance().getACall() }

  private DataFlow::Node getFlaskMailArgument(int argumentPosition, string argumentName) {
    // 'argumentPosition' is not bound to a value.
    argumentName in ["body", "html", "recipients", "sender", "subject"] and
    argumentPosition in [0 .. 5] and
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
