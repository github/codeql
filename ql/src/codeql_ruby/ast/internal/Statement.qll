private import codeql_ruby.AST
private import codeql_ruby.ast.internal.TreeSitter

module Statement {
  abstract class Range extends AstNode { }
}

module ReturningStatement {
  abstract class Range extends Statement::Range {
    abstract Generated::ArgumentList getArgumentList();

    abstract string getStatementName();
  }
}

module ReturnStmt {
  class Range extends ReturningStatement::Range, @return {
    final override Generated::Return generated;

    final override string getStatementName() { result = "return" }

    final override Generated::ArgumentList getArgumentList() { result = generated.getChild() }
  }
}

module BreakStmt {
  class Range extends ReturningStatement::Range, @break {
    final override Generated::Break generated;

    final override string getStatementName() { result = "break" }

    final override Generated::ArgumentList getArgumentList() { result = generated.getChild() }
  }
}

module NextStmt {
  class Range extends ReturningStatement::Range, @next {
    final override Generated::Next generated;

    final override string getStatementName() { result = "next" }

    final override Generated::ArgumentList getArgumentList() { result = generated.getChild() }
  }
}
