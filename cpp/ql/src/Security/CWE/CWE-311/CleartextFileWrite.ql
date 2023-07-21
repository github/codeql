/**
 * @name Cleartext storage of sensitive information in file
 * @description Storing sensitive information in cleartext can expose it
 *              to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cpp/cleartext-storage-file
 * @tags security
 *       external/cwe/cwe-260
 *       external/cwe/cwe-313
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.security.FileWrite
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.ir.dataflow.TaintTracking
import FromSensitiveFlow::PathGraph

/**
 * A taint flow configuration for flow from a sensitive expression to a `FileWrite` sink.
 */
module FromSensitiveConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSourceImpl(source, _) }

  predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _, _) }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().getUnspecifiedType() instanceof IntegralType
  }
}

module FromSensitiveFlow = TaintTracking::Global<FromSensitiveConfig>;

predicate isSinkImpl(DataFlow::Node sink, FileWrite w, Expr dest) {
  exists(Expr e |
    e = [sink.asExpr(), sink.asIndirectExpr()] and
    w.getASource() = e and
    dest = w.getDest() and
    // ignore things written with other conversion characters
    not exists(string convChar | convChar = w.getSourceConvChar(e) | not convChar = ["s", "S"]) and
    // exclude calls with standard streams
    not dest.(VariableAccess).getTarget().getName() = ["stdin", "stdout", "stderr"]
  )
}

predicate isSourceImpl(DataFlow::Node source, SensitiveExpr sensitive) {
  not isFileName(globalValueNumber(sensitive)) and // file names are not passwords
  source.asExpr() = sensitive
}

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
  exists(Expr path |
    filenameOperation(_, path) and
    gvn = globalValueNumber(path)
  )
}

from
  SensitiveExpr source, FromSensitiveFlow::PathNode sourceNode, FromSensitiveFlow::PathNode midNode,
  FileWrite w, Expr dest
where
  FromSensitiveFlow::flowPath(sourceNode, midNode) and
  isSourceImpl(sourceNode.getNode(), source) and
  isSinkImpl(midNode.getNode(), w, dest)
select w, sourceNode, midNode,
  "This write into file '" + dest.toString() + "' may contain unencrypted data from $@.", source,
  "this source."
