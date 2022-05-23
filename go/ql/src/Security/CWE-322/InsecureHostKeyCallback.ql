/**
 * @name Use of insecure HostKeyCallback implementation
 * @description Detects insecure SSL client configurations with an implementation of the `HostKeyCallback` that accepts all host keys.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id go/insecure-hostkeycallback
 * @tags security
 */

import go
import DataFlow::PathGraph

/** The `ssh.InsecureIgnoreHostKey` function, which allows connecting to any host regardless of its host key. */
class InsecureIgnoreHostKey extends Function {
  InsecureIgnoreHostKey() {
    this.hasQualifiedName(CryptoSsh::packagePath(), "InsecureIgnoreHostKey")
  }
}

/** An SSH host-key checking function. */
class HostKeyCallbackFunc extends DataFlow::Node {
  HostKeyCallbackFunc() {
    exists(NamedType nt | nt.hasQualifiedName(CryptoSsh::packagePath(), "HostKeyCallback") |
      this.getType().getUnderlyingType() = nt.getUnderlyingType()
    ) and
    // Restrict possible sources to either function definitions or
    // the result of some external function call (e.g. InsecureIgnoreHostKey())
    // Otherwise we also consider typecasts, variables and other such intermediates
    // as sources.
    (
      this instanceof DataFlow::FunctionNode
      or
      exists(DataFlow::CallNode call | not exists(call.getACallee().getBody()) |
        this = call.getAResult()
      )
    )
  }
}

/** A callback function value that is insecure when used as a `HostKeyCallback`, because it always returns `nil`. */
class InsecureHostKeyCallbackFunc extends HostKeyCallbackFunc {
  InsecureHostKeyCallbackFunc() {
    // Either a call to InsecureIgnoreHostKey(), which we know returns an insecure callback.
    this = any(InsecureIgnoreHostKey f).getACall().getAResult()
    or
    // Or a callback function in the source code (named or anonymous) that always returns nil.
    forex(DataFlow::ResultNode returnValue |
      returnValue = this.(DataFlow::FunctionNode).getAResult()
    |
      returnValue = Builtin::nil().getARead()
    )
  }
}

/**
 * A data-flow configuration for identifying `HostKeyCallbackFunc` instances that reach `ClientConfig.HostKeyCallback` fields.
 */
class HostKeyCallbackAssignmentConfig extends DataFlow::Configuration {
  HostKeyCallbackAssignmentConfig() { this = "HostKeyCallbackAssignmentConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof HostKeyCallbackFunc }

  /**
   * Holds if `sink` is a value written by `write` to a field `ClientConfig.HostKeyCallback`.
   */
  predicate isSink(DataFlow::Node sink, Write write) {
    exists(Field f |
      f.hasQualifiedName(CryptoSsh::packagePath(), "ClientConfig", "HostKeyCallback") and
      write.writesField(_, f, sink)
    )
  }

  override predicate isSink(DataFlow::Node sink) { this.isSink(sink, _) }
}

/**
 * Holds if a secure host-check function reaches `sink` or another similar sink.
 *
 * A sink is considered similar if it writes to the same variable and field.
 */
predicate hostCheckReachesSink(DataFlow::PathNode sink) {
  exists(HostKeyCallbackAssignmentConfig config, DataFlow::PathNode source |
    not source.getNode() instanceof InsecureHostKeyCallbackFunc and
    (
      config.hasFlowPath(source, sink)
      or
      exists(
        DataFlow::PathNode otherSink, Write sinkWrite, Write otherSinkWrite,
        SsaWithFields sinkAccessPath, SsaWithFields otherSinkAccessPath
      |
        config.hasFlowPath(source, otherSink) and
        config.isSink(sink.getNode(), sinkWrite) and
        config.isSink(otherSink.getNode(), otherSinkWrite) and
        sinkWrite.writesField(sinkAccessPath.getAUse(), _, sink.getNode()) and
        otherSinkWrite.writesField(otherSinkAccessPath.getAUse(), _, otherSink.getNode()) and
        otherSinkAccessPath = sinkAccessPath.similar()
      )
    )
  )
}

from HostKeyCallbackAssignmentConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where
  config.hasFlowPath(source, sink) and
  source.getNode() instanceof InsecureHostKeyCallbackFunc and
  // Exclude cases where a good access-path function reaches the same or a similar sink
  // (these probably indicate optional host-checking)
  not hostCheckReachesSink(sink)
select sink, source, sink,
  "Configuring SSH ClientConfig with insecure HostKeyCallback implementation from $@.",
  source.getNode(), "this source"
