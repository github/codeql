/** Provides data flow sinks for sending email. */

import csharp
private import Remote
private import semmle.code.csharp.frameworks.system.net.Mail

/** Provides sinks for emails. */
module Email {
  /** A data flow sink for sending email. */
  abstract class Sink extends DataFlow::ExprNode, RemoteFlowSink { }

  /** A data flow sink for sending email via `System.Net.Mail.MailMessage`. */
  class MailMessageSink extends Sink {
    MailMessageSink() {
      exists(SystemNetMailMailMessageClass message |
        // Constructor to the MailMessage
        exists(ObjectCreation creation | creation.getTarget() = message.getAConstructor() |
          this.getExpr() = creation.getArgumentForName("subject") or
          this.getExpr() = creation.getArgumentForName("body")
        )
        or
        // Assigns to a sensitive property of a MailMessage
        exists(Property p |
          p = message.getBodyProperty() or
          p = message.getSubjectProperty()
        |
          this.getExpr() = p.getAnAssignedValue()
        )
      )
    }
  }
}
