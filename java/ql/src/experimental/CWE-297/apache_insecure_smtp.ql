/*
 * @description  Server identity verification by default is disabled
 *    when making SSL connections. This is equivalent to trusting all certificates.
 *    When trying to connect to the server, this application would readily
 *    accept a certificate issued to any domain potentially leaking sensitive
 *    user information on a broken SSL connection to the server.
 * @id java/apache-insecure-smtp-ssl
 * @kind path-problem
 * @name Apache Commons Email Insecure SMTP SSL Connection
 * @tags security
 * CWE-297: Improper Validation of Certificate with Host Mismatch
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DefUse
import semmle.code.java.dataflow.TaintTracking
import Email

// Declare a new class for variables which are instances of the Email Class or its subclasses.
class EmailVar extends Variable {
  EmailVar() { this.getType() instanceof Email }
}

class SendMethods extends EmailMethod {
  SendMethods() {
    this instanceof MethodEmailSend
    or
    this instanceof MethodEmailSendMimeMessage
    or
    this instanceof MethodEmailSetStartTLSEnabled
  }
}

class SSLOnMethods extends EmailMethod {
  SSLOnMethods() {
    this instanceof MethodEmailIsSSL
    or
    this instanceof MethodEmailIsTLS
    or
    this instanceof MethodEmailSetSSLOnConnect
    or
    this instanceof MethodEmailSetSSLOnConnect
    or
    this instanceof MethodEmailSetStartTLSRequired
    or
    this instanceof MethodEmailSetStartTLSEnabled
  }
}

class EmailConfiguration extends DataFlow::Configuration {
  EmailConfiguration() { this = "EmailConfiguration" }

  // Since by default, certificate checks are disabled,
  // object inititalisation is the source of the weakness
  override predicate isSource(DataFlow::Node source) {
    // exists(EmailVar e | source.asExpr()  = e.getInitializer())
    exists(SSLOnMethods s |
      s.getAReference().getQualifier() = source.asExpr() and
      s.getAReference().getArgument(0).toString() = "true"
    )
  }

  // The flow should stop when the email is sent.
  override predicate isSink(DataFlow::Node sink) {
    exists(MethodEmailSend s | s.getAReference().getQualifier() = sink.asExpr())
  }

  // Call to Email.setSSLCheckServerIdentity will correct the defect
  // and is hence a barrier
  override predicate isBarrier(DataFlow::Node sink) {
    exists(MethodEmailSetSSLCheckServerIdentity s |
      s.getAReference().getQualifier() = sink.asExpr()
    )
  }
}

from EmailConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink
where dataflow.hasFlow(source, sink)
select source.getLocation(), source, sink,
  "SMTP connections with SSL on should should check the server identity to prevent attacks"
