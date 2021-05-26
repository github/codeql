import ql
private import codeql_ql.ast.internal.AstNodes

/** An AST node of a QL program */
class AstNode extends TAstNode {
  string toString() { result = "ASTNode" }

  Location getLocation() { result = toGenerated(this).getLocation() }

  AstNode getParent() { toGenerated(result) = toGenerated(this).getParent() }

  string getAPrimaryQlClass() { result = "???" }
}

/**
 * A classless predicate.
 */
class ClasslessPredicate extends TClasslessPredicate, AstNode {
  Generated::ModuleMember member;
  Generated::ClasslessPredicate pred;

  ClasslessPredicate() { this = TClasslessPredicate(member, pred) }

  predicate isPrivate() {
    member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
  }

  override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

  /**
   * Gets the `i`th parameter of the predicate.
   */
  VarDecl getParameter(int i) {
    toGenerated(result) =
      rank[i](Generated::VarDecl decl, int index | decl = pred.getChild(index) | decl order by index)
  }

  /**
   * Gets the body of the predicate.
   */
  Body getBody() { toGenerated(result) = pred.getChild(_) }
}

/**
 * A variable declaration, with a type and a name.
 */
class VarDecl extends TVarDecl, AstNode {
  Generated::VarDecl var;

  VarDecl() { this = TVarDecl(var) }
  // TODO: Type and name getters.
}

/**
 * The body of a predicate.
 */
class Body extends TBody, AstNode {
  Generated::Body body;

  Body() { this = TBody(body) }
  // TODO: Children.
}
