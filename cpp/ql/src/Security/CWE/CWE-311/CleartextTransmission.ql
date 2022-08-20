/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cpp/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-359
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.security.PrivateData
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.commons.File
import DataFlow::PathGraph

class SourceVariable extends Variable {
  SourceVariable() {
    this instanceof SensitiveVariable or
    this instanceof PrivateDataVariable
  }
}

class SourceFunction extends Function {
  SourceFunction() {
    this instanceof SensitiveFunction or
    this instanceof PrivateDataFunction
  }
}

/**
 * A DataFlow node corresponding to a variable or function call that
 * might contain or return a password or other sensitive information.
 */
class SourceNode extends DataFlow::Node {
  SourceNode() {
    this.asExpr() = any(SourceVariable sv).getInitializer().getExpr() or
    this.asExpr().(VariableAccess).getTarget() = any(SourceVariable sv).(GlobalOrNamespaceVariable) or
    this.asExpr().(VariableAccess).getTarget() = any(SourceVariable v | v instanceof Field) or
    this.asUninitialized() instanceof SourceVariable or
    this.asParameter() instanceof SourceVariable or
    this.asExpr().(FunctionCall).getTarget() instanceof SourceFunction
  }
}

/**
 * A function that sends or receives data over a network.
 */
abstract class SendRecv extends Function {
  /**
   * Gets the expression for the socket or similar object used for sending or
   * receiving data through the function call `call` (if any).
   */
  abstract Expr getSocketExpr(Call call);

  /**
   * Gets the expression for the buffer to be sent from / received into through
   * the function call `call`.
   */
  abstract Expr getDataExpr(Call call);
}

/**
 * A function that sends data over a network.
 */
class Send extends SendRecv instanceof RemoteFlowSinkFunction {
  override Expr getSocketExpr(Call call) {
    call.getTarget() = this and
    exists(FunctionInput input, int arg |
      super.hasSocketInput(input) and
      (
        input.isParameter(arg) or
        input.isParameterDeref(arg)
      ) and
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

/**
 * A function that receives data over a network.
 */
class Recv extends SendRecv instanceof RemoteFlowSourceFunction {
  override Expr getSocketExpr(Call call) {
    call.getTarget() = this and
    exists(FunctionInput input, int arg |
      super.hasSocketInput(input) and
      (
        input.isParameter(arg) or
        input.isParameterDeref(arg)
      ) and
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
 * note: function calls such as `write` may be writing to a network source
 * or a file. We could attempt to determine which, and sort results into
 * `cpp/cleartext-transmission` and perhaps `cpp/cleartext-storage-file`. In
 * practice it usually isn't very important which query reports a result as
 * long as its reported exactly once.
 *
 * We do exclude function calls that specify an apparently constant socket,
 * which is likely to mean standard input, standard output or a similar channel.
 */
abstract class NetworkSendRecv extends FunctionCall {
  SendRecv target;

  NetworkSendRecv() {
    this.getTarget() = target and
    // exclude calls based on the socket...
    not exists(DataFlow::Node src, DataFlow::Node dest |
      DataFlow::localFlow(src, dest) and
      dest.asExpr() = target.getSocketExpr(this) and
      (
        // literal constant
        src.asExpr() instanceof Literal
        or
        // variable (such as a global) initialized to a literal constant
        exists(Variable v |
          v.getInitializer().getExpr() instanceof Literal and
          src.asExpr() = v.getAnAccess()
        )
        or
        // result of a function call with literal inputs (likely constant)
        forex(Expr arg | arg = src.asExpr().(FunctionCall).getAnArgument() | arg instanceof Literal)
        or
        // variable called `stdin`, `stdout` or `stderr`
        src.asExpr().(VariableAccess).getTarget().getName() = ["stdin", "stdout", "stderr"]
        or
        // open of `"/dev/tty"`
        exists(FunctionCall fc |
          fopenCall(fc) and
          fc.getAnArgument().getValue() = "/dev/tty" and
          src.asExpr() = fc
        )
        // (this is not exhaustive)
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

pragma[noinline]
predicate encryptionFunction(Function f) {
  f.getName().toLowerCase().regexpMatch(".*(crypt|encode|decode|hash|securezero).*")
}

pragma[noinline]
predicate encryptionType(UserType t) {
  t.getName().toLowerCase().regexpMatch(".*(crypt|encode|decode|hash|securezero).*")
}

/**
 * An expression that is an argument or return value from an encryption /
 * decryption call. This is quite inclusive to minimize false positives, for
 * example `SecureZeroMemory` is not an encryption routine but a clue that
 * encryption may be present.
 */
class Encrypted extends Expr {
  Encrypted() {
    exists(FunctionCall fc |
      encryptionFunction(fc.getTarget()) and
      (
        this = fc or
        this = fc.getAnArgument()
      )
    )
    or
    exists(Type t |
      this.getType().refersTo(t) and
      encryptionType(t)
    )
  }
}

/**
 * Taint flow from a sensitive expression.
 */
class FromSensitiveConfiguration extends TaintTracking::Configuration {
  FromSensitiveConfiguration() { this = "FromSensitiveConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof SourceNode }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NetworkSendRecv nsr).getDataExpr()
    or
    sink.asExpr() instanceof Encrypted
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
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
