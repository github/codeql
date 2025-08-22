/** Provides dataflow configurations to be used in ZipSlip queries. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.PathSanitizer
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.Sanitizers

/**
 * A method that returns the name of an archive entry.
 */
private class ArchiveEntryNameMethod extends Method {
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
 * An entry name method source node.
 */
private class ArchiveEntryNameMethodSource extends ApiSourceNode {
  ArchiveEntryNameMethodSource() {
    this.asExpr().(MethodCall).getMethod() instanceof ArchiveEntryNameMethod
  }
}

/**
 * A taint-tracking configuration for reasoning about unsafe zip file extraction.
 */
module ZipSlipConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ArchiveEntryNameMethodSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof FileCreationSink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof SimpleTypeSanitizer or
    node instanceof PathInjectionSanitizer
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow from archive entries to file creation. */
module ZipSlipFlow = TaintTracking::Global<ZipSlipConfig>;

/**
 * A sink that represents a file creation, such as a file write, copy or move operation.
 */
private class FileCreationSink extends DataFlow::Node {
  FileCreationSink() { sinkNode(this, "path-injection") }
}
