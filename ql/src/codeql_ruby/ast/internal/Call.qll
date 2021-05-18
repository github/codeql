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

class MethodCallSynth extends MethodCall, TMethodCallSynth {
  final override string getMethodName() {
    exists(string name |
      this = TMethodCallSynth(_, _, name) and
      result = getMethodName(this, name)
    )
  }

  final override Expr getReceiver() { synthChild(this, 0, result) }

  final override Expr getArgument(int n) { synthChild(this, n + 1, result) and n >= 0 }
}

abstract class MethodCallReal extends MethodCall {
  abstract Expr getReceiverReal();

  abstract Expr getArgumentReal(int n);

  abstract int getNumberOfArgumentsReal();

  override Expr getReceiver() { result = this.getReceiverReal() }

  final override Expr getArgument(int n) { result = this.getArgumentReal(n) }
}

class IdentifierMethodCall extends MethodCallReal, TIdentifierMethodCall {
  private Generated::Identifier g;

  IdentifierMethodCall() { this = TIdentifierMethodCall(g) }

  final override string getMethodName() { result = getMethodName(this, g.getValue()) }

  final override Self getReceiver() { result = TSelfSynth(this, 0) }

  final override Self getReceiverReal() { none() }

  final override Expr getArgumentReal(int n) { none() }

  final override int getNumberOfArgumentsReal() { result = 0 }
}

class ScopeResolutionMethodCall extends MethodCallReal, TScopeResolutionMethodCall {
  private Generated::ScopeResolution g;
  private Generated::Identifier i;

  ScopeResolutionMethodCall() { this = TScopeResolutionMethodCall(g, i) }

  final override string getMethodName() { result = getMethodName(this, i.getValue()) }

  final override Expr getReceiverReal() { toGenerated(result) = g.getScope() }

  final override Expr getArgumentReal(int n) { none() }

  final override int getNumberOfArgumentsReal() { result = 0 }
}

class RegularMethodCall extends MethodCallReal, TRegularMethodCall {
  private Generated::Call g;

  RegularMethodCall() { this = TRegularMethodCall(g) }

  final override Expr getReceiver() {
    result = TSelfSynth(this, 0) or result = this.getReceiverReal()
  }

  final override Expr getReceiverReal() {
    toGenerated(result) = g.getReceiver()
    or
    not exists(g.getReceiver()) and
    toGenerated(result) = g.getMethod().(Generated::ScopeResolution).getScope()
  }

  final override string getMethodName() { result = getMethodName(this, regularMethodCallName(g)) }

  final override Expr getArgumentReal(int n) {
    toGenerated(result) = g.getArguments().getChild(n)
    or
    toGenerated(result) = g.getMethod().(Generated::ArgumentList).getChild(n)
  }

  final override int getNumberOfArgumentsReal() {
    result =
      count(g.getArguments().getChild(_)) +
        count(g.getMethod().(Generated::ArgumentList).getChild(_))
  }

  final override Block getBlock() { toGenerated(result) = g.getBlock() }
}

class ElementReferenceReal extends MethodCallReal, TElementReferenceReal {
  private Generated::ElementReference g;

  ElementReferenceReal() { this = TElementReferenceReal(g) }

  final override Expr getReceiverReal() { toGenerated(result) = g.getObject() }

  final override Expr getArgumentReal(int n) { toGenerated(result) = g.getChild(n) }

  final override int getNumberOfArgumentsReal() { result = count(g.getChild(_)) }
}

class ElementReferenceSynth extends MethodCall, TElementReferenceSynth {
  final override Expr getReceiver() { synthChild(this, 0, result) }

  final override Expr getArgument(int n) { synthChild(this, n + 1, result) and n >= 0 }
}

class TokenSuperCall extends SuperCall, TTokenSuperCall {
  private Generated::Super g;

  TokenSuperCall() { this = TTokenSuperCall(g) }

  final override string getMethodName() { result = getMethodName(this, g.getValue()) }
}

class RegularSuperCall extends SuperCall, MethodCallReal, TRegularSuperCall {
  private Generated::Call g;

  RegularSuperCall() { this = TRegularSuperCall(g) }

  final override string getMethodName() {
    result = getMethodName(this, g.getMethod().(Generated::Super).getValue())
  }

  final override Expr getReceiverReal() { none() }

  final override Expr getArgumentReal(int n) { toGenerated(result) = g.getArguments().getChild(n) }

  final override int getNumberOfArgumentsReal() { result = count(g.getArguments().getChild(_)) }

  final override Block getBlock() { toGenerated(result) = g.getBlock() }
}
