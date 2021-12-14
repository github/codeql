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
          "value;;;Argument[0];Element of ReturnValue;value",
          "flatten;;;Element of ReturnValue of Argument[0];Element of ReturnValue;value",
          "sync;;;ReturnValue of Argument[0];Element of ReturnValue;value",
          // `Promise` value transformation methods
          "map;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "map;;;ReturnValue of Argument[0];Element of ReturnValue;value",
          "blockingMap;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "blockingMap;;;ReturnValue of Argument[0];Element of ReturnValue;value",
          "mapError;;;ReturnValue of Argument[1];Element of ReturnValue;value",
          // `apply` passes the qualifier to the function as the first argument
          "apply;;;Element of Argument[-1];Element of Parameter[0] of Argument[0];value",
          "apply;;;Element of ReturnValue of Argument[0];Element of ReturnValue;value",
          // `Promise` termination method
          "then;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          // 'next' accesses qualifier the 'Promise' value and also returns the qualifier
          "next;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "nextOp;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "flatOp;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          // `nextOpIf` accesses qualifier the 'Promise' value and also returns the qualifier
          "nextOpIf;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "nextOpIf;;;Element of Argument[-1];Parameter[0] of Argument[1];value",
          // 'cacheIf' accesses qualifier the 'Promise' value and also returns the qualifier
          "cacheIf;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          // 'route' accesses qualifier the 'Promise' value, and conditionally returns the qualifier or
          // the result of the second argument
          "route;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "route;;;Element of Argument[-1];Parameter[0] of Argument[1];value",
          "route;;;Argument[-1];ReturnValue;value",
          // `flatMap` type methods return their returned `Promise`
          "flatMap;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "flatMap;;;Element of ReturnValue of Argument[0];Element of ReturnValue;value",
          "flatMapError;;;Element of ReturnValue of Argument[1];Element of ReturnValue;value",
          // `blockingOp` passes the value to the argument
          "blockingOp;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          // `replace` returns the passed `Promise`
          "replace;;;Element of Argument[0];Element of ReturnValue;value",
          // `mapIf` methods conditionally map their values, or return themselves
          "mapIf;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "mapIf;;;Element of Argument[-1];Parameter[0] of Argument[1];value",
          "mapIf;;;Element of Argument[-1];Parameter[0] of Argument[2];value",
          "mapIf;;;ReturnValue of Argument[1];Element of ReturnValue;value",
          "mapIf;;;ReturnValue of Argument[2];Element of ReturnValue;value",
          // `wiretap` wraps the qualifier `Promise` value in a `Result` and passes it to the argument
          "wiretap;;;Element of Argument[-1];Element of Parameter[0] of Argument[0];value"
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
            "left;;;Element of Argument[-1];" + right + " of Element of ReturnValue;value",
            "right;;;Element of Argument[-1];" + left + " of Element of ReturnValue;value",
            "flatLeft;;;Element of Argument[-1];" + right + " of Element of ReturnValue;value",
            "flatRight;;;Element of Argument[-1];" + left + " of Element of ReturnValue;value",
            // `left` and `right` taking a `Promise` create a `Promise` of the `Pair`
            "left;(Promise);;Element of Argument[0];" + left + " of Element of ReturnValue;value",
            "right;(Promise);;Element of Argument[0];" + right + " of Element of ReturnValue;value",
            // `left` and `right` taking a `Function` pass the qualifier element then create a `Pair` with the returned value
            "left;(Function);;Element of Argument[-1];Parameter[0] of Argument[0];value",
            "flatLeft;(Function);;Element of Argument[-1];Parameter[0] of Argument[0];value",
            "right;(Function);;Element of Argument[-1];Parameter[0] of Argument[0];value",
            "flatRight;(Function);;Element of Argument[-1];Parameter[0] of Argument[0];value",
            "left;(Function);;ReturnValue of Argument[0];" + left +
              " of Element of ReturnValue;value",
            "flatLeft;(Function);;Element of ReturnValue of Argument[0];" + left +
              " of Element of ReturnValue;value",
            "right;(Function);;ReturnValue of Argument[0];" + right +
              " of Element of ReturnValue;value",
            "flatRight;(Function);;Element of ReturnValue of Argument[0];" + right +
              " of Element of ReturnValue;value"
          ]
    )
    or
    row =
      "ratpack.exec;Result;true;" +
        [
          "success;;;Argument[0];Element of ReturnValue;value",
          "getValue;;;Element of Argument[-1];ReturnValue;value",
          "getValueOrThrow;;;Element of Argument[-1];ReturnValue;value"
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
