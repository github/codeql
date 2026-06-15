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
   * A call to `mail` on the return value of
   * `ActionMailbox::Base#inbound_email`, or a direct call to
   * `ActionMailbox::Base#mail`, which is equivalent. The returned object
   * contains data from the incoming email.
   */
  class Mail extends DataFlow::CallNode {
    Mail() {
      this =
        [
          controller().trackInstance().getReturn("inbound_email").getAMethodCall("mail"),
          controller().trackInstance().getAMethodCall("mail")
        ]
    }
  }

  /**
   * A method call on a `Mail::Message` object which may return data from a remote source.
   */
  private class RemoteContent extends DataFlow::CallNode, RemoteFlowSource::Range {
    RemoteContent() {
      this =
        any(Mail m)
            .track()
            .getAMethodCall([
                "body", "to", "from", "raw_source", "subject", "from_address",
                "recipients_addresses", "cc_addresses", "bcc_addresses", "in_reply_to",
                "references", "reply_to", "raw_envelope", "to_s", "encoded", "header", "bcc", "cc",
                "text_part", "html_part"
              ])
    }

    override string getSourceType() { result = "ActionMailbox" }
  }
}
