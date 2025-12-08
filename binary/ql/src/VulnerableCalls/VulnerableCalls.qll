/**
 * Provides predicates for finding calls that transitively make a call to a
 * known-vulnerable method in CIL (C# IL) binaries.
 */

private import binary
private import semmle.code.binary.ast.ir.IR

/**
 * Holds if any call identified by `(namespace, className, methodName)` should be flagged
 * as potentially vulnerable, for reasons explained by the advisory with the given `id`.
 *
 * This is an extensible predicate - values are provided via YAML data extensions.
 */
extensible predicate vulnerableCallModel(
  string namespace, string className, string methodName, string id
);

/**
 * A method call that has been marked as vulnerable by a model.
 */
class VulnerableMethodCall extends CallInstruction {
  string vulnerabilityId;

  VulnerableMethodCall() {
    exists(string namespace, string className, string methodName |
      vulnerableCallModel(namespace, className, methodName, vulnerabilityId) and
      this.getTargetOperand()
          .getAnyDef()
          .(ExternalRefInstruction)
          .hasFullyQualifiedName(namespace, className, methodName)
    )
  }

  /** Gets the vulnerability ID associated with this call. */
  string getVulnerabilityId() { result = vulnerabilityId }
}

/**
 * Gets a call that a model has marked as vulnerable for the reason given by `id`.
 */
VulnerableMethodCall getAVulnerableCallFromModel(string id) { result.getVulnerabilityId() = id }

/**
 * Gets a method that directly contains a vulnerable call.
 */
Function getADirectlyVulnerableMethod(string id) {
  result = getAVulnerableCallFromModel(id).getEnclosingFunction()
}

/**
 * Gets a method that transitively calls a vulnerable method.
 * This computes the transitive closure of the call graph.
 */
Function getAVulnerableMethod(string id) {
  // Direct call to vulnerable method
  result = getADirectlyVulnerableMethod(id)
  or
  // Transitive: method calls another method that is vulnerable
  exists(CallInstruction call, Function callee |
    call.getEnclosingFunction() = result and
    callee = getAVulnerableMethod(id) and
    call.getTargetOperand().getAnyDef().(ExternalRefInstruction).getFullyQualifiedName() =
      callee.getFullyQualifiedName()
  )
}

/**
 * Gets a public method that transitively calls a vulnerable method.
 */
Function getAPublicVulnerableMethod(string id) {
  result = getAVulnerableMethod(id) and
  result.isPublic()
}

/**
 * Module for exporting vulnerable method information in a format suitable for
 * model generation or further analysis.
 */
module ExportedVulnerableCalls {
  /**
   * Holds if `(namespace, className, methodName)` identifies a method that
   * leads to a vulnerable call identified by `id`.
   */
  predicate pathToVulnerableMethod(string namespace, string className, string methodName, string id) {
    exists(Function m |
      m = getAVulnerableMethod(id) and
      m.hasFullyQualifiedName(namespace, className, methodName)
    )
  }

  /**
   * Holds if `(namespace, className, methodName)` identifies a public method
   * that leads to a vulnerable call identified by `id`.
   */
  predicate publicPathToVulnerableMethod(
    string namespace, string className, string methodName, string id
  ) {
    exists(Function m |
      m = getAPublicVulnerableMethod(id) and
      m.hasFullyQualifiedName(namespace, className, methodName)
    )
  }
}
