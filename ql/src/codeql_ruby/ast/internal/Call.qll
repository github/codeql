private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Pattern
private import codeql_ruby.ast.internal.TreeSitter
private import codeql_ruby.ast.internal.Variable

module Call {
  abstract class Range extends Expr::Range {
    abstract Expr getArgument(int n);

    override predicate child(string label, AstNode::Range child) {
      label = "getArgument" and child = getArgument(_)
    }
  }
}

module MethodCall {
  class Range extends Call::Range {
    MethodCallRange::Range range;

    Range() { this = range }

    final Block getBlock() { result = range.getBlock() }

    final Expr getReceiver() { result = range.getReceiver() }

    final override Expr getArgument(int n) { result = range.getArgument(n) }

    abstract string getMethodName();

    override string toString() {
      result = range.toString()
      or
      not exists(range.toString()) and result = "call to " + concat(this.getMethodName(), "/")
    }

    final override predicate child(string label, AstNode::Range child) {
      super.child(label, child)
      or
      label = "getReceiver" and child = getReceiver()
      or
      label = "getBlock" and child = getBlock()
    }
  }
}

module MethodCallRange {
  abstract class Range extends @ast_node {
    Generated::AstNode generated;

    Range() { this = generated }

    abstract Block getBlock();

    abstract Expr getReceiver();

    abstract string getMethod();

    abstract Expr getArgument(int n);

    string toString() { none() }
  }

  private class IdentifierCallRange extends MethodCallRange::Range, @token_identifier {
    final override Generated::Identifier generated;

    IdentifierCallRange() { vcall(this) and not access(this, _) }

    final override Expr getReceiver() { none() }

    final override string getMethod() { result = generated.getValue() }

    final override Expr getArgument(int n) { none() }

    final override Block getBlock() { none() }
  }

  private class ScopeResolutionIdentifierCallRange extends MethodCallRange::Range, @scope_resolution {
    final override Generated::ScopeResolution generated;
    Generated::Identifier identifier;

    ScopeResolutionIdentifierCallRange() {
      identifier = generated.getName() and
      not exists(Generated::Call c | c.getMethod() = this)
    }

    final override Expr getReceiver() { result = generated.getScope() }

    final override string getMethod() { result = identifier.getValue() }

    final override Expr getArgument(int n) { none() }

    final override Block getBlock() { none() }
  }

  private class RegularCallRange extends MethodCallRange::Range, @call {
    final override Generated::Call generated;

    final override Expr getReceiver() {
      result = generated.getReceiver()
      or
      not exists(generated.getReceiver()) and
      result = generated.getMethod().(Generated::ScopeResolution).getScope()
    }

    final override string getMethod() {
      result = "call" and generated.getMethod() instanceof Generated::ArgumentList
      or
      result = generated.getMethod().(Generated::Token).getValue()
      or
      result =
        generated.getMethod().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
    }

    final override Expr getArgument(int n) {
      result = generated.getArguments().getChild(n)
      or
      not exists(generated.getArguments()) and
      result = generated.getMethod().(Generated::ArgumentList).getChild(n)
    }

    final override Block getBlock() { result = generated.getBlock() }
  }
}

module ElementReferenceRange {
  class Range extends MethodCallRange::Range, @element_reference {
    final override Generated::ElementReference generated;

    final override Expr getReceiver() { result = generated.getObject() }

    final override string getMethod() { result = "[]" }

    final override string toString() { result = "...[...]" }

    final override Expr getArgument(int n) { result = generated.getChild(n) }

    final override Block getBlock() { none() }
  }
}

module NormalMethodCall {
  class Range extends MethodCall::Range {
    Range() {
      not this instanceof LhsExpr::Range or
      generated.getParent() instanceof AssignOperation
    }

    final override string getMethodName() { result = range.getMethod() }
  }
}

module SetterMethodCall {
  class Range extends MethodCall::Range, LhsExpr::Range {
    final override string getMethodName() { result = range.getMethod() + "=" }

    final override string toString() { result = MethodCall::Range.super.toString() }
  }
}

module ElementReference {
  class Range extends MethodCall::Range {
    override ElementReferenceRange::Range range;

    final override string getMethodName() { none() }
  }
}

module SuperCall {
  class Range extends NormalMethodCall::Range {
    override SuperCallRange::Range range;
  }
}

module YieldCall {
  class Range extends Call::Range, @yield {
    final override Generated::Yield generated;

    final override Expr getArgument(int n) { result = generated.getChild().getChild(n) }

    final override string toString() { result = "yield ..." }
  }
}

module SuperCallRange {
  abstract class Range extends MethodCallRange::Range { }

  private class SuperTokenCallRange extends SuperCallRange::Range, @token_super {
    final override Generated::Super generated;

    // N.B. `super` tokens can never be accesses, so any vcall with `super` must
    // be a call.
    SuperTokenCallRange() { vcall(this) }

    final override Expr getReceiver() { none() }

    final override string getMethod() { result = generated.getValue() }

    final override Expr getArgument(int n) { none() }

    final override Block getBlock() { none() }
  }

  private class RegularSuperCallRange extends SuperCallRange::Range, @call {
    final override Generated::Call generated;

    RegularSuperCallRange() { generated.getMethod() instanceof Generated::Super }

    final override Expr getReceiver() { none() }

    final override string getMethod() {
      result = generated.getMethod().(Generated::Super).getValue()
    }

    final override Expr getArgument(int n) { result = generated.getArguments().getChild(n) }

    final override Block getBlock() { result = generated.getBlock() }
  }
}

module BlockArgument {
  class Range extends Expr::Range, @block_argument {
    final override Generated::BlockArgument generated;

    final Expr getValue() { result = generated.getChild() }

    final override string toString() { result = "&..." }

    final override predicate child(string label, AstNode::Range child) {
      label = "getValue" and child = getValue()
    }
  }
}

module SplatArgument {
  class Range extends Expr::Range, @splat_argument {
    final override Generated::SplatArgument generated;

    final Expr getValue() { result = generated.getChild() }

    final override string toString() { result = "*..." }

    final override predicate child(string label, AstNode::Range child) {
      label = "getValue" and child = getValue()
    }
  }
}

module HashSplatArgument {
  class Range extends Expr::Range, @hash_splat_argument {
    final override Generated::HashSplatArgument generated;

    final Expr getValue() { result = generated.getChild() }

    final override string toString() { result = "**..." }

    final override predicate child(string label, AstNode::Range child) {
      label = "getValue" and child = getValue()
    }
  }
}
