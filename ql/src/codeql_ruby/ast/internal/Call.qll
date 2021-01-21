private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.TreeSitter
private import codeql_ruby.ast.internal.Variable

module Call {
  abstract class Range extends Expr::Range {
    abstract Expr getReceiver();

    abstract string getMethodName();

    abstract ScopeResolution getMethodScopeResolution();

    abstract Expr getArgument(int n);

    abstract Block getBlock();
  }

  private class IdentifierCallRange extends Call::Range, @token_identifier {
    final override Generated::Identifier generated;

    IdentifierCallRange() { vcall(this) and not access(this, _) }

    final override Expr getReceiver() { none() }

    final override string getMethodName() { result = generated.getValue() }

    final override ScopeResolution getMethodScopeResolution() { none() }

    final override Expr getArgument(int n) { none() }

    final override Block getBlock() { none() }
  }

  private class RegularCallRange extends Call::Range, @call {
    final override Generated::Call generated;

    final override Expr getReceiver() { result = generated.getReceiver() }

    final override string getMethodName() {
      result = generated.getMethod().(Generated::Token).getValue() or
      result = this.getMethodScopeResolution().getName()
    }

    final override ScopeResolution getMethodScopeResolution() { result = generated.getMethod() }

    final override Expr getArgument(int n) { result = generated.getArguments().getChild(n) }

    final override Block getBlock() { result = generated.getBlock() }
  }
}

module YieldCall {
  class Range extends Call::Range, @yield {
    final override Generated::Yield generated;

    final override Expr getReceiver() { none() }

    final override string getMethodName() { result = "yield" }

    final override ScopeResolution getMethodScopeResolution() { none() }

    final override Expr getArgument(int n) { result = generated.getChild().getChild(n) }

    final override Block getBlock() { none() }
  }
}

module BlockArgument {
  class Range extends Expr::Range, @block_argument {
    final override Generated::BlockArgument generated;

    final Expr getExpr() { result = generated.getChild() }
  }
}

module SplatArgument {
  class Range extends Expr::Range, @splat_argument {
    final override Generated::SplatArgument generated;

    final Expr getExpr() { result = generated.getChild() }
  }
}

module HashSplatArgument {
  class Range extends Expr::Range, @hash_splat_argument {
    final override Generated::HashSplatArgument generated;

    final Expr getExpr() { result = generated.getChild() }
  }
}
