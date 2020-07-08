/**
 * @name Cleartext storage of sensitive information in file
 * @description Storing private data in cleartext can expose it
 *              to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @id cpp/private-cleartext-storage-file
 * @tags security
 *       external/cwe/cwe-313
 */


import cpp
import experimental.semmle.code.cpp.security.PrivateData
import semmle.code.cpp.security.FileWrite
import semmle.code.cpp.dataflow.TaintTracking

/** A call to any method whose name suggests that it encodes or encrypts the parameter. */
class ProtectSanitizer extends DataFlow::ExprNode {
  ProtectSanitizer() {
    exists(Function m, string s |
      this.getExpr().(FunctionCall).getTarget() = m and
      m.getName().regexpMatch("(?i).*" + s + ".*")
    |
      s = "protect" or s = "encode" or s = "encrypt"
    )
  }
}

class FileConfig extends TaintTracking::Configuration {
  FileConfig() {
    this = "File write configuration"
  }
  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PrivateDataExpr }
  override predicate isSink(DataFlow::Node sink) { exists(FileWrite w | sink.asExpr() = w.getASource()) }
  override predicate isSanitizer(DataFlow::Node node) { node instanceof ProtectSanitizer }
}

from FileConfig b, DataFlow::Node source, DataFlow::Node sink
where b.hasFlow(source, sink)
select sink, "This file write may contain unencrypted data"



// import cpp
// import experimental.semmle.code.cpp.security.PrivateData
// import semmle.code.cpp.security.FileWrite

// from FileWrite w, PrivateDataExpr source, Expr dest
// where
//   source = w.getASource() and
//   dest = w.getDest()
// select w, "This write into file '" + dest.toString() + "' may contain unencrypted data from $@",
//   source, "this source."
