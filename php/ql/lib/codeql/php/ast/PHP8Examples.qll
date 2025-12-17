/**
 * @name PHP 8.x Feature Examples
 * @description Example patterns for PHP 8.x features
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.PHP8NamedArguments
private import codeql.php.ast.PHP8ConstructorPromotion
private import codeql.php.ast.PHP8ReadonlyProperties

// This file provides example patterns for PHP 8.x features

/**
 * Example: Find constructors with many promoted parameters.
 */
predicate hasExcessivePromotion(ConstructorWithPromotion c) {
  c.getNumPromotedParameters() > 5
}

/**
 * Example: Find classes mixing readonly and mutable properties.
 */
predicate hasMixedMutability(TS::PHP::ClassDeclaration c) {
  exists(ReadonlyProperty ro | ro.getParent+() = c) and
  exists(TS::PHP::PropertyDeclaration p |
    p.getParent+() = c and
    not p instanceof ReadonlyProperty
  )
}
