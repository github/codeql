import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.objects.ObjectInternal
private import semmle.python.internal.CachedStages

/** An expression */
class Expr extends Expr_, AstNode {
  /** Gets the scope of this expression */
  override Scope getScope() { py_scopes(this, result) }

  /** Gets a textual representation of this element. */
  cached
  override string toString() {
    Stages::AST::ref() and
    result = "Expression"
  }

  /** Gets the module in which this expression occurs */
  Module getEnclosingModule() { result = this.getScope().getEnclosingModule() }

  /**
   * Whether this expression defines variable `v`
   * If doing dataflow, then consider using SsaVariable.getDefinition() for more precision.
   */
  predicate defines(Variable v) { this.getASubExpression().defines(v) }

  /** Whether this expression may have a side effect (as determined purely from its syntax) */
  predicate hasSideEffects() {
    /* If an exception raised by this expression handled, count that as a side effect */
    this.getAFlowNode().getASuccessor().getNode() instanceof ExceptStmt
    or
    this.getASubExpression().hasSideEffects()
  }

  /** Whether this expression is a constant */
  predicate isConstant() { not this.isVariable() }

  /** Whether the parenthesized property of this expression is true. */
  predicate isParenthesized() { Expr_.super.isParenthesised() }

  private predicate isVariable() {
    this.hasSideEffects()
    or
    this instanceof Name
    or
    exists(Expr e | e = this.getASubExpression() and e.isVariable())
  }

  override Location getLocation() { result = Expr_.super.getLocation() }

  /** Gets an immediate (non-nested) sub-expression of this expression */
  Expr getASubExpression() { none() }

  override AstNode getAChildNode() { result = this.getASubExpression() }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Gets what this expression might "refer-to". Performs a combination of localized (intra-procedural) points-to
   *  analysis and global module-level analysis. This points-to analysis favours precision over recall. It is highly
   *  precise, but may not provide information for a significant number of flow-nodes.
   *  If the class is unimportant then use `refersTo(value)` or `refersTo(value, origin)` instead.
   * NOTE: For complex dataflow, involving multiple stages of points-to analysis, it may be more precise to use
   * `ControlFlowNode.refersTo(...)` instead.
   */
  predicate refersTo(Object obj, ClassObject cls, AstNode origin) {
    this.refersTo(_, obj, cls, origin)
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Gets what this expression might "refer-to" in the given `context`.
   */
  predicate refersTo(Context context, Object obj, ClassObject cls, AstNode origin) {
    this.getAFlowNode().refersTo(context, obj, cls, origin.getAFlowNode())
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Holds if this expression might "refer-to" to `value` which is from `origin`
   * Unlike `this.refersTo(value, _, origin)`, this predicate includes results
   * where the class cannot be inferred.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, AstNode origin) {
    this.getAFlowNode().refersTo(obj, origin.getAFlowNode())
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Equivalent to `this.refersTo(value, _)`
   */
  predicate refersTo(Object obj) { this.refersTo(obj, _) }

  /**
   * Holds if this expression might "point-to" to `value` which is from `origin`
   * in the given `context`.
   */
  predicate pointsTo(Context context, Value value, AstNode origin) {
    this.getAFlowNode().pointsTo(context, value, origin.getAFlowNode())
  }

  /**
   * Holds if this expression might "point-to" to `value` which is from `origin`.
   */
  predicate pointsTo(Value value, AstNode origin) {
    this.getAFlowNode().pointsTo(value, origin.getAFlowNode())
  }

  /**
   * Holds if this expression might "point-to" to `value`.
   */
  predicate pointsTo(Value value) { this.pointsTo(value, _) }

  /** Gets a value that this expression might "point-to". */
  Value pointsTo() { this.pointsTo(result) }
}

/** An assignment expression, such as `x := y` */
class AssignExpr extends AssignExpr_ {
  override Expr getASubExpression() {
    result = this.getValue() or
    result = this.getTarget()
  }
}

/** An attribute expression, such as `value.attr` */
class Attribute extends Attribute_ {
  /* syntax: Expr.name */
  override Expr getASubExpression() { result = this.getObject() }

  override AttrNode getAFlowNode() { result = super.getAFlowNode() }

  /** Gets the name of this attribute. That is the `name` in `obj.name` */
  string getName() { result = Attribute_.super.getAttr() }

  /** Gets the object of this attribute. That is the `obj` in `obj.name` */
  Expr getObject() { result = Attribute_.super.getValue() }

  /**
   * Gets the expression corresponding to the object of the attribute, if the name of the attribute is `name`.
   * Equivalent to `this.getObject() and this.getName() = name`.
   */
  Expr getObject(string name) {
    result = Attribute_.super.getValue() and
    name = Attribute_.super.getAttr()
  }
}

/** A subscript expression, such as `value[slice]` */
class Subscript extends Subscript_ {
  /* syntax: Expr[Expr] */
  override Expr getASubExpression() {
    result = this.getIndex()
    or
    result = this.getObject()
  }

  Expr getObject() { result = Subscript_.super.getValue() }

  override SubscriptNode getAFlowNode() { result = super.getAFlowNode() }
}

/** A call expression, such as `func(...)` */
class Call extends Call_ {
  /* syntax: Expr(...) */
  override Expr getASubExpression() {
    result = this.getAPositionalArg() or
    result = this.getAKeyword().getValue() or
    result = this.getFunc()
  }

  override predicate hasSideEffects() { any() }

  override string toString() { result = this.getFunc().toString() + "()" }

  override CallNode getAFlowNode() { result = super.getAFlowNode() }

  /** Gets a tuple (*) argument of this call. */
  Expr getStarargs() { result = this.getAPositionalArg().(Starred).getValue() }

  /** Gets a dictionary (**) argument of this call. */
  Expr getKwargs() { result = this.getANamedArg().(DictUnpacking).getValue() }

  /* Backwards compatibility */
  /**
   * Gets the nth keyword argument of this call expression, provided it is not preceded by a double-starred argument.
   * This exists primarily for backwards compatibility. You are recommended to use
   * Call.getNamedArg(index) instead.
   */
  Keyword getKeyword(int index) {
    result = this.getNamedArg(index) and
    (
      not exists(this.getMinimumUnpackingIndex())
      or
      index <= this.getMinimumUnpackingIndex()
    )
  }

  /** Gets the minimum index (if any) at which a dictionary unpacking (`**foo`) occurs in this call. */
  private int getMinimumUnpackingIndex() {
    result = min(int i | this.getNamedArg(i) instanceof DictUnpacking)
  }

  /**
   * Gets a keyword argument of this call expression, provided it is not preceded by a double-starred argument.
   * This exists primarily for backwards compatibility. You are recommended to use
   * Call.getANamedArg() instead.
   */
  Keyword getAKeyword() { result = this.getKeyword(_) }

  /**
   * Gets the positional argument at `index`, provided it is not preceded by a starred argument.
   * This exists primarily for backwards compatibility. You are recommended to use
   * Call.getPositionalArg(index) instead.
   */
  Expr getArg(int index) {
    result = this.getPositionalArg(index) and
    not result instanceof Starred and
    not exists(Starred s, int lower | s = this.getPositionalArg(lower) and lower < index)
  }

  /**
   * Gets a positional argument, provided it is not preceded by a starred argument.
   * This exists primarily for backwards compatibility. You are recommended to use
   * Call.getAPositionalArg() instead.
   */
  Expr getAnArg() { result = this.getArg(_) }

  override AstNode getAChildNode() {
    result = this.getAPositionalArg() or
    result = this.getANamedArg() or
    result = this.getFunc()
  }

  /** Gets the name of a named argument, including those passed in dict literals. */
  string getANamedArgumentName() {
    result = this.getAKeyword().getArg()
    or
    result = this.getKwargs().(Dict).getAKey().(StringLiteral).getText()
  }

  /** Gets the positional argument count of this call, provided there is no more than one tuple (*) argument. */
  int getPositionalArgumentCount() {
    count(this.getStarargs()) < 2 and
    result = count(Expr arg | arg = this.getAPositionalArg() and not arg instanceof Starred)
  }

  /** Gets the first tuple (*) argument of this call, if any. */
  Expr getStarArg() {
    exists(int firstStarArgIndex |
      firstStarArgIndex = min(int i | this.getPositionalArg(i) instanceof Starred | i) and
      result = this.getPositionalArg(firstStarArgIndex).(Starred).getValue()
    )
  }
}

/** A conditional expression such as, `body if test else orelse` */
class IfExp extends IfExp_ {
  /* syntax: Expr if Expr else Expr */
  override Expr getASubExpression() {
    result = this.getTest() or result = this.getBody() or result = this.getOrelse()
  }

  override IfExprNode getAFlowNode() { result = super.getAFlowNode() }
}

/** A starred expression, such as the `*rest` in the assignment `first, *rest = seq` */
class Starred extends Starred_ {
  /* syntax: *Expr */
  override Expr getASubExpression() { result = this.getValue() }
}

/** A yield expression, such as `yield value` */
class Yield extends Yield_ {
  /* syntax: yield Expr */
  override Expr getASubExpression() { result = this.getValue() }

  override predicate hasSideEffects() { any() }
}

/** A yield expression, such as `yield from value` */
class YieldFrom extends YieldFrom_ {
  /* syntax: yield from Expr */
  override Expr getASubExpression() { result = this.getValue() }

  override predicate hasSideEffects() { any() }
}

/** A repr (backticks) expression, such as `` `value` `` */
class Repr extends Repr_ {
  /* syntax: `Expr` */
  override Expr getASubExpression() { result = this.getValue() }

  override predicate hasSideEffects() { any() }
}

/* Constants */
/**
 * A bytes constant, such as `b'ascii'`. Note that unadorned string constants such as
 * `"hello"` are treated as Bytes for Python2, but Unicode for Python3.
 */
class Bytes extends StringLiteral {
  /* syntax: b"hello" */
  Bytes() { not this.isUnicode() }

  override Object getLiteralObject() {
    py_cobjecttypes(result, theBytesType()) and
    py_cobjectnames(result, this.quotedString())
  }

  /**
   * The extractor puts quotes into the name of each string (to prevent "0" clashing with 0).
   * The following predicate help us match up a string/byte literals in the source
   * which the equivalent object.
   */
  private string quotedString() {
    exists(string b_unquoted | b_unquoted = this.getS() | result = "b'" + b_unquoted + "'")
  }
}

/** An ellipsis expression, such as `...` */
class Ellipsis extends Ellipsis_ {
  /* syntax: ... */
  override Expr getASubExpression() { none() }
}

/**
 * An immutable literal expression (except tuples).
 * Consists of string (both unicode and byte) literals and numeric literals.
 */
abstract class ImmutableLiteral extends Expr {
  abstract Object getLiteralObject();

  abstract boolean booleanValue();

  final Value getLiteralValue() { result.(ConstantObjectInternal).getLiteral() = this }
}

/** A numerical constant expression, such as `7` or `4.2` */
abstract class Num extends Num_, ImmutableLiteral {
  override Expr getASubExpression() { none() }

  /* We want to declare this abstract, but currently we cannot. */
  override string toString() { result = "Num with missing toString" }
}

/** An integer numeric constant, such as `7` or `0x9` */
class IntegerLiteral extends Num {
  /* syntax: 4 */
  IntegerLiteral() { not this instanceof FloatLiteral and not this instanceof ImaginaryLiteral }

  /**
   * Gets the (integer) value of this constant. Will not return a result if the value does not fit into
   * a 32 bit signed value
   */
  int getValue() { result = this.getN().toInt() }

  override string toString() { result = "IntegerLiteral" }

  override Object getLiteralObject() {
    py_cobjecttypes(result, theIntType()) and py_cobjectnames(result, this.getN())
    or
    py_cobjecttypes(result, theLongType()) and py_cobjectnames(result, this.getN())
  }

  override boolean booleanValue() {
    this.getValue() = 0 and result = false
    or
    this.getValue() != 0 and result = true
  }
}

/** A floating point numeric constant, such as `0.4` or `4e3` */
class FloatLiteral extends Num {
  /* syntax: 4.2 */
  FloatLiteral() {
    not this instanceof ImaginaryLiteral and
    this.getN().regexpMatch(".*[.eE].*")
  }

  float getValue() { result = this.getN().toFloat() }

  override string toString() { result = "FloatLiteral" }

  override Object getLiteralObject() {
    py_cobjecttypes(result, theFloatType()) and py_cobjectnames(result, this.getN())
  }

  override boolean booleanValue() {
    this.getValue() = 0.0 and result = false
    or
    // In QL 0.0 != -0.0
    this.getValue() = -0.0 and result = false
    or
    this.getValue() != 0.0 and this.getValue() != -0.0 and result = true
  }
}

/** An imaginary numeric constant, such as `3j` */
class ImaginaryLiteral extends Num {
  private float value;

  /* syntax: 1.0j */
  ImaginaryLiteral() { value = this.getN().regexpCapture("(.+)j.*", 1).toFloat() }

  /** Gets the value of this constant as a floating point value */
  float getValue() { result = value }

  override string toString() { result = "ImaginaryLiteral" }

  override Object getLiteralObject() {
    py_cobjecttypes(result, theComplexType()) and py_cobjectnames(result, this.getN())
  }

  override boolean booleanValue() {
    this.getValue() = 0.0 and result = false
    or
    // In QL 0.0 != -0.0
    this.getValue() = -0.0 and result = false
    or
    this.getValue() != 0.0 and this.getValue() != -0.0 and result = true
  }
}

class NegativeIntegerLiteral extends ImmutableLiteral, UnaryExpr {
  NegativeIntegerLiteral() {
    this.getOp() instanceof USub and
    this.getOperand() instanceof IntegerLiteral
  }

  override boolean booleanValue() { result = this.getOperand().(IntegerLiteral).booleanValue() }

  override Object getLiteralObject() {
    (py_cobjecttypes(result, theIntType()) or py_cobjecttypes(result, theLongType())) and
    py_cobjectnames(result, "-" + this.getOperand().(IntegerLiteral).getN())
  }

  /**
   * Gets the (integer) value of this constant. Will not return a result if the value does not fit into
   * a 32 bit signed value
   */
  int getValue() { result = -this.getOperand().(IntegerLiteral).getValue() }
}

/**
 * A unicode string expression, such as `u"\u20ac"`. Note that unadorned string constants such as
 * "hello" are treated as Bytes for Python2, but Unicode for Python3.
 */
class Unicode extends StringLiteral {
  /* syntax: "hello" */
  Unicode() { this.isUnicode() }

  override Object getLiteralObject() {
    py_cobjecttypes(result, theUnicodeType()) and
    py_cobjectnames(result, this.quotedString())
  }

  /**
   * Gets the quoted representation fo this string.
   *
   * The extractor puts quotes into the name of each string (to prevent "0" clashing with 0).
   * The following predicate help us match up a string/byte literals in the source
   * which the equivalent object.
   */
  string quotedString() {
    exists(string u_unquoted | u_unquoted = this.getS() | result = "u'" + u_unquoted + "'")
  }
}

/* Compound Values */
/** A dictionary expression, such as `{'key':'value'}` */
class Dict extends Dict_ {
  /* syntax: {Expr: Expr, ...} */
  /** Gets the value of an item of this dict display */
  Expr getAValue() { result = this.getAnItem().(DictDisplayItem).getValue() }

  /**
   * Gets the key of an item of this dict display, for those items that have keys
   * E.g, in {'a':1, **b} this returns only 'a'
   */
  Expr getAKey() { result = this.getAnItem().(KeyValuePair).getKey() }

  override Expr getASubExpression() { result = this.getAValue() or result = this.getAKey() }

  override AstNode getAChildNode() { result = this.getAnItem() }
}

/** A list expression, such as `[ 1, 3, 5, 7, 9 ]` */
class List extends List_ {
  /* syntax: [Expr, ...] */
  override Expr getASubExpression() { result = this.getAnElt() }
}

/** A set expression such as `{ 1, 3, 5, 7, 9 }` */
class Set extends Set_ {
  /* syntax: {Expr, ...} */
  override Expr getASubExpression() { result = this.getAnElt() }
}

class PlaceHolder extends PlaceHolder_ {
  string getId() { result = this.getVariable().getId() }

  override Expr getASubExpression() { none() }

  override string toString() { result = "$" + this.getId() }

  override NameNode getAFlowNode() { result = super.getAFlowNode() }
}

/** A tuple expression such as `( 1, 3, 5, 7, 9 )` */
class Tuple extends Tuple_ {
  /* syntax: (Expr, ...) */
  override Expr getASubExpression() { result = this.getAnElt() }
}

/**
 * A  (plain variable) name expression, such as `var`.
 * `None`, `True` and `False` are excluded.
 */
class Name extends Name_ {
  /* syntax: name */
  string getId() { result = this.getVariable().getId() }

  /** Whether this expression is a definition */
  predicate isDefinition() {
    py_expr_contexts(_, 5, this)
    or
    /* Treat Param as a definition (which it is) */
    py_expr_contexts(_, 4, this)
    or
    /* The target in an augmented assignment is also a definition (and a use) */
    exists(AugAssign aa | aa.getTarget() = this)
  }

  /**
   * Whether this expression defines variable `v`
   * If doing dataflow, then consider using SsaVariable.getDefinition() for more precision.
   */
  override predicate defines(Variable v) {
    this.isDefinition() and
    v = this.getVariable()
  }

  /** Whether this expression is a deletion */
  predicate isDeletion() { py_expr_contexts(_, 2, this) }

  /**
   * Whether this expression deletes variable `v`.
   * If doing dataflow, then consider using SsaVariable.getDefinition() for more precision.
   */
  predicate deletes(Variable v) {
    this.isDeletion() and
    v = this.getVariable()
  }

  /** Whether this expression is a use */
  predicate isUse() { py_expr_contexts(_, 3, this) }

  /**
   * Whether this expression is a use of variable `v`
   * If doing dataflow, then consider using SsaVariable.getAUse() for more precision.
   */
  predicate uses(Variable v) {
    this.isUse() and
    v = this.getVariable()
  }

  override predicate isConstant() { none() }

  override Expr getASubExpression() { none() }

  override string toString() { result = this.getId() }

  override NameNode getAFlowNode() { result = super.getAFlowNode() }

  override predicate isArtificial() {
    /* Artificial variable names in comprehensions all start with "." */
    this.getId().charAt(0) = "."
  }
}

class Filter extends Filter_ {
  override Expr getASubExpression() {
    result = this.getFilter()
    or
    result = this.getValue()
  }
}

/** A slice. E.g `0:1` in the expression `x[0:1]` */
class Slice extends Slice_ {
  override Expr getASubExpression() {
    result = this.getStart() or
    result = this.getStop() or
    result = this.getStep()
  }
}

/**
 * Returns all string prefixes in the database that are explicitly marked as Unicode strings.
 *
 * Helper predicate for `StringLiteral::isUnicode`.
 */
pragma[nomagic]
private string unicode_prefix() {
  result = any(Str_ s).getPrefix() and
  result.charAt(_) in ["u", "U"]
}

/**
 * Returns all string prefixes in the database that are _not_ explicitly marked as bytestrings.
 *
 * Helper predicate for `StringLiteral::isUnicode`.
 */
pragma[nomagic]
private string non_byte_prefix() {
  result = any(Str_ s).getPrefix() and
  not result.charAt(_) in ["b", "B"]
}

/** DEPRECATED. Use `StringLiteral` instead. */
deprecated class Str = StringLiteral;

/** DEPRECATED. Use `StringLiteral` instead. */
deprecated class StrConst = StringLiteral;

/** A string constant. */
class StringLiteral extends Str_, ImmutableLiteral {
  /* syntax: "hello" */
  /**
   * Holds if this string is a unicode string, either by default (e.g. if Python 3), or with an
   * explicit prefix.
   */
  predicate isUnicode() {
    this.getPrefix() = unicode_prefix()
    or
    this.getPrefix() = non_byte_prefix() and
    (
      major_version() = 3
      or
      this.getEnclosingModule().hasFromFuture("unicode_literals")
    )
  }

  override Expr getASubExpression() { none() }

  override AstNode getAChildNode() { result = this.getAnImplicitlyConcatenatedPart() }

  /** Gets the text of this str constant */
  string getText() { result = this.getS() }

  /** Whether this is a docstring */
  predicate isDocString() { exists(Scope s | s.getDocString() = this) }

  override boolean booleanValue() {
    this.getText() = "" and result = false
    or
    this.getText() != "" and result = true
  }

  override Object getLiteralObject() { none() }

  override string toString() { result = "StringLiteral" }
}

private predicate name_consts(Name_ n, string id) {
  exists(Variable v | py_variables(v, n) and id = v.getId() |
    id = "True" or id = "False" or id = "None"
  )
}

/** A named constant, one of `None`, `True` or `False` */
abstract class NameConstant extends Name, ImmutableLiteral {
  NameConstant() { name_consts(this, _) }

  override Expr getASubExpression() { none() }

  override string toString() { name_consts(this, result) }

  override predicate isConstant() { any() }

  override NameConstantNode getAFlowNode() { result = Name.super.getAFlowNode() }

  override predicate isArtificial() { none() }
}

/** A boolean named constant, either `True` or `False` */
abstract class BooleanLiteral extends NameConstant { }

/** The boolean named constant `True` */
class True extends BooleanLiteral {
  /* syntax: True */
  True() { name_consts(this, "True") }

  override Object getLiteralObject() { name_consts(this, "True") and result = theTrueObject() }

  override boolean booleanValue() { result = true }
}

/** The boolean named constant `False` */
class False extends BooleanLiteral {
  /* syntax: False */
  False() { name_consts(this, "False") }

  override Object getLiteralObject() { name_consts(this, "False") and result = theFalseObject() }

  override boolean booleanValue() { result = false }
}

/** The `None` constant. */
class None extends NameConstant {
  /* syntax: None */
  None() { name_consts(this, "None") }

  override Object getLiteralObject() { name_consts(this, "None") and result = theNoneObject() }

  override boolean booleanValue() { result = false }
}

/** An await expression such as `await coro`. */
class Await extends Await_ {
  /* syntax: await Expr */
  override Expr getASubExpression() { result = this.getValue() }
}

/** A formatted string literal expression, such as `f'hello {world!s}'` */
class Fstring extends Fstring_ {
  /* syntax: f"Yes!" */
  override Expr getASubExpression() { result = this.getAValue() }
}

/**
 * A formatted value (within a formatted string literal).
 * For example, in the string `f'hello {world!s}'` the formatted value is `world!s`.
 */
class FormattedValue extends FormattedValue_ {
  override Expr getASubExpression() {
    result = this.getValue() or
    result = this.getFormatSpec()
  }
}

/** A guard in a case statement */
class Guard extends Guard_ {
  /* syntax: if Expr */
  override Expr getASubExpression() { result = this.getTest() }
}

/* Expression Contexts */
/** A context in which an expression used */
class ExprContext extends ExprContext_ { }

/** The load context, the context of var in len(var) */
class Load extends Load_ { }

/** The store context, the context of var in var = 0 */
class Store extends Store_ { }

/** The delete context, the context of var in del var */
class Del extends Del_ { }

/** The context of an augmented load. This is an artifact of the Python grammar which includes an AugLoad context, even though it is never used. */
class AugLoad extends AugLoad_ { }

/** The augmented store context, the context of var in var += 1 */
class AugStore extends AugStore_ { }

/** The parameter context, the context of var in def f(var): pass */
class Param extends Param_ { }
