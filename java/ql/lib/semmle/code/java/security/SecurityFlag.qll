/**
 * Provides utility predicates to spot variable names, parameter names, and string literals that suggest deliberately insecure settings.
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources

/**
 * A kind of flag that may indicate security expectations regarding the code it guards.
 */
abstract class FlagKind extends string {
  bindingset[this]
  FlagKind() { any() }

  /**
   * Gets a flag name of this type.
   */
  bindingset[result]
  abstract string getAFlagName();

  private predicate flagFlowStepTC(DataFlow::Node node1, DataFlow::Node node2) {
    node2 = node1 and
    this.isFlagWithName(node1)
    or
    exists(DataFlow::Node nodeMid |
      flagFlowStep(nodeMid, node2) and
      this.flagFlowStepTC(node1, nodeMid)
    )
  }

  private predicate isFlagWithName(DataFlow::Node flag) {
    exists(VarAccess v | v.getVariable().getName() = this.getAFlagName() |
      flag.asExpr() = v and v.getType() instanceof FlagType
    )
    or
    exists(StringLiteral s | s.getValue() = this.getAFlagName() | flag.asExpr() = s)
    or
    exists(MethodCall ma | ma.getMethod().getName() = this.getAFlagName() |
      flag.asExpr() = ma and
      ma.getType() instanceof FlagType
    )
  }

  /** Gets a node representing a (likely) security flag. */
  DataFlow::Node getAFlag() {
    exists(DataFlow::Node flag |
      this.isFlagWithName(flag) and
      this.flagFlowStepTC(flag, result)
    )
  }
}

/**
 * Flags suggesting an optional feature, perhaps deliberately insecure.
 */
private class SecurityFeatureFlag extends FlagKind {
  SecurityFeatureFlag() { this = "SecurityFeatureFlag" }

  bindingset[result]
  override string getAFlagName() { result.regexpMatch("(?i).*(secure|(en|dis)able).*") }
}

/**
 * A flag has to either be of type `String`, `boolean` or `Boolean`.
 */
private class FlagType extends Type {
  FlagType() {
    this instanceof TypeString
    or
    this instanceof BooleanType
  }
}

/**
 * Holds if there is local flow from `node1` to `node2` either due to standard data-flow steps or the
 * following custom flow steps:
 * 1. `Boolean.parseBoolean(taintedValue)` taints the return value of `parseBoolean`.
 * 2. A call to an `EnvReadMethod` such as `System.getProperty` where a tainted value is used as an argument.
 *    The return value of such a method is then tainted.
 */
private predicate flagFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlow::localFlowStep(node1, node2)
  or
  exists(MethodCall ma | ma.getMethod() = any(EnvReadMethod m) |
    ma = node2.asExpr() and ma.getAnArgument() = node1.asExpr()
  )
  or
  exists(MethodCall ma |
    ma.getMethod().hasName("parseBoolean") and
    ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "Boolean")
  |
    ma = node2.asExpr() and ma.getAnArgument() = node1.asExpr()
  )
}

/** Gets a guard that represents a (likely) security feature-flag check. */
Guard getASecurityFeatureFlagGuard() { result = any(SecurityFeatureFlag flag).getAFlag().asExpr() }
