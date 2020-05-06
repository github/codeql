/**
 * Provides classes for reasoning about type annotations independently of dialect.
 */

import javascript
private import internal.StmtContainers

/**
 * A type annotation, either in the form of a TypeScript type or a JSDoc comment.
 */
class TypeAnnotation extends @type_annotation, NodeInStmtContainer {
  /** Holds if this is the `any` type. */
  predicate isAny() { none() }

  /** Holds if this is the `string` type. Does not hold for the (rarely used) `String` type. */
  predicate isString() { none() }

  /** Holds if this is the `string` or `String` type. */
  predicate isStringy() { none() }

  /** Holds if this is the `number` type. Does not hold for the (rarely used) `Number` type. */
  predicate isNumber() { none() }

  /** Holds if this is the `number` or `Number`s type. */
  predicate isNumbery() { none() }

  /** Holds if this is the `boolean` type. Does not hold for the (rarely used) `Boolean` type. */
  predicate isBoolean() { none() }

  /** Holds if this is the `boolean` or `Boolean` type. */
  predicate isBooleany() { none() }

  /** Holds if this is the `undefined` type. */
  predicate isUndefined() { none() }

  /** Holds if this is the `null` type. */
  predicate isNull() { none() }

  /** Holds if this is the `void` type. */
  predicate isVoid() { none() }

  /** Holds if this is the `never` type, or an equivalent type representing the empty set of values. */
  predicate isNever() { none() }

  /** Holds if this is the `this` type. */
  predicate isThis() { none() }

  /** Holds if this is the `symbol` type. */
  predicate isSymbol() { none() }

  /** Holds if this is the `unique symbol` type. */
  predicate isUniqueSymbol() { none() }

  /** Holds if this is the `Function` type. */
  predicate isRawFunction() { none() }

  /** Holds if this is the `object` type. */
  predicate isObjectKeyword() { none() }

  /** Holds if this is the `unknown` type. */
  predicate isUnknownKeyword() { none() }

  /** Holds if this is the `bigint` type. */
  predicate isBigInt() { none() }

  /** Holds if this is the `const` keyword, occurring in a type assertion such as `x as const`. */
  predicate isConstKeyword() { none() }

  /**
   * Repeatedly unfolds unions, intersections, parentheses, and nullability/readonly modifiers and gets any of the underlying types,
   * or this type itself if it cannot be unfolded.
   *
   * Note that this only unfolds the syntax of the type annotation. Type aliases are not followed to their definition.
   */
  TypeAnnotation getAnUnderlyingType() { result = this }

  /**
   * Holds if this is a reference to the type with qualified name `globalName` relative to the global scope.
   */
  predicate hasQualifiedName(string globalName) { none() }

  /**
   * Holds if this is a reference to the type exported from `moduleName` under the name `exportedName`.
   */
  predicate hasQualifiedName(string moduleName, string exportedName) { none() }

  /** Gets the statement in which this type appears. */
  Stmt getEnclosingStmt() { none() }

  /** Gets the function in which this type appears, if any. */
  Function getEnclosingFunction() { none() }

  /**
   * Gets the top-level containing this type annotation.
   */
  TopLevel getTopLevel() { none() }

  /**
   * Gets the static type denoted by this type annotation, if one is provided by the extractor.
   *
   * Note that this has no result for JSDoc type annotations.
   */
  Type getType() { none() }

  /**
   * Gets the class referenced by this type annotation, if any.
   *
   * This unfolds nullability modifiers and generic type applications.
   */
  DataFlow::ClassNode getClass() { none() }
}
