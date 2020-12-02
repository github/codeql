import codeql_ruby.AST
private import internal.TreeSitter
private import internal.Method

/** A callable. */
class Callable extends AstNode {
  CallableRange self;

  Callable() { self = this }

  /** Gets the number of parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this callable. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the `n`th parameter of this callable. */
  final Parameter getParameter(int n) { result = self.getParameter(n) }
}

/** A method. */
class Method extends Callable, @method {
  final override MethodRange self;
  final override Generated::Method generated;

  final override string describeQlClass() { result = "Method" }

  final override string toString() { result = this.getName() }

  /** Gets the name of this method. */
  final string getName() { result = self.getName() }

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
  final override SingletonMethodRange self;

  final override string describeQlClass() { result = "SingletonMethod" }

  final override string toString() { result = this.getName() }

  /** Gets the name of this method. */
  final string getName() { result = self.getName() }
}

/**
 * A lambda (anonymous method). For example:
 * ```rb
 * -> (x) { x + 1 }
 * ```
 */
class Lambda extends Callable, @lambda {
  final override LambdaRange self;

  final override string describeQlClass() { result = "Lambda" }

  final override string toString() { result = "-> { ... }" }
}

/** A block. */
class Block extends AstNode, Callable {
  override BlockRange self;
}

/** A block enclosed within `do` and `end`. */
class DoBlock extends Block, @do_block {
  final override DoBlockRange self;

  final override string describeQlClass() { result = "DoBlock" }

  final override string toString() { result = "| ... |" }
}

/**
 * A block defined using curly braces, e.g. in the following code:
 * ```rb
 * names.each { |name| puts name }
 * ```
 */
class BraceBlock extends Block, @block {
  final override BraceBlockRange self;

  final override string describeQlClass() { result = "BraceBlock" }

  final override string toString() { result = "{ ... }" }
}
