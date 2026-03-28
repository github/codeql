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
 *
 * This excludes read-only operations (e.g., `ClassLoader.getResource`,
 * `FileInputStream`, `File.exists`) that are not relevant to Zip Slip,
 * which specifically targets file extraction (write) vulnerabilities.
 */
private class FileCreationSink extends DataFlow::Node {
  FileCreationSink() {
    sinkNode(this, "path-injection") and
    not this instanceof ReadOnlyPathSink
  }
}

/**
 * A path-injection sink that only performs read or inspection operations
 * and is therefore not vulnerable to Zip Slip file extraction attacks.
 */
private class ReadOnlyPathSink extends DataFlow::Node {
  ReadOnlyPathSink() {
    sinkNode(this, "path-injection") and
    (
      // ClassLoader resource lookup methods
      exists(MethodCall mc | this.asExpr() = mc.getAnArgument() |
        mc.getMethod().getDeclaringType().hasQualifiedName("java.lang", ["ClassLoader", "Class"]) and
        mc.getMethod()
            .hasName(["getResource", "getResources", "getResourceAsStream",
                "getSystemResource", "getSystemResources", "getSystemResourceAsStream"])
      )
      or
      // File read-only inspection methods
      exists(MethodCall mc | this.asExpr() = mc.getQualifier() |
        mc.getMethod().getDeclaringType().hasQualifiedName("java.io", "File") and
        mc.getMethod()
            .hasName(["exists", "isFile", "isDirectory", "isHidden", "canRead", "canWrite",
                "canExecute", "getName", "getPath", "getAbsolutePath", "getCanonicalPath",
                "getCanonicalFile", "length", "lastModified"])
      )
      or
      // FileInputStream (read-only file access)
      exists(Call c | this.asExpr() = c.getAnArgument() |
        c.(ConstructorCall).getConstructedType().hasQualifiedName("java.io", "FileInputStream")
        or
        c.(ConstructorCall).getConstructedType().hasQualifiedName("java.io", "FileReader")
      )
      or
      // NIO read-only methods
      exists(MethodCall mc | this.asExpr() = mc.getAnArgument() |
        mc.getMethod().getDeclaringType().hasQualifiedName("java.nio.file", "Files") and
        mc.getMethod()
            .hasName(["exists", "notExists", "isDirectory", "isRegularFile", "isReadable",
                "isWritable", "isExecutable", "isHidden", "isSameFile", "isSymbolicLink",
                "probeContentType", "getFileStore", "getLastModifiedTime", "getOwner",
                "getAttribute", "readAttributes", "size",
                "readAllBytes", "readAllLines", "readString", "lines",
                "newBufferedReader", "newInputStream"])
      )
    )
  }
}
