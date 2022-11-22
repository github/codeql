/**
 * Models the `ActionMailbox` library, which is part of Rails.
 * Version: 7.0.4.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources

/**
 * Models the `ActionMailbox` library, which is part of Rails.
 * Version: 7.0.4.
 */
module ActionMailbox {
  private DataFlow::ClassNode controller() {
    result = DataFlow::getConstant("ActionMailbox").getConstant("Base").getADescendentModule()
  }

  /**
   * A method in a mailbox which receives incoming mail.
   */
  class Process extends DataFlow::MethodNode {
    Process() { this = controller().getAnInstanceMethod() and this.getMethodName() = "process" }
  }

  /**
   * A call to `ActionMailbox::Base#mail`, which is equivalent to calling `inbound_mail.mail`.
   * The returned object contains data from the incoming mail.
   */
  class MailCall extends DataFlow::CallNode, Mail::Message::Range {
    MailCall() { this = controller().getAnInstanceSelf().getAMethodCall("mail") }
  }

  /**
   * Models classes from the `mail` library.
   * Version: 2.7.1.
   */
  module Mail {
    /**
     * An instance of `Mail::Message`.
     */
    class Message extends DataFlow::Node instanceof Message::Range { }

    module Message {
      abstract class Range extends DataFlow::Node { }
    }

    /**
     * A method call on a `Mail::Message` object which may return data from a remote source.
     */
    class RemoteContent extends DataFlow::CallNode, RemoteFlowSource::Range {
      RemoteContent() {
        this.getReceiver() instanceof Message and
        this.getMethodName() =
          [
            "body", "to", "from", "raw_source", "subject", "from_address", "recipients_addresses",
            "cc_addresses", "bcc_addresses", "in_reply_to", "references", "reply_to",
            "raw_envelope", "to_s", "encoded", "header", "bcc", "cc", "text_part", "html_part"
          ]
      }

      override string getSourceType() { result = "ActionMailbox" }
    }
  }
}
