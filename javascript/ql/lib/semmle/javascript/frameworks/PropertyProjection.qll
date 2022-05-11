/**
 * Provides classes for modeling property projection functions.
 *
 * Subclass `PropertyProjection` to refine the behavior of the analysis on existing property projections.
 * Subclass `CustomPropertyProjection` to introduce new kinds of property projections.
 */

import javascript

/**
 * A property projection call such as `_.get(o, 'a.b')`, which is equivalent to `o.a.b`.
 *
 * Extend this class to work with property project APIs for which there is already a model.
 * To model additional APIs, extend `PropertyProjection::Range` and implement its abstract member
 * predicates.
 */
class PropertyProjection extends DataFlow::CallNode instanceof PropertyProjection::Range {
  /**
   * Gets the argument for the object to project properties from, such as `o` in `_.get(o, 'a.b')`.
   */
  DataFlow::Node getObject() { result = super.getObject() }

  /**
   * Gets an argument that selects the properties to project, such as `'a.b'` in `_.get(o, 'a.b')`.
   */
  DataFlow::Node getASelector() { result = super.getASelector() }

  /**
   * Holds if this call returns the value of a single projected property, as opposed to an object that can contain multiple projected properties.
   *
   * Examples:
   * - This predicate holds for `_.get({a: 'b'}, 'a')`, which returns `'b'`,
   * - This predicate does not hold for `_.pick({a: 'b', c: 'd'}}, 'a')`, which returns `{a: 'b'}`,
   */
  predicate isSingletonProjection() { super.isSingletonProjection() }
}

module PropertyProjection {
  /**
   * A property projection call such as `_.get(o, 'a.b')`, which is equivalent to `o.a.b`.
   *
   * Extends this class to add support for new property projection APIs.
   */
  abstract class Range extends DataFlow::CallNode {
    /**
     * Gets the argument for the object to project properties from, such as `o` in `_.get(o, 'a.b')`.
     */
    abstract DataFlow::Node getObject();

    /**
     * Gets an argument that selects the properties to project, such as `'a.b'` in `_.get(o, 'a.b')`.
     */
    abstract DataFlow::Node getASelector();

    /**
     * Holds if this call returns the value of a single projected property, as opposed to an object that can contain multiple projected properties.
     */
    abstract predicate isSingletonProjection();
  }
}

/**
 * Gets a callee of a simple property projection call.
 * This predicate is used exclusively in `SimplePropertyProjection`.
 */
pragma[noinline]
private DataFlow::SourceNode getASimplePropertyProjectionCallee(
  boolean singleton, int selectorIndex, int objectIndex
) {
  singleton = false and
  (
    result = LodashUnderscore::member("pickBy") and
    objectIndex = 0 and
    selectorIndex = 1
    or
    result = DataFlow::moduleMember("ramda", ["pick", "pickAll", "pickBy"]) and
    objectIndex = 1 and
    selectorIndex = 0
    or
    result = DataFlow::moduleMember("dotty", "search") and
    objectIndex = 0 and
    selectorIndex = 1
  )
  or
  singleton = true and
  (
    result = LodashUnderscore::member("get") and
    objectIndex = 0 and
    selectorIndex = 1
    or
    result = DataFlow::moduleMember("ramda", "path") and
    objectIndex = 1 and
    selectorIndex = 0
    or
    result = DataFlow::moduleMember("dottie", "get") and
    objectIndex = 0 and
    selectorIndex = 1
    or
    result = DataFlow::moduleMember("dotty", "get") and
    objectIndex = 0 and
    selectorIndex = 1
  )
}

/**
 * A simple model of common property projection functions.
 */
private class SimplePropertyProjection extends PropertyProjection::Range {
  int objectIndex;
  int selectorIndex;
  boolean singleton;

  SimplePropertyProjection() {
    this = getASimplePropertyProjectionCallee(singleton, selectorIndex, objectIndex).getACall()
  }

  override DataFlow::Node getObject() { result = getArgument(objectIndex) }

  override DataFlow::Node getASelector() { result = getArgument(selectorIndex) }

  override predicate isSingletonProjection() { singleton = true }
}

/**
 * A property projection with a variable number of selector indices.
 */
private class VarArgsPropertyProjection extends PropertyProjection::Range {
  VarArgsPropertyProjection() { this = LodashUnderscore::member("pick").getACall() }

  override DataFlow::Node getObject() { result = getArgument(0) }

  override DataFlow::Node getASelector() { result = getArgument(any(int i | i > 0)) }

  override predicate isSingletonProjection() { none() }
}

/**
 * A taint step for a property projection.
 */
private class PropertyProjectionTaintStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    // reading from a tainted object yields a tainted result
    exists(PropertyProjection projection |
      pred = projection.getObject() and
      succ = projection
    )
  }
}
