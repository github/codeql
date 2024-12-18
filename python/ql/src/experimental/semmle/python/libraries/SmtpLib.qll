private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.TaintTracking

module SmtpLib {
  /** Gets a reference to `smtplib.SMTP_SSL` */
  private API::Node smtpConnectionInstance() {
    result = API::moduleImport("smtplib").getMember("SMTP_SSL")
  }

  /** Gets a reference to `email.mime.multipart.MIMEMultipart` */
  private API::Node smtpMimeMultipartInstance() {
    result =
      API::moduleImport("email").getMember("mime").getMember("multipart").getMember("MIMEMultipart")
  }

  /** Gets a reference to `email.mime.text.MIMEText` */
  private API::Node smtpMimeTextInstance() {
    result = API::moduleImport("email").getMember("mime").getMember("text").getMember("MIMEText")
  }

  private DataFlow::CallCfgNode mimeText(string mimetype) {
    result = smtpMimeTextInstance().getACall() and
    [result.getArg(1), result.getArgByName("_subtype")].asExpr().(StringLiteral).getText() =
      mimetype
  }

  /**
   * Gets flow from `MIMEText()` to `MIMEMultipart(_subparts=(part1, part2))`'s `_subparts`
   * argument. Used because of the impossibility to get local source nodes from `_subparts`'
   * `(List|Tuple)` elements.
   */
  private module SmtpMessageConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source = mimeText(_) }

    predicate isSink(DataFlow::Node sink) {
      sink = smtpMimeMultipartInstance().getACall().getArgByName("_subparts")
    }
  }

  module SmtpMessageFlow = TaintTracking::Global<SmtpMessageConfig>;

  /**
   * Using the `MimeText` call retrieves the content argument whose type argument equals `mimetype`.
   * This call flows into `MIMEMultipart`'s `_subparts` argument or the `.attach()` method call
   * and both local source nodes correlate to `smtp`'s `sendmail` call 3rd argument's local source.
   *
   * Given the following example with `getSmtpMessage(any(SmtpLibSendMail s), "html")`:
   *
   * ```py
   * part1 = MIMEText(text, "plain")
   * part2 = MIMEText(html, "html")
   * message = MIMEMultipart(_subparts=(part1, part2))
   * server.sendmail(sender_email, receiver_email, message.as_string())
   * ```
   *
   * * `source` would be `MIMEText(text, "html")`.
   * * `sink` would be `MIMEMultipart(_subparts=(part1, part2))`.
   * * Then `message` local source node is correlated to `sink`.
   * * Then the flow from `source` to `_subparts` is checked.
   *
   * Given the following example with `getSmtpMessage(any(SmtpLibSendMail s), "html")`:
   *
   * ```py
   * part1 = MIMEText(text, "plain")
   * part2 = MIMEText(html, "html")
   * message = MIMEMultipart("alternative")
   * message.attach(part1)
   * message.attach(part2)
   * server.sendmail(sender_email, receiver_email, message.as_string())
   * ```
   *
   * * `source` would be `MIMEText(text, "html")`.
   * * `sink` would be `message.attach(part2)`.
   * * Then `sink`'s object (`message`) local source is correlated to `server.sendmail`
   * 3rd argument local source (`MIMEMultipart("alternative")`).
   * * Then the flow from `source` to `sink` 1st argument is checked.
   */
  bindingset[mimetype]
  private DataFlow::Node getSmtpMessage(DataFlow::CallCfgNode sendCall, string mimetype) {
    exists(DataFlow::Node source, DataFlow::Node sink |
      source = mimeText(mimetype) and
      (
        // via _subparts
        sink = smtpMimeMultipartInstance().getACall() and
        sink =
          [sendCall.getArg(2), sendCall.getArg(2).(DataFlow::MethodCallNode).getObject()]
              .getALocalSource() and
        SmtpMessageFlow::flow(source, sink.(DataFlow::CallCfgNode).getArgByName("_subparts"))
        or
        // via .attach()
        sink = smtpMimeMultipartInstance().getReturn().getMember("attach").getACall() and
        sink.(DataFlow::MethodCallNode).getObject().getALocalSource() =
          [sendCall.getArg(2), sendCall.getArg(2).(DataFlow::MethodCallNode).getObject()]
              .getALocalSource() and
        source.(DataFlow::CallCfgNode).flowsTo(sink.(DataFlow::CallCfgNode).getArg(0))
      ) and
      result = source.(DataFlow::CallCfgNode).getArg(0)
    )
  }

  /**
   * Gets a reference to `smtplib.SMTP_SSL().sendmail()`.
   *
   * Given the following example:
   *
   * ```py
   * part1 = MIMEText(text, "plain")
   * part2 = MIMEText(html, "html")
   *
   * message = MIMEMultipart(_subparts=(part1, part2))
   * message["Subject"] = "multipart test"
   * message["From"] = sender_email
   * message["To"] = receiver_email
   *
   * server.login(sender_email, "SERVER_PASSWORD")
   * server.sendmail(sender_email, receiver_email, message.as_string())
   * ```
   *
   * * `this` would be `server.sendmail(sender_email, receiver_email, message.as_string())`.
   * * `getPlainTextBody()`'s result would be `text`.
   * * `getHtmlBody()`'s result would be `html`.
   * * `getTo()`'s result would be `receiver_email`.
   * * `getFrom()`'s result would be `sender_email`.
   * * `getSubject()`'s result would be `"multipart test"`.
   */
  private class SmtpLibSendMail extends API::CallNode, EmailSender::Range {
    SmtpLibSendMail() {
      this = smtpConnectionInstance().getReturn().getMember("sendmail").getACall()
    }

    override DataFlow::Node getPlainTextBody() { result = getSmtpMessage(this, "plain") }

    override DataFlow::Node getHtmlBody() { result = getSmtpMessage(this, "html") }

    override DataFlow::Node getTo() {
      result = this.getParameter(1, "to_addrs").asSink()
      or
      result = this.getMsg().getSubscript("To").asSink()
    }

    override DataFlow::Node getFrom() {
      result = this.getParameter(0, "from_addr").asSink()
      or
      result = this.getMsg().getSubscript("From").asSink()
    }

    override DataFlow::Node getSubject() { result = this.getMsg().getSubscript("Subject").asSink() }

    private API::Node getMsg() {
      result.getAValueReachableFromSource() = this.getParameter(2, "msg").asSink()
      or
      result.getMember("as_string").getReturn().getAValueReachableFromSource() =
        this.getParameter(2, "msg").asSink()
    }
  }
}
