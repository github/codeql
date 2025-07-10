/**
 * @name File Path Injection
 * @description Loading files based on unvalidated user-input may cause file information disclosure
 *              and uploading files with unvalidated file types to an arbitrary directory may lead to
 *              Remote Command Execution (RCE).
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/file-path-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-073
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.TaintedPathQuery
deprecated import JFinalController
import semmle.code.java.security.PathSanitizer
private import semmle.code.java.security.Sanitizers
import InjectFilePathFlow::PathGraph

deprecated private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "file-path-injection" }
}

/** A complementary sanitizer that protects against path traversal using path normalization. */
class PathNormalizeSanitizer extends MethodCall {
  PathNormalizeSanitizer() {
    exists(RefType t |
      t instanceof TypePath or
      t.hasQualifiedName("kotlin.io", "FilesKt")
    |
      this.getMethod().getDeclaringType() = t and
      this.getMethod().hasName("normalize")
    )
    or
    this.getMethod().getDeclaringType() instanceof TypeFile and
    this.getMethod().hasName(["getCanonicalPath", "getCanonicalFile"])
  }
}

/** A node with path normalization. */
class NormalizedPathNode extends DataFlow::Node {
  NormalizedPathNode() {
    TaintTracking::localExprTaint(this.asExpr(), any(PathNormalizeSanitizer ma))
  }
}

module InjectFilePathConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof TaintedPathSink and
    not sink instanceof NormalizedPathNode
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof SimpleTypeSanitizer
    or
    node instanceof PathInjectionSanitizer
  }
}

module InjectFilePathFlow = TaintTracking::Global<InjectFilePathConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, InjectFilePathFlow::PathNode source, InjectFilePathFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  InjectFilePathFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "External control of file name or path due to $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
