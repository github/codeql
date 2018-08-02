/**
 * Provides classes for working with [lodash](https://lodash.com/) and [underscore](http://underscorejs.org/).
 */
import javascript

/** Provides a unified model of [lodash](https://lodash.com/) and [underscore](http://underscorejs.org/). */
module LodashUnderscore {
  /**
   * Gets a data flow node that accesses the given member of `lodash` or `underscore`.
   *
   * In addition to normal imports, this supports per-method imports such as `require("lodash.map")` and `require("lodash/map")`.
   * In addition, the global variable `_` is assumed to refer to `lodash` or `underscore`.
   */
  DataFlow::SourceNode member(string name) {
    result = DataFlow::moduleMember("underscore", name) or
    result = DataFlow::moduleMember("lodash", name) or
    result = DataFlow::moduleImport("lodash/" + name) or
    result = DataFlow::moduleImport("lodash." + name) or
    result = DataFlow::globalVarRef("_").getAPropertyRead(name)
  }
}

/**
 * Flow analysis for `this` expressions inside a function that is called with
 * `_.map` or a similar library function that binds `this` of a callback.
 *
 * However, since the function could be invoked in another way, we additionally
 * still infer the ordinary abstract value.
 */
private class AnalyzedThisInBoundCallback extends AnalyzedValueNode, DataFlow::ThisNode {

  AnalyzedValueNode thisSource;

  AnalyzedThisInBoundCallback() {
    exists(DataFlow::CallNode bindingCall, string binderName, int callbackIndex, int contextIndex, int argumentCount |
      bindingCall = LodashUnderscore::member(binderName).getACall() and
      bindingCall.getNumArgument() = argumentCount and
      getBinder() = bindingCall.getCallback(callbackIndex) and
      thisSource = bindingCall.getArgument(contextIndex) |
      (
        (
          binderName = "bind" or
          binderName = "callback" or
          binderName = "iteratee"
        ) and
        callbackIndex = 0 and
        contextIndex = 1 and
        argumentCount = 2
      ) or
      (
        (
          binderName = "all" or
          binderName = "any" or
          binderName = "collect" or
          binderName = "countBy" or
          binderName = "detect" or
          binderName = "dropRightWhile" or
          binderName = "dropWhile" or
          binderName = "each" or
          binderName = "eachRight" or
          binderName = "every" or
          binderName = "filter" or
          binderName = "find" or
          binderName = "findIndex" or
          binderName = "findKey" or
          binderName = "findLast" or
          binderName = "findLastIndex" or
          binderName = "findLastKey" or
          binderName = "forEach" or
          binderName = "forEachRight" or
          binderName = "forIn" or
          binderName = "forInRight" or
          binderName = "groupBy" or
          binderName = "indexBy" or
          binderName = "map" or
          binderName = "mapKeys" or
          binderName = "mapValues" or
          binderName = "max" or
          binderName = "min" or
          binderName = "omit" or
          binderName = "partition" or
          binderName = "pick" or
          binderName = "reject" or
          binderName = "remove" or
          binderName = "select" or
          binderName = "some" or
          binderName = "sortBy" or
          binderName = "sum" or
          binderName = "takeRightWhile" or
          binderName = "takeWhile" or
          binderName = "tap" or
          binderName = "thru" or
          binderName = "times" or
          binderName = "unzipWith" or
          binderName = "zipWith"
        ) and
        callbackIndex = 1 and
        contextIndex = 2 and
        argumentCount = 3
      ) or (
        (
          binderName = "foldl" or
          binderName = "foldr" or
          binderName = "inject" or
          binderName = "reduce" or
          binderName = "reduceRight" or
          binderName = "transform"
        ) and
        callbackIndex = 1 and
        contextIndex = 3 and
        argumentCount = 4
      ) or (
        (
          binderName = "sortedlastIndex" or
          binderName = "assign" or
          binderName = "eq" or
          binderName = "extend" or
          binderName = "merge" or
          binderName = "sortedIndex" and
          binderName = "uniq"
        ) and
        callbackIndex = 2 and
        contextIndex = 3 and
        argumentCount = 4
      )
    )
  }

  override AbstractValue getALocalValue() {
    result = thisSource.getALocalValue() or
    result = AnalyzedValueNode.super.getALocalValue()
  }

}
