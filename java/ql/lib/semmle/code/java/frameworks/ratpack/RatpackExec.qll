/**
 * Provides classes and predicates related to `ratpack.exec.*`.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Model for Ratpack `Promise` methods.
 */
private class RatpackExecModel extends SummaryModelCsv {
  override predicate row(string row) {
    //"namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind",
    row =
      "ratpack.exec;Promise;true;" +
        [
          // `Promise` creation methods
          "value;;;Argument[0];ReturnValue.Element;value",
          "flatten;;;Argument[0].ReturnValue.Element;ReturnValue.Element;value",
          "sync;;;Argument[0].ReturnValue;ReturnValue.Element;value",
          // `Promise` value transformation methods
          "map;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "map;;;Argument[0].ReturnValue;ReturnValue.Element;value",
          "blockingMap;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "blockingMap;;;Argument[0].ReturnValue;ReturnValue.Element;value",
          "mapError;;;Argument[1].ReturnValue;ReturnValue.Element;value",
          // `apply` passes the qualifier to the function as the first argument
          "apply;;;Argument[-1].Element;Argument[0].Parameter[0].Element;value",
          "apply;;;Argument[0].ReturnValue.Element;ReturnValue.Element;value",
          // `Promise` termination method
          "then;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          // 'next' accesses qualifier the 'Promise' value and also returns the qualifier
          "next;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "nextOp;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "flatOp;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          // `nextOpIf` accesses qualifier the 'Promise' value and also returns the qualifier
          "nextOpIf;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "nextOpIf;;;Argument[-1].Element;Argument[1].Parameter[0];value",
          // 'cacheIf' accesses qualifier the 'Promise' value and also returns the qualifier
          "cacheIf;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          // 'route' accesses qualifier the 'Promise' value, and conditionally returns the qualifier or
          // the result of the second argument
          "route;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "route;;;Argument[-1].Element;Argument[1].Parameter[0];value",
          "route;;;Argument[-1];ReturnValue;value",
          // `flatMap` type methods return their returned `Promise`
          "flatMap;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "flatMap;;;Argument[0].ReturnValue.Element;ReturnValue.Element;value",
          "flatMapError;;;Argument[1].ReturnValue.Element;ReturnValue.Element;value",
          // `blockingOp` passes the value to the argument
          "blockingOp;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          // `replace` returns the passed `Promise`
          "replace;;;Argument[0].Element;ReturnValue.Element;value",
          // `mapIf` methods conditionally map their values, or return themselves
          "mapIf;;;Argument[-1].Element;Argument[0].Parameter[0];value",
          "mapIf;;;Argument[-1].Element;Argument[1].Parameter[0];value",
          "mapIf;;;Argument[-1].Element;Argument[2].Parameter[0];value",
          "mapIf;;;Argument[1].ReturnValue;ReturnValue.Element;value",
          "mapIf;;;Argument[2].ReturnValue;ReturnValue.Element;value",
          // `wiretap` wraps the qualifier `Promise` value in a `Result` and passes it to the argument
          "wiretap;;;Argument[-1].Element;Argument[0].Parameter[0].Element;value"
        ]
    or
    exists(string left, string right |
      left = "Field[ratpack.func.Pair.left]" and
      right = "Field[ratpack.func.Pair.right]"
    |
      row =
        "ratpack.exec;Promise;true;" +
          [
            // `left`, `right`, `flatLeft`, `flatRight` all pass the qualifier `Promise` element as the other `Pair` field
            "left;;;Argument[-1].Element;ReturnValue.Element." + right + ";value",
            "right;;;Argument[-1].Element;ReturnValue.Element." + left + ";value",
            "flatLeft;;;Argument[-1].Element;ReturnValue.Element." + right + ";value",
            "flatRight;;;Argument[-1].Element;ReturnValue.Element." + left + ";value",
            // `left` and `right` taking a `Promise` create a `Promise` of the `Pair`
            "left;(Promise);;Argument[0].Element;ReturnValue.Element." + left + ";value",
            "right;(Promise);;Argument[0].Element;ReturnValue.Element." + right + ";value",
            // `left` and `right` taking a `Function` pass the qualifier element then create a `Pair` with the returned value
            "left;(Function);;Argument[-1].Element;Argument[0].Parameter[0];value",
            "flatLeft;(Function);;Argument[-1].Element;Argument[0].Parameter[0];value",
            "right;(Function);;Argument[-1].Element;Argument[0].Parameter[0];value",
            "flatRight;(Function);;Argument[-1].Element;Argument[0].Parameter[0];value",
            "left;(Function);;Argument[0].ReturnValue;ReturnValue.Element." + left + ";value",
            "flatLeft;(Function);;Argument[0].ReturnValue.Element;ReturnValue.Element." + left +
              ";value",
            "right;(Function);;Argument[0].ReturnValue;ReturnValue.Element." + right + ";value",
            "flatRight;(Function);;Argument[0].ReturnValue.Element;ReturnValue.Element." + right +
              ";value"
          ]
    )
    or
    row =
      "ratpack.exec;Result;true;" +
        [
          "success;;;Argument[0];ReturnValue.Element;value",
          "getValue;;;Argument[-1].Element;ReturnValue;value",
          "getValueOrThrow;;;Argument[-1].Element;ReturnValue;value"
        ]
  }
}

/** A reference type that extends a parameterization the Promise type. */
private class RatpackPromise extends RefType {
  RatpackPromise() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("ratpack.exec", "Promise")
  }
}

/**
 * Ratpack `Promise` method that will return `this`.
 */
private class RatpackPromiseFluentMethod extends FluentMethod {
  RatpackPromiseFluentMethod() {
    not this.isStatic() and
    // It's generally safe to assume that if the return type exactly matches the declaring type, `this` will be returned.
    exists(ParameterizedType t |
      t instanceof RatpackPromise and
      t = this.getDeclaringType() and
      t = this.getReturnType()
    )
  }
}
