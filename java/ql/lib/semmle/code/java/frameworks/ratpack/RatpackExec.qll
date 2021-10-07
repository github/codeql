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
      ["ratpack.exec;Promise;true;"] +
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
          // 'next' accesses qualfier the 'Promise' value and also returns the qualifier
          "next;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "next;;;Argument[-1];ReturnValue;value",
          // 'cacheIf' accesses qualfier the 'Promise' value and also returns the qualifier
          "cacheIf;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "cacheIf;;;Argument[-1];ReturnValue;value",
          // 'route' accesses qualfier the 'Promise' value, and conditionally returns the qualifier or
          // the result of the second argument
          "route;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "route;;;Element of Argument[-1];Parameter[0] of Argument[1];value",
          "route;;;Argument[-1];ReturnValue;value",
          // `flatMap` type methods return their returned `Promise`
          "flatMap;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "flatMap;;;Element of ReturnValue of Argument[0];Element of ReturnValue;value",
          "flatMapError;;;Element of ReturnValue of Argument[1];Element of ReturnValue;value",
          // `mapIf` methods conditionally map their values, or return themselves
          "mapIf;;;Element of Argument[-1];Parameter[0] of Argument[0];value",
          "mapIf;;;Element of Argument[-1];Parameter[0] of Argument[1];value",
          "mapIf;;;Element of Argument[-1];Parameter[0] of Argument[2];value",
          "mapIf;;;ReturnValue of Argument[1];Element of ReturnValue;value",
          "mapIf;;;ReturnValue of Argument[2];Element of ReturnValue;value"
        ]
  }
}

/** A reference type that extends a parameterization the Promise type. */
private class RatpackPromise extends RefType {
  RatpackPromise() {
    getSourceDeclaration().getASourceSupertype*().hasQualifiedName("ratpack.exec", "Promise")
  }
}

/**
 * Ratpack `Promise` method that will return `this`.
 */
private class RatpackPromiseFluentMethod extends FluentMethod {
  RatpackPromiseFluentMethod() {
    getDeclaringType() instanceof RatpackPromise and
    not isStatic() and
    // It's generally safe to assume that if the return type exactly matches the declaring type, `this` will be returned.
    exists(ParameterizedType t |
      t instanceof RatpackPromise and
      t = getDeclaringType() and
      t = getReturnType()
    )
  }
}
