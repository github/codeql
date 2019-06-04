import semmle.code.cpp.exprs.Expr
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ cast expression or similar unary expression that doesn't affect the logical value of its operand.
 *
 * Instances of this class are not present in the main AST which is navigated by parent/child links. Instead,
 * instances of this class are attached to nodes in the main AST via special conversion links.
 */
abstract class Conversion extends Expr {
  /** Gets the expression being converted. */
  Expr getExpr() { result.getConversion() = this }

  /** Holds if this conversion is an implicit conversion. */
  predicate isImplicit() { this.isCompilerGenerated() }

  override predicate mayBeImpure() {
    this.getExpr().mayBeImpure()
  }
  override predicate mayBeGloballyImpure() {
    this.getExpr().mayBeGloballyImpure()
  }
}

/**
 * A C/C++ cast expression.
 *
 * To get the type which the expression is being cast to, use getType().
 *
 * There are two groups of subtypes of `Cast`. The first group differentiates
 * between the different cast syntax forms, e.g. `CStyleCast`, `StaticCast`,
 * etc. The second group differentiates between the semantic operation being
 * performed by the cast, e.g. `IntegralConversion`, `PointerBaseClassConversion`,
 * etc.
 * The two groups are largely orthogonal to one another. For example, a
 * cast that is syntactically as `CStyleCast` may also be an `IntegralConversion`,
 * a `PointerBaseClassConversion`, or some other semantic conversion. Similarly,
 * a `PointerDerivedClassConversion` may also be a `CStyleCast` or a `StaticCast`.
 */
abstract class Cast extends Conversion, @cast {
  /**
   * Gets a string describing the semantic conversion operation being performed by
   * this cast.
   */
  string getSemanticConversionString() {
    result = "unknown conversion"
  }
}

/**
 * INTERNAL: Do not use.
 * Query predicates used to check invariants that should hold for all `Cast`
 * nodes. To run all sanity queries for the ASTs, including the ones below,
 * run "semmle/code/cpp/ASTSanity.ql".
 */
module CastSanity {
  query predicate multipleSemanticConversionStrings(Cast cast, Type fromType, string kind) {
    // Every cast should have exactly one semantic conversion kind
    count(cast.getSemanticConversionString()) > 1 and
    kind = cast.getSemanticConversionString() and
    fromType = cast.getExpr().getUnspecifiedType()
  }

  query predicate missingSemanticConversionString(Cast cast, Type fromType) {
    // Every cast should have exactly one semantic conversion kind
    not exists(cast.getSemanticConversionString()) and
    fromType = cast.getExpr().getUnspecifiedType()
  }

  query predicate unknownSemanticConversionString(Cast cast, Type fromType) {
    // Every cast should have a known semantic conversion kind
    cast.getSemanticConversionString() = "unknown conversion" and
    fromType = cast.getExpr().getUnspecifiedType()
  }
}

/**
 * A cast expression in C, or a C-style cast expression in C++.
 */
class CStyleCast extends Cast, @c_style_cast {
  override string toString() { result = "(" + this.getType().getName() + ")..." }

  override int getPrecedence() { result = 15 }
}

/**
 * A C++ `static_cast` expression.
 */
class StaticCast extends Cast, @static_cast {
  override string toString() { result = "static_cast<" + this.getType().getName() + ">..." }

  override int getPrecedence() { result = 16 }
}

/**
 * A C++ `const_cast` expression.
 */
class ConstCast extends Cast, @const_cast {
  override string toString() { result = "const_cast<" + this.getType().getName() + ">..." }

  override int getPrecedence() { result = 16 }
}

/**
 * A C++ `reinterpret_cast` expression.
 */
class ReinterpretCast extends Cast, @reinterpret_cast {
  override string toString() { result = "reinterpret_cast<" + this.getType().getName() + ">..." }

  override int getPrecedence() { result = 16 }
}

private predicate isArithmeticOrEnum(Type type) {
  type instanceof ArithmeticType or
  type instanceof Enum
}

private predicate isIntegralOrEnum(Type type) {
  type instanceof IntegralType or
  type instanceof Enum
}

private predicate isPointerOrNullPointer(Type type) {
  type instanceof PointerType or
  type instanceof FunctionPointerType or
  type instanceof NullPointerType
}

private predicate isPointerToMemberOrNullPointer(Type type) {
  type instanceof PointerToMemberType or
  type instanceof NullPointerType
}

/**
 * A conversion from one arithmetic or enum type to another.
 */
class ArithmeticConversion extends Cast {
  ArithmeticConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isArithmeticOrEnum(getUnspecifiedType()) and
    isArithmeticOrEnum(getExpr().getUnspecifiedType())
  }

  override string getSemanticConversionString() {
    result = "arithmetic conversion"
  }
}

/**
 * A conversion from one integral or enum type to another.
 */
class IntegralConversion extends ArithmeticConversion {
  IntegralConversion() {
    isIntegralOrEnum(getUnspecifiedType()) and
    isIntegralOrEnum(getExpr().getUnspecifiedType())
  }

  override string getSemanticConversionString() {
    result = "integral conversion"
  }
}

/**
 * A conversion from one floating point type to another.
 */
class FloatingPointConversion extends ArithmeticConversion {
  FloatingPointConversion() {
    getUnspecifiedType() instanceof FloatingPointType and
    getExpr().getUnspecifiedType() instanceof FloatingPointType
  }

  override string getSemanticConversionString() {
    result = "floating point conversion"
  }
}

/**
 * A conversion from a floating point type to an integral or enum type.
 */
class FloatingPointToIntegralConversion extends ArithmeticConversion {
  FloatingPointToIntegralConversion() {
    isIntegralOrEnum(getUnspecifiedType()) and
    getExpr().getUnspecifiedType() instanceof FloatingPointType
  }

  override string getSemanticConversionString() {
    result = "floating point to integral conversion"
  }
}

/**
 * A conversion from an integral or enum type to a floating point type.
 */
class IntegralToFloatingPointConversion extends ArithmeticConversion {
  IntegralToFloatingPointConversion() {
    getUnspecifiedType() instanceof FloatingPointType and
    isIntegralOrEnum(getExpr().getUnspecifiedType())
  }

  override string getSemanticConversionString() {
    result = "integral to floating point conversion"
  }
}

/**
 * A conversion from one pointer type to another. The conversion does
 * not modify the value of the pointer. For pointer conversions involving
 * casts between base and derived classes, see `BaseClassConversion` and
 * `DerivedClassConversion`.
 */
class PointerConversion extends Cast {
  PointerConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isPointerOrNullPointer(getUnspecifiedType()) and
    isPointerOrNullPointer(getExpr().getUnspecifiedType())
  }

  override string getSemanticConversionString() {
    result = "pointer conversion"
  }
}

/**
 * A conversion from one pointer-to-member type to another. The conversion
 * does not modify the value of the pointer-to-member. For pointer-to-member
 * conversions involving casts between base and derived classes, see 
 * `PointerToMemberBaseClassConversion` and `PointerToMemberDerivedClassConversion`.
 */
class PointerToMemberConversion extends Cast {
  PointerToMemberConversion() {
    conversionkinds(underlyingElement(this), 0) and
    exists(Type fromType, Type toType |
      fromType = getExpr().getUnspecifiedType() and
      toType = getUnspecifiedType() and
      isPointerToMemberOrNullPointer(fromType) and
      isPointerToMemberOrNullPointer(toType) and
      // A conversion from nullptr to nullptr is a `PointerConversion`, not a
      // `PointerToMemberConversion`.
      not (
        fromType instanceof NullPointerType and
        toType instanceof NullPointerType
      )
    )
  }

  override string getSemanticConversionString() {
    result = "pointer-to-member conversion"
  }
}

/**
 * A conversion from a pointer type to an integral or enum type.
 */
class PointerToIntegralConversion extends Cast {
  PointerToIntegralConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isIntegralOrEnum(getUnspecifiedType()) and
    isPointerOrNullPointer(getExpr().getUnspecifiedType())
  }

  override string getSemanticConversionString() {
    result = "pointer to integral conversion"
  }
}

/**
 * A conversion from an integral or enum type to a pointer type.
 */
class IntegralToPointerConversion extends Cast {
  IntegralToPointerConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isPointerOrNullPointer(getUnspecifiedType()) and
    isIntegralOrEnum(getExpr().getUnspecifiedType())
  }

  override string getSemanticConversionString() {
    result = "integral to pointer conversion"
  }
}

/**
 * A conversion to `bool`. Returns `false` if the source value is zero,
 * false, or nullptr. Returns `true` otherwise.
 */
class BoolConversion extends Cast {
  BoolConversion() {
    conversionkinds(underlyingElement(this), 1)
  }

  override string getSemanticConversionString() {
    result = "conversion to bool"
  }
}

/**
 * A conversion to `void`.
 */
class VoidConversion extends Cast {
  VoidConversion() {
    conversionkinds(underlyingElement(this), 0) and
    getUnspecifiedType() instanceof VoidType
  }

  override string getSemanticConversionString() {
    result = "conversion to void"
  }
}

/**
 * A conversion between two pointers or glvalues related by inheritance. The
 * base class will always be either a direct base class of the derived class,
 * or a virtual base class of the derived class. A conversion to an indirect
 * non-virtual base class will be represented as a sequence of conversions to
 * direct base classes.
 */
class InheritanceConversion extends Cast {
  InheritanceConversion() {
    conversionkinds(underlyingElement(this), 2) or conversionkinds(underlyingElement(this), 3)
  }

  /**
   * Gets the `ClassDerivation` for the inheritance relationship between
   * the base and derived classes. This predicate does not hold if the
   * conversion is to an indirect virtual base class.
   */
  final ClassDerivation getDerivation() {
    result.getBaseClass() = getBaseClass() and
    result.getDerivedClass() = getDerivedClass()
  }

  /**
   * Gets the base class of the conversion. This will be either a direct
   * base class of the derived class, or a virtual base class of the
   * derived class.
   */
  Class getBaseClass() {
    none()  // Overridden by subclasses
  }

  /**
   * Gets the derived class of the conversion.
   */
  Class getDerivedClass() {
    none()  // Overridden by subclasses
  }
}

/**
 * Given the source operand or result of an `InheritanceConversion`, returns the
 * class being converted from or to. If the type of the expression is a pointer,
 * this returns the pointed-to class. Otherwise, the type of the expression must
 * be a class, in which case the result is that class.
 */
private Class getConversionClass(Expr expr) {
  exists(Type operandType |
    operandType = expr.getUnspecifiedType() and
    (
      result = operandType or
      result = operandType.(PointerType).getBaseType()
    )
  )
}

/**
 * A conversion from a pointer or glvalue of a derived class to a pointer or
 * glvalue of a direct or virtual base class.
 */
class BaseClassConversion extends InheritanceConversion {
  BaseClassConversion() {
    conversionkinds(underlyingElement(this), 2)
  }

  override string getSemanticConversionString() {
    result = "base class conversion"
  }

  override Class getBaseClass() {
    result = getConversionClass(this)
  }

  override Class getDerivedClass() {
    result = getConversionClass(getExpr())
  }

  /**
   * Holds if this conversion is to a virtual base class.
   */
  predicate isVirtual() {
    getDerivation().isVirtual() or not exists(getDerivation())
  }
}

/**
 * A conversion from a pointer or glvalue to a base class to a pointer or glvalue
 * to a direct derived class.
 */
class DerivedClassConversion extends InheritanceConversion {
  DerivedClassConversion() {
    conversionkinds(underlyingElement(this), 3)
  }

  override string getSemanticConversionString() {
    result = "derived class conversion"
  }

  override Class getBaseClass() {
    result = getConversionClass(getExpr())
  }

  override Class getDerivedClass() {
    result = getConversionClass(this)
  }
}

/**
 * A conversion from a pointer-to-member of a derived class to a pointer-to-member
 * of an immediate base class.
 */
class PointerToMemberBaseClassConversion extends Cast {
  PointerToMemberBaseClassConversion() {
    conversionkinds(underlyingElement(this), 4)
  }

  override string getSemanticConversionString() {
    result = "pointer-to-member base class conversion"
  }
}

/**
 * A conversion from a pointer-to-member of a base class to a pointer-to-member
 * of an immediate derived class.
 */
class PointerToMemberDerivedClassConversion extends Cast {
  PointerToMemberDerivedClassConversion() {
    conversionkinds(underlyingElement(this), 5)
  }

  override string getSemanticConversionString() {
    result = "pointer-to-member derived class conversion"
  }
}

/**
 * A conversion of a glvalue from one type to another. The conversion does not
 * modify the address of the glvalue. For glvalue conversions involving base and
 * derived classes, see `BaseClassConversion` and `DerivedClassConversion`.
 */
class GlvalueConversion extends Cast {
  GlvalueConversion() {
    conversionkinds(underlyingElement(this), 6)
  }

  override string getSemanticConversionString() {
    result = "glvalue conversion"
  }
}

/**
 * The adjustment of the type of a class prvalue. Most commonly seen in code
 * similar to:
 *
 * class String { ... };
 * String func();
 * void caller() {
 *   const String& r = func();
 * }
 *
 * In the above example, the result of the call to `func` is a prvalue of type
 * `String`, which will be adjusted to type `const String` before being bound
 * to the reference.
 */
class PrvalueAdjustmentConversion extends Cast {
  PrvalueAdjustmentConversion() {
    conversionkinds(underlyingElement(this), 7)
  }

  override string getSemanticConversionString() {
    result = "prvalue adjustment conversion"
  }
}

/**
 * A C++ `dynamic_cast` expression.
 */
class DynamicCast extends Cast, @dynamic_cast {
  override string toString() { result = "dynamic_cast<" + this.getType().getName() + ">..." }

  override int getPrecedence() { result = 16 }

  override string getSemanticConversionString() {
    result = "dynamic_cast"
  }
}

/**
 * A Microsoft C/C++ `__uuidof` expression that returns the UUID of a type, as
 * specified by the `__declspec(uuid)` attribute.
 */
class UuidofOperator extends Expr, @uuidof {
  override string toString() {
    if exists(getTypeOperand()) then
      result = "__uuidof(" + getTypeOperand().getName() + ")"
    else
      result = "__uuidof(0)"
  }

  override int getPrecedence() { result = 15 }

  /** Gets the contained type. */
  Type getTypeOperand() {
    uuidof_bind(underlyingElement(this), unresolveElement(result))
  }
}

/**
 * A C++ `typeid` expression which provides runtime type information
 * about an expression or type.
 */
class TypeidOperator extends Expr, @type_id {
  /**
   * Gets the type that is returned by this typeid expression.
   *
   * For example in the following code the `typeid` returns the
   * type `MyClass *`.
   *
   * ```
   * MyClass *ptr;
   *
   * printf("the type of ptr is: %s\n", typeid(ptr).name);
   * ```
   */
  Type getResultType() { typeid_bind(underlyingElement(this),unresolveElement(result)) }

  /**
   * DEPRECATED: Use `getResultType()` instead.
   *
   * Gets the type that is returned by this typeid expression.
   */
  deprecated Type getSpecifiedType() { result = this.getResultType() }

  /**
   * Gets the contained expression, if any (if this typeid contains
   * a type rather than an expression, there is no result).
   */
  Expr getExpr() { result = this.getChild(0) }

  override string toString() { result = "typeid ..." }

  override int getPrecedence() { result = 16 }

  override predicate mayBeImpure() {
    this.getExpr().mayBeImpure()
  }
  override predicate mayBeGloballyImpure() {
    this.getExpr().mayBeGloballyImpure()
  }
}

/**
 * A C++11 `sizeof...` expression which determines the size of a template parameter pack.
 *
 * This expression only appears in templates themselves - in any actual
 * instantiations, "sizeof...(x)" will be replaced by its integer value.
 */
class SizeofPackOperator extends Expr, @sizeof_pack {
  override string toString() { result = "sizeof...(...)" }

  override predicate mayBeImpure() {
    none()
  }
  override predicate mayBeGloballyImpure() {
    none()
  }
}

/**
 * A C/C++ sizeof expression.
 */
abstract class SizeofOperator extends Expr, @runtime_sizeof {
  override int getPrecedence() { result = 15 }
}

/**
 * A C/C++ sizeof expression whose operand is an expression.
 */
class SizeofExprOperator extends SizeofOperator {
  SizeofExprOperator() { exists(Expr e | this.getChild(0) = e) }

  /** Gets the contained expression. */
  Expr getExprOperand() { result = this.getChild(0) }

  /**
   * DEPRECATED: Use `getExprOperand()` instead
   *
   * Gets the contained expression.
   * */
  deprecated Expr getExpr() { result = this.getExprOperand() }

  override string toString() { result = "sizeof(<expr>)" }

  override predicate mayBeImpure() {
    this.getExprOperand().mayBeImpure()
  }
  override predicate mayBeGloballyImpure() {
    this.getExprOperand().mayBeGloballyImpure()
  }
}

/**
 * A C/C++ sizeof expression whose operand is a type name.
 */
class SizeofTypeOperator extends SizeofOperator {
  SizeofTypeOperator() { sizeof_bind(underlyingElement(this),_) }

  /** Gets the contained type. */
  Type getTypeOperand() { sizeof_bind(underlyingElement(this),unresolveElement(result)) }

  /**
   * DEPRECATED: Use `getTypeOperand()` instead
   *
   * Gets the contained type.
   */
  deprecated Type getSpecifiedType() { result = this.getTypeOperand() }

  override string toString() { result = "sizeof(" + this.getTypeOperand().getName() + ")" }

  override predicate mayBeImpure() {
    none()
  }
  override predicate mayBeGloballyImpure() {
    none()
  }
}

/**
 * A C++11 `alignof` expression.
 */
abstract class AlignofOperator extends Expr, @runtime_alignof {
  override int getPrecedence() { result = 15 }
}

/**
 * A C++11 `alignof` expression whose operand is an expression.
 */
class AlignofExprOperator extends AlignofOperator {
  AlignofExprOperator() { exists(Expr e | this.getChild(0) = e) }

  /**
   * Gets the contained expression.
   */
  Expr getExprOperand() { result = this.getChild(0) }

  /**
   * DEPRECATED: Use `getExprOperand()` instead.
   */
  deprecated Expr getExpr() { result = this.getExprOperand() }

  override string toString() { result = "alignof(<expr>)" }
}

/**
 * A C++11 `alignof` expression whose operand is a type name.
 */
class AlignofTypeOperator extends AlignofOperator {
  AlignofTypeOperator() { sizeof_bind(underlyingElement(this),_) }

  /** Gets the contained type. */
  Type getTypeOperand() { sizeof_bind(underlyingElement(this),unresolveElement(result)) }

  /**
   * DEPRECATED: Use `getTypeOperand()` instead.
   */
  deprecated Type getSpecifiedType() { result = this.getTypeOperand() }

  override string toString() { result = "alignof(" + this.getTypeOperand().getName() + ")" }
}

/**
 * A C/C++ array to pointer conversion.
 */
class ArrayToPointerConversion extends Conversion, @array_to_pointer {
  /** Gets a textual representation of this conversion. */
  override string toString() { result = "array to pointer conversion" }

  override predicate mayBeImpure() {
    none()
  }
  override predicate mayBeGloballyImpure() {
    none()
  }
}
