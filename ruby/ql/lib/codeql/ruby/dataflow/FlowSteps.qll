/**
 * Provides classes representing various flow steps for dataflow and taint tracking.
 */

private import codeql.ruby.DataFlow
private import internal.DataFlowPrivate as DFPrivate

private class Unit = DFPrivate::Unit;

/**
 * A module importing the frameworks that implement additional flow steps,
 * ensuring that they are visible to the dataflow and taint tracking libraries.
 */
private module Frameworks {
  import codeql.ruby.frameworks.StringFormatters
  import codeql.ruby.frameworks.Rails
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

// TODO: this class is not applied to all configurations by default.
/**
 * A unit class for adding additional flow steps.
 *
 * Extend this class to add additional flow steps that can be used by all
 * dataflow configurations.
 */
class AdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}
