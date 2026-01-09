/**
 * Provides predicates for finding calls that transitively make a call to a
 * known-vulnerable method in CIL (C# IL) and JVM binaries.
 *
 * Performance optimizations applied:
 * - Materialized intermediate predicates with pragma[nomagic] to prevent
 *   expensive cross-product computations
 * - Direct string matching on getExternalName() instead of SSA traversal
 *   where possible
 * - Separated external reference matching from static target matching
 *   for better join ordering
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

/*
 * ============================================================================
 * Materialized helper predicates for performance
 * ============================================================================
 */

/**
 * Materialized: builds the fully qualified name string for each vulnerable method
 * in the model. This enables efficient string comparison.
 */
pragma[nomagic]
private predicate vulnerableMethodFqn(string fqn, string id) {
  exists(string namespace, string className, string methodName |
    vulnerableCallModel(namespace, className, methodName, id) and
    fqn = namespace + "." + className + "." + methodName
  )
}

/**
 * Materialized: gets ExternalRefInstructions that directly reference vulnerable methods.
 * Uses direct string comparison against getExternalName() to avoid expensive
 * hasFullyQualifiedName() regex parsing.
 */
pragma[nomagic]
private predicate isVulnerableExternalRef(ExternalRefInstruction eri, string id) {
  exists(string fqn |
    vulnerableMethodFqn(fqn, id) and
    eri.getExternalName() = fqn
  )
}

/**
 * Materialized: gets Functions that are marked as vulnerable in the model.
 * Used for matching calls with static targets.
 */
pragma[nomagic]
private predicate isVulnerableFunction(Function f, string id) {
  exists(string namespace, string className, string methodName |
    vulnerableCallModel(namespace, className, methodName, id) and
    f.hasFullyQualifiedName(namespace, className, methodName)
  )
}

/**
 * Materialized: maps ExternalRefInstructions to their enclosing functions.
 * This avoids repeated getEnclosingFunction() lookups in the recursive predicate.
 */
pragma[nomagic]
private predicate externalRefInFunction(ExternalRefInstruction eri, Function f) {
  f = eri.getEnclosingFunction()
}

/**
 * Materialized: maps CallInstructions to their enclosing functions.
 */
pragma[nomagic]
private predicate callInFunction(CallInstruction call, Function f) {
  f = call.getEnclosingFunction()
}

/**
 * Materialized: maps ExternalRefInstructions to their external names.
 */
pragma[nomagic]
private predicate externalRefName(ExternalRefInstruction eri, string name) {
  name = eri.getExternalName()
}

/*
 * ============================================================================
 * Direct vulnerable call detection
 * ============================================================================
 */

/**
 * A method call that has been marked as vulnerable by a model.
 *
 * This class matches calls where either:
 * 1. The static target is a vulnerable function (internal calls)
 * 2. The external reference points to a vulnerable method (external calls)
 */
class VulnerableMethodCall extends CallInstruction {
  string vulnerabilityId;

  VulnerableMethodCall() {
    // Match via static target (more efficient, no SSA traversal)
    isVulnerableFunction(this.getStaticTarget(), vulnerabilityId)
    or
    // Match via external reference for external calls
    exists(ExternalRefInstruction eri |
      isVulnerableExternalRef(eri, vulnerabilityId) and
      this.getTargetOperand().getAnyDef() = eri
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
pragma[nomagic]
Function getADirectlyVulnerableMethod(string id) {
  result = getAVulnerableCallFromModel(id).getEnclosingFunction()
}

/*
 * ============================================================================
 * C# Iterator/Async State Machine handling
 * ============================================================================
 */

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
pragma[nomagic]
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
Function getStateMachineImplementation(Function stub) {
  isStateMachineImplementation(stub, result)
}

/*
 * ============================================================================
 * Optimized call graph edges for transitive closure
 * ============================================================================
 */

/**
 * Materialized: holds if function `caller` contains a call to function `callee`
 * via a static target (direct call, no SSA traversal needed).
 */
pragma[nomagic]
private predicate callsViaStaticTarget(Function caller, Function callee) {
  exists(CallInstruction call |
    callInFunction(call, caller) and
    callee = call.getStaticTarget()
  )
}

/**
 * Materialized: holds if function `caller` contains a call to a function
 * with fully qualified name `calleeFqn` via an external reference.
 */
pragma[nomagic]
private predicate callsViaExternalRef(Function caller, string calleeFqn) {
  exists(CallInstruction call, ExternalRefInstruction eri |
    callInFunction(call, caller) and
    call.getTargetOperand().getAnyDef() = eri and
    externalRefName(eri, calleeFqn)
  )
}

/**
 * Materialized: maps functions to their fully qualified names for join efficiency.
 */
pragma[nomagic]
private predicate functionFqn(Function f, string fqn) {
  fqn = f.getFullyQualifiedName()
}

/*
 * ============================================================================
 * Transitive vulnerable method detection
 * ============================================================================
 */

/**
 * Gets a method that transitively calls a vulnerable method.
 * This computes the transitive closure of the call graph.
 *
 * Also handles iterator/async methods by linking stub methods to their
 * state machine implementations.
 *
 * Performance notes:
 * - Uses materialized helper predicates to avoid repeated expensive operations
 * - Separates static target calls from external reference calls for better join ordering
 * - The recursion is bounded by the call graph depth
 */
Function getAVulnerableMethod(string id) {
  // Base case: direct call to vulnerable method
  result = getADirectlyVulnerableMethod(id)
  or
  // Transitive case 1: method calls a vulnerable method via static target
  exists(Function callee |
    callee = getAVulnerableMethod(id) and
    callsViaStaticTarget(result, callee)
  )
  or
  // Transitive case 2: method calls a vulnerable method via external reference
  exists(Function callee, string calleeFqn |
    callee = getAVulnerableMethod(id) and
    functionFqn(callee, calleeFqn) and
    callsViaExternalRef(result, calleeFqn)
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
pragma[nomagic]
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
