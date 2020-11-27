import codeql_ruby.AST
private import codeql_ruby.Generated
private import internal.Method

/** A callable. */
class Callable extends AstNode {
  Callable() { this instanceof CallableRange }

  /** Gets the number of parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this callable. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the nth parameter of this callable. */
  final Parameter getParameter(int n) { result = this.(CallableRange).getParameter(n) }
}

/** A method. */
class Method extends Callable, @method {
  final override Generated::Method generated;

  override string describeQlClass() { result = "Method" }

  override string toString() { result = this.getName() }

  /** Gets the name of this method. */
  string getName() {
    result = generated.getName().(Generated::Token).getValue() or
    // TODO: use hand-written Symbol class
    result = generated.getName().(Generated::Symbol).toString() or
    result = generated.getName().(Generated::Setter).getName().getValue() + "="
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
  predicate isSetter() { generated.getName() instanceof Generated::Setter }
}

/** A singleton method. */
class SingletonMethod extends Callable, @singleton_method {
  final override Generated::SingletonMethod generated;

  override string describeQlClass() { result = "SingletonMethod" }

  override string toString() { result = this.getName() }

  /** Gets the name of this method. */
  string getName() {
    result = generated.getName().(Generated::Token).getValue() or
    // TODO: use hand-written Symbol class
    result = generated.getName().(Generated::Symbol).toString() or
    result = generated.getName().(Generated::Setter).getName().getValue() + "="
  }
}

/**
 * A lambda (anonymous method). For example:
 * ```rb
 * -> (x) { x + 1 }
 * ```
 */
class Lambda extends Callable, @lambda {
  final override Generated::Lambda generated;

  override string describeQlClass() { result = "Lambda" }

  override string toString() { result = "-> { ... }" }
}

/** A block. */
class Block extends AstNode, Callable {
  Block() { this instanceof BlockRange }
}

/** A block enclosed within `do` and `end`. */
class DoBlock extends Block, @do_block {
  final override Generated::DoBlock generated;

  override string describeQlClass() { result = "DoBlock" }

  override string toString() { result = "| ... |" }
}

/**
 * A block defined using curly braces, e.g. in the following code:
 * ```rb
 * names.each { |name| puts name }
 * ```
 */
class BraceBlock extends Block, @block {
  final override Generated::Block generated;

  override string describeQlClass() { result = "BraceBlock" }

  override string toString() { result = "{ ... }" }
}
