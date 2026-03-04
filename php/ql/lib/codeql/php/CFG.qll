/**
 * Provides classes representing the control flow graph for PHP programs.
 */

import codeql.Locations
private import codeql.php.AST

/**
 * An AST node with an associated control-flow graph.
 *
 * Functions, methods, closures, and arrow functions are CFG scopes.
 */
class CfgScope extends AstNode {
  CfgScope() {
    this instanceof FunctionDef or
    this instanceof MethodDecl or
    this instanceof AnonymousFunction or
    this instanceof ArrowFunction or
    this instanceof Program
  }
}

/**
 * A control flow node.
 *
 * A control flow node is a node in the control flow graph (CFG). There is a
 * many-to-one relationship between CFG nodes and AST nodes.
 */
class CfgNode extends AstNode {
  /** Gets a successor of this CFG node. */
  CfgNode getASuccessor() { none() }

  /** Gets a predecessor of this CFG node. */
  CfgNode getAPredecessor() { result.getASuccessor() = this }
}
