/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.models.interfaces.FlowSource
import DataFlow::PathGraph

/**
 * A DataFlow node corresponding to a variable or function call that
 * might contain or return a password or other sensitive information.
 */
class SensitiveNode extends DataFlow::Node {
  SensitiveNode() {
    this.asExpr() = any(SensitiveVariable sv).getInitializer().getExpr() or
    this.asExpr().(VariableAccess).getTarget() =
      any(SensitiveVariable sv).(GlobalOrNamespaceVariable) or
    this.asUninitialized() instanceof SensitiveVariable or
    this.asParameter() instanceof SensitiveVariable or
    this.asExpr().(FunctionCall).getTarget() instanceof SensitiveFunction
  }
}

abstract class SendRecv extends Function {
  /**
   * Gets the expression for the socket or similar object used for sending or
   * receiving data through the function call `call` (if any).
   */
  abstract Expr getSocketExpr(Call call);

  /**
   * Gets the expression for the buffer to be sent from / received into.
   */
  abstract Expr getDataExpr(Call call);
}

class Send extends SendRecv instanceof RemoteFlowSinkFunction {
  override Expr getSocketExpr(Call call) {
    call.getTarget() = this and
    exists(FunctionInput input, int arg |
      super.hasSocketInput(input) and
      input.isParameter(arg) and
      result = call.getArgument(arg)
    )
  }

  override Expr getDataExpr(Call call) {
    call.getTarget() = this and
    exists(FunctionInput input, int arg |
      super.hasRemoteFlowSink(input, _) and
      input.isParameterDeref(arg) and
      result = call.getArgument(arg)
    )
  }
}

class Recv extends SendRecv instanceof RemoteFlowSourceFunction {
  override Expr getSocketExpr(Call call) {
    call.getTarget() = this and
    exists(FunctionInput input, int arg |
      super.hasSocketInput(input) and
      input.isParameter(arg) and
      result = call.getArgument(arg)
    )
  }

  override Expr getDataExpr(Call call) {
    call.getTarget() = this and
    exists(FunctionOutput output, int arg |
      super.hasRemoteFlowSource(output, _) and
      output.isParameterDeref(arg) and
      result = call.getArgument(arg)
    )
  }
}

/**
 * A function call that sends or receives data over a network.
 *
 * note: functions such as `write` may be writing to a network source or a file. We could attempt to determine which, and sort results into `cpp/cleartext-transmission` and perhaps `cpp/cleartext-storage-file`. In practice it usually isn't very important which query reports a result as long as its reported exactly once. See `checkSocket` to narrow this down somewhat.
 */
abstract class NetworkSendRecv extends FunctionCall {
  SendRecv target;

  NetworkSendRecv() {
    this.getTarget() = target and
    not exists(GVN g |
      g = globalValueNumber(target.getSocketExpr(this)) and
      (
        // literal constant
        globalValueNumber(any(Literal l)) = g
        or
        // variable (such as a global) initialized to a literal constant
        exists(Variable v |
          v.getInitializer().getExpr() instanceof Literal and
          g = globalValueNumber(v.getAnAccess())
        )
      )
    )
  }

  final Expr getDataExpr() { result = target.getDataExpr(this) }
}

/**
 * A function call that sends data over a network.
 */
class NetworkSend extends NetworkSendRecv {
  override Send target;
}

/**
 * A function call that receives data over a network.
 */
class NetworkRecv extends NetworkSendRecv {
  override Recv target;
}

/**
 * An expression that is an argument or return value from an encryption or
 * decryption call.
 */
class Encrypted extends Expr {
  Encrypted() {
    exists(FunctionCall fc |
      fc.getTarget().getName().toLowerCase().regexpMatch(".*(crypt|encode|decode).*") and
      (
        this = fc or
        this = fc.getAnArgument()
      )
    )
  }
}

/**
 * Taint flow from a sensitive expression.
 */
class FromSensitiveConfiguration extends TaintTracking::Configuration {
  FromSensitiveConfiguration() { this = "FromSensitiveConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof SensitiveNode }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NetworkSendRecv nsr).getDataExpr()
    or
    sink.asExpr() instanceof Encrypted
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // flow from pre-update to post-update of the source
    isSource(node1) and
    node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1
    or
    // flow through encryption functions to the return value (in case we can reach other sinks)
    node2.asExpr().(Encrypted).(FunctionCall).getAnArgument() = node1.asExpr()
  }
}

from
  FromSensitiveConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  NetworkSendRecv networkSendRecv, string msg
where
  // flow from sensitive -> network data
  config.hasFlowPath(source, sink) and
  sink.getNode().asExpr() = networkSendRecv.getDataExpr() and
  // no flow from sensitive -> evidence of encryption
  not exists(DataFlow::Node encrypted |
    config.hasFlow(source.getNode(), encrypted) and
    encrypted.asExpr() instanceof Encrypted
  ) and
  // construct result
  if networkSendRecv instanceof NetworkSend
  then
    msg =
      "This operation transmits '" + sink.toString() +
        "', which may contain unencrypted sensitive data from $@"
  else
    msg =
      "This operation receives into '" + sink.toString() +
        "', which may put unencrypted sensitive data into $@"
select networkSendRecv, source, sink, msg, source, source.getNode().toString()
