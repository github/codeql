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
}
