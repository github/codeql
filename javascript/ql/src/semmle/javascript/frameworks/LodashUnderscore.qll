/**
 * Provides classes for working with [lodash](https://lodash.com/) and [underscore](http://underscorejs.org/).
 */

import javascript

/** Provides a unified model of [lodash](https://lodash.com/) and [underscore](http://underscorejs.org/). */
module LodashUnderscore {
  /**
   * A data flow node that accesses a given member of `lodash` or `underscore`.
   */
  abstract class Member extends DataFlow::SourceNode {
    /** Gets the name of the accessed member. */
    abstract string getName();
  }

  /**
   * An import of `lodash` or `underscore` accessing a given member of that package.
   */
  private class DefaultMember extends Member {
    string name;

    DefaultMember() {
      this = DataFlow::moduleMember("underscore", name)
      or
      this = DataFlow::moduleMember("lodash", name)
      or
      this = DataFlow::moduleImport("lodash/" + name)
      or
      this = DataFlow::moduleImport("lodash." + name.toLowerCase()) and isLodashMember(name)
      or
      this = DataFlow::globalVarRef("_").getAPropertyRead(name)
    }

    override string getName() { result = name }
  }

  /**
   * Gets a data flow node that accesses the given member of `lodash` or `underscore`.
   *
   * In addition to normal imports, this supports per-method imports such as `require("lodash.map")` and `require("lodash/map")`.
   * In addition, the global variable `_` is assumed to refer to `lodash` or `underscore`.
   */
  DataFlow::SourceNode member(string name) { result.(Member).getName() = name }

  /**
   * Holds if `name` is the name of a member exported from the `lodash` package
   * which has a corresponding `lodash.xxx` NPM package.
   */
  private predicate isLodashMember(string name) {
    // Can be generated using Object.keys(require('lodash'))
    name = "templateSettings" or
    name = "after" or
    name = "ary" or
    name = "assign" or
    name = "assignIn" or
    name = "assignInWith" or
    name = "assignWith" or
    name = "at" or
    name = "before" or
    name = "bind" or
    name = "bindAll" or
    name = "bindKey" or
    name = "castArray" or
    name = "chain" or
    name = "chunk" or
    name = "compact" or
    name = "concat" or
    name = "cond" or
    name = "conforms" or
    name = "constant" or
    name = "countBy" or
    name = "create" or
    name = "curry" or
    name = "curryRight" or
    name = "debounce" or
    name = "defaults" or
    name = "defaultsDeep" or
    name = "defer" or
    name = "delay" or
    name = "difference" or
    name = "differenceBy" or
    name = "differenceWith" or
    name = "drop" or
    name = "dropRight" or
    name = "dropRightWhile" or
    name = "dropWhile" or
    name = "fill" or
    name = "filter" or
    name = "flatMap" or
    name = "flatMapDeep" or
    name = "flatMapDepth" or
    name = "flatten" or
    name = "flattenDeep" or
    name = "flattenDepth" or
    name = "flip" or
    name = "flow" or
    name = "flowRight" or
    name = "fromPairs" or
    name = "functions" or
    name = "functionsIn" or
    name = "groupBy" or
    name = "initial" or
    name = "intersection" or
    name = "intersectionBy" or
    name = "intersectionWith" or
    name = "invert" or
    name = "invertBy" or
    name = "invokeMap" or
    name = "iteratee" or
    name = "keyBy" or
    name = "keys" or
    name = "keysIn" or
    name = "map" or
    name = "mapKeys" or
    name = "mapValues" or
    name = "matches" or
    name = "matchesProperty" or
    name = "memoize" or
    name = "merge" or
    name = "mergeWith" or
    name = "method" or
    name = "methodOf" or
    name = "mixin" or
    name = "negate" or
    name = "nthArg" or
    name = "omit" or
    name = "omitBy" or
    name = "once" or
    name = "orderBy" or
    name = "over" or
    name = "overArgs" or
    name = "overEvery" or
    name = "overSome" or
    name = "partial" or
    name = "partialRight" or
    name = "partition" or
    name = "pick" or
    name = "pickBy" or
    name = "property" or
    name = "propertyOf" or
    name = "pull" or
    name = "pullAll" or
    name = "pullAllBy" or
    name = "pullAllWith" or
    name = "pullAt" or
    name = "range" or
    name = "rangeRight" or
    name = "rearg" or
    name = "reject" or
    name = "remove" or
    name = "rest" or
    name = "reverse" or
    name = "sampleSize" or
    name = "set" or
    name = "setWith" or
    name = "shuffle" or
    name = "slice" or
    name = "sortBy" or
    name = "sortedUniq" or
    name = "sortedUniqBy" or
    name = "split" or
    name = "spread" or
    name = "tail" or
    name = "take" or
    name = "takeRight" or
    name = "takeRightWhile" or
    name = "takeWhile" or
    name = "tap" or
    name = "throttle" or
    name = "thru" or
    name = "toArray" or
    name = "toPairs" or
    name = "toPairsIn" or
    name = "toPath" or
    name = "toPlainObject" or
    name = "transform" or
    name = "unary" or
    name = "union" or
    name = "unionBy" or
    name = "unionWith" or
    name = "uniq" or
    name = "uniqBy" or
    name = "uniqWith" or
    name = "unset" or
    name = "unzip" or
    name = "unzipWith" or
    name = "update" or
    name = "updateWith" or
    name = "values" or
    name = "valuesIn" or
    name = "without" or
    name = "words" or
    name = "wrap" or
    name = "xor" or
    name = "xorBy" or
    name = "xorWith" or
    name = "zip" or
    name = "zipObject" or
    name = "zipObjectDeep" or
    name = "zipWith" or
    name = "entries" or
    name = "entriesIn" or
    name = "extend" or
    name = "extendWith" or
    name = "add" or
    name = "attempt" or
    name = "camelCase" or
    name = "capitalize" or
    name = "ceil" or
    name = "clamp" or
    name = "clone" or
    name = "cloneDeep" or
    name = "cloneDeepWith" or
    name = "cloneWith" or
    name = "conformsTo" or
    name = "deburr" or
    name = "defaultTo" or
    name = "divide" or
    name = "endsWith" or
    name = "eq" or
    name = "escape" or
    name = "escapeRegExp" or
    name = "every" or
    name = "find" or
    name = "findIndex" or
    name = "findKey" or
    name = "findLast" or
    name = "findLastIndex" or
    name = "findLastKey" or
    name = "floor" or
    name = "forEach" or
    name = "forEachRight" or
    name = "forIn" or
    name = "forInRight" or
    name = "forOwn" or
    name = "forOwnRight" or
    name = "get" or
    name = "gt" or
    name = "gte" or
    name = "has" or
    name = "hasIn" or
    name = "head" or
    name = "identity" or
    name = "includes" or
    name = "indexOf" or
    name = "inRange" or
    name = "invoke" or
    name = "isArguments" or
    name = "isArray" or
    name = "isArrayBuffer" or
    name = "isArrayLike" or
    name = "isArrayLikeObject" or
    name = "isBoolean" or
    name = "isBuffer" or
    name = "isDate" or
    name = "isElement" or
    name = "isEmpty" or
    name = "isEqual" or
    name = "isEqualWith" or
    name = "isError" or
    name = "isFinite" or
    name = "isFunction" or
    name = "isInteger" or
    name = "isLength" or
    name = "isMap" or
    name = "isMatch" or
    name = "isMatchWith" or
    name = "isNaN" or
    name = "isNative" or
    name = "isNil" or
    name = "isNull" or
    name = "isNumber" or
    name = "isObject" or
    name = "isObjectLike" or
    name = "isPlainObject" or
    name = "isRegExp" or
    name = "isSafeInteger" or
    name = "isSet" or
    name = "isString" or
    name = "isSymbol" or
    name = "isTypedArray" or
    name = "isUndefined" or
    name = "isWeakMap" or
    name = "isWeakSet" or
    name = "join" or
    name = "kebabCase" or
    name = "last" or
    name = "lastIndexOf" or
    name = "lowerCase" or
    name = "lowerFirst" or
    name = "lt" or
    name = "lte" or
    name = "max" or
    name = "maxBy" or
    name = "mean" or
    name = "meanBy" or
    name = "min" or
    name = "minBy" or
    name = "stubArray" or
    name = "stubFalse" or
    name = "stubObject" or
    name = "stubString" or
    name = "stubTrue" or
    name = "multiply" or
    name = "nth" or
    name = "noConflict" or
    name = "noop" or
    name = "now" or
    name = "pad" or
    name = "padEnd" or
    name = "padStart" or
    name = "parseInt" or
    name = "random" or
    name = "reduce" or
    name = "reduceRight" or
    name = "repeat" or
    name = "replace" or
    name = "result" or
    name = "round" or
    name = "runInContext" or
    name = "sample" or
    name = "size" or
    name = "snakeCase" or
    name = "some" or
    name = "sortedIndex" or
    name = "sortedIndexBy" or
    name = "sortedIndexOf" or
    name = "sortedLastIndex" or
    name = "sortedLastIndexBy" or
    name = "sortedLastIndexOf" or
    name = "startCase" or
    name = "startsWith" or
    name = "subtract" or
    name = "sum" or
    name = "sumBy" or
    name = "template" or
    name = "times" or
    name = "toFinite" or
    name = "toInteger" or
    name = "toLength" or
    name = "toLower" or
    name = "toNumber" or
    name = "toSafeInteger" or
    name = "toString" or
    name = "toUpper" or
    name = "trim" or
    name = "trimEnd" or
    name = "trimStart" or
    name = "truncate" or
    name = "unescape" or
    name = "uniqueId" or
    name = "upperCase" or
    name = "upperFirst" or
    name = "each" or
    name = "eachRight" or
    name = "first"
  }

  /**
   * A data flow step propagating an exception thrown from a callback to a Lodash/Underscore function.
   */
  private class ExceptionStep extends DataFlow::CallNode, DataFlow::AdditionalFlowStep {
    ExceptionStep() {
      exists(string name | this = member(name).getACall() |
        // Members ending with By, With, or While indicate that they are a variant of
        // another function that takes a callback.
        name.matches("%By") or
        name.matches("%With") or
        name.matches("%While") or
        // Other members that don't fit the above pattern.
        name = "each" or
        name = "eachRight" or
        name = "every" or
        name = "filter" or
        name = "find" or
        name = "findLast" or
        name = "flatMap" or
        name = "flatMapDeep" or
        name = "flatMapDepth" or
        name = "forEach" or
        name = "forEachRight" or
        name = "partition" or
        name = "reduce" or
        name = "reduceRight" or
        name = "replace" or
        name = "some" or
        name = "transform"
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getAnArgument().(DataFlow::FunctionNode).getExceptionalReturn() and
      succ = this.getExceptionalReturn()
    }
  }

  /**
   * Holds if there is a taint-step involving a (non-function) underscore method from `pred` to `succ`.
   */
  private predicate underscoreTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(string name, DataFlow::CallNode call |
      call = any(Member member | member.getName() = name).getACall()
    |
      name =
        [
          "find", "filter", "findWhere", "where", "reject", "pluck", "max", "min", "sortBy",
          "shuffle", "sample", "toArray", "partition", "compact", "first", "initial", "last",
          "rest", "flatten", "without", "difference", "uniq", "unique", "unzip", "transpose",
          "object", "chunk", "values", "mapObject", "pick", "omit", "defaults", "clone", "tap",
          "identity",
          // String category
          "camelCase", "capitalize", "deburr", "kebabCase", "lowerCase", "lowerFirst", "pad",
          "padEnd", "padStart", "repeat", "replace", "snakeCase", "split", "startCase", "toLower",
          "toUpper", "trim", "trimEnd", "trimStart", "truncate", "unescape", "upperCase",
          "upperFirst", "words"
        ] and
      pred = call.getArgument(0) and
      succ = call
      or
      name = ["union", "zip"] and
      pred = call.getAnArgument() and
      succ = call
      or
      name =
        ["each", "map", "every", "some", "max", "min", "sortBy", "partition", "mapObject", "tap"] and
      pred = call.getArgument(0) and
      succ = call.getABoundCallbackParameter(1, 0)
      or
      name = ["reduce", "reduceRight"] and
      pred = call.getArgument(0) and
      succ = call.getABoundCallbackParameter(1, 1)
      or
      name = ["map", "reduce", "reduceRight"] and
      pred = call.getCallback(1).getAReturn() and
      succ = call
    )
  }

  /**
   * A model for taint-steps involving (non-function) underscore methods.
   */
  private class UnderscoreTaintStep extends TaintTracking::AdditionalTaintStep {
    UnderscoreTaintStep() { underscoreTaintStep(this, _) }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      underscoreTaintStep(pred, succ) and pred = this
    }
  }
}

/**
 * Flow analysis for `this` expressions inside a function that is called with
 * `_.map` or a similar library function that binds `this` of a callback.
 *
 * However, since the function could be invoked in another way, we additionally
 * still infer the ordinary abstract value.
 */
private class LodashCallbackAsPartialInvoke extends DataFlow::PartialInvokeNode::Range,
  DataFlow::CallNode {
  int callbackIndex;
  int contextIndex;

  LodashCallbackAsPartialInvoke() {
    exists(string name, int argumentCount |
      this = LodashUnderscore::member(name).getACall() and
      getNumArgument() = argumentCount
    |
      (
        name = "bind" or
        name = "callback" or
        name = "iteratee"
      ) and
      callbackIndex = 0 and
      contextIndex = 1 and
      argumentCount = 2
      or
      (
        name = "all" or
        name = "any" or
        name = "collect" or
        name = "countBy" or
        name = "detect" or
        name = "dropRightWhile" or
        name = "dropWhile" or
        name = "each" or
        name = "eachRight" or
        name = "every" or
        name = "filter" or
        name = "find" or
        name = "findIndex" or
        name = "findKey" or
        name = "findLast" or
        name = "findLastIndex" or
        name = "findLastKey" or
        name = "forEach" or
        name = "forEachRight" or
        name = "forIn" or
        name = "forInRight" or
        name = "groupBy" or
        name = "indexBy" or
        name = "map" or
        name = "mapKeys" or
        name = "mapValues" or
        name = "max" or
        name = "min" or
        name = "omit" or
        name = "partition" or
        name = "pick" or
        name = "reject" or
        name = "remove" or
        name = "select" or
        name = "some" or
        name = "sortBy" or
        name = "sum" or
        name = "takeRightWhile" or
        name = "takeWhile" or
        name = "tap" or
        name = "thru" or
        name = "times" or
        name = "unzipWith" or
        name = "zipWith"
      ) and
      callbackIndex = 1 and
      contextIndex = 2 and
      argumentCount = 3
      or
      (
        name = "foldl" or
        name = "foldr" or
        name = "inject" or
        name = "reduce" or
        name = "reduceRight" or
        name = "transform"
      ) and
      callbackIndex = 1 and
      contextIndex = 3 and
      argumentCount = 4
      or
      (
        name = "sortedlastIndex"
        or
        name = "assign"
        or
        name = "eq"
        or
        name = "extend"
        or
        name = "merge"
        or
        name = "sortedIndex" and
        name = "uniq"
      ) and
      callbackIndex = 2 and
      contextIndex = 3 and
      argumentCount = 4
    )
  }

  override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    callback = getArgument(callbackIndex) and
    result = getArgument(contextIndex)
  }
}
