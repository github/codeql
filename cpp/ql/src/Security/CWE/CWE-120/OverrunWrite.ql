/**
 * @name Potentially overrunning write
 * @description Buffer write operations that do not control the length
 *              of data written may overflow.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cpp/overrunning-write
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 *       external/cwe/cwe-787
 *       external/cwe/cwe-805
 */

import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.commons.Alloc

/*
 * See CWE-120/UnboundedWrite.ql for a summary of CWE-120 alert cases.
 */

from BufferWrite bw, Expr dest, int destSize
where
  not bw.hasExplicitLimit() and // has no explicit size limit
  dest = bw.getDest() and
  destSize = getBufferSize(dest, _) and
  // we can deduce that too much data may be copied (even without
  // long '%f' conversions)
  bw.getMaxDataLimited() > destSize
select bw,
  "This '" + bw.getBWDesc() + "' operation requires " + bw.getMaxData() +
    " bytes but the destination is only " + destSize + " bytes."
