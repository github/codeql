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

  /**
   * Holds if `i` is an `identifier` node occurring in the context where it
   * should be considered a VCALL. VCALL is the term that MRI/Ripper uses
   * internally when there's an identifier without arguments or parentheses,
   * i.e. it *might* be a method call, but it might also be a variable access,
   * depending on the bindings in the current scope.
   * ```rb
   * foo # in MRI this is a VCALL, and the predicate should hold for this
   * bar() # in MRI this would be an FCALL. Tree-sitter gives us a `call` node,
   *       # and the `method` field will be an `identifier`, but this predicate
   *       # will not hold for that identifier.
   * ```
   */
  private predicate vcall(Generated::Identifier i) {
    exists(Generated::ArgumentList x | x.getChild(_) = i)
    or
    exists(Generated::Array x | x.getChild(_) = i)
    or
    exists(Generated::Assignment x | x.getRight() = i)
    or
    exists(Generated::Begin x | x.getChild(_) = i)
    or
    exists(Generated::BeginBlock x | x.getChild(_) = i)
    or
    exists(Generated::Binary x | x.getLeft() = i or x.getRight() = i)
    or
    exists(Generated::Block x | x.getChild(_) = i)
    or
    exists(Generated::BlockArgument x | x.getChild() = i)
    or
    exists(Generated::Call x | x.getReceiver() = i)
    or
    exists(Generated::Case x | x.getValue() = i)
    or
    exists(Generated::Class x | x.getChild(_) = i)
    or
    exists(Generated::Conditional x |
      x.getCondition() = i or x.getConsequence() = i or x.getAlternative() = i
    )
    or
    exists(Generated::Do x | x.getChild(_) = i)
    or
    exists(Generated::DoBlock x | x.getChild(_) = i)
    or
    exists(Generated::ElementReference x | x.getChild(_) = i or x.getObject() = i)
    or
    exists(Generated::Else x | x.getChild(_) = i)
    or
    exists(Generated::Elsif x | x.getCondition() = i)
    or
    exists(Generated::EndBlock x | x.getChild(_) = i)
    or
    exists(Generated::Ensure x | x.getChild(_) = i)
    or
    exists(Generated::Exceptions x | x.getChild(_) = i)
    or
    exists(Generated::HashSplatArgument x | x.getChild() = i)
    or
    exists(Generated::If x | x.getCondition() = i)
    or
    exists(Generated::IfModifier x | x.getCondition() = i or x.getBody() = i)
    or
    exists(Generated::In x | x.getChild() = i)
    or
    exists(Generated::Interpolation x | x.getChild() = i)
    or
    exists(Generated::KeywordParameter x | x.getValue() = i)
    or
    exists(Generated::Method x | x.getChild(_) = i)
    or
    exists(Generated::Module x | x.getChild(_) = i)
    or
    exists(Generated::OperatorAssignment x | x.getRight() = i)
    or
    exists(Generated::OptionalParameter x | x.getValue() = i)
    or
    exists(Generated::Pair x | x.getKey() = i or x.getValue() = i)
    or
    exists(Generated::ParenthesizedStatements x | x.getChild(_) = i)
    or
    exists(Generated::Pattern x | x.getChild() = i)
    or
    exists(Generated::Program x | x.getChild(_) = i)
    or
    exists(Generated::Range x | x.getChild(_) = i)
    or
    exists(Generated::RescueModifier x | x.getBody() = i or x.getHandler() = i)
    or
    exists(Generated::RightAssignmentList x | x.getChild(_) = i)
    or
    exists(Generated::ScopeResolution x | x.getScope() = i)
    or
    exists(Generated::SingletonClass x | x.getValue() = i or x.getChild(_) = i)
    or
    exists(Generated::SingletonMethod x | x.getChild(_) = i or x.getObject() = i)
    or
    exists(Generated::SplatArgument x | x.getChild() = i)
    or
    exists(Generated::Superclass x | x.getChild() = i)
    or
    exists(Generated::Then x | x.getChild(_) = i)
    or
    exists(Generated::Unary x | x.getOperand() = i)
    or
    exists(Generated::Unless x | x.getCondition() = i)
    or
    exists(Generated::UnlessModifier x | x.getCondition() = i or x.getBody() = i)
    or
    exists(Generated::Until x | x.getCondition() = i)
    or
    exists(Generated::UntilModifier x | x.getCondition() = i or x.getBody() = i)
    or
    exists(Generated::While x | x.getCondition() = i)
    or
    exists(Generated::WhileModifier x | x.getCondition() = i or x.getBody() = i)
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
      result = getMethodScopeResolution().getName()
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
