/**
 * @name Cleartext storage of sensitive information in buffer
 * @description Storing sensitive information in cleartext can expose it
 *              to an attacker.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/cleartext-storage-buffer
 * @tags security
 *       external/cwe/cwe-312
 */

import cpp
import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.security.TaintTracking
import semmle.code.cpp.security.SensitiveExprs

from BufferWrite w, Expr taintedArg, Expr taintSource, string taintCause, SensitiveExpr dest
where
  tainted(taintSource, taintedArg) and
  isUserInput(taintSource, taintCause) and
  w.getASource() = taintedArg and
  dest = w.getDest()
select w, "This write into buffer '" + dest.toString() + "' may contain unencrypted data from $@",
  taintSource, "user input (" + taintCause + ")"
