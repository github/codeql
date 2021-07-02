/**
 * Provides an extension point for for modeling sensitive data, such as secrets, certificates, or passwords.
 * Sensitive data can be interesting to use as data-flow sources in security queries.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
// Need to import `semmle.python.Frameworks` since frameworks can extend `SensitiveDataSource::Range`
private import semmle.python.Frameworks
private import semmle.python.security.internal.SensitiveDataHeuristics as SensitiveDataHeuristics

// We export these explicitly, so we don't also export the `HeuristicNames` module.
class SensitiveDataClassification = SensitiveDataHeuristics::SensitiveDataClassification;

module SensitiveDataClassification = SensitiveDataHeuristics::SensitiveDataClassification;

/**
 * A data flow source of sensitive data, such as secrets, certificates, or passwords.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SensitiveDataSource::Range` instead.
 */
class SensitiveDataSource extends DataFlow::Node {
  SensitiveDataSource::Range range;

  SensitiveDataSource() { this = range }

  /**
   * Gets the classification of the sensitive data.
   */
  SensitiveDataClassification getClassification() { result = range.getClassification() }
}

/** Provides a class for modeling new sources of sensitive data, such as secrets, certificates, or passwords. */
module SensitiveDataSource {
  /**
   * A data flow source of sensitive data, such as secrets, certificates, or passwords.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SensitiveDataSource` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the classification of the sensitive data.
     */
    abstract SensitiveDataClassification getClassification();
  }
}

/** Actual sensitive data modeling */
private module SensitiveDataModeling {
  private import SensitiveDataHeuristics::HeuristicNames

  /**
   * Gets a reference to a function that is considered to be a sensitive source of
   * `classification`.
   */
  private DataFlow::TypeTrackingNode sensitiveFunction(
    DataFlow::TypeTracker t, SensitiveDataClassification classification
  ) {
    t.start() and
    exists(Function f |
      nameIndicatesSensitiveData(f.getName(), classification) and
      result.asExpr() = f.getDefinition()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = sensitiveFunction(t2, classification).track(t2, t))
  }

  /**
   * Gets a reference to a function that is considered to be a sensitive source of
   * `classification`.
   */
  DataFlow::Node sensitiveFunction(SensitiveDataClassification classification) {
    sensitiveFunction(DataFlow::TypeTracker::end(), classification).flowsTo(result)
  }

  /**
   * Gets a reference to a string constant that, if used as the key in a lookup,
   * indicates the presence of sensitive data with `classification`.
   */
  private DataFlow::TypeTrackingNode sensitiveLookupStringConst(
    DataFlow::TypeTracker t, SensitiveDataClassification classification
  ) {
    t.start() and
    nameIndicatesSensitiveData(result.asExpr().(StrConst).getText(), classification)
    or
    exists(DataFlow::TypeTracker t2 |
      result = sensitiveLookupStringConst(t2, classification).track(t2, t)
    )
  }

  /**
   * Gets a reference to a string constant that, if used as the key in a lookup,
   * indicates the presence of sensitive data with `classification`.
   *
   * Also see `extraStepForCalls`.
   */
  DataFlow::Node sensitiveLookupStringConst(SensitiveDataClassification classification) {
    sensitiveLookupStringConst(DataFlow::TypeTracker::end(), classification).flowsTo(result)
  }

  /** A function call that is considered a source of sensitive data. */
  class SensitiveFunctionCall extends SensitiveDataSource::Range, DataFlow::CallCfgNode {
    SensitiveDataClassification classification;

    SensitiveFunctionCall() {
      this.getFunction() = sensitiveFunction(classification)
      or
      // to cover functions that we don't have the definition for, and where the
      // reference to the function has not already been marked as being sensitive
      nameIndicatesSensitiveData(this.getFunction().asCfgNode().(NameNode).getId(), classification)
    }

    override SensitiveDataClassification getClassification() { result = classification }
  }

  /**
   * Tracks any modeled source of sensitive data (with any classification),
   * to limit the scope of `extraStepForCalls`. See it's QLDoc for more context.
   */
  private DataFlow::TypeTrackingNode possibleSensitiveCallable(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof SensitiveDataSource
    or
    exists(DataFlow::TypeTracker t2 | result = possibleSensitiveCallable(t2).track(t2, t))
  }

  /**
   * Tracks any modeled source of sensitive data (with any classification),
   * to limit the scope of `extraStepForCalls`. See it's QLDoc for more context.
   */
  private DataFlow::Node possibleSensitiveCallable() {
    possibleSensitiveCallable(DataFlow::TypeTracker::end()).flowsTo(result)
  }

  /**
   * Holds if the step from `nodeFrom` to `nodeTo` should be considered a
   * taint-flow step for sensitive-data, to ensure calls are handled correctly.
   *
   * To handle calls properly, while preserving a good source for path explanations,
   * you need to include this predicate as an additional taint step in your taint-tracking
   * configurations.
   *
   * The core problem can be illustrated by the example below. If we consider the
   * `print` a sink, what path and what source do we want to show? My initial approach
   * would be to use type-tracking to propagate from the `not_found.get_passwd` attribute
   * lookup, to the use of `non_sensitive_name`, and then create a new `SensitiveDataSource::Range`
   * like `SensitiveFunctionCall`. Although that seems likely to work, it will also end up
   * with a non-optimal path, which starts at _bad source_, and therefore doesn't show
   * how we figured out that `non_sensitive_name`
   * could be a function that returns a password (and in cases where there is many calls to
   * `my_func` it will be annoying for someone to figure this out manually).
   *
   * By including this additional taint-step in the taint-tracking configuration, it's possible
   * to get a path explanation going from _good source_ to the sink.
   *
   * ```python
   * def my_func(non_sensitive_name):
   *     x = non_sensitive_name() # <-- bad source
   *     print(x) # <-- sink
   *
   * import not_found
   * f = not_found.get_passwd # <-- good source
   * my_func(f)
   * ```
   */
  predicate extraStepForCalls(DataFlow::Node nodeFrom, DataFlow::CallCfgNode nodeTo) {
    // However, we do still use the type-tracking approach to limit the size of this
    // predicate.
    nodeTo.getFunction() = nodeFrom and
    nodeFrom = possibleSensitiveCallable()
  }

  /**
   * Any kind of variable assignment (also including with/for) where the name indicates
   * it contains sensitive data.
   *
   * Note: We _could_ make any access to a variable with a sensitive name a source of
   * sensitive data, but to make path explanations in data-flow/taint-tracking good,
   * we don't want that, since it works against allowing users to understand the flow
   * in the program (which is the whole point).
   *
   * Note: To make data-flow/taint-tracking work, the expression that is _assigned_ to
   * the variable is marked as the source (as compared to marking the variable as the
   * source).
   */
  class SensitiveVariableAssignment extends SensitiveDataSource::Range {
    SensitiveDataClassification classification;

    SensitiveVariableAssignment() {
      exists(DefinitionNode def |
        nameIndicatesSensitiveData(def.(NameNode).getId(), classification) and
        (
          this.asCfgNode() = def.getValue()
          or
          this.asCfgNode() = def.getValue().(ForNode).getSequence()
        ) and
        not this.asExpr() instanceof FunctionExpr and
        not this.asExpr() instanceof ClassExpr
      )
      or
      exists(With with |
        nameIndicatesSensitiveData(with.getOptionalVars().(Name).getId(), classification) and
        this.asExpr() = with.getContextExpr()
      )
    }

    override SensitiveDataClassification getClassification() { result = classification }
  }

  /** An attribute access that is considered a source of sensitive data. */
  class SensitiveAttributeAccess extends SensitiveDataSource::Range {
    SensitiveDataClassification classification;

    SensitiveAttributeAccess() {
      // Things like `foo.<sensitive-name>` or `from <module> import <sensitive-name>`
      // I considered excluding any `from ... import something_sensitive`, but then realized that
      // we should flag up `form ... import password as ...` as a password
      nameIndicatesSensitiveData(this.(DataFlow::AttrRead).getAttributeName(), classification)
      or
      // Things like `getattr(foo, <reference-to-string>)`
      this.(DataFlow::AttrRead).getAttributeNameExpr() = sensitiveLookupStringConst(classification)
    }

    override SensitiveDataClassification getClassification() { result = classification }
  }

  /** A subscript, where the key indicates the result will be sensitive data. */
  class SensitiveSubscript extends SensitiveDataSource::Range {
    SensitiveDataClassification classification;

    SensitiveSubscript() {
      this.asCfgNode().(SubscriptNode).getIndex() =
        sensitiveLookupStringConst(classification).asCfgNode()
    }

    override SensitiveDataClassification getClassification() { result = classification }
  }

  /** A call to `get` on an object, where the key indicates the result will be sensitive data. */
  class SensitiveGetCall extends SensitiveDataSource::Range, DataFlow::CallCfgNode {
    SensitiveDataClassification classification;

    SensitiveGetCall() {
      this.getFunction().(DataFlow::AttrRef).getAttributeName() = "get" and
      this.getArg(0) = sensitiveLookupStringConst(classification)
    }

    override SensitiveDataClassification getClassification() { result = classification }
  }

  /** A parameter where the name indicates it will receive sensitive data. */
  class SensitiveParameter extends SensitiveDataSource::Range, DataFlow::ParameterNode {
    SensitiveDataClassification classification;

    SensitiveParameter() {
      nameIndicatesSensitiveData(this.getParameter().getName(), classification)
    }

    override SensitiveDataClassification getClassification() { result = classification }
  }
}

predicate sensitiveDataExtraStepForCalls = SensitiveDataModeling::extraStepForCalls/2;
