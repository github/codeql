/**
 * @name PHP 8.4 Property Hooks Analysis
 * @description Detects PHP 8.4 property hooks (placeholder - requires tree-sitter update)
 * @kind problem
 * @problem.severity recommendation
 * @id php/property-hooks
 * @tags php84 hooks encapsulation
 */

import php
import codeql.php.ast.PHP84PropertyHooks
private import codeql.php.ast.internal.TreeSitter as TS

// Property hooks are not yet supported in tree-sitter PHP grammar
// This query will return no results until grammar is updated
from TS::PHP::PropertyDeclaration prop
where hasPropertyHook(prop)
select prop, "Property hook detected"
