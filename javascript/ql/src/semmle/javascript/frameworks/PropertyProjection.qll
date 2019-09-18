/**
 * Provides classes for modelling property projection functions.
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
class PropertyProjection extends DataFlow::CallNode {
  PropertyProjection::Range self;

  PropertyProjection() { this = self }

  /**
   * Gets the argument for the object to project properties from, such as `o` in `_.get(o, 'a.b')`.
   */
  DataFlow::Node getObject() { result = self.getObject() }

  /**
   * Gets an argument that selects the properties to project, such as `'a.b'` in `_.get(o, 'a.b')`.
   */
  DataFlow::Node getASelector() { result = self.getASelector() }

  /**
   * Holds if this call returns the value of a single projected property, as opposed to an object that can contain multiple projected properties.
   *
   * Examples:
   * - This predicate holds for `_.get({a: 'b'}, 'a')`, which returns `'b'`,
   * - This predicate does not hold for `_.pick({a: 'b', c: 'd'}}, 'a')`, which returns `{a: 'b'}`,
   */
  predicate isSingletonProjection() { self.isSingletonProjection() }
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

deprecated class CustomPropertyProjection = PropertyProjection::Range;

/**
 * A simple model of common property projection functions.
 */
private class SimplePropertyProjection extends PropertyProjection::Range {
  int objectIndex;
  int selectorIndex;
  boolean singleton;

  SimplePropertyProjection() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      singleton = false and
      (
        callee = LodashUnderscore::member("pick") and
        objectIndex = 0 and
        selectorIndex = [1 .. getNumArgument()]
        or
        callee = LodashUnderscore::member("pickBy") and
        objectIndex = 0 and
        selectorIndex = 1
        or
        exists(string name |
          name = "pick" or
          name = "pickAll" or
          name = "pickBy"
        |
          callee = DataFlow::moduleMember("ramda", name) and
          objectIndex = 1 and
          selectorIndex = 0
        )
        or
        callee = DataFlow::moduleMember("dotty", "search") and
        objectIndex = 0 and
        selectorIndex = 1
      )
      or
      singleton = true and
      (
        callee = LodashUnderscore::member("get") and
        objectIndex = 0 and
        selectorIndex = 1
        or
        callee = DataFlow::moduleMember("ramda", "path") and
        objectIndex = 1 and
        selectorIndex = 0
        or
        callee = DataFlow::moduleMember("dottie", "get") and
        objectIndex = 0 and
        selectorIndex = 1
        or
        callee = DataFlow::moduleMember("dotty", "get") and
        objectIndex = 0 and
        selectorIndex = 1
      )
    )
  }

  override DataFlow::Node getObject() { result = getArgument(objectIndex) }

  override DataFlow::Node getASelector() { result = getArgument(selectorIndex) }

  override predicate isSingletonProjection() { singleton = true }
}

/**
 * A taint step for a property projection.
 */
private class PropertyProjectionTaintStep extends TaintTracking::AdditionalTaintStep {
  PropertyProjection projection;

  PropertyProjectionTaintStep() { projection = this }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    // reading from a tainted object yields a tainted result
    this = succ and
    pred = projection.getObject()
  }
}
