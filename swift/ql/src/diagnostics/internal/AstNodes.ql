/**
 * @name Number of extracted AST nodes
 * @description Count all AST nodes.
 * @kind metric
 * @id swift/diagnostics/ast-nodes
 * @tags summary
 */

import swift

select count(AstNode n)
