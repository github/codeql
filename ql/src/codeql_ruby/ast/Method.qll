private import codeql_ruby.AST
private import codeql_ruby.controlflow.ControlFlowGraph
private import internal.AST
private import internal.Method
private import internal.TreeSitter

/**
 * A representation of a method.
 */
class Method extends TMethod {
  /** Get a declaration of this module, if any. */
  MethodBase getADeclaration() { result.getMethod() = this }

  /** Gets a textual representation of this method. */
  string toString() {
    exists(Module m, string name |
      this = TInstanceMethod(m, name) and result = m.toString() + "." + name
    )
  }

  /** Gets the location of this method. */
  Location getLocation() {
    result =
      min(MethodBase decl, Module m, string name, Location loc, int weight |
        this = TInstanceMethod(m, name) and
        decl = methodDeclaration(m, name) and
        loc = decl.getLocation() and
        if exists(loc.getFile().getRelativePath()) then weight = 0 else weight = 1
      |
        loc
        order by
          weight, count(decl.getAStmt()) desc, loc.getFile().getAbsolutePath(), loc.getStartLine(),
          loc.getStartColumn()
      )
  }
}

/** A callable. */
class Callable extends Expr, Scope, TCallable {
  /** Gets the number of parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this callable. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the `n`th parameter of this callable. */
  Parameter getParameter(int n) { none() }

  override AstNode getAChild(string pred) {
    pred = "getParameter" and result = this.getParameter(_)
  }
}

/** A method. */
class MethodBase extends Callable, BodyStmt, Scope, TMethodBase {
  /** Gets the name of this method. */
  string getName() { none() }

  /** Gets the method defined by this declaration. */
  Method getMethod() { none() }

  override AstNode getAChild(string pred) {
    result = Callable.super.getAChild(pred)
    or
    result = BodyStmt.super.getAChild(pred)
  }
}

/** A normal method. */
class MethodDeclaration extends MethodBase, TMethodDeclaration {
  private Generated::Method g;

  MethodDeclaration() { this = TMethodDeclaration(g) }

  final override string getAPrimaryQlClass() { result = "MethodDeclaration" }

  final override string getName() {
    result = g.getName().(Generated::Token).getValue() or
    result = g.getName().(Generated::Setter).getName().getValue() + "="
  }

  final override Method getMethod() {
    exists(Module owner, string name |
      result = TInstanceMethod(owner, name) and this = methodDeclaration(owner, name)
    )
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
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = this.getName() }
}

/** A singleton method. */
class SingletonMethod extends MethodBase, TSingletonMethod {
  private Generated::SingletonMethod g;

  SingletonMethod() { this = TSingletonMethod(g) }

  final override string getAPrimaryQlClass() { result = "SingletonMethod" }

  /** Gets the object of this singleton method. */
  final Expr getObject() { toGenerated(result) = g.getObject() }

  final override string getName() {
    result = g.getName().(Generated::Token).getValue()
    or
    result = g.getName().(Generated::Setter).getName().getValue() + "="
  }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override string toString() { result = this.getName() }

  final override AstNode getAChild(string pred) {
    result = MethodBase.super.getAChild(pred)
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
  private Generated::Lambda g;

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
  private Generated::DoBlock g;

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
  private Generated::Block g;

  BraceBlock() { this = TBraceBlock(g) }

  final override Parameter getParameter(int n) {
    toGenerated(result) = g.getParameters().getChild(n)
  }

  final override Stmt getStmt(int i) { toGenerated(result) = g.getChild(i) }

  final override string toString() { result = "{ ... }" }

  final override string getAPrimaryQlClass() { result = "BraceBlock" }
}
