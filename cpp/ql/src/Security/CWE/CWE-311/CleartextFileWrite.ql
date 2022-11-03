/**
 * @name Cleartext storage of sensitive information in file
 * @description Storing sensitive information in cleartext can expose it
 *              to an attacker.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cpp/cleartext-storage-file
 * @tags security
 *       external/cwe/cwe-313
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.security.FileWrite
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * An operation on a filename.
 */
predicate filenameOperation(FunctionCall op, Expr path) {
  exists(string name | name = op.getTarget().getName() |
    name =
      [
        "remove", "unlink", "rmdir", "rename", "fopen", "open", "freopen", "_open", "_wopen",
        "_wfopen", "_fsopen", "_wfsopen", "chmod", "chown", "stat", "lstat", "fstat", "access",
        "_access", "_waccess", "_access_s", "_waccess_s"
      ] and
    path = op.getArgument(0)
    or
    name = ["fopen_s", "wfopen_s", "rename"] and
    path = op.getArgument(1)
  )
}

predicate isFileName(GVN gvn) {
  exists(FunctionCall op, Expr path |
    filenameOperation(op, path) and
    gvn = globalValueNumber(path)
  )
}

from FileWrite w, SensitiveExpr source, Expr mid, Expr dest
where
  DataFlow::localFlow(DataFlow::exprNode(source), DataFlow::exprNode(mid)) and
  mid = w.getASource() and
  dest = w.getDest() and
  not isFileName(globalValueNumber(source)) and // file names are not passwords
  not exists(string convChar | convChar = w.getSourceConvChar(mid) | not convChar = ["s", "S"]) // ignore things written with other conversion characters
select w, "This write into file '" + dest.toString() + "' may contain unencrypted data from $@",
  source, "this source."
