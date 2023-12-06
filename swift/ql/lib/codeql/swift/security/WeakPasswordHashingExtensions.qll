/**
 * Provides classes and predicates for reasoning about use of inappropriate
 * cryptographic hashing algorithms on passwords.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.security.WeakSensitiveDataHashingExtensions

/**
 * A dataflow sink for weak password hashing vulnerabilities. That is,
 * a `DataFlow::Node` that is passed into a weak password hashing function.
 */
abstract class WeakPasswordHashingSink extends DataFlow::Node {
  /**
   * Gets the name of the hashing algorithm, for display.
   */
  abstract string getAlgorithm();
}

/**
 * A barrier for weak password hashing vulnerabilities.
 */
abstract class WeakPasswordHashingBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class WeakPasswordHashingAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to weak password hashing vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink inherited from weak sensitive data hashing. Password hashing has
 * stronger requirements than sensitive data hashing, since (in addition to
 * its particular qualities) a password *is* sensitive data. Thus, any sink
 * for the weak sensitive data hashing query is a sink for weak password
 * hashing as well.
 */
private class InheritedWeakPasswordHashingSink extends WeakPasswordHashingSink {
 InheritedWeakPasswordHashingSink() {
   this instanceof WeakSensitiveDataHashingSink
 }

 override string getAlgorithm() { result = this.(WeakSensitiveDataHashingSink).getAlgorithm() }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultWeakPasswordHashingSink extends WeakPasswordHashingSink {
  string algorithm;

  DefaultWeakPasswordHashingSink() {
    sinkNode(this, "weak-password-hash-input-" + algorithm)
  }

  override string getAlgorithm() { result = algorithm }
}
