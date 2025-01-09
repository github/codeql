/**
 * @name Badly bounded write
 * @description Buffer write operations with a length parameter that
 *              does not match the size of the destination buffer may
 *              overflow.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id cpp/badly-bounded-write
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 *       external/cwe/cwe-787
 *       external/cwe/cwe-805
 */

import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.ConfigurationTestFile

/*
 * See CWE-120/UnboundedWrite.ql for a summary of CWE-120 alert cases.
 */

from BufferWrite bw, int destSize
where
  bw.hasExplicitLimit() and // has an explicit size limit
  destSize = max(getBufferSize(bw.getDest(), _)) and
  bw.getExplicitLimit() > destSize and // but it's larger than the destination
  not bw.getDest().getType().stripType() instanceof ErroneousType and // destSize may be incorrect
  not bw.getFile() instanceof ConfigurationTestFile // expressions in files generated during configuration are likely false positives
select bw,
  "This '" + bw.getBWDesc() + "' operation is limited to " + bw.getExplicitLimit() +
    " bytes but the destination is only " + destSize + " bytes."
