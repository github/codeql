/**
 * @name Sensitive Expressions
 * @description List all sensitive expressions found in the database.
 *              Sensitive expressions are expressions that have been
 *              identified as potentially containing data that should not be
 *              leaked to an attacker.
 * @kind problem
 * @problem.severity info
 * @id swift/summary/sensitive-expressions
 * @tags summary
 */

import swift
import codeql.swift.security.SensitiveExprs

from SensitiveExpr e
select e, "Sensitive expression: " + e.getSensitiveType()
