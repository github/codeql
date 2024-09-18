/**
 *  This module defines the hook used internally to tweak the characteristic predicate of
 *  `MethodLookupExpr` synthesized instances.
 *  INTERNAL: Do not use.
 */

private import codeql.swift.generated.Raw

/**
 *  The characteristic predicate of `MethodLookupExpr` synthesized instances.
 *  INTERNAL: Do not use.
 */
predicate constructMethodLookupExpr(Raw::SelfApplyExpr id) { any() }
