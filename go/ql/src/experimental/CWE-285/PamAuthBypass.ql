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

// PAM auth bypass (Start to AcctMgmt)
module PamStartToAcctMgmtConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(PamStartFunc p | p.getACall().getResult(0) = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(PamAcctMgmt p | p.getACall().getReceiver() = sink)
  }
}

module PamStartToAcctMgmtFlow = TaintTracking::Global<PamStartToAcctMgmtConfig>;

// PAM auth bypass (Start to Authenticate)
module PamStartToAuthenticateConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(PamStartFunc p | p.getACall().getResult(0) = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(PamAuthenticate p | p.getACall().getReceiver() = sink)
  }
}

module PamStartToAuthenticateFlow = TaintTracking::Global<PamStartToAuthenticateConfig>;

from DataFlow::Node source, DataFlow::Node sink
where
  not isInTestFile(source.asExpr()) and
  (PamStartToAuthenticateFlow::flow(source, sink) and not PamStartToAcctMgmtFlow::flow(source, _))
select source, "This Pam transaction may not be secure."
