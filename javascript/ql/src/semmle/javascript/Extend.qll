/**
 * Provides classes for reasoning about `extend`-like functions.
 */

import javascript

/**
 * A call to an `extend`-like function, which copies properties from
 * one or more objects into another object, and returns the result.
 */
abstract class ExtendCall extends DataFlow::CallNode {
  /**
   * Gets an object from which properties are taken.
   */
  abstract DataFlow::Node getASourceOperand();

  /**
   * Gets the object into which properties are stored, if any.
   */
  abstract DataFlow::Node getDestinationOperand();

  /**
   * Holds if the copying operation recursively copies nested objects
   * into the destination.
   */
  abstract predicate isDeep();

  /**
   * Gets an object from which properties are taken or stored.
   */
  DataFlow::Node getAnOperand() {
    result = getASourceOperand() or
    result = getDestinationOperand()
  }
}

/** A version of `JQuery::dollarSource()` with fewer dependencies. */
private DataFlow::SourceNode localDollar() {
  result.accessesGlobal(["$", "jQuery"])
  or
  result = DataFlow::moduleImport("jquery")
}

/**
 * An extend call of form `extend(true/false, dst, src1, src2, ...)`, where the true/false
 * argument is possibly omitted.
 */
private class ExtendCallWithFlag extends ExtendCall {
  ExtendCallWithFlag() {
    exists(string name | this = DataFlow::moduleImport(name).getACall() |
      name = "extend" or
      name = "extend2" or
      name = "just-extend" or
      name = "node.extend"
    )
    or
    this = localDollar().getAMemberCall("extend")
  }

  /**
   * Holds if the first argument appears to be a boolean flag.
   */
  predicate hasFlag() { getArgument(0).mayHaveBooleanValue(_) }

  /**
   * Gets the `n`th argument after the optional boolean flag.
   */
  DataFlow::Node getTranslatedArgument(int n) {
    if hasFlag() then result = getArgument(n + 1) else result = getArgument(n)
  }

  override DataFlow::Node getASourceOperand() {
    exists(int n | n >= 1 | result = getTranslatedArgument(n))
  }

  override DataFlow::Node getDestinationOperand() { result = getTranslatedArgument(0) }

  override predicate isDeep() { getArgument(0).mayHaveBooleanValue(true) }
}

/**
 * A deep extend call of form `extend(dst, src1, src2, ...)`.
 */
private class ExtendCallDeep extends ExtendCall {
  ExtendCallDeep() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      callee = DataFlow::moduleMember("deep", "extend") or
      callee = DataFlow::moduleImport("deep-assign") or
      callee = DataFlow::moduleImport("deep-extend") or
      callee = DataFlow::moduleImport("deep-merge").getACall() or
      callee = DataFlow::moduleImport("deepmerge") or
      callee = DataFlow::moduleImport("defaults-deep") or
      callee = DataFlow::moduleMember("js-extend", "extend") or
      callee = DataFlow::moduleMember("merge", "recursive") or
      callee = DataFlow::moduleImport("merge-deep") or
      callee = DataFlow::moduleImport("merge-options") or
      callee = DataFlow::moduleImport("mixin-deep") or
      callee = DataFlow::moduleMember("ramda", "mergeDeepLeft") or
      callee = DataFlow::moduleMember("ramda", "mergeDeepRight") or
      callee = DataFlow::moduleMember("smart-extend", "deep") or
      callee = LodashUnderscore::member("merge") or
      callee = LodashUnderscore::member("mergeWith") or
      callee = LodashUnderscore::member("defaultsDeep") or
      callee = AngularJS::angular().getAPropertyRead("merge")
    )
  }

  override DataFlow::Node getASourceOperand() { exists(int n | n >= 1 | result = getArgument(n)) }

  override DataFlow::Node getDestinationOperand() { result = getArgument(0) }

  override predicate isDeep() { any() }
}

/**
 * A shallow extend call of form `extend(dst, src1, src2, ...)`.
 */
private class ExtendCallShallow extends ExtendCall {
  ExtendCallShallow() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      callee = DataFlow::globalVarRef("Object").getAPropertyRead("assign") or
      callee = DataFlow::moduleImport("defaults") or
      callee = DataFlow::moduleImport("extend-shallow") or
      callee = DataFlow::moduleImport("merge") or
      callee = DataFlow::moduleImport("mixin-object") or
      callee = DataFlow::moduleImport("object-assign") or
      callee = DataFlow::moduleImport("object.assign") or
      callee = DataFlow::moduleImport("object.defaults") or
      callee = DataFlow::moduleImport("smart-extend") or
      callee = DataFlow::moduleImport("util-extend") or
      callee = DataFlow::moduleImport("utils-merge") or
      callee = DataFlow::moduleImport("xtend/mutable") or
      callee = LodashUnderscore::member("extend") or
      callee = AngularJS::angular().getAPropertyRead("extend")
    )
  }

  override DataFlow::Node getASourceOperand() { exists(int n | n >= 1 | result = getArgument(n)) }

  override DataFlow::Node getDestinationOperand() { result = getArgument(0) }

  override predicate isDeep() { none() }
}

/**
 * A shallow extend call of form `extend(src1, src2, ...)`.
 */
private class FunctionalExtendCallShallow extends ExtendCall {
  FunctionalExtendCallShallow() {
    exists(DataFlow::SourceNode callee | this = callee.getACall() |
      callee = DataFlow::moduleImport("xtend") or
      callee = DataFlow::moduleImport("xtend/immutable") or
      callee = DataFlow::moduleMember("ramda", "merge")
    )
  }

  override DataFlow::Node getASourceOperand() { result = getAnArgument() }

  override DataFlow::Node getDestinationOperand() { none() }

  override predicate isDeep() { none() }
}

/**
 * A taint propagating data flow edge from the objects flowing into an extend call to its return value
 * and to the source of the destination object.
 */
private class ExtendCallTaintStep extends TaintTracking::AdditionalTaintStep {
  ExtendCall extend;

  ExtendCallTaintStep() { this = extend }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = extend.getASourceOperand() and succ = extend.getDestinationOperand().getALocalSource()
    or
    pred = extend.getAnOperand() and succ = extend
  }
}
