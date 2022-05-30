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

from
  DataFlow::Node source, DataFlow::Node sink, PamAuthenticate auth, PamStartFunc start,
  PamAcctMgmt actmgt
where
  not isInTestFile(source.asExpr()) and
  (
    start.getACall().getResult(0) = source and
    sink = auth.getACall().getReceiver() and
    DataFlow::localFlow(source, sink) and
    not DataFlow::localFlow(source, actmgt.getACall().getReceiver())
  )
select source, "This Pam transaction may not check authorization correctly."
