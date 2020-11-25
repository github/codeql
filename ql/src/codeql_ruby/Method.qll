import codeql_ruby.AST
private import codeql_ruby.Generated

/** A Ruby method. */
class Method extends @method, AstNode {
  Generated::Method generated;

  Method() { generated = this }

  override string describeQlClass() { result = "Method" }

  override string toString() { result = this.getName() }

  /** Gets the name of the method. */
  string getName() {
    result = generated.getName().(Generated::Token).getValue() or
    // TODO: use hand-written Symbol class
    result = generated.getName().(Generated::Symbol).toString() or
    result = generated.getName().(Generated::Setter).getName().getValue() + "="
  }

  /**
   * Holds if this is a setter method, as in the following example:
   * ```
   * class Person
   *   def name=(n)
   *     @name = n
   *   end
   * end
   * ```
   */
  predicate isSetter() { generated.getName() instanceof Generated::Setter }

  /** Gets the number of parameters of this method. */
  int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this method. */
  Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the nth parameter of this method. */
  Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}

/**
 * A Ruby lambda (anonymous method). For example:
 * ```
 * -> (x) { x + 1 }
 * ```
 */
class Lambda extends @lambda, AstNode {
  Generated::Lambda generated;

  Lambda() { generated = this }

  override string describeQlClass() { result = "Lambda" }

  override string toString() { result = "-> { ... }" }

  /** Gets the number of parameters of this lambda. */
  int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets a parameter of this lambda. */
  Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the nth parameter of this lambda. */
  Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}

/** A Ruby block. */
abstract class Block extends AstNode {
  /** Gets the number of parameters of this block. */
  abstract int getNumberOfParameters();

  /** Gets the nth parameter of this block. */
  abstract Parameter getParameter(int n);

  /** Gets a parameter of this block. */
  Parameter getAParameter() { result = this.getParameter(_) }
  // TODO: body/statements
}

/** A Ruby block enclosed within `do` and `end`. */
class DoBlock extends @do_block, Block {
  Generated::DoBlock generated;

  DoBlock() { generated = this }

  override string describeQlClass() { result = "DoBlock" }

  override string toString() { result = "| ... |" }

  /** Gets the number of parameters of this block. */
  override int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets the nth parameter of this block. */
  override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}

/**
 * A Ruby block defined using curly braces, e.g. in the following code:
 * ```
 * names.each { |name| puts name }
 * ```
 */
class BraceBlock extends @block, Block {
  Generated::Block generated;

  BraceBlock() { generated = this }

  override string describeQlClass() { result = "BraceBlock" }

  override string toString() { result = "{ ... }" }

  /** Gets the number of parameters of this block. */
  override int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets the nth parameter of this block. */
  override Parameter getParameter(int n) { result = generated.getParameters().getChild(n) }
}
