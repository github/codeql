import semmle.code.cpp.exprs.Expr

/**
 * A C/C++ literal.
 */
class Literal extends Expr, @literal {
  /** Gets a textual representation of this literal. */
  override string toString() {
    result = this.getValue() or
    (
      not exists(this.getValue()) and
      result = "Unknown literal"
    )
  }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "Literal" }
  
  override predicate mayBeImpure() {
    none()
  }
  override predicate mayBeGloballyImpure() {
    none()
  }
}

/**
 * A label literal, that is, a use of the '&&' operator to take the address of a
 * label for use in a computed goto statement.  This is a non-standard C/C++ extension.
 * 
 * For example:
 * ```
 * void *label_ptr = &&myLabel; // &&myLabel is a LabelLiteral
 * 
 * goto *label_ptr; // this is a ComputedGotoStmt
 * 
 * myLabel: // this is a LabelStmt
 * ```
 */
class LabelLiteral extends Literal {
  LabelLiteral() {
    jumpinfo(underlyingElement(this),_,_)
  }

  /** Gets the corresponding label statement. */
  LabelStmt getLabel() {
    jumpinfo(underlyingElement(this),_,unresolveElement(result))
  }
}

/** A character literal or a string literal. */
abstract class TextLiteral extends Literal {
  /** Gets a hex escape sequence that appears in the character or string literal (see [lex.ccon] in the C++ Standard). */
  string getAHexEscapeSequence(int occurrence, int offset) {
    result = getValueText().regexpFind("(?<!\\\\)\\\\x[0-9a-fA-F]+", occurrence, offset)
  }

  /** Gets an octal escape sequence that appears in the character or string literal (see [lex.ccon] in the C++ Standard). */
  string getAnOctalEscapeSequence(int occurrence, int offset) {
    result = getValueText().regexpFind("(?<!\\\\)\\\\[0-7]{1,3}", occurrence, offset)
  }

  /**
   * Gets a non-standard escape sequence that appears in the character or string literal. This is one that has the
   * form of an escape sequence but is not one of the valid types of escape sequence in the C++ Standard.
   */
  string getANonStandardEscapeSequence(int occurrence, int offset) {
    // Find all single character escape sequences (ignoring the start of octal escape sequences),
    // together with anything starting like a hex escape sequence but not followed by a hex digit.
    result = getValueText().regexpFind("\\\\[^x0-7\\s]|\\\\x[^0-9a-fA-F]", occurrence, offset)

    // From these, exclude all standard escape sequences.
    and not(result = getAStandardEscapeSequence(_,_))
  }

  /** Gets a simple escape sequence that appears in the char or string literal (see [lex.ccon] in the C++ Standard). */
  string getASimpleEscapeSequence(int occurrence, int offset) {
    result = getValueText().regexpFind("\\\\['\"?\\\\abfnrtv]", occurrence, offset)
  }

  /** Gets a standard escape sequence that appears in the char or string literal (see [lex.ccon] in the C++ Standard). */
  string getAStandardEscapeSequence(int occurrence, int offset) {
    result = getASimpleEscapeSequence(occurrence, offset)
    or result = getAnOctalEscapeSequence(occurrence, offset)
    or result = getAHexEscapeSequence(occurrence, offset)
  }

  /**
   * Gets the length of the string literal (including null) before escape sequences added by the extractor.
   */
  int getOriginalLength()
  {
    result = getValue().length() + 1
  }
}

/**
 * A character literal, for example `'a'` or `L'a'`.
 */
class CharLiteral extends TextLiteral {
  CharLiteral() {
    this.getValueText().regexpMatch("(?s)\\s*L?'.*")
  }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "CharLiteral" }

  /**
   * Gets the character of this literal. For example `L'a'` has character `"a"`.
   */
  string getCharacter() {
    result = this.getValueText().regexpCapture("(?s)\\s*L?'(.*)'", 1)
  }
}

/**
 * A string literal, for example `"abcdef"` or `L"123456"`.
 */
class StringLiteral extends TextLiteral
{
  StringLiteral() {
    this.getType() instanceof ArrayType
    // Note that `AggregateLiteral`s can also have an array type, but they derive from
    // @aggregateliteral rather than @literal.
  }
  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "StringLiteral" }
  
}

/**
 * An octal literal.
 */
class OctalLiteral extends Literal {
  OctalLiteral() {
    super.getValueText().regexpMatch("\\s*0[0-7]+[uUlL]*\\s*")
  }
  
  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "OctalLiteral" }
}

/**
 * A hexadecimal literal.
 */
class HexLiteral extends Literal {
  HexLiteral() {
    super.getValueText().regexpMatch("\\s*0[xX][0-9a-fA-F]+[uUlL]*\\s*")
  }
  
  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "HexLiteral" }
}

/**
 * A C/C++ aggregate literal.
*/
class AggregateLiteral extends Expr, @aggregateliteral {
  // if this is turned into a Literal we need to change mayBeImpure

  /**
   * DEPRECATED: Use ClassAggregateLiteral.getFieldExpr() instead.
   *
   * Gets the expression within the aggregate literal that is used to initialise field `f`,
   * if this literal is being used to initialise a class/struct instance.
   */
  deprecated Expr getCorrespondingExpr(Field f) {
    result = this.(ClassAggregateLiteral).getFieldExpr(f)
  }

  /** Gets a textual representation of this aggregate literal. */
  override string toString() { result = "{...}" }
}

/**
 * A C/C++ aggregate literal that initializes a class, struct, or union
 */
class ClassAggregateLiteral extends AggregateLiteral {
  Class classType;

  ClassAggregateLiteral() {
    classType = this.getUnspecifiedType()
  }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "ClassAggregateLiteral" }

  /**
   * Gets the expression within the aggregate literal that is used to initialize
   * field `field`, if present.
   */
  Expr getFieldExpr(Field field) {
    field = classType.getAField() and
    aggregate_field_init(underlyingElement(this), unresolveElement(result),
        unresolveElement(field))
  }

  /**
   * Holds if the field `field` is initialized by this initializer list, either
   * explicitly with an expression, or implicitly value initialized.
   */
  pragma[inline]
  predicate isInitialized(Field field) {
    field = classType.getAField() and
    field.isInitializable() and
    (
      // If the field has an explicit initializer expression, then the field is
      // initialized.
      exists(getFieldExpr(field)) or
      // If the type is not a union, all fields without initializers are value
      // initialized.
      not classType instanceof Union or
      // If the type is a union, and there are no explicit initializers, then
      // the first declared field is value initialized.
      (
        not exists(getAChild()) and
        field.getInitializationOrder() = 0
      )
    )
  }

  /**
   * Holds if the field `field` is value initialized because it is not
   * explicitly initialized by this initializer list.
   *
   * Value initialization (see [dcl.init]/8) recursively initializes all fields
   * of an object to `false`, `0`, `nullptr`, or by calling the default
   * constructor, as appropriate to the type.
   */
  pragma[inline]
  predicate isValueInitialized(Field field) {
    isInitialized(field) and
    not exists(getFieldExpr(field))
  }
}

/**
 * A C/C++ aggregate literal that initializes an array
 */
class ArrayAggregateLiteral extends AggregateLiteral {
  ArrayType arrayType;

  ArrayAggregateLiteral() {
    arrayType = this.getUnspecifiedType()
  }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "ArrayAggregateLiteral" }

  /**
   * Gets the expression within the aggregate literal that is used to initialize
   * element `elementIndex`, if present.
   */
  Expr getElementExpr(int elementIndex) {
    aggregate_array_init(underlyingElement(this), unresolveElement(result),
        elementIndex)
  }

  /**
   * Holds if the element `elementIndex` is initialized by this initializer
   * list, either explicitly with an expression, or implicitly value
   * initialized.
   */
  pragma[inline]
  predicate isInitialized(int elementIndex) {
    elementIndex in [0..arrayType.getArraySize() - 1]
  }

  /**
   * Holds if the element `elementIndex` is value initialized because it is not
   * explicitly initialized by this initializer list.
   *
   * Value initialization (see [dcl.init]/8) recursively initializes all fields
   * of an object to `false`, `0`, `nullptr`, or by calling the default
   * constructor, as appropriate to the type.
   */
  pragma[inline]
  predicate isValueInitialized(int elementIndex) {
    isInitialized(elementIndex) and
    not exists(getElementExpr(elementIndex))
  }
}
