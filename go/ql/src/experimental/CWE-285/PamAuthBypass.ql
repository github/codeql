/**
 * @name PAM authorization bypass due to incorrect usage
 * @description Not using `pam.AcctMgmt` after `pam.Authenticate` to check the validity of a login can lead to authorization bypass.
 * @kind problem
 * @problem.severity warning
 * @id go/unreachable-statement
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 *       external/cwe/cwe-285
 * @precision very-high
 */

import go

predicate isInTestFile(Expr r) {
  r.getFile().getAbsolutePath().matches("%test%") and
  not r.getFile().getAbsolutePath().matches("%/ql/test/%")
}

class PamAuthenticate extends Method {
  PamAuthenticate() {
    this.hasQualifiedName("github.com/msteinert/pam", "Transaction", "Authenticate")
  }
}

class PamAcctMgmt extends Method {
  PamAcctMgmt() { this.hasQualifiedName("github.com/msteinert/pam", "Transaction", "AcctMgmt") }
}

class PamTransaction extends StructType {
  PamTransaction() { this.hasQualifiedName("github.com/msteinert/pam", "Transaction") }
}

class PamStartFunc extends Function {
  PamStartFunc() { this.hasQualifiedName("github.com/msteinert/pam", ["StartFunc", "Start"]) }
}

class PamAuthBypassConfiguration extends TaintTracking::Configuration {
  PamAuthBypassConfiguration() { this = "PAM auth bypass" }

  override predicate isSource(DataFlow::Node source) {
    exists(PamStartFunc p | p.getACall().getResult(0) = source)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(PamAcctMgmt p | p.getACall().getReceiver() = sink)
  }
}

class PamAuthBypassConfig extends TaintTracking::Configuration {
  PamAuthBypassConfig() { this = "PAM auth bypass2" }

  override predicate isSource(DataFlow::Node source) {
    exists(PamStartFunc p | p.getACall().getResult(0) = source)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(PamAuthenticate p | p.getACall().getReceiver() = sink)
  }
}

from
  PamAuthBypassConfiguration config, PamAuthBypassConfig config2, DataFlow::Node source,
  DataFlow::Node sink
where
  not isInTestFile(source.asExpr()) and
  (config2.hasFlow(source, sink) and not config.hasFlow(source, _))
select source, "This Pam transaction may not be secure."
