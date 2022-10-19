/**
 * @name Sensitive Expressions
 * @description List all sensitive expressions found in the database.
 *              Sensitive expressions are expressions that have been
 *              identified as potentially containing data that should not be
 *              leaked to an attacker.
 * @kind table
 * @id swift/summary/sensitive-expressions
 */

import swift
import codeql.swift.security.SensitiveExprs

from SensitiveExpr e
select e, "Sensitive expression: " + e.getSensitiveType()
