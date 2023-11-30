/** Provides dataflow configurations to be used in ZipSlip queries. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.PathSanitizer
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.PathCreation

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
 * A taint-tracking configuration for reasoning about unsafe zip file extraction.
 */
module ZipSlipConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(MethodCall).getMethod() instanceof ArchiveEntryNameMethod
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof FileCreationSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof PathInjectionSanitizer }
}

/** Tracks flow from archive entries to file creation. */
module ZipSlipFlow = TaintTracking::Global<ZipSlipConfig>;

/**
 * A sink that represents a file creation, such as a file write, copy or move operation.
 */
private class FileCreationSink extends DataFlow::Node {
  FileCreationSink() {
    sinkNode(this, "path-injection") and
    not isPathCreation(this)
  }
}

/**
 * Holds if `sink` is a path creation node that doesn't imply a read/write filesystem operation.
 * This is to avoid creating new spurious alerts, since `PathCreation` sinks weren't
 * previously part of this query.
 */
private predicate isPathCreation(DataFlow::Node sink) {
  exists(PathCreation pc |
    pc.getAnInput() = sink.asExpr()
    or
    pc.getAnInput().(Argument).isVararg() and sink.(DataFlow::ImplicitVarargsArray).getCall() = pc
  |
    // exclude actual read/write operations included in `PathCreation`
    not pc.(Call)
        .getCallee()
        .getDeclaringType()
        .hasQualifiedName("java.io",
          ["FileInputStream", "FileOutputStream", "FileReader", "FileWriter"])
  )
}
