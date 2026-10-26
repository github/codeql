/**
 * @name Suspicious 'sizeof' use
 * @description Taking 'sizeof' of an array parameter is often mistakenly thought
 *              to yield the size of the underlying array, but it always yields
 *              the machine pointer size.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision medium
 * @id cpp/suspicious-sizeof
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-467
 */

import cpp

class CandidateParameter extends Parameter {
  CandidateParameter() {
    // an array parameter
    this.getUnspecifiedType() instanceof ArrayType
    or
    // a pointer parameter
    this.getUnspecifiedType() instanceof PointerType and
    // whose address is never taken (rules out common
    // false positive patterns)
    not exists(AddressOfExpr aoe | aoe.getAddressable() = this)
  }
}

from SizeofExprOperator seo, VariableAccess va
where
  seo.getExprOperand() = va and
  va.getTarget() instanceof CandidateParameter and
  not va.isAffectedByMacro() and
  not va.isCompilerGenerated()
select seo, "This evaluates to the size of the pointer type, which may not be what you want."
