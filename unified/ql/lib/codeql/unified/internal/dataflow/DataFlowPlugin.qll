/**
 * Provides an interface for language-specific data flow rules.
 */

private import unified
private import AllDataFlow
private import codeql.util.Unit
private import DataFlowPluginSwift // ensure overrides are seen

class DataFlowPlugin extends Unit {
  /** Holds if there is a language-specific step from `node1 -> step -> node2`. */
  predicate step(Node node1, Step step, Node node2) { none() }
}
