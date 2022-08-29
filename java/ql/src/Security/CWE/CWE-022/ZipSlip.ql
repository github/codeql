/**
 * @name Arbitrary file write during archive extraction ("Zip Slip")
 * @description Extracting files from a malicious archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind path-problem
 * @id java/zipslip
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.SSA
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.PathSanitizer
import DataFlow
import PathGraph
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A method that returns the name of an archive entry.
 */
class ArchiveEntryNameMethod extends Method {
  ArchiveEntryNameMethod() {
    exists(RefType archiveEntry |
      archiveEntry.hasQualifiedName("java.util.zip", "ZipEntry") or
      archiveEntry.hasQualifiedName("org.apache.commons.compress.archivers", "ArchiveEntry")
    |
      this.getDeclaringType().getAnAncestor() = archiveEntry and
      this.hasName("getName")
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String`,
 * `File`, and `Path`.
 */
predicate filePathStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeFile |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
  or
  exists(MethodAccess ma, Method m |
    ma.getMethod() = m and
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    m.getDeclaringType() instanceof TypeFile and m.hasName("toPath")
    or
    m.getDeclaringType() instanceof TypePath and m.hasName("toAbsolutePath")
    or
    m.getDeclaringType() instanceof TypePath and m.hasName("toFile")
  )
}

predicate fileTaintStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() or
    n1.asExpr() = ma.getAnArgument()
  |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypePath and
    m.hasName("resolve")
  )
}

class ZipSlipConfiguration extends TaintTracking::Configuration {
  ZipSlipConfiguration() { this = "ZipSlip" }

  override predicate isSource(Node source) {
    source.asExpr().(MethodAccess).getMethod() instanceof ArchiveEntryNameMethod
  }

  override predicate isSink(Node sink) { sink instanceof FileCreationSink }

  override predicate isAdditionalTaintStep(Node n1, Node n2) {
    filePathStep(n1, n2) or fileTaintStep(n1, n2)
  }

  override predicate isSanitizer(Node node) { node instanceof PathInjectionSanitizer }
}

/**
 * A sink that represents a file creation, such as a file write, copy or move operation.
 */
private class FileCreationSink extends DataFlow::Node {
  FileCreationSink() { sinkNode(this, "create-file") }
}

from PathNode source, PathNode sink
where any(ZipSlipConfiguration c).hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
