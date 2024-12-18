/**
 * Provides a taint-tracking configuration for reasoning about user-controlled bypass of sensitive
 * methods.
 */

import csharp
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.controlflow.BasicBlocks
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Net
private import semmle.code.csharp.security.SensitiveActions

/**
 * A data flow source for user-controlled bypass of sensitive method.
 */
abstract class Source extends ApiSourceNode { }

/**
 * A data flow sink for user-controlled bypass of sensitive method.
 */
abstract class Sink extends ApiSinkExprNode {
  /** Gets the 'MethodCall' which is considered sensitive. */
  abstract MethodCall getSensitiveMethodCall();
}

/**
 * A sanitizer for user-controlled bypass of sensitive method.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for user-controlled bypass of sensitive method.
 */
private module ConditionalBypassConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for user-controlled bypass of sensitive method.
 */
module ConditionalBypass = TaintTracking::Global<ConditionalBypassConfig>;

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

/** The result of a reverse dns may be user-controlled. */
class ReverseDnsSource extends Source {
  ReverseDnsSource() {
    this.asExpr().(MethodCall).getTarget() = any(SystemNetDnsClass dns).getGetHostByAddressMethod()
  }
}

pragma[noinline]
private predicate conditionControlsCall0(
  SensitiveExecutionMethodCall call, Expr e, ControlFlow::SuccessorTypes::BooleanSuccessor s
) {
  forex(BasicBlock bb | bb = call.getAControlFlowNode().getBasicBlock() | e.controlsBlock(bb, s, _))
}

private predicate conditionControlsCall(
  SensitiveExecutionMethodCall call, SensitiveExecutionMethod def, Expr e, boolean cond
) {
  exists(ControlFlow::SuccessorTypes::BooleanSuccessor s | cond = s.getValue() |
    conditionControlsCall0(call, e, s)
  ) and
  def = call.getTarget().getUnboundDeclaration()
}

/**
 * Calls to a sensitive method that are controlled by a condition
 * on the given expression.
 */
predicate conditionControlsMethod(SensitiveExecutionMethodCall call, Expr e) {
  exists(SensitiveExecutionMethod def, boolean cond |
    conditionControlsCall(call, def, e, cond) and
    // Exclude this condition if the other branch also contains a call to the same security
    // sensitive method.
    not conditionControlsCall(_, def, e, cond.booleanNot())
  )
}

/**
 * An expression which is a condition which controls access to a sensitive action.
 */
class ConditionControllingSensitiveAction extends Sink {
  private MethodCall sensitiveMethodCall;

  ConditionControllingSensitiveAction() {
    // A condition used to guard a sensitive method call
    conditionControlsMethod(sensitiveMethodCall, this.getExpr())
    or
    // A condition used to guard a sensitive method call, where the condition is `EndsWith`,
    // `StartsWith` or `Contains` on a tainted value. Tracking from strings to booleans doesn't
    // make sense in all contexts, so this is restricted to this case.
    exists(MethodCall stringComparisonCall, string methodName |
      methodName = "EndsWith" or
      methodName = "StartsWith" or
      methodName = "Contains"
    |
      stringComparisonCall = any(SystemStringClass s).getAMethod(methodName).getACall() and
      conditionControlsMethod(sensitiveMethodCall, stringComparisonCall) and
      stringComparisonCall.getQualifier() = this.getExpr()
    )
  }

  override MethodCall getSensitiveMethodCall() { result = sensitiveMethodCall }
}
