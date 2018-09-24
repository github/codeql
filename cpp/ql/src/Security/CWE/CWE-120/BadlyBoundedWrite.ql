/**
 * @name Badly bounded write
 * @description Buffer write operations with a length parameter that
 *              does not match the size of the destination buffer may
 *              overflow.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/badly-bounded-write
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 *       external/cwe/cwe-787
 *       external/cwe/cwe-805
 */
import semmle.code.cpp.security.BufferWrite

// see CWE-120UnboundedWrite.ql for a summary of CWE-120 violation cases

from BufferWrite bw, int destSize
where bw.hasExplicitLimit()                     // has an explicit size limit
  and destSize = getBufferSize(bw.getDest(), _)
  and (bw.getExplicitLimit() > destSize)        // but it's larger than the destination
  and not destSize = 0                          // probably just a hack if the destination size is 0
select bw, "This '" + bw.getBWDesc() + "' operation is limited to " + bw.getExplicitLimit() + " bytes but the destination is only " + destSize + " bytes."
