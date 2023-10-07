/**
 * @name Number of unresolved AST nodes
 * @description Count all unresolved AST nodes.
 * @kind metric
 * @id swift/diagnostics/unresolved-ast-nodes
 * @tags summary
 */

import swift

select count(AstNode n | n.getAPrimaryQlClass().matches("Unresolved%") | n)
