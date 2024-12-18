/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe unpack vulnerabilities, as well as extension points for
 * adding your own.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow source for unsafe unpack vulnerabilities.
 */
abstract class UnsafeUnpackSource extends DataFlow::Node { }

/**
 * A dataflow sink for unsafe unpack vulnerabilities.
 */
abstract class UnsafeUnpackSink extends DataFlow::Node { }

/**
 * A barrier for unsafe unpack vulnerabilities.
 */
abstract class UnsafeUnpackBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class UnsafeUnpackAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to unsafe unpack vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultUnsafeUnpackSink extends UnsafeUnpackSink {
  DefaultUnsafeUnpackSink() { sinkNode(this, "unsafe-unpack") }
}

private class UnsafeUnpackSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Zip;true;unzipFile(_:destination:overwrite:password:progress:fileOutputHandler:);;;Argument[0];unsafe-unpack",
        ";FileManager;true;unzipItem(at:to:skipCRC32:progress:pathEncoding:);;;Argument[0];unsafe-unpack",
      ]
  }
}

/**
 * An additional taint step for unsafe unpack vulnerabilities.
 */
private class UnsafeUnpackAdditionalDataFlowStep extends UnsafeUnpackAdditionalFlowStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(CallExpr initCall, CallExpr call |
      // If a zip file is remotely downloaded the destination path is tainted
      call.getStaticTarget().(Method).hasQualifiedName("Data", "write(to:options:)") and
      call.getQualifier() = initCall and
      initCall.getStaticTarget().(Initializer).getEnclosingDecl().(TypeDecl).getName() = "Data" and
      nodeFrom.asExpr() = initCall and
      nodeTo.asExpr() = call.getAnArgument().getExpr()
    )
  }
}

/**
 * A barrier for unsafe unpack vulnerabilities.
 */
private class UnsafeUnpackDefaultBarrier extends UnsafeUnpackBarrier {
  UnsafeUnpackDefaultBarrier() {
    // any numeric type
    this.asExpr().getType().getUnderlyingType().getABaseType*().getName() =
      ["Numeric", "SignedInteger", "UnsignedInteger"]
  }
}
