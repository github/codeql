/**
 * @name A variable use without a unique SSA variable
 * @description Every variable use that is sufficiently trackable
 *              should have a unique associated SSA variable.
 * @kind problem
 * @problem.severity error
 * @id java/consistency/use-without-unique-ssa-variable
 * @tags consistency
 */

import java
import semmle.code.java.dataflow.SSA

class SsaConvertibleReadAccess extends VarRead {
  SsaConvertibleReadAccess() {
    this.getEnclosingCallable().getBody().getBasicBlock().getABBSuccessor*() = this.getBasicBlock() and
    (
      not exists(this.getQualifier())
      or
      this.getVariable() instanceof LocalScopeVariable
      or
      this.getVariable().(Field).isStatic()
      or
      exists(Expr q | q = this.getQualifier() |
        q instanceof ThisAccess or
        q instanceof SuperAccess or
        q instanceof SsaConvertibleReadAccess
      )
    )
  }
}

predicate accessWithoutSourceVariable(SsaConvertibleReadAccess va) {
  not exists(SsaSourceVariable v | v.getAnAccess() = va)
}

predicate readAccessWithoutSsaVariable(SsaConvertibleReadAccess va) {
  not exists(SsaVariable v | v.getAUse() = va)
}

predicate readAccessWithAmbiguousSsaVariable(SsaConvertibleReadAccess va) {
  1 < strictcount(SsaVariable v | v.getAUse() = va)
}

from SsaConvertibleReadAccess va, string problem
where
  accessWithoutSourceVariable(va) and problem = "No source variable"
  or
  readAccessWithoutSsaVariable(va) and problem = "No SSA variable"
  or
  readAccessWithAmbiguousSsaVariable(va) and problem = "Multiple SSA variables"
select va, problem
