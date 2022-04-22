private import codeql.ruby.AST
private import codeql.Locations
private import internal.AST
private import internal.Pattern
private import internal.TreeSitter
private import internal.Variable
private import internal.Parameter

/**
 * DEPRECATED
 *
 * A pattern.
 */
deprecated class Pattern extends AstNode {
  Pattern() {
    explicitAssignmentNode(toGenerated(this), _)
    or
    implicitAssignmentNode(toGenerated(this))
    or
    implicitParameterAssignmentNode(toGenerated(this), _)
    or
    this = getSynthChild(any(AssignExpr ae), 0)
    or
    this instanceof SimpleParameterImpl
  }

  /** Gets a variable used in (or introduced by) this pattern. */
  Variable getAVariable() { none() }
}

/**
 * DEPRECATED
 *
 * A simple variable pattern.
 */
deprecated class VariablePattern extends Pattern, LhsExpr, TVariableAccess {
  override Variable getAVariable() { result = this.(VariableAccess).getVariable() }
}

/**
 * DEPRECATED
 *
 * A tuple pattern.
 *
 * This includes both tuple patterns in parameters and assignments. Example patterns:
 * ```rb
 * a, self.b = value
 * (a, b), c[3] = value
 * a, b, *rest, c, d = value
 * ```
 */
deprecated class TuplePattern extends Pattern, TTuplePattern {
  private TuplePatternImpl getImpl() { result = toGenerated(this) }

  private Ruby::AstNode getChild(int i) { result = this.getImpl().getChildNode(i) }

  /** Gets the `i`th pattern in this tuple pattern. */
  final Pattern getElement(int i) {
    exists(Ruby::AstNode c | c = this.getChild(i) |
      toGenerated(result) = c.(Ruby::RestAssignment).getChild()
      or
      toGenerated(result) = c
    )
  }

  /** Gets a sub pattern in this tuple pattern. */
  final Pattern getAnElement() { result = this.getElement(_) }

  /**
   * Gets the index of the pattern with the `*` marker on it, if it exists.
   * In the example below the index is `2`.
   * ```rb
   * a, b, *rest, c, d = value
   * ```
   */
  final int getRestIndex() { result = this.getImpl().getRestIndex() }

  override Variable getAVariable() { result = this.getElement(_).getAVariable() }
}

private class TPatternNode =
  TArrayPattern or TFindPattern or THashPattern or TAlternativePattern or TAsPattern or
      TParenthesizedPattern or TExpressionReferencePattern or TVariableReferencePattern;

private class TPattern =
  TPatternNode or TLiteral or TLambda or TConstantAccess or TLocalVariableAccess or
      TUnaryArithmeticOperation;

/**
 * A pattern used in a `case-in` expression. For example
 * ```rb
 * case expr
 *   in [ x ] then ...
 *   in Point(a:, b:) then ...
 *   in Integer => x then ...
 * end
 * ```
 */
class CasePattern extends AstNode, TPattern {
  CasePattern() {
    casePattern(toGenerated(this)) or
    synthChild(any(HashPattern p), _, this)
  }
}

/**
 * An array pattern, for example:
 * ```rb
 * in []
 * in ["first", Integer => x, "last"]
 * in ["a", Integer => x, *]
 * in ["a", Integer => x, ]
 * in [1, 2, *x, 7, 8]
 * in [*init, 7, 8]
 * in List["a", Integer => x, *tail]
 * ```
 */
class ArrayPattern extends CasePattern, TArrayPattern {
  private Ruby::ArrayPattern g;

  ArrayPattern() { this = TArrayPattern(g) }

  /** Gets the class this pattern matches objects against, if any. */
  ConstantReadAccess getClass() { toGenerated(result) = g.getClass() }

  /**
   * Gets the `n`th element of this list pattern's prefix, i.e. the elements `1, ^two, 3`
   * in the following examples:
   * ```
   * in [ 1, ^two, 3 ]
   * in [ 1, ^two, 3, ]
   * in [ 1, ^two, 3, *, 4 , 5]
   * in [ 1, ^two, 3, *more]
   * ```
   */
  CasePattern getPrefixElement(int n) {
    toGenerated(result) = g.getChild(n) and
    (
      n < this.restIndex()
      or
      not exists(this.restIndex())
    )
  }

  /**
   * Gets the `n`th element of this list pattern's suffix, i.e. the elements `4, 5`
   * in the following examples:
   * ```
   * in [ *, 4, 5 ]
   * in [ 1, 2, 3, *middle, 4 , 5]
   * ```
   */
  CasePattern getSuffixElement(int n) { toGenerated(result) = g.getChild(n + this.restIndex() + 1) }

  /**
   * Gets the variable of the rest token, if any. For example `middle` in `the following array pattern.
   * ```rb
   * [ 1, 2, 3, *middle, 4 , 5]
   * ```
   */
  LocalVariableWriteAccess getRestVariableAccess() {
    toGenerated(result) = g.getChild(this.restIndex()).(Ruby::SplatParameter).getName()
  }

  /**
   * Holds if this pattern permits any unmatched remaining elements, i.e. the pattern does not have a trailing `,`
   * and does not contain a rest token (`*` or `*name`) either.
   */
  predicate allowsUnmatchedElements() { not exists(this.restIndex()) }

  private int restIndex() { g.getChild(result) instanceof Ruby::SplatParameter }

  final override string getAPrimaryQlClass() { result = "ArrayPattern" }

  final override string toString() { result = "[ ..., * ]" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getClass" and result = this.getClass()
    or
    pred = "getPrefixElement" and result = this.getPrefixElement(_)
    or
    pred = "getSuffixElement" and result = this.getSuffixElement(_)
    or
    pred = "getRestVariableAccess" and result = this.getRestVariableAccess()
  }
}

/**
 * A find pattern, for example:
 * ```rb
 * in [*, "a", Integer => x, *]
 * in List[*init, "a", Integer => x, *tail]
 * in List[*, "a", Integer => x, *]
 * ```
 */
class FindPattern extends CasePattern, TFindPattern {
  private Ruby::FindPattern g;

  FindPattern() { this = TFindPattern(g) }

  /** Gets the class this pattern matches objects against, if any. */
  ConstantReadAccess getClass() { toGenerated(result) = g.getClass() }

  /** Gets the `n`th element of this list pattern. */
  CasePattern getElement(int n) { toGenerated(result) = g.getChild(n + 1) }

  /** Gets an element of this list pattern. */
  CasePattern getAnElement() { result = this.getElement(_) }

  /**
   * Gets the variable for the prefix of this find pattern, if any. For example `init` in:
   * ```rb
   * in List[*init, "a", Integer => x, *tail]
   * ```
   */
  LocalVariableWriteAccess getPrefixVariableAccess() {
    toGenerated(result) = g.getChild(0).(Ruby::SplatParameter).getName()
  }

  /**
   * Gets the variable for the suffix of this find pattern, if any. For example `tail` in:
   * ```rb
   * in List[*init, "a", Integer => x, *tail]
   * ```
   */
  LocalVariableWriteAccess getSuffixVariableAccess() {
    toGenerated(result) = max(int i | | g.getChild(i) order by i).(Ruby::SplatParameter).getName()
  }

  final override string getAPrimaryQlClass() { result = "FindPattern" }

  final override string toString() { result = "[ *,...,* ]" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getClass" and result = this.getClass()
    or
    pred = "getElement" and result = this.getElement(_)
    or
    pred = "getPrefixVariableAccess" and result = this.getPrefixVariableAccess()
    or
    pred = "getSuffixVariableAccess" and result = this.getSuffixVariableAccess()
  }
}

/**
 * A hash pattern, for example:
 * ```rb
 * in {}
 * in { a: 1 }
 * in { a: 1, **rest }
 * in { a: 1, **nil }
 * in Node{ label: , children: [] }
 * ```
 */
class HashPattern extends CasePattern, THashPattern {
  private Ruby::HashPattern g;

  HashPattern() { this = THashPattern(g) }

  /** Gets the class this pattern matches objects against, if any. */
  ConstantReadAccess getClass() { toGenerated(result) = g.getClass() }

  private Ruby::KeywordPattern keyValuePair(int n) { result = g.getChild(n) }

  /** Gets the key of the `n`th pair. */
  StringlikeLiteral getKey(int n) { toGenerated(result) = this.keyValuePair(n).getKey() }

  /** Gets the value of the `n`th pair. */
  CasePattern getValue(int n) {
    toGenerated(result) = this.keyValuePair(n).getValue() or
    synthChild(this, n, result)
  }

  /** Gets the value for a given key name. */
  CasePattern getValueByKey(string key) {
    exists(int i |
      this.getKey(i).getConstantValue().isStringlikeValue(key) and result = this.getValue(i)
    )
  }

  /**
   * Gets the variable of the keyword rest token, if any. For example `rest` in:
   * ```rb
   * in { a: 1, **rest }
   * ```
   */
  LocalVariableWriteAccess getRestVariableAccess() {
    toGenerated(result) =
      max(int i | | g.getChild(i) order by i).(Ruby::HashSplatParameter).getName()
  }

  /**
   * Holds if this pattern is terminated by `**nil` indicating that the pattern does not permit
   * any unmatched remaining pairs.
   */
  predicate allowsUnmatchedElements() { g.getChild(_) instanceof Ruby::HashSplatNil }

  final override string getAPrimaryQlClass() { result = "HashPattern" }

  final override string toString() { result = "{ ..., ** }" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getClass" and result = this.getClass()
    or
    pred = "getKey" and result = this.getKey(_)
    or
    pred = "getValue" and result = this.getValue(_)
    or
    pred = "getRestVariableAccess" and result = this.getRestVariableAccess()
  }
}

/**
 * A composite pattern matching one of the given sub-patterns, for example:
 * ```rb
 * in 1 | 2 | 3
 * ```
 */
class AlternativePattern extends CasePattern, TAlternativePattern {
  private Ruby::AlternativePattern g;

  AlternativePattern() { this = TAlternativePattern(g) }

  /** Gets the `n`th alternative of this pattern. */
  CasePattern getAlternative(int n) { toGenerated(result) = g.getAlternatives(n) }

  /** Gets an alternative of this pattern. */
  CasePattern getAnAlternative() { result = this.getAlternative(_) }

  final override string getAPrimaryQlClass() { result = "AlternativePattern" }

  final override string toString() { result = "... | ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getAlternative" and result = this.getAlternative(_)
  }
}

/**
 * A pattern match that binds to the specified local variable, for example `Integer => a`
 * in the following:
 * ```rb
 *  case 1
 *    in Integer => a then puts "#{a} is an integer value"
 *  end
 * ```
 */
class AsPattern extends CasePattern, TAsPattern {
  private Ruby::AsPattern g;

  AsPattern() { this = TAsPattern(g) }

  /** Gets the underlying pattern. */
  CasePattern getPattern() { toGenerated(result) = g.getValue() }

  /** Gets the variable access for this pattern. */
  LocalVariableWriteAccess getVariableAccess() { toGenerated(result) = g.getName() }

  final override string getAPrimaryQlClass() { result = "AsPattern" }

  final override string toString() { result = "... => ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getPattern" and result = this.getPattern()
    or
    pred = "getVariableAccess" and result = this.getVariableAccess()
  }
}

/**
 * A parenthesized pattern:
 * ```rb
 * in (1 ..)
 * in (0 | "" | [] | {})
 * ```
 */
class ParenthesizedPattern extends CasePattern, TParenthesizedPattern {
  private Ruby::ParenthesizedPattern g;

  ParenthesizedPattern() { this = TParenthesizedPattern(g) }

  /** Gets the underlying pattern. */
  final CasePattern getPattern() { toGenerated(result) = g.getChild() }

  final override string getAPrimaryQlClass() { result = "ParenthesizedPattern" }

  final override string toString() { result = "( ... )" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getPattern" and result = this.getPattern()
  }
}

/**
 * A variable or value reference in a pattern, i.e. `^x`, and `^(2 * x)` in the following example:
 * ```rb
 * x = 10
 * case expr
 *   in ^x then puts "ok"
 *   in ^(2 * x) then puts "ok"
 * end
 * ```
 */
class ReferencePattern extends CasePattern, TReferencePattern {
  private Ruby::AstNode value;

  ReferencePattern() {
    value = any(Ruby::VariableReferencePattern g | this = TVariableReferencePattern(g)).getName()
    or
    value =
      any(Ruby::ExpressionReferencePattern g | this = TExpressionReferencePattern(g)).getValue()
  }

  /** Gets the value this reference pattern matches against. For example `2 * x` in `^(2 * x)` */
  final Expr getExpr() { toGenerated(result) = value }

  final override string getAPrimaryQlClass() { result = "ReferencePattern" }

  final override string toString() { result = "^..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getExpr" and result = this.getExpr()
  }
}

/**
 * DEPRECATED: Use `ReferencePattern` instead.
 *
 * A variable reference in a pattern, i.e. `^x` in the following example:
 * ```rb
 * x = 10
 * case expr
 *   in ^x then puts "ok"
 * end
 * ```
 */
deprecated class VariableReferencePattern extends ReferencePattern, TVariableReferencePattern {
  /** Gets the variable access corresponding to this variable reference pattern. */
  final VariableReadAccess getVariableAccess() { result = this.getExpr() }
}
