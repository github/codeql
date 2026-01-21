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
 * Holds if `stub` is an iterator/async stub method and `stateMachine` is its
 * corresponding state machine implementation (the MoveNext method).
 *
 * Iterator/async methods in C# are compiled to:
 * 1. A stub method that creates a state machine object
 * 2. A nested class with a MoveNext method containing the actual implementation
 *
 * The pattern is: method `Foo` in class `Bar` creates `Bar.<Foo>d__N`
 * and the impl is in `Bar.<Foo>d__N.MoveNext`
 */
private predicate isStateMachineImplementation(Function stub, Function stateMachine) {
  exists(string stubName, Type stubType, string stateMachineTypeName |
    stubName = stub.getName() and
    stubType = stub.getDeclaringType() and
    stateMachine.getName() = "MoveNext" and
    // The state machine type is nested in the same type as the stub
    // and named <MethodName>d__N
    stateMachineTypeName = stateMachine.getDeclaringType().getName() and
    stateMachineTypeName.matches("<" + stubName + ">d__%") and
    // The state machine's declaring type's namespace should be the stub's type full name
    stateMachine.getDeclaringType().getNamespace() = stubType.getFullName()
  )
}

/**
 * Gets the state machine implementation for an iterator/async stub method.
 */
Function getStateMachineImplementation(Function stub) { isStateMachineImplementation(stub, result) }

/**
 * Gets a method that transitively calls a vulnerable method.
 * This computes the transitive closure of the call graph.
 *
 * Also handles iterator/async methods by linking stub methods to their
 * state machine implementations.
 */
Function getAVulnerableMethod(string id) {
  // Direct call to vulnerable method
  result = getADirectlyVulnerableMethod(id)
  or
  // Transitive: method calls another method that is vulnerable (via ExternalRef for external calls)
  exists(CallInstruction call, Function callee |
    call.getEnclosingFunction() = result and
    callee = getAVulnerableMethod(id) and
    call.getTargetOperand().getAnyDef().(ExternalRefInstruction).getFullyQualifiedName() =
      callee.getFullyQualifiedName()
  )
  or
  // Transitive: method calls another method that is vulnerable (via static target for direct calls)
  exists(CallInstruction call |
    call.getEnclosingFunction() = result and
    call.getStaticTarget() = getAVulnerableMethod(id)
  )
  or
  // Iterator/async: if a state machine's MoveNext is vulnerable,
  // the stub method that creates it is also vulnerable
  exists(Function stateMachine |
    stateMachine = getAVulnerableMethod(id) and
    isStateMachineImplementation(result, stateMachine)
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
