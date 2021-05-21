private import TreeSitter
private import Variable
private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST

predicate isIdentifierMethodCall(Generated::Identifier g) { vcall(g) and not access(g, _) }

predicate isRegularMethodCall(Generated::Call g) { not g.getMethod() instanceof Generated::Super }

string regularMethodCallName(Generated::Call g) {
  isRegularMethodCall(g) and
  (
    result = "call" and g.getMethod() instanceof Generated::ArgumentList
    or
    result = g.getMethod().(Generated::Token).getValue()
    or
    result = g.getMethod().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
  )
}

predicate isScopeResolutionMethodCall(Generated::ScopeResolution g, Generated::Identifier i) {
  i = g.getName() and
  not exists(Generated::Call c | c.getMethod() = g)
}

string methodCallName(MethodCall mc) {
  exists(Generated::AstNode g | g = toGenerated(mc) |
    isIdentifierMethodCall(g) and result = g.(Generated::Identifier).getValue()
    or
    result = regularMethodCallName(g)
    or
    isScopeResolutionMethodCall(g, any(Generated::Identifier i | result = i.getValue()))
  )
}

bindingset[s]
string getMethodName(MethodCall mc, string s) {
  if mc instanceof SetterMethodCall then result = s + "=" else result = s
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
}

/**
 * Gets the special integer literal used to specify the number of arguments
 * in a synthesized call.
 */
private TIntegerLiteralSynth getNumberOfArgumentsSynth(MethodCall mc, int value) {
  result = TIntegerLiteralSynth(mc, -2, value)
}

class MethodCallSynth extends MethodCallImpl, TMethodCallSynth {
  final override string getMethodName() {
    exists(string name |
      this = TMethodCallSynth(_, _, name) and
      result = getMethodName(this, name)
    )
  }

  final override Expr getReceiverImpl() { synthChild(this, 0, result) }

  final override Expr getArgumentImpl(int n) { synthChild(this, n + 1, result) and n >= 0 }

  final override int getNumberOfArgumentsImpl() { exists(getNumberOfArgumentsSynth(this, result)) }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getNumberOfArguments" and
    result = getNumberOfArgumentsSynth(this, _)
  }
}

class IdentifierMethodCall extends MethodCallImpl, TIdentifierMethodCall {
  private Generated::Identifier g;

  IdentifierMethodCall() { this = TIdentifierMethodCall(g) }

  final override string getMethodName() { result = getMethodName(this, g.getValue()) }

  final override Self getReceiverImpl() { result = TSelfSynth(this, 0) }

  final override Expr getArgumentImpl(int n) { none() }

  final override int getNumberOfArgumentsImpl() { result = 0 }
}

class ScopeResolutionMethodCall extends MethodCallImpl, TScopeResolutionMethodCall {
  private Generated::ScopeResolution g;
  private Generated::Identifier i;

  ScopeResolutionMethodCall() { this = TScopeResolutionMethodCall(g, i) }

  final override string getMethodName() { result = getMethodName(this, i.getValue()) }

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

  final override string getMethodName() { result = getMethodName(this, regularMethodCallName(g)) }

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

class ElementReferenceReal extends MethodCallImpl, TElementReferenceReal {
  private Generated::ElementReference g;

  ElementReferenceReal() { this = TElementReferenceReal(g) }

  final override Expr getReceiverImpl() { toGenerated(result) = g.getObject() }

  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getChild(_)) }
}

class ElementReferenceSynth extends MethodCallImpl, TElementReferenceSynth {
  final override Expr getReceiverImpl() { synthChild(this, 0, result) }

  final override Expr getArgumentImpl(int n) { synthChild(this, n + 1, result) and n >= 0 }

  final override int getNumberOfArgumentsImpl() { exists(getNumberOfArgumentsSynth(this, result)) }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getNumberOfArguments" and
    result = getNumberOfArgumentsSynth(this, _)
  }
}

class TokenSuperCall extends SuperCall, TTokenSuperCall {
  private Generated::Super g;

  TokenSuperCall() { this = TTokenSuperCall(g) }

  final override string getMethodName() { result = getMethodName(this, g.getValue()) }
}

class RegularSuperCall extends SuperCall, MethodCallImpl, TRegularSuperCall {
  private Generated::Call g;

  RegularSuperCall() { this = TRegularSuperCall(g) }

  final override string getMethodName() {
    result = getMethodName(this, g.getMethod().(Generated::Super).getValue())
  }

  final override Expr getReceiverImpl() { none() }

  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getArguments().getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getArguments().getChild(_)) }

  final override Block getBlock() { toGenerated(result) = g.getBlock() }
}

class YieldCallImpl extends CallImpl, YieldCall {
  final override Expr getArgumentImpl(int n) { toGenerated(result) = g.getChild().getChild(n) }

  final override int getNumberOfArgumentsImpl() { result = count(g.getChild().getChild(_)) }
}
