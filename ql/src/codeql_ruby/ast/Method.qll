private import codeql_ruby.AST
private import internal.TreeSitter
private import internal.Method

/** A callable. */
class Callable extends AstNode {
  Callable::Range range;

  Callable() { range = this }

  /** Gets the number of parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this callable. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the `n`th parameter of this callable. */
  final Parameter getParameter(int n) { result = range.getParameter(n) }
}

/** A method. */
class Method extends Callable, @method {
  final override Method::Range range;
  final override Generated::Method generated;

  final override string getAPrimaryQlClass() { result = "Method" }

  final override string toString() { result = this.getName() }

  /** Gets the name of this method. */
  final string getName() { result = range.getName() }

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
  final predicate isSetter() { generated.getName() instanceof Generated::Setter }
}

/** A singleton method. */
class SingletonMethod extends Callable, @singleton_method {
  final override SingletonMethod::Range range;

  final override string getAPrimaryQlClass() { result = "SingletonMethod" }

  final override string toString() { result = this.getName() }

  /** Gets the name of this method. */
  final string getName() { result = range.getName() }
}

/**
 * A lambda (anonymous method). For example:
 * ```rb
 * -> (x) { x + 1 }
 * ```
 */
class Lambda extends Callable, @lambda {
  final override Lambda::Range range;

  final override string getAPrimaryQlClass() { result = "Lambda" }

  final override string toString() { result = "-> { ... }" }
}

/** A block. */
class Block extends AstNode, Callable {
  override Block::Range range;
}

/** A block enclosed within `do` and `end`. */
class DoBlock extends Block, @do_block {
  final override DoBlock::Range range;

  final override string getAPrimaryQlClass() { result = "DoBlock" }

  final override string toString() { result = "do ... end" }
}

/**
 * A block defined using curly braces, e.g. in the following code:
 * ```rb
 * names.each { |name| puts name }
 * ```
 */
class BraceBlock extends Block, @block {
  final override BraceBlock::Range range;

  final override string getAPrimaryQlClass() { result = "BraceBlock" }

  final override string toString() { result = "{ ... }" }
}
