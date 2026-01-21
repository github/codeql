/**
 * @name Summarize calls to vulnerable methods
 * @description Exports methods that transitively call vulnerable methods in a format
 *              suitable for model generation and iterative dependency analysis.
 * @kind table
 * @id binary/vulnerable-calls-summarize
 */

import VulnerableCalls
import semmle.code.binary.ast.ir.IR

/**
 * Exports all methods that can reach vulnerable calls.
 * Output format matches the vulnerableCallModel extensible predicate for iterative analysis.
 */
query predicate vulnerableCallModel(string namespace, string className, string methodName, string id) {
  ExportedVulnerableCalls::pathToVulnerableMethod(namespace, className, methodName, id)
}

/**
 * Exports only public methods that reach vulnerable calls (for API surface analysis).
 */
query predicate publicVulnerableCallModel(
  string namespace, string className, string methodName, string id
) {
  ExportedVulnerableCalls::publicPathToVulnerableMethod(namespace, className, methodName, id)
}

/**
 * Lists the direct vulnerable call sites with their enclosing method context.
 */
query predicate vulnerableCallLocations(
  VulnerableMethodCall call, string callerNamespace, string callerClassName,
  string callerMethodName, string targetFqn, string id
) {
  call.getVulnerabilityId() = id and
  call.getEnclosingFunction()
      .hasFullyQualifiedName(callerNamespace, callerClassName, callerMethodName) and
  targetFqn = call.getTargetOperand().getAnyDef().(ExternalRefInstruction).getFullyQualifiedName()
}
