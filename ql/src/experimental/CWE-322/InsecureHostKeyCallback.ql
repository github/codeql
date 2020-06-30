/**
 * @name Use of insecure HostKeyCallback implementation
 * @description Detects insecure SSL client configurations with an implementation of the `HostKeyCallback` that accepts all host keys.
 * @kind path-problem
 * @problem.severity error
 * @precision very-high
 * @id go/insecure-hostkeycallback
 * @tags security
 */

import go
import DataFlow::PathGraph

class InsecureIgnoreHostKey extends Function {
  InsecureIgnoreHostKey() {
    this.hasQualifiedName("golang.org/x/crypto/ssh", "InsecureIgnoreHostKey")
  }
}

/** A callback function value that is insecure when used as a `HostKeyCallback`, because it always returns `nil`. */
class InsecureHostKeyCallbackFunc extends DataFlow::Node {
  InsecureHostKeyCallbackFunc() {
    // Either a call to InsecureIgnoreHostKey(), which we know returns an insecure callback.
    this = any(InsecureIgnoreHostKey f).getACall()
    or
    // Or a callback function in the source code  (named or anonymous) that always returns nil.
    forex(DataFlow::ResultNode returnValue |
      returnValue = this.(DataFlow::FunctionNode).getAResult()
    |
      returnValue = Builtin::nil().getARead()
    )
  }
}

class HostKeyCallbackAssignmentConfig extends DataFlow::Configuration {
  HostKeyCallbackAssignmentConfig() { this = "HostKeyCallbackAssignmentConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof InsecureHostKeyCallbackFunc
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Field f |
      f.hasQualifiedName("golang.org/x/crypto/ssh", "ClientConfig", "HostKeyCallback") and
      sink = f.getAWrite().getRhs()
    )
  }
}

from HostKeyCallbackAssignmentConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink,
  "Configuring SSH ClientConfig with insecure HostKeyCallback implementation from $@.",
  source.getNode(), "this source"
