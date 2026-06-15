/**
 *  This module defines the hook used internally to tweak the characteristic predicate of
 *  `ArrayListExpr` synthesized instances.
 *  INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Raw

/**
 *  The characteristic predicate of `ArrayListExpr` synthesized instances.
 *  INTERNAL: Do not use.
 */
predicate constructArrayListExpr(Raw::ArrayExprInternal id) { not id.isSemicolon() }
