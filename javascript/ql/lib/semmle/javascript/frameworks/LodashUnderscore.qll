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
      this = DataFlow::moduleMember(["underscore", "lodash", "lodash-es"], name)
      or
      this = DataFlow::moduleImport(["lodash/", "lodash-es/"] + name)
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
    name =
      [
        "templateSettings", "after", "ary", "assign", "assignIn", "assignInWith", "assignWith",
        "at", "before", "bind", "bindAll", "bindKey", "castArray", "chain", "chunk", "compact",
        "concat", "cond", "conforms", "constant", "countBy", "create", "curry", "curryRight",
        "debounce", "defaults", "defaultsDeep", "defer", "delay", "difference", "differenceBy",
        "differenceWith", "drop", "dropRight", "dropRightWhile", "dropWhile", "fill", "filter",
        "flatMap", "flatMapDeep", "flatMapDepth", "flatten", "flattenDeep", "flattenDepth", "flip",
        "flow", "flowRight", "fromPairs", "functions", "functionsIn", "groupBy", "initial",
        "intersection", "intersectionBy", "intersectionWith", "invert", "invertBy", "invokeMap",
        "iteratee", "keyBy", "keys", "keysIn", "map", "mapKeys", "mapValues", "matches",
        "matchesProperty", "memoize", "merge", "mergeWith", "method", "methodOf", "mixin", "negate",
        "nthArg", "omit", "omitBy", "once", "orderBy", "over", "overArgs", "overEvery", "overSome",
        "partial", "partialRight", "partition", "pick", "pickBy", "property", "propertyOf", "pull",
        "pullAll", "pullAllBy", "pullAllWith", "pullAt", "range", "rangeRight", "rearg", "reject",
        "remove", "rest", "reverse", "sampleSize", "set", "setWith", "shuffle", "slice", "sortBy",
        "sortedUniq", "sortedUniqBy", "split", "spread", "tail", "take", "takeRight",
        "takeRightWhile", "takeWhile", "tap", "throttle", "thru", "toArray", "toPairs", "toPairsIn",
        "toPath", "toPlainObject", "transform", "unary", "union", "unionBy", "unionWith", "uniq",
        "uniqBy", "uniqWith", "unset", "unzip", "unzipWith", "update", "updateWith", "values",
        "valuesIn", "without", "words", "wrap", "xor", "xorBy", "xorWith", "zip", "zipObject",
        "zipObjectDeep", "zipWith", "entries", "entriesIn", "extend", "extendWith", "add",
        "attempt", "camelCase", "capitalize", "ceil", "clamp", "clone", "cloneDeep",
        "cloneDeepWith", "cloneWith", "conformsTo", "deburr", "defaultTo", "divide", "endsWith",
        "eq", "escape", "escapeRegExp", "every", "find", "findIndex", "findKey", "findLast",
        "findLastIndex", "findLastKey", "floor", "forEach", "forEachRight", "forIn", "forInRight",
        "forOwn", "forOwnRight", "get", "gt", "gte", "has", "hasIn", "head", "identity", "includes",
        "indexOf", "inRange", "invoke", "isArguments", "isArray", "isArrayBuffer", "isArrayLike",
        "isArrayLikeObject", "isBoolean", "isBuffer", "isDate", "isElement", "isEmpty", "isEqual",
        "isEqualWith", "isError", "isFinite", "isFunction", "isInteger", "isLength", "isMap",
        "isMatch", "isMatchWith", "isNaN", "isNative", "isNil", "isNull", "isNumber", "isObject",
        "isObjectLike", "isPlainObject", "isRegExp", "isSafeInteger", "isSet", "isString",
        "isSymbol", "isTypedArray", "isUndefined", "isWeakMap", "isWeakSet", "join", "kebabCase",
        "last", "lastIndexOf", "lowerCase", "lowerFirst", "lt", "lte", "max", "maxBy", "mean",
        "meanBy", "min", "minBy", "stubArray", "stubFalse", "stubObject", "stubString", "stubTrue",
        "multiply", "nth", "noConflict", "noop", "now", "pad", "padEnd", "padStart", "parseInt",
        "random", "reduce", "reduceRight", "repeat", "replace", "result", "round", "runInContext",
        "sample", "size", "snakeCase", "some", "sortedIndex", "sortedIndexBy", "sortedIndexOf",
        "sortedLastIndex", "sortedLastIndexBy", "sortedLastIndexOf", "startCase", "startsWith",
        "subtract", "sum", "sumBy", "template", "times", "toFinite", "toInteger", "toLength",
        "toLower", "toNumber", "toSafeInteger", "toString", "toUpper", "trim", "trimEnd",
        "trimStart", "truncate", "unescape", "uniqueId", "upperCase", "upperFirst", "each",
        "eachRight", "first"
      ]
  }

  /**
   * A data flow step propagating an exception thrown from a callback to a Lodash/Underscore function.
   */
  private class ExceptionStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call, string name |
        // Members ending with By, With, or While indicate that they are a variant of
        // another function that takes a callback.
        name.matches(["%By", "%With", "%While"])
        or
        // Other members that don't fit the above pattern.
        name =
          [
            "each", "eachRight", "every", "filter", "find", "findLast", "flatMap", "flatMapDeep",
            "flatMapDepth", "forEach", "forEachRight", "partition", "reduce", "reduceRight",
            "replace", "some", "transform"
          ]
      |
        call = member(name).getACall() and
        pred = call.getAnArgument().(DataFlow::FunctionNode).getExceptionalReturn() and
        succ = call.getExceptionalReturn()
      )
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
  private class UnderscoreTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      underscoreTaintStep(pred, succ)
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
  DataFlow::CallNode
{
  int callbackIndex;
  int contextIndex;

  LodashCallbackAsPartialInvoke() {
    exists(string name, int argumentCount |
      this = LodashUnderscore::member(name).getACall() and
      this.getNumArgument() = argumentCount
    |
      name = ["bind", "callback", "iteratee"] and
      callbackIndex = 0 and
      contextIndex = 1 and
      argumentCount = 2
      or
      name =
        [
          "all", "any", "collect", "countBy", "detect", "dropRightWhile", "dropWhile", "each",
          "eachRight", "every", "filter", "find", "findIndex", "findKey", "findLast",
          "findLastIndex", "findLastKey", "forEach", "forEachRight", "forIn", "forInRight",
          "groupBy", "indexBy", "map", "mapKeys", "mapValues", "max", "min", "omit", "partition",
          "pick", "reject", "remove", "select", "some", "sortBy", "sum", "takeRightWhile",
          "takeWhile", "tap", "thru", "times", "unzipWith", "zipWith"
        ] and
      callbackIndex = 1 and
      contextIndex = 2 and
      argumentCount = 3
      or
      name = ["foldl", "foldr", "inject", "reduce", "reduceRight", "transform"] and
      callbackIndex = 1 and
      contextIndex = 3 and
      argumentCount = 4
      or
      name = ["sortedlastIndex", "assign", "eq", "extend", "merge", "sortedIndex", "uniq"] and
      callbackIndex = 2 and
      contextIndex = 3 and
      argumentCount = 4
    )
  }

  override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    callback = this.getArgument(callbackIndex) and
    result = this.getArgument(contextIndex)
  }
}
