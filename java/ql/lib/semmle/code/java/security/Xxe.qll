/** Provides classes to reason about XML eXternal Entity (XXE) vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow

/** A node where insecure XML parsing takes place. */
abstract class XxeSink extends DataFlow::Node { }

/** A node that acts as a sanitizer in configurations realted to XXE vulnerabilities. */
abstract class XxeSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to flows related to
 * XXE vulnerabilities.
 */
class XxeAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for flows related to XXE vulnerabilities.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}
