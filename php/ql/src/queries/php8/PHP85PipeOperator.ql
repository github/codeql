/**
 * @name PHP 8.5 Pipe Operator Readability Analysis
 * @description Analyzes PHP 8.5 pipe operator usage (placeholder - requires tree-sitter update)
 * @kind problem
 * @problem.severity recommendation
 * @id php/pipe-operator-readability
 * @tags php85 functional-programming readability
 */

import php
import codeql.php.ast.PHP85PipeOperator
private import codeql.php.ast.internal.TreeSitter as TS

// Pipe operator is not yet supported in tree-sitter PHP grammar
// This query will return no results until grammar is updated
from TS::PHP::AstNode node
where isPipeExpression(node)
select node, "Pipe operator expression detected"
