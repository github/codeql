/**
 * Provides classes for modeling C/C++ casts and conversions, as well as some
 * type-related operators such as `sizeof` and `alignof`.
 */

import semmle.code.cpp.exprs.Expr
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ cast expression or similar unary expression that doesn't affect the logical value of its operand.
 *
 * Instances of this class are not present in the main AST which is navigated by parent/child links. Instead,
 * instances of this class are attached to nodes in the main AST via special conversion links.
 */
class Conversion extends Expr, @conversion {
  /** Gets the expression being converted. */
  Expr getExpr() { result.getConversion() = this }

  /** Holds if this conversion is an implicit conversion. */
  predicate isImplicit() { this.isCompilerGenerated() }

  override predicate mayBeImpure() { this.getExpr().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getExpr().mayBeGloballyImpure() }
}

/**
 * A C/C++ cast expression.
 *
 * To get the type which the expression is being cast to, use `Cast::getType()`.
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
 *
 * This is a root QL class representing the different casts.  For
 * specific examples, consult the documentation for any of QL classes mentioned above.
 */
class Cast extends Conversion, @cast {
  /**
   * Gets a string describing the semantic conversion operation being performed by
   * this cast.
   */
  string getSemanticConversionString() { result = "unknown conversion" }
}

/**
 * INTERNAL: Do not use.
 * Query predicates used to check invariants that should hold for all `Cast`
 * nodes. To run all consistency queries for the ASTs, including the ones below,
 * run "semmle/code/cpp/ASTConsistency.ql".
 */
module CastConsistency {
  /**
   * Holds if the cast has more than one result for `Cast.getSemanticConversionString()`.
   */
  query predicate multipleSemanticConversionStrings(Cast cast, Type fromType, string kind) {
    // Every cast should have exactly one semantic conversion kind
    count(cast.getSemanticConversionString()) > 1 and
    kind = cast.getSemanticConversionString() and
    fromType = cast.getExpr().getUnspecifiedType()
  }

  /**
   * Holds if the cast has no result for `Cast.getSemanticConversionString()`.
   */
  query predicate missingSemanticConversionString(Cast cast, Type fromType) {
    // Every cast should have exactly one semantic conversion kind
    not exists(cast.getSemanticConversionString()) and
    fromType = cast.getExpr().getUnspecifiedType()
  }

  /**
   * Holds if the cast has a result for `Cast.getSemanticConversionString()` that indicates that the
   * kind of its semantic conversion is not known.
   */
  query predicate unknownSemanticConversionString(Cast cast, Type fromType) {
    // Every cast should have a known semantic conversion kind
    cast.getSemanticConversionString() = "unknown conversion" and
    fromType = cast.getExpr().getUnspecifiedType()
  }
}

/**
 * A cast expression in C, or a C-style cast expression in C++.
 * ```
 * float f = 3.0f;
 * int i = (int)f;
 * ```
 */
class CStyleCast extends Cast, @c_style_cast {
  override string toString() { result = "(" + this.getType().getName() + ")..." }

  override string getAPrimaryQlClass() { result = "CStyleCast" }

  override int getPrecedence() { result = 16 }
}

/**
 * A C++ `static_cast` expression.
 *
 * Please see https://en.cppreference.com/w/cpp/language/static_cast for
 * more information.
 * ```
 * struct T: S {};
 * struct S *s = get_S();
 * struct T *t = static_cast<struct T *>(s); // downcast
 * ```
 */
class StaticCast extends Cast, @static_cast {
  override string toString() { result = "static_cast<" + this.getType().getName() + ">..." }

  override string getAPrimaryQlClass() { result = "StaticCast" }

  override int getPrecedence() { result = 17 }
}

/**
 * A C++ `const_cast` expression.
 *
 * Please see https://en.cppreference.com/w/cpp/language/const_cast for
 * more information.
 * ```
 * const struct S *s = get_S();
 * struct S *t = const_cast<struct S *>(s);
 * ```
 */
class ConstCast extends Cast, @const_cast {
  override string toString() { result = "const_cast<" + this.getType().getName() + ">..." }

  override string getAPrimaryQlClass() { result = "ConstCast" }

  override int getPrecedence() { result = 17 }
}

/**
 * A C++ `reinterpret_cast` expression.
 *
 * Please see https://en.cppreference.com/w/cpp/language/reinterpret_cast for
 * more information.
 * ```
 * struct S *s = get_S();
 * std::uintptr_t p = reinterpret_cast<std::uintptr_t>(s);
 * ```
 */
class ReinterpretCast extends Cast, @reinterpret_cast {
  override string toString() { result = "reinterpret_cast<" + this.getType().getName() + ">..." }

  override string getAPrimaryQlClass() { result = "ReinterpretCast" }

  override int getPrecedence() { result = 17 }
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
 * A conversion from one arithmetic or `enum` type to another.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class ArithmeticConversion extends Cast {
  ArithmeticConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isArithmeticOrEnum(this.getUnspecifiedType()) and
    isArithmeticOrEnum(this.getExpr().getUnspecifiedType())
  }

  override string getSemanticConversionString() { result = "arithmetic conversion" }
}

/**
 * A conversion from one integral or enum type to another.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`,  `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class IntegralConversion extends ArithmeticConversion {
  IntegralConversion() {
    isIntegralOrEnum(this.getUnspecifiedType()) and
    isIntegralOrEnum(this.getExpr().getUnspecifiedType())
  }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "IntegralConversion"
  }

  override string getSemanticConversionString() { result = "integral conversion" }
}

/**
 * A conversion from one floating point type.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class FloatingPointConversion extends ArithmeticConversion {
  FloatingPointConversion() {
    this.getUnspecifiedType() instanceof FloatingPointType and
    this.getExpr().getUnspecifiedType() instanceof FloatingPointType
  }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "FloatingPointConversion"
  }

  override string getSemanticConversionString() { result = "floating point conversion" }
}

/**
 * A conversion from a floating point type to an integral or enum type.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class FloatingPointToIntegralConversion extends ArithmeticConversion {
  FloatingPointToIntegralConversion() {
    isIntegralOrEnum(this.getUnspecifiedType()) and
    this.getExpr().getUnspecifiedType() instanceof FloatingPointType
  }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "FloatingPointToIntegralConversion"
  }

  override string getSemanticConversionString() { result = "floating point to integral conversion" }
}

/**
 * A conversion from an integral or enum type to a floating point type.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class IntegralToFloatingPointConversion extends ArithmeticConversion {
  IntegralToFloatingPointConversion() {
    this.getUnspecifiedType() instanceof FloatingPointType and
    isIntegralOrEnum(this.getExpr().getUnspecifiedType())
  }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "IntegralToFloatingPointConversion"
  }

  override string getSemanticConversionString() { result = "integral to floating point conversion" }
}

/**
 * A conversion from one pointer type to another.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`,  `ConstCast`
 * or `ReinterpretCast` for more information.
 *
 * The conversion does
 * not modify the value of the pointer. For pointer conversions involving
 * casts between base and derived classes, please see see `BaseClassConversion` or
 * `DerivedClassConversion`.
 */
class PointerConversion extends Cast {
  PointerConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isPointerOrNullPointer(this.getUnspecifiedType()) and
    isPointerOrNullPointer(this.getExpr().getUnspecifiedType())
  }

  override string getAPrimaryQlClass() { not exists(qlCast(this)) and result = "PointerConversion" }

  override string getSemanticConversionString() { result = "pointer conversion" }
}

/**
 * A conversion from one pointer-to-member type to another.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 *
 * The conversion does not modify the value of the pointer-to-member.
 * For pointer-to-member conversions involving casts between base and
 * derived classes, please see `PointerToMemberBaseClassConversion`
 * or `PointerToMemberDerivedClassConversion`.
 */
class PointerToMemberConversion extends Cast {
  PointerToMemberConversion() {
    conversionkinds(underlyingElement(this), 0) and
    exists(Type fromType, Type toType |
      fromType = this.getExpr().getUnspecifiedType() and
      toType = this.getUnspecifiedType() and
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

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "PointerToMemberConversion"
  }

  override string getSemanticConversionString() { result = "pointer-to-member conversion" }
}

/**
 * A conversion from a pointer type to an integral or enum type.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class PointerToIntegralConversion extends Cast {
  PointerToIntegralConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isIntegralOrEnum(this.getUnspecifiedType()) and
    isPointerOrNullPointer(this.getExpr().getUnspecifiedType())
  }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "PointerToIntegralConversion"
  }

  override string getSemanticConversionString() { result = "pointer to integral conversion" }
}

/**
 * A conversion from an integral or enum type to a pointer type.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class IntegralToPointerConversion extends Cast {
  IntegralToPointerConversion() {
    conversionkinds(underlyingElement(this), 0) and
    isPointerOrNullPointer(this.getUnspecifiedType()) and
    isIntegralOrEnum(this.getExpr().getUnspecifiedType())
  }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "IntegralToPointerConversion"
  }

  override string getSemanticConversionString() { result = "integral to pointer conversion" }
}

/**
 * A conversion to `bool`. Returns `false` if the source value is zero,
 * `false`, or `nullptr`. Returns `true` otherwise.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class BoolConversion extends Cast {
  BoolConversion() { conversionkinds(underlyingElement(this), 1) }

  override string getAPrimaryQlClass() { not exists(qlCast(this)) and result = "BoolConversion" }

  override string getSemanticConversionString() { result = "conversion to bool" }
}

/**
 * A conversion to `void`.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class VoidConversion extends Cast {
  VoidConversion() {
    conversionkinds(underlyingElement(this), 0) and
    this.getUnspecifiedType() instanceof VoidType
  }

  override string getAPrimaryQlClass() { not exists(qlCast(this)) and result = "VoidConversion" }

  override string getSemanticConversionString() { result = "conversion to void" }
}

/**
 * A conversion between two pointers or _glvalue_s related by inheritance.
 *
 * The base class will always be either a direct base class of the derived class,
 * or a virtual base class of the derived class. A conversion to an indirect
 * non-virtual base class will be represented as a sequence of conversions to
 * direct base classes.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
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
    result.getBaseClass() = this.getBaseClass() and
    result.getDerivedClass() = this.getDerivedClass()
  }

  /**
   * Gets the base class of the conversion. This will be either a direct
   * base class of the derived class, or a virtual base class of the
   * derived class.
   */
  Class getBaseClass() {
    none() // Overridden by subclasses
  }

  /**
   * Gets the derived class of the conversion.
   */
  Class getDerivedClass() {
    none() // Overridden by subclasses
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
 * A conversion from a pointer or _glvalue_ of a derived class to a pointer or
 * _glvalue_ of a direct or virtual base class.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class BaseClassConversion extends InheritanceConversion {
  BaseClassConversion() { conversionkinds(underlyingElement(this), 2) }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "BaseClassConversion"
  }

  override string getSemanticConversionString() { result = "base class conversion" }

  override Class getBaseClass() { result = getConversionClass(this) }

  override Class getDerivedClass() { result = getConversionClass(this.getExpr()) }

  /**
   * Holds if this conversion is to a virtual base class.
   */
  predicate isVirtual() { this.getDerivation().isVirtual() or not exists(this.getDerivation()) }
}

/**
 * A conversion from a pointer or _glvalue_ to a base class to a pointer or _glvalue_
 * to a direct derived class.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class DerivedClassConversion extends InheritanceConversion {
  DerivedClassConversion() { conversionkinds(underlyingElement(this), 3) }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "DerivedClassConversion"
  }

  override string getSemanticConversionString() { result = "derived class conversion" }

  override Class getBaseClass() { result = getConversionClass(this.getExpr()) }

  override Class getDerivedClass() { result = getConversionClass(this) }
}

/**
 * A conversion from a pointer-to-member of a derived class to a pointer-to-member
 * of an immediate base class.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class PointerToMemberBaseClassConversion extends Cast {
  PointerToMemberBaseClassConversion() { conversionkinds(underlyingElement(this), 4) }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "PointerToMemberBaseClassConversion"
  }

  override string getSemanticConversionString() {
    result = "pointer-to-member base class conversion"
  }
}

/**
 * A conversion from a pointer-to-member of a base class to a pointer-to-member
 * of an immediate derived class.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class PointerToMemberDerivedClassConversion extends Cast {
  PointerToMemberDerivedClassConversion() { conversionkinds(underlyingElement(this), 5) }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "PointerToMemberDerivedClassConversion"
  }

  override string getSemanticConversionString() {
    result = "pointer-to-member derived class conversion"
  }
}

/**
 * A conversion of a _glvalue_ from one type to another. The conversion does not
 * modify the address of the _glvalue_. For _glvalue_ conversions involving base and
 * derived classes, see `BaseClassConversion` and `DerivedClassConversion`.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class GlvalueConversion extends Cast {
  GlvalueConversion() { conversionkinds(underlyingElement(this), 6) }

  override string getAPrimaryQlClass() { not exists(qlCast(this)) and result = "GlvalueConversion" }

  override string getSemanticConversionString() { result = "glvalue conversion" }
}

/**
 * The adjustment of the type of a class _prvalue_. Most commonly seen in code
 * similar to:
 * ```
 * class String { ... };
 * String func();
 * void caller() {
 *   const String& r = func();
 * }
 * ```
 * In the above example, the result of the call to `func` is a _prvalue_ of type
 * `String`, which will be adjusted to type `const String` before being bound
 * to the reference.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`, `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class PrvalueAdjustmentConversion extends Cast {
  PrvalueAdjustmentConversion() { conversionkinds(underlyingElement(this), 7) }

  override string getAPrimaryQlClass() {
    not exists(qlCast(this)) and result = "PrvalueAdjustmentConversion"
  }

  override string getSemanticConversionString() { result = "prvalue adjustment conversion" }
}

/**
 * A C++ `dynamic_cast` expression.
 *
 * Please see https://en.cppreference.com/w/cpp/language/dynamic_cast for
 * more information.
 * ```
 * struct T: S {};
 * struct S *s = get_S();
 * struct T *t = dynamic_cast<struct T *>(s); // downcast
 * ```
 */
class DynamicCast extends Cast, @dynamic_cast {
  override string toString() { result = "dynamic_cast<" + this.getType().getName() + ">..." }

  override int getPrecedence() { result = 17 }

  override string getAPrimaryQlClass() { result = "DynamicCast" }

  override string getSemanticConversionString() { result = "dynamic_cast" }
}

/**
 * A Microsoft C/C++ `__uuidof` expression that returns the UUID of a type, as
 * specified by the `__declspec(uuid)` attribute.
 * ```
 * struct UUID { char a[16]; };
 * struct __declspec(uuid("{01234567-89ab-cdef-0123-456789ABCDEF}")) S {};
 * UUID uuid = __uuidof(S);
 * ```
 */
class UuidofOperator extends Expr, @uuidof {
  override string toString() {
    if exists(this.getTypeOperand())
    then result = "__uuidof(" + this.getTypeOperand().getName() + ")"
    else result = "__uuidof(0)"
  }

  override int getPrecedence() { result = 16 }

  /** Gets the contained type. */
  Type getTypeOperand() { uuidof_bind(underlyingElement(this), unresolveElement(result)) }
}

/**
 * A C++ `typeid` expression which provides run-time type information (RTTI)
 * about its argument.
 *
 * Please see https://en.cppreference.com/w/cpp/language/typeid for more
 * information.
 * ```
 * Base *ptr = new Derived;
 * const std::type_info &info1 = typeid(ptr);
 * printf("the type of ptr is: %s\n", typeid(ptr).name());
 * ```
 */
class TypeidOperator extends Expr, @type_id {
  /**
   * Gets the type that is returned by this typeid expression.
   */
  Type getResultType() { typeid_bind(underlyingElement(this), unresolveElement(result)) }

  override string getAPrimaryQlClass() { result = "TypeidOperator" }

  /**
   * Gets the contained expression, if any (if this typeid contains
   * a type rather than an expression, there is no result).
   */
  Expr getExpr() { result = this.getChild(0) }

  override string toString() { result = "typeid ..." }

  override int getPrecedence() { result = 17 }

  override predicate mayBeImpure() { this.getExpr().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getExpr().mayBeGloballyImpure() }
}

/**
 * A C++11 `sizeof...` expression which determines the size of a template parameter pack.
 *
 * This expression only appears in templates themselves - in any actual
 * instantiations, "sizeof...(x)" will be replaced by its integer value.
 * ```
 * template < typename... T >
 * int count ( T &&... t ) { return sizeof... ( t ); }
 * ```
 */
class SizeofPackOperator extends Expr, @sizeof_pack {
  override string toString() { result = "sizeof...(...)" }

  override string getAPrimaryQlClass() { result = "SizeofPackOperator" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A C/C++ sizeof expression.
 */
class SizeofOperator extends Expr, @runtime_sizeof {
  override int getPrecedence() { result = 16 }
}

/**
 * A C/C++ sizeof expression whose operand is an expression.
 * ```
 * if (sizeof(a) == sizeof(b)) { c = (b)a; }
 * ```
 */
class SizeofExprOperator extends SizeofOperator {
  SizeofExprOperator() { exists(this.getChild(0)) }

  override string getAPrimaryQlClass() { result = "SizeofExprOperator" }

  /** Gets the contained expression. */
  Expr getExprOperand() { result = this.getChild(0) }

  override string toString() { result = "sizeof(<expr>)" }

  override predicate mayBeImpure() { this.getExprOperand().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getExprOperand().mayBeGloballyImpure() }
}

/**
 * A C/C++ sizeof expression whose operand is a type name.
 * ```
 * int szlong = sizeof(int) == sizeof(long)? 4 : 8;
 * ```
 */
class SizeofTypeOperator extends SizeofOperator {
  SizeofTypeOperator() { sizeof_bind(underlyingElement(this), _) }

  override string getAPrimaryQlClass() { result = "SizeofTypeOperator" }

  /** Gets the contained type. */
  Type getTypeOperand() { sizeof_bind(underlyingElement(this), unresolveElement(result)) }

  override string toString() { result = "sizeof(" + this.getTypeOperand().getName() + ")" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A C++11 `alignof` expression.
 */
class AlignofOperator extends Expr, @runtime_alignof {
  override int getPrecedence() { result = 16 }
}

/**
 * A C++11 `alignof` expression whose operand is an expression.
 * ```
 * int addrMask = ~(alignof(expr) - 1);
 * ```
 */
class AlignofExprOperator extends AlignofOperator {
  AlignofExprOperator() { exists(this.getChild(0)) }

  /**
   * Gets the contained expression.
   */
  Expr getExprOperand() { result = this.getChild(0) }

  override string toString() { result = "alignof(<expr>)" }
}

/**
 * A C++11 `alignof` expression whose operand is a type name.
 * ```
 * bool proper_alignment = (alingof(T) == alignof(T[0]);
 * ```
 */
class AlignofTypeOperator extends AlignofOperator {
  AlignofTypeOperator() { sizeof_bind(underlyingElement(this), _) }

  /** Gets the contained type. */
  Type getTypeOperand() { sizeof_bind(underlyingElement(this), unresolveElement(result)) }

  override string toString() { result = "alignof(" + this.getTypeOperand().getName() + ")" }
}

/**
 * A C/C++ array to pointer conversion.
 *
 * The conversion is either implicit or underlies a particular cast.
 * Please see `CStyleCast`, `StaticCast`,  `ConstCast`
 * or `ReinterpretCast` for more information.
 */
class ArrayToPointerConversion extends Conversion, @array_to_pointer {
  /** Gets a textual representation of this conversion. */
  override string toString() { result = "array to pointer conversion" }

  override string getAPrimaryQlClass() { result = "ArrayToPointerConversion" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A node representing a temporary object created as part of an expression.
 *
 * This is most commonly seen in the following cases:
 * ```c++
 * // when binding a reference to a prvalue
 * const std::string& r = std::string("text");
 *
 * // when performing member access on a class prvalue
 * strlen(std::string("text").c_str());
 *
 * // when a prvalue of a type with a destructor is discarded
 * s.substr(0, 5);  // Return value is discarded but requires destruction
 * ```
 */
class TemporaryObjectExpr extends Conversion, @temp_init {
  /** Gets a textual representation of this conversion. */
  override string toString() { result = "temporary object" }

  override string getAPrimaryQlClass() { result = "TemporaryObjectExpr" }
}

/**
 * A node representing the Cast sub-class of entity `cast`.
 */
string qlCast(Cast cast) {
  // NB: Take care and include only leaf QL classes
  cast instanceof CStyleCast and result = "CStyleCast"
  or
  cast instanceof StaticCast and result = "StaticCast"
  or
  cast instanceof DynamicCast and result = "DynamicCast"
  or
  cast instanceof ConstCast and result = "ConstCast"
  or
  cast instanceof ReinterpretCast and result = "ReinterpretCast"
}

/**
 * A node representing the Conversion sub-class of entity `cast`.
 */
string qlConversion(Cast cast) {
  // NB: Take care and include only leaf QL classes
  cast instanceof IntegralConversion and result = "IntegralConversion"
  or
  cast instanceof FloatingPointConversion and result = "FloatingPointConversion"
  or
  cast instanceof FloatingPointToIntegralConversion and result = "FloatingPointToIntegralConversion"
  or
  cast instanceof IntegralToFloatingPointConversion and result = "IntegralToFloatingPointConversion"
  or
  cast instanceof PointerConversion and result = "PointerConversion"
  or
  cast instanceof PointerToMemberConversion and result = "PointerToMemberConversion"
  or
  cast instanceof PointerToIntegralConversion and result = "PointerToIntegralConversion"
  or
  cast instanceof IntegralToPointerConversion and result = "IntegralToPointerConversion"
  or
  cast instanceof BoolConversion and result = "BoolConversion"
  or
  cast instanceof VoidConversion and result = "VoidConversion"
  or
  cast instanceof BaseClassConversion and result = "BaseClassConversion"
  or
  cast instanceof DerivedClassConversion and result = "DerivedClassConversion"
  or
  cast instanceof PointerToMemberBaseClassConversion and
  result = "PointerToMemberBaseClassConversion"
  or
  cast instanceof PointerToMemberDerivedClassConversion and
  result = "PointerToMemberDerivedClassConversion"
  or
  cast instanceof GlvalueConversion and result = "GlvalueConversion"
  or
  cast instanceof PrvalueAdjustmentConversion and result = "PrvalueAdjustmentConversion"
  or
  // treat dynamic_cast<...>(...) as a conversion
  cast instanceof DynamicCast and result = "DynamicCast"
}
