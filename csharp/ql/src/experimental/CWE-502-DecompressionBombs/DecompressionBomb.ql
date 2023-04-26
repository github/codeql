/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id cs/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote

/**
 * A data flow source for unsafe Decompression extraction.
 */
abstract class DecompressionSource extends DataFlow::Node { }

class ZipOpenReadSource extends DecompressionSource {
  ZipOpenReadSource() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipFile", ["OpenRead", "Open"]) and
      this.asExpr() = mc.getArgument(0) and
      not mc.getArgument(0).getType().isConst()
    )
  }
}

/** A path argument to a call to the `ZipArchive` constructor call. */
class ZipArchiveArgSource extends DecompressionSource {
  ZipArchiveArgSource() {
    exists(ObjectCreation oc |
      oc.getTarget().getDeclaringType().hasQualifiedName("System.IO.Compression", "ZipArchive")
    |
      this.asExpr() = oc.getArgument(0)
    )
  }
}

/**
 * A data flow sink for unsafe zip extraction.
 */
abstract class DecompressionSink extends DataFlow::Node { }

/** A Caller of the `ExtractToFile` method. */
class ExtractToFileCallSink extends DecompressionSink {
  ExtractToFileCallSink() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipFileExtensions", "ExtractToFile") and
      this.asExpr() = mc.getArgumentForName("source")
    )
  }
}

/** A Qualifier of the `Open()` method. */
class OpenCallSink extends DecompressionSink {
  OpenCallSink() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipArchiveEntry", "Open") and
      this.asExpr() = mc.getQualifier()
    )
  }
}

/** A Call to the `GZipStreamSink` first arugument of Constructor Call . */
class GZipStreamSink extends DecompressionSink, DecompressionSource {
  GZipStreamSink() {
    exists(Constructor mc |
      mc.getDeclaringType().hasQualifiedName("System.IO.Compression", "GZipStream") and
      this.asExpr() = mc.getACall().getArgument(0)
    )
  }
}

/**
 * A taint tracking configuration for Decompression Bomb.
 */
private module DecompressionBombConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof DecompressionSource
    or
    source instanceof RemoteFlowSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionSink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // var node2 = new ZipArchive(node1, ZipArchiveMode.Read);
    exists(ObjectCreation oc |
      oc.getTarget().getDeclaringType().hasQualifiedName("System.IO.Compression", "ZipArchive") and
      node2.asExpr() = oc and
      node1.asExpr() = oc.getArgumentForName("stream")
    )
    or
    // var node2 = node1.ExtractToFile("./output.txt", true)
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipFileExtensions", "ExtractToFile") and
      node2.asExpr() = mc and
      node1.asExpr() = mc.getArgumentForName("source")
    )
    or
    // var node2 = node1.OpenReadStream()
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("Microsoft.AspNetCore.Http", "IFormFile", "OpenReadStream") and
      node2.asExpr() = mc and
      node1.asExpr() = mc.getQualifier()
    )
  }
}

module DecompressionBomb = TaintTracking::Global<DecompressionBombConfig>;

import DecompressionBomb::PathGraph

from DecompressionBomb::PathNode source, DecompressionBomb::PathNode sink
where DecompressionBomb::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
