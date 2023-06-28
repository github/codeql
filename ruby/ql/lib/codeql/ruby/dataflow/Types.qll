/**
 * Provides an extension point for modeling type definitions
 */

private import codeql.ruby.dataflow.internal.DataFlowPublic as DataFlow
// Need to import since frameworks can extend `TypeSummary::Range`
private import codeql.ruby.Frameworks

/**
 * A type definition.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `TypeDefinition::Range` instead.
 */
class TypeDefinition extends DataFlow::Node instanceof TypeDefinition::Range {
  /** Gets a string that describes the defined type. */
  string getInstanceType() { result = super.getInstanceType() }
}

/** Provides a class for modeling new type definitions. */
module TypeDefinition {
  /**
   * A type definition.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `TypeDefinition` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets a string that describes the defined type. */
    abstract string getInstanceType();
  }
}
