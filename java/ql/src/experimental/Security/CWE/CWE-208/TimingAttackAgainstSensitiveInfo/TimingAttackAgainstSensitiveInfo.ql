/**
 * @name Timing attack against sensitive info
 * @description Use of a non-constant-time verification routine to check the value of an sensitive info,
 *              possibly allowing a timing attack to infer the info's expected value.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/timing-attack-against-sensitive-info
 * @tags security
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** A string for `match` that identifies strings that look like they represent secret data. */
private string suspicious() {
  result =
    [
      "%password%", "%passwd%", "%pwd%", "%refresh%token%", "%secret%token", "%secret%key",
      "%passcode%", "%passphrase%", "%token%", "%secret%", "%credential%", "%UserPass%"
    ]
}

/** A variable that may hold sensitive information, judging by its name. * */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().toLowerCase().matches(suspicious()) and
      not v.isFinal()
    )
  }
}

/** Methods that use a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeEqualsCall extends MethodAccess {
  NonConstantTimeEqualsCall() {
    this.getMethod()
        .hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"]) or
    this.getMethod().hasQualifiedName("java.nio", "ByteBuffer", ["equals", "compareTo"])
  }
}

/** A static method that uses a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeComparisonCall extends StaticMethodAccess {
  NonConstantTimeComparisonCall() {
    this.getMethod().hasQualifiedName("java.util", "Arrays", ["equals", "deepEquals"]) or
    this.getMethod().hasQualifiedName("java.util", "Objects", "deepEquals") or
    this.getMethod()
        .hasQualifiedName("org.apache.commons.lang3", "StringUtils",
          ["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"])
  }
}

/**
 * Holds if `firstObject` and `secondObject` are compared using a method
 * that does not use a constant-time algorithm, for example, `String.equals()`.
 */
private predicate isNonConstantEqualsCallArgument(Expr e) {
  exists(NonConstantTimeEqualsCall call | e = [call.getQualifier(), call.getAnArgument()])
}

/**
 * Holds if `firstInput` and `secondInput` are compared using a static method
 * that does not use a constant-time algorithm, for example, `Arrays.equals()`.
 */
private predicate isNonConstantComparisonCallArgument(Expr p) {
  exists(NonConstantTimeComparisonCall call | p = [call.getArgument(0), call.getArgument(1)])
}

/**
 * A configuration that tracks data flow from variable that may hold sensitive data
 * to methods that compare data using a non-constant-time algorithm.
 */
class NonConstantTimeComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeComparisonConfig() { this = "NonConstantTimeComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CredentialExpr }

  override predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeComparisonConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Possible timing attack against $@ validation.",
  source.getNode(), "time constant"
