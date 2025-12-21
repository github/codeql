/**
 * @name PHP 8.5 Clone With Immutability Analysis
 * @description Detects PHP 8.5 clone-with syntax (placeholder - requires tree-sitter update)
 * @kind problem
 * @problem.severity recommendation
 * @id php/clone-with-immutability
 * @tags php85 immutability copy-constructor
 */

import php
import codeql.php.ast.PHP85CloneWith
private import codeql.php.ast.internal.TreeSitter as TS

// Clone with is not yet supported in tree-sitter PHP grammar
// This query will return no results until grammar is updated
from TS::PHP::AstNode node
where isCloneWithExpression(node)
select node, "Clone with expression detected"
