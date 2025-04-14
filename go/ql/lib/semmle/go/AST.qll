/**
 * Provides classes for working with AST nodes.
 */

import go

/**
 * An AST node.
 */
class AstNode extends @node, Locatable {
  /**
   * Gets the `i`th child node of this node.
   *
   * Note that the precise indices of child nodes are considered an implementation detail
   * and are subject to change without notice.
   */
  AstNode getChild(int i) {
    result = this.(ExprParent).getChildExpr(i) or
    result = this.(GoModExprParent).getChildGoModExpr(i) or
    result = this.(StmtParent).getChildStmt(i) or
    result = this.(DeclParent).getDecl(i) or
    result = this.(GenDecl).getSpec(i) or
    result = this.(FieldParent).getField(i) or
    result = this.(File).getCommentGroup(i) or
    result = this.(CommentGroup).getComment(i)
  }

  /**
   * Gets a child node of this node.
   */
  AstNode getAChild() { result = this.getChild(_) }

  /**
   * Gets the number of child nodes of this node.
   */
  int getNumChild() { result = count(this.getAChild()) }

  /**
   * Gets a child with the given index and of the given kind, if one exists.
   * Note that a given parent can have multiple children with the same index but differing kind.
   */
  private AstNode getChildOfKind(string kind, int i) {
    kind = "expr" and result = this.(ExprParent).getChildExpr(i)
    or
    kind = "gomodexpr" and result = this.(GoModExprParent).getChildGoModExpr(i)
    or
    kind = "stmt" and result = this.(StmtParent).getChildStmt(i)
    or
    kind = "decl" and result = this.(DeclParent).getDecl(i)
    or
    kind = "spec" and result = this.(GenDecl).getSpec(i)
    or
    kind = "field" and result = this.(FieldParent).getField(i)
    or
    kind = "commentgroup" and result = this.(File).getCommentGroup(i)
    or
    kind = "comment" and result = this.(CommentGroup).getComment(i)
    or
    kind = "typeparamdecl" and result = this.(TypeParamDeclParent).getTypeParameterDecl(i)
  }

  /**
   * Get an AstNode child, ordered by child kind and then by index.
   */
  AstNode getUniquelyNumberedChild(int index) {
    result =
      rank[index + 1](AstNode child, string kind, int i |
        child = this.getChildOfKind(kind, i)
      |
        child order by kind, i
      )
  }

  /** Gets the parent node of this AST node, if any. */
  AstNode getParent() { this = result.getAChild() }

  /** Gets the parent node of this AST node, but without crossing function boundaries. */
  private AstNode parentInSameFunction() {
    result = this.getParent() and
    not this instanceof FuncDef
  }

  /** Gets the innermost function definition to which this AST node belongs, if any. */
  pragma[nomagic]
  FuncDef getEnclosingFunction() { result = this.getParent().parentInSameFunction*() }

  /**
   * Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs.
   */
  final string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }

  /**
   * Gets the name of a primary CodeQL class to which this node belongs.
   *
   * For most nodes, this is simply the most precise syntactic category to which they belong;
   * for example, `AddExpr` is a primary class, but `BinaryExpr` is not.
   *
   * For identifiers and selector expressions, the class describing what kind of entity they refer
   * to (for example `FunctionName` or `TypeName`) is also considered primary. For such nodes,
   * this predicate has multiple values.
   */
  string getAPrimaryQlClass() { result = "???" }

  override string toString() { result = "AST node" }
}

/**
 * An AST node whose children include expressions.
 */
class ExprParent extends @exprparent, AstNode {
  /**
   * Gets the `i`th child expression of this node.
   *
   * Note that the precise indices of child expressions are considered an implementation detail
   * and are subject to change without notice.
   */
  Expr getChildExpr(int i) { exprs(result, _, this, i) }

  /**
   * Gets an expression that is a child node of this node in the AST.
   */
  Expr getAChildExpr() { result = this.getChildExpr(_) }

  /**
   * Gets the number of child expressions of this node.
   */
  int getNumChildExpr() { result = count(this.getAChildExpr()) }
}

/**
 * An AST node whose children include go.mod expressions.
 */
class GoModExprParent extends @modexprparent, AstNode {
  /**
   * Gets the `i`th child expression of this node.
   *
   * Note that the precise indices of child expressions are considered an implementation detail
   * and are subject to change without notice.
   */
  GoModExpr getChildGoModExpr(int i) { modexprs(result, _, this, i) }

  /**
   * Gets an expression that is a child node of this node in the AST.
   */
  GoModExpr getAChildGoModExpr() { result = this.getChildGoModExpr(_) }

  /**
   * Gets the number of child expressions of this node.
   */
  int getNumChildGoModExpr() { result = count(this.getAChildGoModExpr()) }
}

/**
 * An AST node whose children include statements.
 */
class StmtParent extends @stmtparent, AstNode {
  /**
   * Gets the `i`th child statement of this node.
   *
   * Note that the precise indices of child statements are considered an implementation detail
   * and are subject to change without notice.
   */
  Stmt getChildStmt(int i) { stmts(result, _, this, i) }

  /**
   * Gets a statement that is a child node of this node in the AST.
   */
  Stmt getAChildStmt() { result = this.getChildStmt(_) }

  /**
   * Gets the number of child statements of this node.
   */
  int getNumChildStmt() { result = count(this.getAChildStmt()) }
}

/**
 * An AST node whose children include declarations.
 */
class DeclParent extends @declparent, AstNode {
  /**
   * Gets the `i`th child declaration of this node.
   *
   * Note that the precise indices of declarations are considered an implementation detail
   * and are subject to change without notice.
   */
  Decl getDecl(int i) { decls(result, _, this, i) }

  /**
   * Gets a child declaration of this node in the AST.
   */
  Decl getADecl() { result = this.getDecl(_) }

  /**
   * Gets the number of child declarations of this node.
   */
  int getNumDecl() { result = count(this.getADecl()) }
}

/**
 * An AST node whose children include field declarations.
 *
 * A field declaration can be in a struct, a function (for parameter or result
 * variables), or an interface (in which case it is a method or embedding spec).
 */
class FieldParent extends @fieldparent, AstNode {
  /**
   * Gets the `i`th field declaration of this node.
   *
   * Note that the precise indices of field declarations are considered an
   * implementation detail and are subject to change without notice.
   */
  FieldBase getField(int i) { fields(result, this, i) }

  /**
   * Gets a child field declaration of this node in the AST.
   */
  FieldBase getAField() { result = this.getField(_) }

  /**
   * Gets the number of child field declarations of this node.
   */
  int getNumFields() { result = count(this.getAField()) }
}

/**
 * An AST node whose children include type parameter declarations.
 */
class TypeParamDeclParent extends @typeparamdeclparent, AstNode {
  /**
   * Gets the `i`th type parameter declaration of this node.
   *
   * Note that the precise indices of type parameters are considered an implementation detail
   * and are subject to change without notice.
   */
  TypeParamDecl getTypeParameterDecl(int i) { typeparamdecls(result, this, i) }

  /**
   * Gets a child field of this node in the AST.
   */
  TypeParamDecl getATypeParameterDecl() { result = this.getTypeParameterDecl(_) }
}

/**
 * An AST node which may induce a scope.
 *
 * The following nodes may induce scopes:
 *
 *   - files
 *   - block statements, `if` statements, `switch` statements, `case` clauses, comm clauses, loops
 *   - function type expressions
 *
 * Note that functions themselves do not induce a scope, it is their type declaration that induces
 * the scope.
 */
class ScopeNode extends @scopenode, AstNode {
  /** Gets the scope induced by this node, if any. */
  LocalScope getScope() { scopenodes(this, result) }
}
