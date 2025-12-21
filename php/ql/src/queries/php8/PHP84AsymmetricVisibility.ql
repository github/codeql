/**
 * @name PHP 8.4 Asymmetric Visibility Analysis
 * @description Detects PHP 8.4 asymmetric visibility (placeholder - requires tree-sitter update)
 * @kind problem
 * @problem.severity recommendation
 * @id php/asymmetric-visibility
 * @tags php84 visibility encapsulation immutability
 */

import php
import codeql.php.ast.PHP84AsymmetricVisibility
private import codeql.php.ast.internal.TreeSitter as TS

// Asymmetric visibility is not yet supported in tree-sitter PHP grammar
// This query will return no results until grammar is updated
from TS::PHP::PropertyDeclaration prop
where hasAsymmetricVisibility(prop)
select prop, "Asymmetric visibility property detected"
