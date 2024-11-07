/**
 * @name Use of insecure HostKeyCallback implementation
 * @description Detects insecure SSL client configurations with an implementation of the `HostKeyCallback` that accepts all host keys.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.2
 * @precision high
 * @id go/insecure-hostkeycallback
 * @tags security
 *       external/cwe/cwe-322
 */

import go

private string cryptoSshPackage() { result = package("golang.org/x/crypto", "ssh") }

/** The `ssh.InsecureIgnoreHostKey` function, which allows connecting to any host regardless of its host key. */
class InsecureIgnoreHostKey extends Function {
  InsecureIgnoreHostKey() { this.hasQualifiedName(cryptoSshPackage(), "InsecureIgnoreHostKey") }
}

/** An SSH host-key checking function. */
class HostKeyCallbackFunc extends DataFlow::Node {
  HostKeyCallbackFunc() {
    exists(NamedType nt | nt.hasQualifiedName(cryptoSshPackage(), "HostKeyCallback") |
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

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof HostKeyCallbackFunc }

  /**
   * Holds if `sink` is a value written by `write` to a field `ClientConfig.HostKeyCallback`.
   */
  additional predicate writeIsSink(DataFlow::Node sink, Write write) {
    exists(Field f |
      f.hasQualifiedName(cryptoSshPackage(), "ClientConfig", "HostKeyCallback") and
      write.writesField(_, f, sink)
    )
  }

  predicate isSink(DataFlow::Node sink) { writeIsSink(sink, _) }
}

/**
 * Tracks data flow to identify `HostKeyCallbackFunc` instances that reach
 * `ClientConfig.HostKeyCallback` fields.
 */
module Flow = DataFlow::Global<Config>;

import Flow::PathGraph

/**
 * Holds if a secure host-check function reaches `sink` or another similar sink.
 *
 * A sink is considered similar if it writes to the same variable and field.
 */
predicate hostCheckReachesSink(Flow::PathNode sink) {
  exists(Flow::PathNode source |
    not source.getNode() instanceof InsecureHostKeyCallbackFunc and
    (
      Flow::flowPath(source, sink)
      or
      exists(
        Flow::PathNode otherSink, Write sinkWrite, Write otherSinkWrite,
        SsaWithFields sinkAccessPath, SsaWithFields otherSinkAccessPath
      |
        Flow::flowPath(source, otherSink) and
        Config::writeIsSink(sink.getNode(), sinkWrite) and
        Config::writeIsSink(otherSink.getNode(), otherSinkWrite) and
        sinkWrite.writesField(sinkAccessPath.getAUse(), _, sink.getNode()) and
        otherSinkWrite.writesField(otherSinkAccessPath.getAUse(), _, otherSink.getNode()) and
        otherSinkAccessPath = sinkAccessPath.similar()
      )
    )
  )
}

from Flow::PathNode source, Flow::PathNode sink
where
  Flow::flowPath(source, sink) and
  source.getNode() instanceof InsecureHostKeyCallbackFunc and
  // Exclude cases where a good access-path function reaches the same or a similar sink
  // (these probably indicate optional host-checking)
  not hostCheckReachesSink(sink)
select sink, source, sink,
  "Configuring SSH ClientConfig with insecure HostKeyCallback implementation from $@.",
  source.getNode(), "this source"
