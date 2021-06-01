private import TreeSitter
private import Variable
private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST

predicate isIdentifierMethodCall(Generated::Identifier g) { vcall(g) and not access(g, _) }

predicate isRegularMethodCall(Generated::Call g) { not g.getMethod() instanceof Generated::Super }

predicate isScopeResolutionMethodCall(Generated::ScopeResolution g, Generated::Identifier i) {
  i = g.getName() and
  not exists(Generated::Call c | c.getMethod() = g)
}

abstract class CallImpl extends Call {
  abstract Expr getArgumentImpl(int n);

  /**
   * It is not possible to define this predicate as
   *
   * ```ql
   * result = count(this.getArgumentImpl(_))
   * ```
   *
   * since that will result in a non-monotonicity error.
   */
  abstract int getNumberOfArgumentsImpl();
}

abstract class MethodCallImpl extends CallImpl, MethodCall {
  abstract Expr getReceiverImpl();

  abstract string getMethodNameImpl();
}

class MethodCallSynth extends MethodCallImpl, TMethodCallSynth {
  final override string getMethodNameImpl() {
    exists(boolean setter, string name | this = TMethodCallSynth(_, _, name, setter, _) |
      setter = true and result = name + "="
      or
      setter = false and result = name
    )
  }

  final override Expr getReceiverImpl() { synthChild(this, 0, result) }

  final override Expr getArgumentImpl(int n) { synthChild(this, n + 1, result) and n >= 0 }

  final override int getNumberOfArgumentsImpl() { this = TMethodCallSynth(_, _, _, _, result) }
}

class IdentifierMethodCall extends MethodCallImpl, TIdentifierMethodCall {
  private Generated::Identifier g;

  IdentifierMethodCall() { this = TIdentifierMethodCall(g) }

  final override string getMethodNameImpl() { result = g.getValue() }

  final override Self getReceiverImpl() { result = TSelfSynth(this, 0) }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }
}

class ScopeResolutionMethodCall extends MethodCallImpl, TScopeResolutionMethodCall {
  private Generated::ScopeResolution g;
  private Generated::Identifier i;

  ScopeResolutionMethodCall() { this = TScopeResolutionMethodCall(g, i) }

  final override string getMethodNameImpl() { result = i.getValue() }

  final override Expr getReceiverImpl() { toGenerated(result) = g.getScope() }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }
}

class RegularMethodCall extends MethodCallImpl, TRegularMethodCall {
  private Generated::Call g;

  RegularMethodCall() { this = TRegularMethodCall(g) }

  final override Expr getReceiverImpl() {
    toGenerated(result) = g.getReceiver()
    or
    not exists(g.getReceiver()) and
    toGenerated(result) = g.getMethod().(Generated::ScopeResolution).getScope()
    or
    result = TSelfSynth(this, 0)
  }

  final override string getMethodNameImpl() {
    isRegularMethodCall(g) and
    (
      result = "call" and g.getMethod() instanceof Generated::ArgumentList
      or
      result = g.getMethod().(Generated::Token).getValue()
      or
      result = g.getMethod().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
    )
  }

  final override Expr getArgumentImpl(int n) {
    toGenerated(result) = g.getArguments().getChild(n)
    or
    toGenerated(result) = g.getMethod().(Generated::ArgumentList).getChild(n)
  }

  final override int getNumberOfArgumentsImpl() {
    result =
      count(g.getArguments().getChild(_)) +
        count(g.getMethod().(Generated::ArgumentList).getChild(_))
  }

  final override Block getBlock() { toGenerated(result) = g.getBlock() }
}

class ElementReferenceImpl extends MethodCallImpl, TElementReference {
  private Generated::ElementReference g;

  ElementReferenceImpl() { this = TElementReference(g) }

  final override Expr getReceiverImpl() { toGenerated(result) = g.getObject() }

  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getChild(_)) }

  final override string getMethodNameImpl() { result = "[]" }
}

class TokenSuperCall extends SuperCall, MethodCallImpl, TTokenSuperCall {
  private Generated::Super g;

  TokenSuperCall() { this = TTokenSuperCall(g) }

  final override string getMethodNameImpl() { result = g.getValue() }

  final override Expr getReceiverImpl() { none() }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }
}

class RegularSuperCall extends SuperCall, MethodCallImpl, TRegularSuperCall {
  private Generated::Call g;

  RegularSuperCall() { this = TRegularSuperCall(g) }

  final override string getMethodNameImpl() { result = g.getMethod().(Generated::Super).getValue() }

  final override Expr getReceiverImpl() { none() }

  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getArguments().getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getArguments().getChild(_)) }

  final override Block getBlock() { toGenerated(result) = g.getBlock() }
}

class YieldCallImpl extends CallImpl, YieldCall {
  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getChild().getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getChild().getChild(_)) }
}
