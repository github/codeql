private import codeql.ruby.AST
private import codeql.ruby.CFG
private import AST
private import TreeSitter

class StmtSequenceSynth extends StmtSequence, TStmtSequenceSynth {
  final override Stmt getStmt(int n) { synthChild(this, n, result) }

  final override string toString() { result = "..." }
}

class Then extends StmtSequence, TThen {
  private Ruby::Then g;

  Then() { this = TThen(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "then ..." }
}

class Else extends StmtSequence, TElse {
  private Ruby::Else g;

  Else() { this = TElse(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "else ..." }
}

class Do extends StmtSequence, TDo {
  private Ruby::Do g;

  Do() { this = TDo(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "do ..." }
}

class Ensure extends StmtSequence, TEnsure {
  private Ruby::Ensure g;

  Ensure() { this = TEnsure(g) }

  override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "ensure ..." }
}

// Not defined by dispatch, as it should not be exposed
Ruby::AstNode getBodyStmtChild(TBodyStmt b, int i) {
  result = any(Ruby::Method g | b = TMethod(g)).getChild(i)
  or
  result = any(Ruby::SingletonMethod g | b = TSingletonMethod(g)).getChild(i)
  or
  exists(Ruby::Lambda g | b = TLambda(g) |
    result = g.getBody().(Ruby::DoBlock).getChild(i) or
    result = g.getBody().(Ruby::Block).getChild(i)
  )
  or
  result = any(Ruby::DoBlock g | b = TDoBlock(g)).getChild(i)
  or
  result = any(Ruby::Program g | b = TToplevel(g)).getChild(i) and
  not result instanceof Ruby::BeginBlock
  or
  result = any(Ruby::Class g | b = TClassDeclaration(g)).getChild(i)
  or
  result = any(Ruby::SingletonClass g | b = TSingletonClass(g)).getChild(i)
  or
  result = any(Ruby::Module g | b = TModuleDeclaration(g)).getChild(i)
  or
  result = any(Ruby::Begin g | b = TBeginExpr(g)).getChild(i)
}

abstract class DestructuredLhsExprImpl extends Ruby::AstNode {
  abstract Ruby::AstNode getChildNode(int i);

  final int getRestIndex() {
    result = unique(int i | this.getChildNode(i) instanceof Ruby::RestAssignment)
  }
}

class DestructuredLeftAssignmentImpl extends DestructuredLhsExprImpl,
  Ruby::DestructuredLeftAssignment {
  override Ruby::AstNode getChildNode(int i) { result = this.getChild(i) }
}

class LeftAssignmentListImpl extends DestructuredLhsExprImpl, Ruby::LeftAssignmentList {
  override Ruby::AstNode getChildNode(int i) {
    this =
      any(Ruby::LeftAssignmentList lal |
        if
          strictcount(int j | exists(lal.getChild(j))) = 1 and
          lal.getChild(0) instanceof Ruby::DestructuredLeftAssignment
        then result = lal.getChild(0).(Ruby::DestructuredLeftAssignment).getChild(i)
        else result = lal.getChild(i)
      )
  }
}
