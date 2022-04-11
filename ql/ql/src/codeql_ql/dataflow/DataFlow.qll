private import codeql_ql.ast.Ast
private import internal.NodesInternal

/**
 * An expression or variable in a formula, including some additional nodes
 * that are not part of the AST.
 */
class Node extends TNode {
  string toString() { none() } // overridden in subclasses
  Location getLocation() { none() } // overridden in subclasses

  /**
   * Gets the underlying `Expr` or `VarDef` node, if this is an `AstNodeNode`.
   */
  AstNode asAstNode() { astNode(result) = this }

  /**
   * Gets the predicate containing this data-flow node.
   *
   * All data-flow nodes belong in exactly one predicate.
   * TODO: select clauses
   */
  Predicate getEnclosingPredicate() { none() } // overridden in subclasses
}

/**
 * A data-flow node based an `Expr` or `VarDef` AST node.
 */
class AstNodeNode extends Node, MkAstNodeNode {
  private AstNode ast;

  AstNodeNode() { this = MkAstNodeNode(ast) }

  override string toString() {
    result = ast.toString()
  }

  override Location getLocation() {
    result = ast.getLocation()
  }

  /** Gets the AST node. */
  AstNode getAstNode() {
    result = ast
  }

  override Predicate getEnclosingPredicate() {
    result = ast.getEnclosingPredicate()
  }
}

/**
 * Gets the data-flow node correspoinding to the given AST node.
 */
pragma[inline]
Node astNode(AstNode node) {
  result = MkAstNodeNode(node)
}

/**
 * A data-flow node representing a variable within a specific scope.
 */
class ScopedVariableNode extends Node, MkScopedVariable {
  private VarDef var;
  private AstNode scope;

  ScopedVariableNode() { this = MkScopedVariable(var, scope) }

  override string toString() {
    result = "Variable '" + var.getName() + "' scoped to " + scope.getLocation().getStartLine() + ":" + scope.getLocation().getStartColumn()
  }

  override Location getLocation() {
    result = scope.getLocation()
  }

  /** Gets the variable being refined to a specific scope. */
  VarDef getVariable() {
    result = var
  }

  /** Gets the scope to which this variable has been refined. */
  AstNode getScope() {
    result = scope
  }

  override Predicate getEnclosingPredicate() {
    result = var.getEnclosingPredicate()
  }
}

/**
 * Gets the data-flow node corresponding to `var` restricted to `scope`.
 */
pragma[inline]
Node scopedVariable(VarDef var, AstNode scope) {
  result = MkScopedVariable(var, scope)
}

/**
 * A data-flow node representing `this` within a class predicate, charpred, or newtype branch.
 */
class ThisNode extends Node, MkThisNode {
  private Predicate pred;

  ThisNode() { this = MkThisNode(pred) }

  override string toString() {
    result = "'this' in " + pred.getName()
  }

  override Location getLocation() {
    result = pred.getLocation()
  }

  /** Gets the class predicate, charpred, or newtype branch whose 'this' parameter is represented by this node. */
  Predicate getPredicate() {
    result = pred
  }

  override Predicate getEnclosingPredicate() {
    result = pred
  }
}

/**
 * Gets the data-flow node representing `this` within the given class predicate, charpred, or newtype branch.
 */
pragma[inline]
Node thisNode(Predicate pred) {
  result = MkThisNode(pred)
}

/**
 * A data-flow node representing `result` within a predicate that has a result.
 */
class ResultNode extends Node, MkResultNode {
  private Predicate pred;

  ResultNode() { this = MkResultNode(pred) }

  override string toString() {
    result = "'result' in " + pred.getName()
  }

  override Location getLocation() {
    result = pred.getLocation()
  }

  /** Gets the predicate whose 'result' parameter is represented by this node. */
  Predicate getPredicate() {
    result = pred
  }

  override Predicate getEnclosingPredicate() {
    result = pred
  }
}

/**
 * Gets the data-flow node representing `result` within the given predicate.
 */
pragma[inline]
Node resultNode(Predicate pred) {
  result = MkResultNode(pred)
}

/**
 * A data-flow node representing the view of a field in the enclosing class, as seen
 * from a charpred or class predicate.
 */
class FieldNode extends Node, MkFieldNode {
  private Predicate pred;
  private FieldDecl fieldDecl;

  FieldNode() { this = MkFieldNode(pred, fieldDecl) }

  /** Gets the member predicate or charpred for which this node represents access to the field. */
  Predicate getPredicate() {
    result = pred
  }

  FieldDecl getFieldDeclaration() {
    result = fieldDecl
  }

  string getFieldName() {
    result = fieldDecl.getName()
  }

  override string toString() {
    result = "'"  + this.getFieldName() + "' in " + pred.getName()
  }

  override Location getLocation() {
    result = pred.getLocation()
  }

  override Predicate getEnclosingPredicate() {
    result = pred
  }
}

/**
 * Gets the data-flow node representing the given predicate's view of the given field
 * in the enclosing class.
 */
pragma[inline]
Node fieldNode(Predicate pred, FieldDecl fieldDecl) {
  result = MkFieldNode(pred, fieldDecl)
}
