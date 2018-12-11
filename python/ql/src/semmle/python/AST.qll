import python

/** Syntactic node (Class, Function, Module, Expr, Stmt or Comprehension) corresponding to a flow node */
abstract class AstNode extends AstNode_ {

    /** Gets the scope that this node occurs in */
    abstract Scope getScope();

    /** Gets a flow node corresponding directly to this node.
     * NOTE: For some statements and other purely syntactic elements,
     * there may not be a `ControlFlowNode` */
    ControlFlowNode getAFlowNode() {
        py_flow_bb_node(result, this, _, _)
    }

    /** Gets the location for this AST node */
    Location getLocation() {
        none()
    }

    /** Whether this syntactic element is artificial, that is it is generated 
     *  by the compiler and is not present in the source */
    predicate isArtificial() {
        none()
    }

    /** Gets a child node of this node in the AST. This predicate exists to aid exploration of the AST
      * and other experiments. The child-parent relation may not be meaningful. 
      * For a more meaningful relation in terms of dependency use 
      * Expr.getASubExpression(), Stmt.getASubStatement(), Stmt.getASubExpression() or
      * Scope.getAStmt().
      */
    abstract AstNode getAChildNode();

    /** Gets the parent node of this node in the AST. This predicate exists to aid exploration of the AST
      * and other experiments. The child-parent relation may not be meaningful. 
      * For a more meaningful relation in terms of dependency use 
      * Expr.getASubExpression(), Stmt.getASubStatement(), Stmt.getASubExpression() or
      * Scope.getAStmt() applied to the parent.
      */
    AstNode getParentNode() {
        result.getAChildNode() = this
    }

    /** Whether this contains `inner` syntactically */
    predicate contains(AstNode inner) {
        this.getAChildNode+() = inner
    }

    /** Whether this contains `inner` syntactically and `inner` has the same scope as `this` */
    predicate containsInScope(AstNode inner) {
        this.contains(inner) and
        this.getScope() = inner.getScope() and
        not inner instanceof Scope
    }

}
