private import codeql.ruby.AST
private import codeql.ruby.controlflow.ControlFlowGraph
private import internal.AST
private import internal.TreeSitter
private import internal.Method

/** A callable. */
class Callable extends StmtSequence, Expr, Scope, TCallable {
  /** Gets the number of parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this callable. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the `n`th parameter of this callable. */
  Parameter getParameter(int n) { none() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getParameter" and result = this.getParameter(_)
  }
}

/** A method. */
class MethodBase extends Callable, BodyStmt, Scope, TMethodBase {
  /** Gets the name of this method. */
  string getName() { none() }

  /** Holds if the name of this method is `name`. */
  final predicate hasName(string name) { this.getName() = name }

  override AstNode getAChild(string pred) {
    result = Callable.super.getAChild(pred)
    or
    result = BodyStmt.super.getAChild(pred)
  }
}

/** A call to `private`. */
private class Private extends MethodCall {
  Private() { this.getMethodName() = "private" }
}

/** A normal method. */
class Method extends MethodBase, TMethod {
  private Ruby::Method g;

  Method() { this = TMethod(g) }

  final override string getAPrimaryQlClass() { result = "Method" }

  final override string getName() {
    result = g.getName().(Ruby::Token).getValue() or
    result = g.getName().(Ruby::Setter).getName().getValue() + "="
  }

  /**
   * Holds if this is a setter method, as in the following example:
   * ```rb
   * class Person
   *   def name=(n)
   *     @name = n
   *   end
   * end
   * ```
   */
  final predicate isSetter() { g.getName() instanceof Ruby::Setter }

  /**
   * Holds if this method is private. All methods with the name prefix
   * `private` are private below:
   *
   * ```rb
   * class C
   *   private def private1
   *   end
   *
   *   def public
   *   end
   *
   *   def private2
   *   end
   *   private :private2
   *
   *   private
   *
   *   def private3
   *   end
   *
   *   def private4
   *   end
   * end
   * ```
   */
  predicate isPrivate() {
    this = any(Private p).getArgument(0)
    or
    exists(ClassDeclaration c, Private p, SymbolLiteral s |
      p.getArgument(0) = s and
      p = c.getAStmt() and
      this.getName() = s.getValueText() and
      this = c.getAStmt()
    )
    or
    exists(ClassDeclaration c, int i, int j |
      c.getStmt(i).(Private).getNumberOfArguments() = 0 and
      this = c.getStmt(j) and
      j > i
    )
    or
    // Top-level methods are private members of the Object class
    this.getEnclosingModule() instanceof Toplevel
  }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = this.getName() }
}

/** A singleton method. */
class SingletonMethod extends MethodBase, TSingletonMethod {
  private Ruby::SingletonMethod g;

  SingletonMethod() { this = TSingletonMethod(g) }

  final override string getAPrimaryQlClass() { result = "SingletonMethod" }

  /** Gets the object of this singleton method. */
  final Expr getObject() { toGenerated(result) = g.getObject() }

  final override string getName() {
    result = g.getName().(Ruby::Token).getValue()
    or
    result = g.getName().(Ruby::Setter).getName().getValue() + "="
  }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = this.getName() }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getObject" and result = this.getObject()
  }
}

/**
 * A lambda (anonymous method). For example:
 * ```rb
 * -> (x) { x + 1 }
 * ```
 */
class Lambda extends Callable, BodyStmt, TLambda {
  private Ruby::Lambda g;

  Lambda() { this = TLambda(g) }

  final override string getAPrimaryQlClass() { result = "Lambda" }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = "-> { ... }" }

  final override AstNode getAChild(string pred) {
    result = Callable.super.getAChild(pred)
    or
    result = BodyStmt.super.getAChild(pred)
  }
}

/** A block. */
class Block extends Callable, StmtSequence, Scope, TBlock {
  override AstNode getAChild(string pred) {
    result = Callable.super.getAChild(pred)
    or
    result = StmtSequence.super.getAChild(pred)
  }
}

/** A block enclosed within `do` and `end`. */
class DoBlock extends Block, BodyStmt, TDoBlock {
  private Ruby::DoBlock g;

  DoBlock() { this = TDoBlock(g) }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = "do ... end" }

  final override AstNode getAChild(string pred) {
    result = Block.super.getAChild(pred)
    or
    result = BodyStmt.super.getAChild(pred)
  }

  final override string getAPrimaryQlClass() { result = "DoBlock" }
}

/**
 * A block defined using curly braces, e.g. in the following code:
 * ```rb
 * names.each { |name| puts name }
 * ```
 */
class BraceBlock extends Block, TBraceBlock {
  final override string toString() { result = "{ ... }" }

  final override string getAPrimaryQlClass() { result = "BraceBlock" }
}
