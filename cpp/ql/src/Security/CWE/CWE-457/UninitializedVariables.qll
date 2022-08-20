/**
 * A module for identifying conditionally initialized variables.
 */

import cpp
import InitializationFunctions

// Optimised reachability predicates
private predicate reaches(ControlFlowNode a, ControlFlowNode b) = fastTC(successor/2)(a, b)

private predicate successor(ControlFlowNode a, ControlFlowNode b) { b = a.getASuccessor() }

class WhitelistedCallsConfig extends string {
  WhitelistedCallsConfig() { this = "config" }

  abstract predicate isWhitelisted(Call c);
}

abstract class WhitelistedCall extends Call {
  override Function getTarget() { none() }
}

private predicate hasConditionalInitialization(
  ConditionalInitializationFunction f, ConditionalInitializationCall call, LocalVariable v,
  VariableAccess initAccess, Evidence e
) {
  // Ignore whitelisted calls
  not call instanceof WhitelistedCall and
  f = getTarget(call) and
  initAccess = v.getAnAccess() and
  initAccess = call.getAConditionallyInitializedArgument(f, e).(AddressOfExpr).getOperand()
}

/**
 * A variable that can be conditionally initialized by a call.
 */
class ConditionallyInitializedVariable extends LocalVariable {
  ConditionalInitializationCall call;
  ConditionalInitializationFunction f;
  VariableAccess initAccess;
  Evidence e;

  ConditionallyInitializedVariable() {
    // Find a call that conditionally initializes this variable
    hasConditionalInitialization(f, call, this, initAccess, e) and
    // Ignore cases where the variable is assigned prior to the call
    not reaches(this.getAnAssignedValue(), initAccess) and
    // Ignore cases where the variable is assigned field-wise prior to the call.
    not exists(FieldAccess fa |
      exists(Assignment a |
        fa = getAFieldAccess(this) and
        a.getLValue() = fa
      )
    |
      reaches(fa, initAccess)
    ) and
    // Ignore cases where the variable is assigned by a prior call to an initialization function
    not exists(Call c |
      this.getAnAccess() = getAnInitializedArgument(c).(AddressOfExpr).getOperand() and
      reaches(c, initAccess)
    ) and
    /*
     * Static local variables with constant initializers do not have the initializer expr as part of
     * the CFG, but should always be considered as initialized, so exclude them.
     */

    not exists(this.getInitializer().getExpr())
  }

  /**
   * Gets an access of the variable `v` which is not used as an lvalue, and not used as an argument
   * to an initialization function.
   */
  private VariableAccess getAReadAccess() {
    result = this.getAnAccess() and
    // Not used as an lvalue
    not result = any(AssignExpr a).getLValue() and
    // Not passed to another initialization function
    not exists(Call c, int j | j = c.getTarget().(InitializationFunction).initializedParameter() |
      result = c.getArgument(j).(AddressOfExpr).getOperand()
    ) and
    // Not a pointless read
    not result = any(ExprStmt es).getExpr()
  }

  /**
   * Gets a read access of variable `v` that occurs after the `initializingCall`.
   */
  private VariableAccess getAReadAccessAfterCall(ConditionalInitializationCall initializingCall) {
    // Variable associated with this particular call
    call = initializingCall and
    // Access is a meaningful read access
    result = this.getAReadAccess() and
    // Which occurs after the call
    reaches(call, result) and
    /*
     * Ignore risky accesses which are arguments to calls which also include another parameter to
     * the original call. This is an attempt to eliminate results where the "status" can be checked
     * through another parameter that assigned as part of the original call.
     */

    not exists(Call c |
      c.getAnArgument() = result or
      c.getAnArgument().(AddressOfExpr).getOperand() = result
    |
      exists(LocalVariable lv |
        call.getAnArgument().(AddressOfExpr).getOperand() = lv.getAnAccess() and
        not lv = this
      |
        c.getAnArgument() = lv.getAnAccess()
      )
    )
  }

  /**
   * Gets an access to the variable that is risky because the variable may not be initialized after
   * the `call`, and the status of the call is never checked.
   */
  VariableAccess getARiskyAccessWithNoStatusCheck(
    ConditionalInitializationFunction initializingFunction,
    ConditionalInitializationCall initializingCall, Evidence evidence
  ) {
    // Variable associated with this particular call
    call = initializingCall and
    initializingFunction = f and
    e = evidence and
    result = this.getAReadAccessAfterCall(initializingCall) and
    (
      // Access is risky because status return code ignored completely
      call instanceof ExprInVoidContext
      or
      // Access is risky because status return code ignored completely
      exists(LocalVariable status | call = status.getAnAssignedValue() |
        not exists(status.getAnAccess())
      )
    )
  }

  /**
   * Gets an access to the variable that is risky because the variable may not be initialized after
   * the `call`, and the status of the call is only checked after the risky access.
   */
  VariableAccess getARiskyAccessBeforeStatusCheck(
    ConditionalInitializationFunction initializingFunction,
    ConditionalInitializationCall initializingCall, Evidence evidence
  ) {
    // Variable associated with this particular call
    call = initializingCall and
    initializingFunction = f and
    e = evidence and
    result = this.getAReadAccessAfterCall(initializingCall) and
    exists(LocalVariable status, Assignment a |
      a.getRValue() = call and
      call = status.getAnAssignedValue() and
      // There exists a check of the status code
      definitionUsePair(status, a, _) and
      // And the check of the status code does not occur before the risky access
      not exists(VariableAccess statusAccess |
        definitionUsePair(status, a, statusAccess) and
        reaches(statusAccess, result)
      ) and
      // Ignore cases where the assignment to the status code is used directly
      a instanceof ExprInVoidContext and
      /*
       * Ignore risky accesses which are arguments to calls which also include the status code.
       * If both the risky value and status code are passed to a different function, that
       * function is responsible for checking the status code.
       */

      not exists(Call c |
        c.getAnArgument() = result or
        c.getAnArgument().(AddressOfExpr).getOperand() = result
      |
        definitionUsePair(status, a, c.getAnArgument())
      )
    )
  }

  /**
   * Gets an access to the variable that is risky because the variable may not be initialized after
   * the `call`.
   */
  VariableAccess getARiskyAccess(
    ConditionalInitializationFunction initializingFunction,
    ConditionalInitializationCall initializingCall, Evidence evidence
  ) {
    result = this.getARiskyAccessBeforeStatusCheck(initializingFunction, initializingCall, evidence) or
    result = this.getARiskyAccessWithNoStatusCheck(initializingFunction, initializingCall, evidence)
  }
}
