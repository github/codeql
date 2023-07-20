/**
 * @name PAM authorization bypass due to incorrect usage
 * @description Not using `pam.AcctMgmt` after `pam.Authenticate` to check the validity of a login can lead to authorization bypass.
 * @kind problem
 * @problem.severity warning
 * @id go/pam-auth-bypass
 * @tags maintainability
 *       correctness
 *       experimental
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

class PamStartFunc extends Function {
  PamStartFunc() { this.hasQualifiedName("github.com/msteinert/pam", ["StartFunc", "Start"]) }
}

class PamStartToAcctMgmtConfig extends TaintTracking::Configuration {
  PamStartToAcctMgmtConfig() { this = "PAM auth bypass (Start to AcctMgmt)" }

  override predicate isSource(DataFlow::Node source) {
    exists(PamStartFunc p | p.getACall().getResult(0) = source)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(PamAcctMgmt p | p.getACall().getReceiver() = sink)
  }
}

class PamStartToAuthenticateConfig extends TaintTracking::Configuration {
  PamStartToAuthenticateConfig() { this = "PAM auth bypass (Start to Authenticate)" }

  override predicate isSource(DataFlow::Node source) {
    exists(PamStartFunc p | p.getACall().getResult(0) = source)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(PamAuthenticate p | p.getACall().getReceiver() = sink)
  }
}

from
  PamStartToAcctMgmtConfig acctMgmtConfig, PamStartToAuthenticateConfig authConfig,
  DataFlow::Node source, DataFlow::Node sink
where
  not isInTestFile(source.asExpr()) and
  (authConfig.hasFlow(source, sink) and not acctMgmtConfig.hasFlow(source, _))
select source, "This Pam transaction may not be secure."
