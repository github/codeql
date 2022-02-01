private import codeql.ruby.AST
private import internal.AST
private import internal.Constant
private import internal.Module
private import internal.Variable
private import internal.TreeSitter

/** A constant value. */
class ConstantValue extends TConstantValue {
  /** Gets a textual representation of this constant value. */
  final string toString() {
    result = this.getInt().toString()
    or
    result = this.getFloat().toString()
    or
    exists(int numerator, int denominator |
      this.isRational(numerator, denominator) and
      result = numerator + "/" + denominator
    )
    or
    exists(float real, float imaginary |
      this.isComplex(real, imaginary) and
      result = real + "+" + imaginary + "i"
    )
    or
    result = this.getString()
    or
    result = ":" + this.getSymbol()
    or
    result = this.getBoolean().toString()
    or
    this.isNil() and result = "nil"
  }

  /** Gets the integer value, if this is an integer. */
  int getInt() { this = TInt(result) }

  /** Holds if this is the integer value `i`. */
  predicate isInt(int i) { i = this.getInt() }

  /** Gets the float value, if this is a float. */
  float getFloat() { this = TFloat(result) }

  /** Holds if this is the float value `f`. */
  predicate isFloat(float f) { f = this.getFloat() }

  /** Holds if this is the rational value `numerator / denominator`. */
  predicate isRational(int numerator, int denominator) { this = TRational(numerator, denominator) }

  /** Holds if this is the complex value `real + imaginary * i`. */
  predicate isComplex(float real, float imaginary) { this = TComplex(real, imaginary) }

  /** Gets the string value, if this is a string. */
  string getString() { this = TString(result) }

  /** Holds if this is the string value `s`. */
  predicate isString(string s) { s = this.getString() }

  /** Gets the symbol value (exluding the `:` prefix), if this is a symbol. */
  string getSymbol() { this = TSymbol(result) }

  /** Holds if this is the symbol value `:s`. */
  predicate isSymbol(string s) { s = this.getSymbol() }

  /** Gets the string or symbol value, if any. */
  string getStringOrSymbol() { result = [this.getString(), this.getSymbol()] }

  /** Holds if this is the string value `s` or the symbol value `:s`. */
  predicate isStringOrSymbol(string s) { s = this.getStringOrSymbol() }

  /** Gets the Boolean value, if this is a Boolean. */
  boolean getBoolean() { this = TBoolean(result) }

  /** Holds if this is the Boolean value `b`. */
  predicate isBoolean(boolean b) { b = this.getBoolean() }

  /** Holds if this is the `nil` value. */
  predicate isNil() { this = TNil() }
}

/** Provides different sub classes of `ConstantValue`. */
module ConstantValue {
  /** A constant integer value. */
  class ConstantIntegerValue extends ConstantValue, TInt { }

  /** A constant float value. */
  class ConstantFloatValue extends ConstantValue, TFloat { }

  /** A constant rational value. */
  class ConstantRationalValue extends ConstantValue, TRational { }

  /** A constant complex value. */
  class ConstantComplexValue extends ConstantValue, TComplex { }

  /** A constant string value. */
  class ConstantStringValue extends ConstantValue, TString { }

  /** A constant symbol value. */
  class ConstantSymbolValue extends ConstantValue, TSymbol { }

  /** A constant Boolean value. */
  class ConstantBooleanValue extends ConstantValue, TBoolean { }

  /** A constant `nil` value. */
  class ConstantNilValue extends ConstantValue, TNil { }
}

/** An access to a constant. */
class ConstantAccess extends Expr, TConstantAccess {
  /** Gets the name of the constant being accessed. */
  string getName() { none() }

  /** Holds if the name of the constant being accessed is `name`. */
  final predicate hasName(string name) { this.getName() = name }

  /**
   * Gets the expression used in the access's scope resolution operation, if
   * any. In the following example, the result is the `Call` expression for
   * `foo()`.
   *
   * ```rb
   * foo()::MESSAGE
   * ```
   *
   * However, there is no result for the following example, since there is no
   * scope resolution operation.
   *
   * ```rb
   * MESSAGE
   * ```
   */
  Expr getScopeExpr() { none() }

  /**
   * Holds if the access uses the scope resolution operator to refer to the
   * global scope, as in this example:
   *
   * ```rb
   * ::MESSAGE
   * ```
   */
  predicate hasGlobalScope() { none() }

  override string toString() { result = this.getName() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getScopeExpr" and result = this.getScopeExpr()
  }
}

private class TokenConstantAccess extends ConstantAccess, TTokenConstantAccess {
  private Ruby::Constant g;

  TokenConstantAccess() { this = TTokenConstantAccess(g) }

  final override string getName() { result = g.getValue() }
}

private class ScopeResolutionConstantAccess extends ConstantAccess, TScopeResolutionConstantAccess {
  private Ruby::ScopeResolution g;
  private Ruby::Constant constant;

  ScopeResolutionConstantAccess() { this = TScopeResolutionConstantAccess(g, constant) }

  final override string getName() { result = constant.getValue() }

  final override Expr getScopeExpr() { toGenerated(result) = g.getScope() }

  final override predicate hasGlobalScope() { not exists(g.getScope()) }
}

private class ConstantReadAccessSynth extends ConstantAccess, TConstantReadAccessSynth {
  private string value;

  ConstantReadAccessSynth() { this = TConstantReadAccessSynth(_, _, value) }

  final override string getName() {
    if this.hasGlobalScope() then result = value.suffix(2) else result = value
  }

  final override Expr getScopeExpr() { synthChild(this, 0, result) }

  final override predicate hasGlobalScope() { value.matches("::%") }
}

/**
 * A use (read) of a constant.
 *
 * For example, the right-hand side of the assignment in:
 *
 * ```rb
 * x = Foo
 * ```
 *
 * Or the superclass `Bar` in this example:
 *
 * ```rb
 * class Foo < Bar
 * end
 * ```
 */
class ConstantReadAccess extends ConstantAccess {
  ConstantReadAccess() {
    not this instanceof ConstantWriteAccess
    or
    // `X` in `X ||= 10` is considered both a read and a write
    this = any(AssignOperation a).getLeftOperand()
    or
    this instanceof TConstantReadAccessSynth
  }

  /**
   * Gets the value being read, if any. For example, in
   *
   * ```rb
   * module M
   *   CONST = "const"
   * end
   *
   * puts M::CONST
   * ```
   *
   * the value being read at `M::CONST` is `"const"`.
   */
  Expr getValue() {
    not exists(this.getScopeExpr()) and
    result = lookupConst(this.getEnclosingModule+().getModule(), this.getName()) and
    // For now, we restrict the scope of top-level declarations to their file.
    // This may remove some plausible targets, but also removes a lot of
    // implausible targets
    if result.getEnclosingModule() instanceof Toplevel
    then result.getFile() = this.getFile()
    else any()
    or
    this.hasGlobalScope() and
    result = lookupConst(TResolved("Object"), this.getName())
    or
    result = lookupConst(resolveConstantReadAccess(this.getScopeExpr()), this.getName())
  }

  final override ConstantValue getConstantValue() { result = this.getValue().getConstantValue() }

  final override string getAPrimaryQlClass() { result = "ConstantReadAccess" }
}

/**
 * A definition of a constant.
 *
 * Examples:
 *
 * ```rb
 * Foo = 1             # defines constant Foo as an integer
 * M::Foo = 1          # defines constant Foo as an integer in module M
 *
 * class Bar; end      # defines constant Bar as a class
 * class M::Bar; end   # defines constant Bar as a class in module M
 *
 * module Baz; end     # defines constant Baz as a module
 * module M::Baz; end  # defines constant Baz as a module in module M
 * ```
 */
class ConstantWriteAccess extends ConstantAccess {
  ConstantWriteAccess() {
    explicitAssignmentNode(toGenerated(this), _) or this instanceof TNamespace
  }

  override string getAPrimaryQlClass() { result = "ConstantWriteAccess" }

  /**
   * Gets a fully qualified name for this constant, based on the context in
   * which it is defined.
   *
   *  For example, given
   *  ```rb
   *  module Foo
   *    module Bar
   *      class Baz
   *      end
   *    end
   *    CONST_A = "a"
   *  end
   *  ```
   *
   * the constant `Baz` has the fully qualified name `Foo::Bar::Baz`, and
   * `CONST_A` has the fully qualified name `Foo::CONST_A`.
   *
   * Important note: This can return more than one value, because there are
   * situations where there can be multiple possible "fully qualified" names.
   * For example:
   * ```
   * module Mod4
   *   include Mod1
   *   module Mod3::Mod5 end
   * end
   * ```
   * In the above snippet, `Mod5` has two valid fully qualified names it can be
   * referred to by: `Mod1::Mod3::Mod5`, or `Mod4::Mod3::Mod5`.
   *
   * Another example has to do with the order in which module definitions are
   * executed at runtime. Because of the way that ruby dynamically looks up
   * constants up the namespace chain, the fully qualified name of a nested
   * constant can be ambiguous from just statically looking at the AST.
   */
  string getAQualifiedName() { result = resolveConstantWriteAccess(this) }

  /**
   * Gets a qualified name for this constant. Deprecated in favor of
   * `getAQualifiedName` because this can return more than one value
   */
  deprecated string getQualifiedName() { result = this.getAQualifiedName() }
}

/**
 * A definition of a constant via assignment. For example, the left-hand
 * operand in the following example:
 *
 * ```rb
 * MAX_SIZE = 100
 * ```
 */
class ConstantAssignment extends ConstantWriteAccess, LhsExpr {
  override string getAPrimaryQlClass() { result = "ConstantAssignment" }
}
