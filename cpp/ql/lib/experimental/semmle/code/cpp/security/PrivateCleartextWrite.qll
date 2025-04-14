/**
 * Provides a taint-tracking configuration for reasoning about private information flowing unencrypted to an external location.
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.PrivateData
import semmle.code.cpp.security.FileWrite
import semmle.code.cpp.security.BufferWrite

module PrivateCleartextWrite {
  /**
   * A data flow source for private information flowing unencrypted to an external location.
   */
  abstract class Source extends DataFlow::ExprNode { }

  /**
   * A data flow sink for private information flowing unencrypted to an external location.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for private information flowing unencrypted to an external location.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /** A call to any method whose name suggests that it encodes or encrypts the parameter. */
  class ProtectSanitizer extends Sanitizer {
    ProtectSanitizer() {
      exists(Function m, string s |
        this.getExpr().(FunctionCall).getTarget() = m and
        m.getName().regexpMatch("(?i).*" + s + ".*")
      |
        s = "protect" or s = "encode" or s = "encrypt"
      )
    }
  }

  private module WriteConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  module WriteFlow = TaintTracking::Global<WriteConfig>;

  class PrivateDataSource extends Source {
    PrivateDataSource() { this.getExpr() instanceof PrivateDataExpr }
  }

  class WriteSink extends Sink {
    WriteSink() {
      this.asExpr() = any(FileWrite f).getASource() or
      this.asExpr() = any(BufferWrite b).getAChild()
    }
  }
}
