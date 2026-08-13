/**
 * Provides classes for reasoning about lexically scoped names and references to these.
 */

private import unified
private import unified as U
private import codeql.namebinding.LocalNameBinding

private module LocalNameBindingInput implements LocalNameBindingInputSig<Location> {
  class AstNode = U::AstNode;

  private class LogicalAndRoot extends LogicalAndExpr {
    LogicalAndRoot() { not this = any(LogicalAndExpr e).getAnOperand() }

    private Expr getDescendant(string path) {
      path = "" and result = this
      or
      exists(LogicalAndExpr mid, string midPath | mid = this.getDescendant(midPath) |
        result = mid.getLeft() and path = midPath + "A"
        or
        result = mid.getRight() and path = midPath + "B"
      )
    }

    Expr getNthLeaf(int n) {
      result =
        rank[n](Expr e, string path |
          e = this.getDescendant(path) and not e instanceof LogicalAndExpr
        |
          e order by path
        )
    }

    Expr getLastLeaf() { result = max(int n | | this.getNthLeaf(n) order by n) }
  }

  private class BlockWithGuardStmts extends Block {
    BlockWithGuardStmts() { this.getStmt(_) instanceof GuardIfStmt }

    AstNode getTranslatedChild(int n) {
      result =
        rank[n](AstNode stmt, AstNode child, int i1, int i2 |
          stmt = this.getStmt(i1) and
          (
            child = stmt.(GuardIfStmt).getCondition().(LogicalAndRoot).getNthLeaf(i2)
            or
            child = stmt.(GuardIfStmt).getCondition() and
            not child instanceof LogicalAndExpr and
            i2 = 0
            or
            child = stmt.(GuardIfStmt).getElse() and
            i2 = -1 // place before condition so its variables are not seen
            or
            not stmt instanceof GuardIfStmt and
            child = stmt and
            i2 = 0
          )
        |
          child order by i1, i2
        )
    }
  }

  private AstNode getChild1(AstNode n, int index) {
    result = n.(Block).getStmt(index) and
    not n instanceof BlockWithGuardStmts
    or
    result = n.(BlockWithGuardStmts).getTranslatedChild(index)
    or
    result = n.(LogicalAndRoot).getNthLeaf(index)
    or
    exists(PatternGuardExpr guard | n = guard |
      index = 0 and result = guard.getPattern()
      or
      index = 1 and result = guard.getValue()
    )
    or
    exists(IfExpr expr | n = expr |
      index = 0 and result = expr.getCondition()
      or
      index = 1 and result = expr.getThen()
      or
      index = 2 and result = expr.getElse()
    )
    or
    exists(VariableDeclaration decl | n = decl |
      index = 0 and result = decl.getPattern()
      or
      index = 1 and result = decl.getType()
      or
      index = 2 and result = decl.getValue()
    )
    or
    index = 0 and
    relocatedClassMember(n, result)
  }

  /**
   * Holds if `member` is moved onto a child of `className` instead of the class itself,
   * so the member name is not in scope in the base types and type parameter constraints.
   */
  private predicate relocatedClassMember(Identifier className, Member member) {
    exists(ClassLikeDeclaration cls |
      className = cls.getName() and
      member = cls.getAMember()
    )
  }

  AstNode getChild(AstNode n, int index) {
    result = getChild1(n, index)
    or
    not exists(getChild1(n, _)) and
    not n instanceof LogicalAndExpr and // also ignore intermediate nodes within a 'logical and' tree
    not n instanceof GuardIfStmt and
    not relocatedClassMember(_, result) and
    index = 0 and
    result = n.getAFieldOrChild()
  }

  abstract class Conditional extends AstNode {
    /** Gets the condition of this conditional. */
    abstract AstNode getCondition();

    /** Gets the then-branch of this conditional. */
    abstract AstNode getThen();

    /** Gets the else-branch of this conditional. */
    abstract AstNode getElse();
  }

  private class IfExprConditional extends Conditional instanceof IfExpr {
    override AstNode getCondition() { result = IfExpr.super.getCondition() }

    override AstNode getThen() { result = IfExpr.super.getThen() }

    override AstNode getElse() { result = IfExpr.super.getElse() }
  }

  private class WhileStmtConditional extends Conditional instanceof WhileStmt {
    override AstNode getCondition() { result = WhileStmt.super.getCondition() }

    override AstNode getThen() { result = WhileStmt.super.getBody() }

    override AstNode getElse() { none() }
  }

  abstract class SiblingShadowingDecl extends AstNode {
    abstract AstNode getPattern();

    /**
     * Gets the right-hand side of this declaration.
     *
     * Any local declared in the left-hand side of this declaration is _not_ in scope
     * in the right-hand side.
     */
    abstract AstNode getRhs();

    /**
     * Gets the else-branch of this declaration, if any.
     *
     * Any local declared in the left-hand side of this declaration is _not_ in scope
     * in the else-branch.
     */
    abstract AstNode getElse();
  }

  private class LocalVariableDeclarationSiblingShadowingDecl extends SiblingShadowingDecl instanceof LocalVariableDeclaration
  {
    LocalVariableDeclarationSiblingShadowingDecl() { not this instanceof TopLevelStmt }

    override Pattern getPattern() { result = LocalVariableDeclaration.super.getPattern() }

    override AstNode getRhs() { result = LocalVariableDeclaration.super.getValue() }

    override AstNode getElse() { none() }
  }

  private class PatternGuardExprSiblingShadowingDecl extends SiblingShadowingDecl instanceof PatternGuardExpr
  {
    override Pattern getPattern() { result = PatternGuardExpr.super.getPattern() }

    override AstNode getRhs() { result = PatternGuardExpr.super.getValue() }

    override AstNode getElse() { none() }
  }

  additional predicate bindingContext(AstNode pattern, AstNode scope, AstNode declaration) {
    exists(SiblingShadowingDecl decl |
      scope = decl and
      pattern = decl.getPattern() and
      declaration = decl
    )
    or
    exists(VariableDeclaration decl |
      not decl instanceof SiblingShadowingDecl and
      getChild(scope, _) = decl and
      pattern = decl.getPattern() and
      declaration = decl
    )
    or
    exists(FunctionDeclaration func |
      getChild(scope, _) = func and
      pattern = func.getName() and
      declaration = func
    )
    or
    exists(Parameter param |
      scope = param.getParent() and // TODO: add SourceCallable and use .getParameter() instead
      pattern = param.getPattern() and
      declaration = param
    )
    or
    exists(CatchClause catch |
      scope = catch and // ensure both body and pattern are in scope
      pattern = catch.getPattern() and
      declaration = catch
    )
    or
    exists(SwitchCase case |
      scope = case and // ensure both body and pattern are in scope
      pattern = case.getPattern() and
      declaration = case
    )
    or
    exists(ForEachStmt stmt |
      scope = stmt and // ensure both 'body' and 'guard' are in scope
      pattern = stmt.getPattern() and
      declaration = stmt
    )
    or
    exists(ClassLikeDeclaration cls |
      getChild(scope, _) = cls and
      pattern = cls.getName() and
      declaration = cls
    )
    or
    exists(TypeAliasDeclaration decl |
      getChild(scope, _) = decl and
      pattern = decl.getName() and
      declaration = decl
    )
    or
    exists(TypeParameter param |
      scope = param.getParent() and
      pattern = param.getName() and
      declaration = param
    )
    or
    exists(AssociatedTypeDeclaration decl |
      getChild(scope, _) = decl and
      pattern = decl.getName() and
      declaration = decl
    )
    or
    exists(AccessorDeclaration decl |
      getChild(scope, _) = decl and
      pattern = decl.getName() and
      declaration = decl
    )
    or
    exists(ImportDeclaration imprt |
      getChild(scope, _) = imprt and
      pattern = imprt.getPattern() and
      declaration = imprt
    )
    or
    exists(NamePattern p |
      bindingContext(p, scope, declaration) and
      pattern = p.getIdentifier()
    )
    or
    bindingContext(pattern.(Pattern).getEnclosingPattern(), scope, declaration)
  }

  /**
   * Gets the nearest enclosing `OrPattern` to which variable bindings in `p` should be lifted.
   *
   * To ensure that `case .foo(let x), .bar(let x)` result in a single definition for
   * the variable `x`, the `OrPattern` becomes the `definingNode` for `x`.
   *
   * At the moment no further checks are needed since the Swift compiler enforces that
   * variable names bound in any branch are bound in all branches.
   */
  private OrPattern getEnclosingOrPattern(Pattern p) {
    p = result.getPattern(_)
    or
    not p instanceof OrPattern and
    result = getEnclosingOrPattern(p.getEnclosingPattern())
  }

  private OrPattern getEnclosingOrPatternFromIdentifier(Identifier id) {
    exists(NamePattern p |
      id = p.getIdentifier() and
      result = getEnclosingOrPattern(p)
    )
  }

  predicate declInScope(AstNode definingNode, string name, AstNode scope) {
    exists(AstNode pattern |
      bindingContext(pattern, scope, _) and
      pattern.(Identifier).getValue() = name and
      (
        definingNode = getEnclosingOrPatternFromIdentifier(pattern)
        or
        not exists(getEnclosingOrPatternFromIdentifier(pattern)) and
        definingNode = pattern
      )
    )
  }

  predicate implicitDeclInScope(string name, AstNode scope) {
    none()
    // TODO: self
  }

  predicate accessCand(AstNode n, string name) { n.(PotentialLocalNameAccess).getName() = name }

  predicate uncertainScope(AstNode scope) {
    // Classes can have uncertain members due to unqualified access to inherited members.
    scope = any(ClassLikeDeclaration cls)
    or
    scope = any(TopLevel t).getBody() // Imported names are in scope here
    or
    // Scopes with a bulk-import have uncertain members
    bindingContext(any(BulkImportingPattern b), scope, _)
  }
}

import LocalNameBindingInput

module LocalNameBindingOutput = LocalNameBinding<Location, LocalNameBindingInput>;

module Public {
  /**
   * A representative for a lexically scoped entity, such as a local variable, type name, or module name.
   */
  class LocalName instanceof LocalNameBindingOutput::Local {
    /** Gets a textual representation of this local entity. */
    string toString() { result = super.toString() }

    /** Gets the location of this local name's first declaration */
    Location getLocation() { result = super.getLocation() }

    /** Gets the name of this local, as a string. */
    string getName() { result = super.getName() }
  }

  /** An identifier that appears as the declaration site of a name, such as the `x` in `let x = 123`. */
  class NameDeclaration extends Identifier {
    NameDeclaration() { LocalNameBindingInput::bindingContext(this, _, _) }

    /** Gets the statement-like node declaring this name, such as a `VariableDeclaration` or `CatchClause`. */
    AstNode getDeclaration() { LocalNameBindingInput::bindingContext(this, _, result) }

    /** Gets the name being declared. */
    string getName() { result = this.getValue() }

    /** Gets the representative for the local name introduced by this declaration. */
    LocalName getLocalName() { result = this.(LocalNameBindingOutput::LocalAccess).getLocal() }
  }
}

/**
 * An identifier node that is possibly a reference to a local name, but could also refer to a member
 * visible through imports or inheritance.
 *
 * For example, the type annotation `C` below is a potential access to `class C`, but could
 * also refer to `B.C` if such a class exists:
 * ```swift
 * class C {}
 * class A : B {
 *   let x : C
 * }
 * ```
 */
class PotentialLocalNameAccess extends Identifier {
  PotentialLocalNameAccess() {
    this = any(NameExpr e).getIdentifier()
    or
    this = any(NamePattern e).getIdentifier()
    or
    this = any(NamedTypeExpr e | not exists(e.getQualifier())).getName()
    or
    this instanceof NameDeclaration
  }

  LocalName getLocalName() { result = this.(LocalNameBindingOutput::LocalAccess).getLocal() }

  string getName() { result = this.getValue() }

  /** Holds if this is one of the declaration sites for a name, such as the `x` in `let x = 123`. */
  predicate isDeclarationSite() { this instanceof NameDeclaration }
}
