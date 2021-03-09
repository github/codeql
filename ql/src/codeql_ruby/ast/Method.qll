private import codeql_ruby.AST
private import codeql_ruby.controlflow.ControlFlowGraph
private import internal.AST
private import internal.Method

/** A callable. */
class Callable extends Expr, CfgScope {
  override Callable::Range range;

  /** Gets the number of parameters of this callable. */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this callable. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the `n`th parameter of this callable. */
  final Parameter getParameter(int n) { result = range.getParameter(n) }
}

/** A method. */
class MethodBase extends Callable, BodyStatement, Scope {
  override MethodBase::Range range;

  /** Gets the name of this method. */
  final string getName() { result = range.getName() }
}

/** A normal method. */
class Method extends MethodBase, @method {
  final override Method::Range range;

  final override string getAPrimaryQlClass() { result = "Method" }

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
  final predicate isSetter() { range.isSetter() }
}

/** A singleton method. */
class SingletonMethod extends MethodBase, @singleton_method {
  final override SingletonMethod::Range range;

  final override string getAPrimaryQlClass() { result = "SingletonMethod" }

  /** Gets the object of this singleton method. */
  final Expr getObject() { result = range.getObject() }
}

/**
 * A lambda (anonymous method). For example:
 * ```rb
 * -> (x) { x + 1 }
 * ```
 */
class Lambda extends Callable, BodyStatement, @lambda {
  final override Lambda::Range range;

  final override string getAPrimaryQlClass() { result = "Lambda" }
}

/** A block. */
class Block extends Callable, StmtSequence, Scope {
  override Block::Range range;
}

/** A block enclosed within `do` and `end`. */
class DoBlock extends Block, BodyStatement, @do_block {
  final override DoBlock::Range range;

  final override string getAPrimaryQlClass() { result = "DoBlock" }
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
}
