/**
 *  This module defines the hook used internally to tweak the characteristic predicate of
 *  `ArrayRepeatExpr` synthesized instances.
 *  INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Raw

/**
 *  The characteristic predicate of `ArrayRepeatExpr` synthesized instances.
 *  INTERNAL: Do not use.
 */
predicate constructArrayRepeatExpr(Raw::ArrayExprInternal id) { id.isSemicolon() }
