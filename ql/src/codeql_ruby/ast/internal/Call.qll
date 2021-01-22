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
    i = any(Generated::ArgumentList x).getChild(_)
    or
    i = any(Generated::Array x).getChild(_)
    or
    i = any(Generated::Assignment x).getRight()
    or
    i = any(Generated::Begin x).getChild(_)
    or
    i = any(Generated::BeginBlock x).getChild(_)
    or
    i = any(Generated::Binary x).getLeft()
    or
    i = any(Generated::Binary x).getRight()
    or
    i = any(Generated::Block x).getChild(_)
    or
    i = any(Generated::BlockArgument x).getChild()
    or
    i = any(Generated::Call x).getReceiver()
    or
    i = any(Generated::Case x).getValue()
    or
    i = any(Generated::Class x).getChild(_)
    or
    i = any(Generated::Conditional x).getCondition()
    or
    i = any(Generated::Conditional x).getConsequence()
    or
    i = any(Generated::Conditional x).getAlternative()
    or
    i = any(Generated::Do x).getChild(_)
    or
    i = any(Generated::DoBlock x).getChild(_)
    or
    i = any(Generated::ElementReference x).getChild(_)
    or
    i = any(Generated::ElementReference x).getObject()
    or
    i = any(Generated::Else x).getChild(_)
    or
    i = any(Generated::Elsif x).getCondition()
    or
    i = any(Generated::EndBlock x).getChild(_)
    or
    i = any(Generated::Ensure x).getChild(_)
    or
    i = any(Generated::Exceptions x).getChild(_)
    or
    i = any(Generated::HashSplatArgument x).getChild()
    or
    i = any(Generated::If x).getCondition()
    or
    i = any(Generated::IfModifier x).getCondition()
    or
    i = any(Generated::IfModifier x).getBody()
    or
    i = any(Generated::In x).getChild()
    or
    i = any(Generated::Interpolation x).getChild()
    or
    i = any(Generated::KeywordParameter x).getValue()
    or
    i = any(Generated::Method x).getChild(_)
    or
    i = any(Generated::Module x).getChild(_)
    or
    i = any(Generated::OperatorAssignment x).getRight()
    or
    i = any(Generated::OptionalParameter x).getValue()
    or
    i = any(Generated::Pair x).getKey()
    or
    i = any(Generated::Pair x).getValue()
    or
    i = any(Generated::ParenthesizedStatements x).getChild(_)
    or
    i = any(Generated::Pattern x).getChild()
    or
    i = any(Generated::Program x).getChild(_)
    or
    i = any(Generated::Range x).getChild(_)
    or
    i = any(Generated::RescueModifier x).getBody()
    or
    i = any(Generated::RescueModifier x).getHandler()
    or
    i = any(Generated::RightAssignmentList x).getChild(_)
    or
    i = any(Generated::ScopeResolution x).getScope()
    or
    i = any(Generated::SingletonClass x).getValue()
    or
    i = any(Generated::SingletonClass x).getChild(_)
    or
    i = any(Generated::SingletonMethod x).getChild(_)
    or
    i = any(Generated::SingletonMethod x).getObject()
    or
    i = any(Generated::SplatArgument x).getChild()
    or
    i = any(Generated::Superclass x).getChild()
    or
    i = any(Generated::Then x).getChild(_)
    or
    i = any(Generated::Unary x).getOperand()
    or
    i = any(Generated::Unless x).getCondition()
    or
    i = any(Generated::UnlessModifier x).getCondition()
    or
    i = any(Generated::UnlessModifier x).getBody()
    or
    i = any(Generated::Until x).getCondition()
    or
    i = any(Generated::UntilModifier x).getCondition()
    or
    i = any(Generated::UntilModifier x).getBody()
    or
    i = any(Generated::While x).getCondition()
    or
    i = any(Generated::WhileModifier x).getCondition()
    or
    i = any(Generated::WhileModifier x).getBody()
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
