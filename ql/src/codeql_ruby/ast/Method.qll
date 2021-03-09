private import codeql_ruby.AST
private import codeql_ruby.controlflow.ControlFlowGraph
private import internal.AST
private import internal.TreeSitter

/** A callable. */
class Callable extends Expr, CfgScope, TCallable {
  /** Gets the number of parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this callable. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the `n`th parameter of this callable. */
  Parameter getParameter(int n) { none() }

  override predicate child(string label, AstNode child) {
    label = "getParameter" and child = this.getParameter(_)
  }
}

/** A method. */
class MethodBase extends Callable, BodyStmt, Scope, TMethodBase {
  /** Gets the name of this method. */
  string getName() { none() }

  override predicate child(string label, AstNode child) {
    Callable.super.child(label, child)
    or
    BodyStmt.super.child(label, child)
  }
}

/** A normal method. */
class Method extends MethodBase, TMethod {
  private Generated::Method g;

  Method() { this = TMethod(g) }

  final override string getAPrimaryQlClass() { result = "Method" }

  final override string getName() {
    result = g.getName().(Generated::Token).getValue() or
    result = g.getName().(Generated::Setter).getName().getValue() + "="
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
  final predicate isSetter() { g.getName() instanceof Generated::Setter }

  final override Parameter getParameter(int n) {
    toTreeSitter(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = this.getName() }
}

/** A singleton method. */
class SingletonMethod extends MethodBase, TSingletonMethod {
  private Generated::SingletonMethod g;

  SingletonMethod() { this = TSingletonMethod(g) }

  final override string getAPrimaryQlClass() { result = "SingletonMethod" }

  /** Gets the object of this singleton method. */
  final Expr getObject() { toTreeSitter(result) = g.getObject() }

  final override string getName() {
    result = g.getName().(Generated::Token).getValue()
    or
    // result = g.getName().(SymbolLiteral).getValueText() or
    result = g.getName().(Generated::Setter).getName().getValue() + "="
  }

  final override Parameter getParameter(int n) {
    toTreeSitter(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = this.getName() }

  final override predicate child(string label, AstNode child) {
    MethodBase.super.child(label, child)
    or
    label = "getObject" and child = this.getObject()
  }
}

/**
 * A lambda (anonymous method). For example:
 * ```rb
 * -> (x) { x + 1 }
 * ```
 */
class Lambda extends Callable, BodyStmt, TLambda {
  private Generated::Lambda g;

  Lambda() { this = TLambda(g) }

  final override string getAPrimaryQlClass() { result = "Lambda" }

  final override Parameter getParameter(int n) {
    toTreeSitter(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = "-> { ... }" }

  final override predicate child(string label, AstNode child) {
    Callable.super.child(label, child)
    or
    BodyStmt.super.child(label, child)
  }
}

/** A block. */
class Block extends Callable, StmtSequence, Scope, TBlock {
  override predicate child(string label, AstNode child) {
    Callable.super.child(label, child)
    or
    StmtSequence.super.child(label, child)
  }
}

/** A block enclosed within `do` and `end`. */
class DoBlock extends Block, BodyStmt, TDoBlock {
  private Generated::DoBlock g;

  DoBlock() { this = TDoBlock(g) }

  final override Parameter getParameter(int n) {
    toTreeSitter(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = "do ... end" }

  final override predicate child(string label, AstNode child) {
    Block.super.child(label, child)
    or
    BodyStmt.super.child(label, child)
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
  private Generated::Block g;

  BraceBlock() { this = TBraceBlock(g) }

  final override Parameter getParameter(int n) {
    toTreeSitter(result) = g.getParameters().getChild(n)
  }

  final override Stmt getStmt(int i) { toTreeSitter(result) = g.getChild(i) }

  final override string toString() { result = "{ ... }" }

  final override string getAPrimaryQlClass() { result = "BraceBlock" }
}
