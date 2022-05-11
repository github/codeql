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

  /** Holds if this method is private. */
  predicate isPrivate() { none() }
}

/**
 * A method call which modifies another method in some way.
 * For example, `private :foo` makes the method `foo` private.
 */
private class MethodModifier extends MethodCall {
  /** Gets the name of the method that this call applies to. */
  Expr getMethodArgument() { result = this.getArgument(0) }

  /** Holds if this call modifies a method with name `name` in namespace `n`. */
  pragma[noinline]
  predicate modifiesMethod(Namespace n, string name) {
    this = n.getAStmt() and
    [
      this.getMethodArgument().getConstantValue().getStringlikeValue(),
      this.getMethodArgument().(MethodBase).getName()
    ] = name
  }
}

/** A call to `private` or `private_class_method`. */
private class Private extends MethodModifier {
  private Namespace namespace;
  private int position;

  Private() { this.getMethodName() = "private" and namespace.getStmt(position) = this }

  override predicate modifiesMethod(Namespace n, string name) {
    n = namespace and
    (
      // def foo
      // ...
      // private :foo
      super.modifiesMethod(n, name)
      or
      // private
      // ...
      // def foo
      not exists(this.getMethodArgument()) and
      exists(MethodBase m, int i | n.getStmt(i) = m and m.getName() = name and i > position)
    )
  }
}

/** A call to `private_class_method`. */
private class PrivateClassMethod extends MethodModifier {
  PrivateClassMethod() { this.getMethodName() = "private_class_method" }
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
  override predicate isPrivate() {
    exists(Namespace n, string name |
      any(Private p).modifiesMethod(n, name) and
      isDeclaredIn(this, n, name)
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

/**
 * Holds if the method `m` has name `name` and is declared in namespace `n`.
 */
pragma[noinline]
private predicate isDeclaredIn(MethodBase m, Namespace n, string name) {
  n = m.getEnclosingModule() and name = m.getName()
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

  /**
   * Holds if this method is private. All methods with the name prefix
   * `private` are private below:
   *
   * ```rb
   * class C
   *   private_class_method def self.private1
   *   end
   *
   *   def self.public
   *   end
   *
   *   def self.private2
   *   end
   *   private_class_method :private2
   *
   *   private # this has no effect on singleton methods
   *
   *   def self.public2
   *   end
   * end
   * ```
   */
  override predicate isPrivate() {
    exists(Namespace n, string name |
      any(PrivateClassMethod p).modifiesMethod(n, name) and
      isDeclaredIn(this, n, name)
    )
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
