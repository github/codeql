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

module ZipSlipConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(MethodAccess).getMethod() instanceof ArchiveEntryNameMethod
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof FileCreationSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof PathInjectionSanitizer }
}

module ZipSlipFlow = TaintTracking::Global<ZipSlipConfig>;

import ZipSlipFlow::PathGraph

/**
 * A sink that represents a file creation, such as a file write, copy or move operation.
 */
private class FileCreationSink extends DataFlow::Node {
  FileCreationSink() { sinkNode(this, "create-file") }
}

from ZipSlipFlow::PathNode source, ZipSlipFlow::PathNode sink
where ZipSlipFlow::flowPath(source, sink)
select source.getNode(), source, sink,
  "Unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
