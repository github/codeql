/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module Django {
  private API::Node django() { result = API::moduleImport("django") }

  /** https://docs.djangoproject.com/en/3.2/topics/email/ */
  private API::Node djangoMail() { result = django().getMember("core").getMember("mail") }

  private class DjangoSendMail extends DataFlow::CallCfgNode, EmailSender {
    DjangoSendMail() { this = djangoMail().getMember("send_mail").getACall() }

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

  /** https://github.com/django/django/blob/ca9872905559026af82000e46cde6f7dedc897b6/django/core/mail/__init__.py#L90-L121 */
  private class DjangoMailInternal extends DataFlow::CallCfgNode, EmailSender {
    DjangoMailInternal() {
      this = djangoMail().getMember(["mail_admins", "mail_managers"]).getACall()
    }

    override DataFlow::Node getPlainTextBody() {
      result in [this.getArg(1), this.getArgByName("message")]
    }

    override DataFlow::Node getHtmlBody() {
      result in [this.getArg(4), this.getArgByName("html_message")]
    }

    override DataFlow::Node getTo() { none() }

    override DataFlow::Node getFrom() { none() }

    override DataFlow::Node getSubject() {
      result in [this.getArg(0), this.getArgByName("subject")]
    }
  }
}
