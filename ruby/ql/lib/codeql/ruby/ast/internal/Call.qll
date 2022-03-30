private import TreeSitter
private import Variable
private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST

predicate isIdentifierMethodCall(Ruby::Identifier g) { vcall(g) and not access(g, _) }

predicate isRegularMethodCall(Ruby::Call g) { not g.getMethod() instanceof Ruby::Super }

predicate isScopeResolutionMethodCall(Ruby::ScopeResolution g, Ruby::Identifier i) {
  i = g.getName() and
  not exists(Ruby::Call c | c.getMethod() = g)
}

abstract class CallImpl extends Expr, TCall {
  abstract AstNode getArgumentImpl(int n);

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

abstract class MethodCallImpl extends CallImpl, TMethodCall {
  abstract AstNode getReceiverImpl();

  abstract string getMethodNameImpl();

  abstract Block getBlockImpl();
}

class MethodCallSynth extends MethodCallImpl, TMethodCallSynth {
  final override string getMethodNameImpl() {
    exists(boolean setter, string name | this = TMethodCallSynth(_, _, name, setter, _) |
      setter = true and result = name + "="
      or
      setter = false and result = name
    )
  }

  final override AstNode getReceiverImpl() { synthChild(this, 0, result) }

  final override AstNode getArgumentImpl(int n) { synthChild(this, n + 1, result) and n >= 0 }

  final override int getNumberOfArgumentsImpl() { this = TMethodCallSynth(_, _, _, _, result) }

  final override Block getBlockImpl() { synthChild(this, -2, result) }
}

class IdentifierMethodCall extends MethodCallImpl, TIdentifierMethodCall {
  private Ruby::Identifier g;

  IdentifierMethodCall() { this = TIdentifierMethodCall(g) }

  final override string getMethodNameImpl() { result = g.getValue() }

  final override AstNode getReceiverImpl() { result = TSelfSynth(this, 0, _) }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }

  final override Block getBlockImpl() { none() }
}

class ScopeResolutionMethodCall extends MethodCallImpl, TScopeResolutionMethodCall {
  private Ruby::ScopeResolution g;
  private Ruby::Identifier i;

  ScopeResolutionMethodCall() { this = TScopeResolutionMethodCall(g, i) }

  final override string getMethodNameImpl() { result = i.getValue() }

  final override Expr getReceiverImpl() { toGenerated(result) = g.getScope() }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }

  final override Block getBlockImpl() { none() }
}

class RegularMethodCall extends MethodCallImpl, TRegularMethodCall {
  private Ruby::Call g;

  RegularMethodCall() { this = TRegularMethodCall(g) }

  final override Expr getReceiverImpl() {
    toGenerated(result) = g.getReceiver()
    or
    not exists(g.getReceiver()) and
    toGenerated(result) = g.getMethod().(Ruby::ScopeResolution).getScope()
    or
    result = TSelfSynth(this, 0, _)
  }

  final override string getMethodNameImpl() {
    isRegularMethodCall(g) and
    (
      result = "call" and g.getMethod() instanceof Ruby::ArgumentList
      or
      result = g.getMethod().(Ruby::Token).getValue()
      or
      result = g.getMethod().(Ruby::ScopeResolution).getName().(Ruby::Token).getValue()
    )
  }

  final override Expr getArgumentImpl(int n) {
    toGenerated(result) = g.getArguments().getChild(n)
    or
    toGenerated(result) = g.getMethod().(Ruby::ArgumentList).getChild(n)
  }

  final override int getNumberOfArgumentsImpl() {
    result =
      count(g.getArguments().getChild(_)) + count(g.getMethod().(Ruby::ArgumentList).getChild(_))
  }

  final override Block getBlockImpl() { toGenerated(result) = g.getBlock() }
}

class ElementReferenceImpl extends MethodCallImpl, TElementReference {
  private Ruby::ElementReference g;

  ElementReferenceImpl() { this = TElementReference(g) }

  final override Expr getReceiverImpl() { toGenerated(result) = g.getObject() }

  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getChild(_)) }

  final override string getMethodNameImpl() { result = "[]" }

  final override Block getBlockImpl() { none() }
}

abstract class SuperCallImpl extends MethodCallImpl, TSuperCall { }

class TokenSuperCall extends SuperCallImpl, TTokenSuperCall {
  private Ruby::Super g;

  TokenSuperCall() { this = TTokenSuperCall(g) }

  final override string getMethodNameImpl() { result = g.getValue() }

  final override Expr getReceiverImpl() { none() }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }

  final override Block getBlockImpl() { none() }
}

class RegularSuperCall extends SuperCallImpl, TRegularSuperCall {
  private Ruby::Call g;

  RegularSuperCall() { this = TRegularSuperCall(g) }

  final override string getMethodNameImpl() { result = g.getMethod().(Ruby::Super).getValue() }

  final override Expr getReceiverImpl() { none() }

  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getArguments().getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getArguments().getChild(_)) }

  final override Block getBlockImpl() { toGenerated(result) = g.getBlock() }
}

class YieldCallImpl extends CallImpl, TYieldCall {
  Ruby::Yield g;

  YieldCallImpl() { this = TYieldCall(g) }

  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getChild().getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getChild().getChild(_)) }
}
