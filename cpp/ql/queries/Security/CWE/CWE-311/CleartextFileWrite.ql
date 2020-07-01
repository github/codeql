/**
 * @name Cleartext storage of sensitive information in file
 * @description Storing sensitive information in cleartext can expose it
 *              to an attacker.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/cleartext-storage-file
 * @tags security
 *       external/cwe/cwe-313
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.security.FileWrite

from FileWrite w, SensitiveExpr source, Expr dest
where
  source = w.getASource() and
  dest = w.getDest()
select w, "This write into file '" + dest.toString() + "' may contain unencrypted data from $@",
  source, "this source."
