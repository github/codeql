import python

/**
 * An operation that sends an email.
 */
abstract class EmailSender extends DataFlow::CallCfgNode {
  /**
   * Gets a data flow node holding the plaintext version of the email body.
   */
  abstract ControlFlowNode getPlainTextBody();

  /**
   * Gets a data flow node holding the html version of the email body.
   */
  abstract ControlFlowNode getHtmlBody();

  /**
   * Gets a data flow node holding the recipients of the email.
   */
  abstract DataFlow::Node getTo();

  /**
   * Gets a data flow node holding the senders of the email.
   */
  abstract DataFlow::Node getFrom();

  /**
   * Gets a data flow node holding the subject of the email.
   */
  abstract DataFlow::Node getSubject();
}\

class FlaskMailEmailSender extends EmailSender {
  FlaskMailEmailSender() {
    this =
      API::moduleImport("flask_mail").getMember("Mail").getReturn().getMember("send").getACall()
  }
  override ControlFlowNode getPlainTextBody() {
    exists(API::Node message |
      message = API::moduleImport("flask_mail").getMember("Message").getReturn() and
      getArg(0) = message.getAUse() and
      result = message.getAUse().getALocalSource().asCfgNode().(CallNode).getArgByName("body")
    )
  }
  override ControlFlowNode getHtmlBody() {
    exists(API::Node message |
      message = API::moduleImport("flask_mail").getMember("Message").getReturn() and
      getArg(0) = message.getAUse() and
      result = message.getAUse().getALocalSource().asCfgNode().(CallNode).getArgByName("html")
    ) or
    exists(API::Node message, DataFlow::AttrWrite htmlAttr |
      message = API::moduleImport("flask_mail").getMember("Message").getReturn() and
      htmlAttr.getAttributeName() = "html" and
      getArg(0) = message.getAUse() and
      htmlAttr.getObject() = message.getAUse() and
      result = htmlAttr.getValue().asCfgNode()
    )
  }
  override ControlFlowNode getTo() {
    exists(API::Node message |
      message = API::moduleImport("flask_mail").getMember("Message").getReturn() and
      getArg(0) = message.getAUse() and
      result = message.getAUse().getALocalSource().asCfgNode().(CallNode).getArgByName("recipients")
    )
  }
  override ControlFlowNode getFrom() {
    exists(API::Node message |
      message = API::moduleImport("flask_mail").getMember("Message").getReturn() and
      getArg(0) = message.getAUse() and
      result = message.getAUse().getALocalSource().asCfgNode().(CallNode).getArgByName("sender")
    )
  }
  override ControlFlowNode getSubject() {
    exists(API::Node message |
      message = API::moduleImport("flask_mail").getMember("Message").getReturn() and
      getArg(0) = message.getAUse() and
      result = message.getAUse().getALocalSource().asCfgNode().(CallNode).getArgByName("subject")
    )
  }
}
