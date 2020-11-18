/**
 * Provides a hierarchy of classes for modeling C/C++ types.
 */

import semmle.code.cpp.Element
import semmle.code.cpp.Function
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ type.
 *
 * This QL class represents the root of the C/C++ type hierarchy.
 */
class Type extends Locatable, @type {
  Type() { isType(underlyingElement(this)) }

  /**
   * Gets the name of this type.
   */
  string getName() { none() }

  /**
   * Holds if this type is called `name`.
   */
  predicate hasName(string name) { name = this.getName() }

  /**
   * Holds if this declaration has a specifier called `name`, recursively looking
   * through `typedef` and `decltype`. For example, in the context of
   * `typedef const int *restrict t`, the type `volatile t` has specifiers
   * `volatile` and `restrict` but not `const` since the `const` is attached to
   * the type being pointed to rather than the pointer itself.
   */
  // This predicate should not be overridden, but it cannot be declared `final`
  // because there is a similarly-named predicate in Declaration, and UserType
  // inherits from both Type and Declaration and must override it to resolve
  // the ambiguity.
  predicate hasSpecifier(string name) { this.getASpecifier().hasName(name) }

  /**
   * Gets a specifier of this type, recursively looking through `typedef` and
   * `decltype`. For example, in the context of `typedef const int *restrict
   * t`, the type `volatile t` has specifiers `volatile` and `restrict` but not
   * `const` since the `const` is attached to the type being pointed to rather
   * than the pointer itself.
   */
  // This predicate should not be overridden, but it cannot be declared `final`
  // because there is a similarly-named predicate in Declaration, and UserType
  // inherits from both Type and Declaration and must override it to resolve
  // the ambiguity.
  Specifier getASpecifier() {
    typespecifiers(underlyingElement(this), unresolveElement(result))
    or
    result = this.internal_getAnAdditionalSpecifier()
  }

  /**
   * Gets an attribute of this type.
   */
  Attribute getAnAttribute() { typeattributes(underlyingElement(this), unresolveElement(result)) }

  /**
   * Internal -- should be `protected` when QL supports such a flag. Subtypes
   * override this to recursively get specifiers that are not attached directly
   * to this `@type` in the database but arise through type aliases such as
   * `typedef` and `decltype`.
   */
  Specifier internal_getAnAdditionalSpecifier() { none() }

  /**
   * Holds if this type is const.
   */
  predicate isConst() { this.hasSpecifier("const") }

  /**
   * Holds if this type is volatile.
   */
  predicate isVolatile() { this.hasSpecifier("volatile") }

  /**
   * Holds if this type refers to type `t` (by default,
   * a type always refers to itself).
   */
  predicate refersTo(Type t) { refersToDirectly*(t) }

  /**
   * Holds if this type refers to type `t` directly.
   */
  predicate refersToDirectly(Type t) { none() }

  /**
   * Gets this type after typedefs have been resolved.
   *
   * The result of this predicate will be the type itself, except in the case of a TypedefType or a Decltype,
   * in which case the result will be type which results from (possibly recursively) resolving typedefs.
   */
  Type getUnderlyingType() { result = this }

  /**
   * Gets this type after specifiers have been deeply stripped and typedefs have been resolved.
   *
   * For example, starting with `const i64* const` in the context of `typedef long long i64;`, this predicate will return `long long*`.
   */
  Type getUnspecifiedType() { unspecifiedtype(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets this type after any top-level specifiers and typedefs have been stripped.
   *
   * For example, starting with `const i64* const`, this predicate will return `const i64*`.
   */
  Type stripTopLevelSpecifiers() { result = this }

  /**
   * Gets the size of this type in bytes.
   */
  int getSize() {
    builtintypes(underlyingElement(this), _, _, result, _, _) or
    pointerishsize(underlyingElement(this), result, _) or
    usertypesize(underlyingElement(this), result, _)
  }

  /**
   * Gets the alignment of this type in bytes.
   */
  int getAlignment() {
    builtintypes(underlyingElement(this), _, _, _, _, result) or
    pointerishsize(underlyingElement(this), _, result) or
    usertypesize(underlyingElement(this), _, result)
  }

  /**
   * Gets the pointer indirection level of this type.
   */
  int getPointerIndirectionLevel() { result = 0 }

  /**
   * Gets a detailed string representation explaining the AST of this type
   * (with all specifiers and nested constructs such as pointers). This is
   * intended to help debug queries and is a very expensive operation; not
   * to be used in production queries.
   *
   * An example output is "const {pointer to {const {char}}}".
   */
  string explain() { result = "type" } // Concrete base impl to allow filters on Type

  /**
   * Holds if this type is constant and only contains constant types.
   * For instance, a `char *const` is a constant type, but not deeply constant,
   * because while the pointer can't be modified the character can. The type
   * `const char *const*` is a deeply constant type though - both the pointer
   * and what it points to are immutable.
   */
  predicate isDeeplyConst() { this.isConst() and this.isDeeplyConstBelow() }

  /**
   * Holds if this type is constant and only contains constant types, excluding
   * the type itself. It is implied by Type.isDeeplyConst() and is just used to
   * implement that predicate.
   * For example, `const char *const` is deeply constant and deeply constant below,
   * but `const char *` is only deeply constant below (the pointer can be changed,
   * but not the underlying char). `char *const` is neither (it is just `const`).
   */
  predicate isDeeplyConstBelow() { none() } // Concrete base impl to allow filters on Type

  /**
   * Gets as many places as possible where this type is used by name in the source after macros have been replaced
   * (in particular, therefore, this will find type name uses caused by macros). Note that all type name uses within
   * instantiations are currently excluded - this is too draconian in the absence of indexing prototype instantiations
   * of functions, and is likely to improve in the future. At present, the method takes the conservative approach of
   * giving valid type name uses, but not necessarily *all* type name uses.
   */
  Element getATypeNameUse() {
    // An explicit cast to a type referring to T uses T. We exclude casts within instantiations,
    // since they do not appear directly in the source.
    exists(Cast c |
      not c.isImplicit() and
      c.getType().refersTo(this) and
      result = c and
      not c.getEnclosingFunction().isConstructedFrom(_)
    )
    or
    // A class derivation from a type referring to T uses T. We exclude class derivations within
    // instantiations, since they do not appear directly in the source.
    exists(ClassDerivation cd |
      cd.getBaseType().refersTo(this) and
      result = cd and
      not cd.getDerivedClass() instanceof ClassTemplateInstantiation
    )
    or
    // A new, new array, or placement new expression with a type that refers to T uses T.
    // We exclude news within instantiations, since they do not appear directly in the source.
    exists(Expr e |
      (
        e instanceof NewArrayExpr or
        e instanceof NewExpr
      ) and
      e.getType().refersTo(this) and
      result = e and
      not e.getEnclosingFunction().isConstructedFrom(_)
    )
    or
    // The declaration of a function that returns a type referring to T uses T. We exclude
    // declarations of function template instantiations, since their return types do not
    // appear directly in the source. We also exclude constructors and destructors, since
    // they are indexed with a dummy return type of void that does not appear in the source.
    exists(FunctionDeclarationEntry fde, Type t |
      (if exists(fde.getTypedefType()) then t = fde.getTypedefType() else t = fde.getType()) and
      t.refersTo(this) and
      result = fde and
      not fde.getDeclaration().isConstructedFrom(_) and
      not fde.getDeclaration() instanceof Constructor and
      not fde.getDeclaration() instanceof Destructor
    )
    or
    // A function call that provides an explicit template argument that refers to T uses T.
    // We exclude calls within instantiations, since they do not appear directly in the source.
    exists(FunctionCall c |
      c.getAnExplicitTemplateArgument().(Type).refersTo(this) and
      result = c and
      not c.getEnclosingFunction().isConstructedFrom(_)
    )
    or
    // Qualifying an expression with a type that refers to T uses T. We exclude qualifiers
    // within instantiations, since they do not appear directly in the source.
    exists(NameQualifier nq |
      nq.getQualifyingElement().(Type).refersTo(this) and
      result = nq and
      not nq.getExpr().getEnclosingFunction().isConstructedFrom(_)
    )
    or
    // Calculating the size of a type that refers to T uses T. We exclude sizeofs within
    // instantiations, since they do not appear directly in the source.
    exists(SizeofTypeOperator soto |
      soto.getTypeOperand().refersTo(this) and
      result = soto and
      not soto.getEnclosingFunction().isConstructedFrom(_)
    )
    or
    // A typedef of a type that refers to T uses T.
    exists(TypeDeclarationEntry tde |
      tde.getDeclaration().(TypedefType).getBaseType().refersTo(this) and
      result = tde
    )
    or
    // Using something declared within a type that refers to T uses T.
    exists(UsingDeclarationEntry ude |
      ude.getDeclaration().getDeclaringType().refersTo(this) and
      result = ude
    )
    or
    // The declaration of a variable with a type that refers to T uses T. We exclude declarations within
    // instantiations, since those do not appear directly in the source.
    exists(VariableDeclarationEntry vde |
      vde.getType().refersTo(this) and
      result = vde and
      not exists(LocalScopeVariable sv |
        sv = vde.getDeclaration() and sv.getFunction().isConstructedFrom(_)
      ) and
      not exists(MemberVariable mv |
        mv = vde.getDeclaration() and mv.getDeclaringType() instanceof ClassTemplateInstantiation
      )
    )
  }

  /**
   * Holds if this type involves a reference.
   */
  predicate involvesReference() { none() }

  /**
   * Holds if this type involves a template parameter.
   */
  predicate involvesTemplateParameter() { none() }

  /**
   * Gets this type with any typedefs resolved. For example, given
   * `typedef C T`, this would resolve `const T&amp;` to `const C&amp;`.
   * Note that this will only work if the resolved type actually appears
   * on its own elsewhere in the program.
   */
  Type resolveTypedefs() { result = this }

  /**
   * Gets the type stripped of pointers, references and cv-qualifiers, and resolving typedefs.
   * For example, given `typedef const C&amp; T`, `stripType` returns `C`.
   */
  Type stripType() { result = this }

  override Location getLocation() {
    suppressUnusedThis(this) and
    result instanceof UnknownDefaultLocation
  }
}

/**
 * A C/C++ built-in primitive type (int, float, void, and so on). See 4.1.1.
 * In the following example, `unsigned int` and `double` denote primitive
 * built-in types:
 * ```
 * double a;
 * unsigned int ua[40];
 * typedef double LargeFloat;
 * ```
 */
class BuiltInType extends Type, @builtintype {
  override string toString() { result = this.getName() }

  override string getName() { builtintypes(underlyingElement(this), result, _, _, _, _) }

  override string explain() { result = this.getName() }

  override predicate isDeeplyConstBelow() { any() } // No subparts
}

/**
 * An erroneous type.  This type has no corresponding C/C++ syntax.
 *
 * `ErroneousType` is the type of `ErrorExpr`, which in turn refers to an illegal
 * language construct.  In the example below, a temporary (`0`) cannot be bound
 * to an lvalue reference (`int &`):
 * ```
 * int &intref = 0;
 * ```
 */
class ErroneousType extends BuiltInType {
  ErroneousType() { builtintypes(underlyingElement(this), _, 1, _, _, _) }

  override string getAPrimaryQlClass() { result = "ErroneousType" }
}

/**
 * The unknown type.  This type has no corresponding C/C++ syntax.
 *
 * Unknown types usually occur inside _uninstantiated_ template functions.
 * In the example below, the expressions `x.a` and `x.b` have unknown type
 * in the _uninstantiated_ template.
 * ```
 * template<typename T>
 * bool check(T x) {
 *   if (x.a == x.b)
 *     abort();
 * }
 * ```
 */
class UnknownType extends BuiltInType {
  UnknownType() { builtintypes(underlyingElement(this), _, 2, _, _, _) }

  override string getAPrimaryQlClass() { result = "UnknownType" }
}

private predicate isArithmeticType(@builtintype type, int kind) {
  builtintypes(type, _, kind, _, _, _) and
  kind >= 4 and
  kind != 34 // Exclude decltype(nullptr)
}

/**
 * The C/C++ arithmetic types. See 4.1.1.
 *
 * This includes primitive types on which arithmetic, bitwise or logical
 * operations may be performed.  Examples of arithmetic types include
 * `char`, `int`, `float`, and `bool`.
 */
class ArithmeticType extends BuiltInType {
  ArithmeticType() { isArithmeticType(underlyingElement(this), _) }

  override string getAPrimaryQlClass() { result = "ArithmeticType" }
}

private predicate isIntegralType(@builtintype type, int kind) {
  isArithmeticType(type, kind) and
  (
    kind < 24
    or
    kind = 33
    or
    35 <= kind and kind <= 37
    or
    kind = 43
    or
    kind = 44
    or
    kind = 51
  )
}

/**
 * A C/C++ integral or `enum` type.
 *
 * The definition of "integral type" in the C++ standard excludes `enum` types,
 * but because an `enum` type holds a value of its underlying integral type,
 * it is often useful to have a common category that includes both integral
 * and `enum` types.
 *
 * In the following example, `a`, `b` and `c` are all declared with an
 * integral or `enum` type:
 * ```
 * unsigned long a;
 * enum e1 { val1, val2 } b;
 * enum class e2: short { val3, val4 } c;
 * ```
 */
class IntegralOrEnumType extends Type {
  IntegralOrEnumType() {
    // Integral type
    isIntegralType(underlyingElement(this), _)
    or
    // Enum type
    (
      usertypes(underlyingElement(this), _, 4) or
      usertypes(underlyingElement(this), _, 13)
    )
  }
}

/**
 * Maps between different integral types of the same size.
 *
 * original: The original type. Can be any integral type kind.
 * canonical: The canonical form of the type
 *   - plain T -> T
 *   - signed T -> T (except signed char -> signed char)
 *   - unsigned T -> unsigned T
 * unsigned: The explicitly unsigned form of the type.
 * signed: The explicitly signed form of the type.
 */
private predicate integralTypeMapping(int original, int canonical, int unsigned, int signed) {
  original = 4 and canonical = 4 and unsigned = -1 and signed = -1 // bool
  or
  original = 5 and canonical = 5 and unsigned = 6 and signed = 7 // char
  or
  original = 6 and canonical = 6 and unsigned = 6 and signed = 7 // unsigned char
  or
  original = 7 and canonical = 7 and unsigned = 6 and signed = 7 // signed char
  or
  original = 8 and canonical = 8 and unsigned = 9 and signed = 10 // short
  or
  original = 9 and canonical = 9 and unsigned = 9 and signed = 10 // unsigned short
  or
  original = 10 and canonical = 8 and unsigned = 9 and signed = 10 // signed short
  or
  original = 11 and canonical = 11 and unsigned = 12 and signed = 13 // int
  or
  original = 12 and canonical = 12 and unsigned = 12 and signed = 13 // unsigned int
  or
  original = 13 and canonical = 11 and unsigned = 12 and signed = 13 // signed int
  or
  original = 14 and canonical = 14 and unsigned = 15 and signed = 16 // long
  or
  original = 15 and canonical = 15 and unsigned = 15 and signed = 16 // unsigned long
  or
  original = 16 and canonical = 14 and unsigned = 15 and signed = 16 // signed long
  or
  original = 17 and canonical = 17 and unsigned = 18 and signed = 19 // long long
  or
  original = 18 and canonical = 18 and unsigned = 18 and signed = 19 // unsigned long long
  or
  original = 19 and canonical = 17 and unsigned = 18 and signed = 19 // signed long long
  or
  original = 33 and canonical = 33 and unsigned = -1 and signed = -1 // wchar_t
  or
  original = 35 and canonical = 35 and unsigned = 36 and signed = 37 // __int128
  or
  original = 36 and canonical = 36 and unsigned = 36 and signed = 37 // unsigned __int128
  or
  original = 37 and canonical = 35 and unsigned = 36 and signed = 37 // signed __int128
  or
  original = 43 and canonical = 43 and unsigned = -1 and signed = -1 // char16_t
  or
  original = 44 and canonical = 44 and unsigned = -1 and signed = -1 // char32_t
  or
  original = 51 and canonical = 51 and unsigned = -1 and signed = -1 // char8_t
}

/**
 * The C/C++ integral types. See 4.1.1.  These are types that are represented
 * as integers of varying sizes.  Both `enum` types and floating-point types
 * are excluded.
 *
 * In the following examples, `a`, `b` and `c` are declared using integral
 * types:
 * ```
 * unsigned int a;
 * long long b;
 * char c;
 * ```
 */
class IntegralType extends ArithmeticType, IntegralOrEnumType {
  int kind;

  IntegralType() { isIntegralType(underlyingElement(this), kind) }

  /** Holds if this integral type is signed. */
  predicate isSigned() { builtintypes(underlyingElement(this), _, _, _, -1, _) }

  /** Holds if this integral type is unsigned. */
  predicate isUnsigned() { builtintypes(underlyingElement(this), _, _, _, 1, _) }

  /** Holds if this integral type is explicitly signed. */
  predicate isExplicitlySigned() {
    builtintypes(underlyingElement(this), _, 7, _, _, _) or
    builtintypes(underlyingElement(this), _, 10, _, _, _) or
    builtintypes(underlyingElement(this), _, 13, _, _, _) or
    builtintypes(underlyingElement(this), _, 16, _, _, _) or
    builtintypes(underlyingElement(this), _, 19, _, _, _) or
    builtintypes(underlyingElement(this), _, 37, _, _, _)
  }

  /** Holds if this integral type is explicitly unsigned. */
  predicate isExplicitlyUnsigned() {
    builtintypes(underlyingElement(this), _, 6, _, _, _) or
    builtintypes(underlyingElement(this), _, 9, _, _, _) or
    builtintypes(underlyingElement(this), _, 12, _, _, _) or
    builtintypes(underlyingElement(this), _, 15, _, _, _) or
    builtintypes(underlyingElement(this), _, 18, _, _, _) or
    builtintypes(underlyingElement(this), _, 36, _, _, _)
  }

  /** Holds if this integral type is implicitly signed. */
  predicate isImplicitlySigned() {
    builtintypes(underlyingElement(this), _, 5, _, -1, _) or
    builtintypes(underlyingElement(this), _, 8, _, -1, _) or
    builtintypes(underlyingElement(this), _, 11, _, -1, _) or
    builtintypes(underlyingElement(this), _, 14, _, -1, _) or
    builtintypes(underlyingElement(this), _, 17, _, -1, _) or
    builtintypes(underlyingElement(this), _, 35, _, -1, _)
  }

  /**
   * Gets the unsigned type corresponding to this integral type.  For
   * example on a `short`, this would give the type `unsigned short`.
   */
  IntegralType getUnsigned() {
    exists(int unsignedKind |
      integralTypeMapping(kind, _, unsignedKind, _) and
      builtintypes(unresolveElement(result), _, unsignedKind, _, _, _)
    )
  }

  /**
   * Gets the canonical type corresponding to this integral type.
   *
   * For a plain type, this gives the same type (e.g. `short` -> `short`).
   * For an explicitly unsigned type, this gives the same type (e.g. `unsigned short` -> `unsigned short`).
   * For an explicitly signed type, this gives the plain version of that type (e.g. `signed short` -> `short`), except
   * that `signed char` -> `signed char`.
   */
  IntegralType getCanonicalArithmeticType() {
    exists(int canonicalKind |
      integralTypeMapping(kind, canonicalKind, _, _) and
      builtintypes(unresolveElement(result), _, canonicalKind, _, _, _)
    )
  }
}

/**
 * The C/C++ boolean type. See 4.2.  This is the C `_Bool` type
 * or the C++ `bool` type.  For example:
 * ```
 * extern bool a, b;   // C++
 * _Bool c, d;         // C
 * ```
 */
class BoolType extends IntegralType {
  BoolType() { builtintypes(underlyingElement(this), _, 4, _, _, _) }

  override string getAPrimaryQlClass() { result = "BoolType" }
}

/**
 * The C/C++ character types. See 4.3.  This includes the `char`,
 * `signed char` and `unsigned char` types, all of which are
 * distinct from one another.  For example:
 * ```
 * char a, b;
 * signed char c, d;
 * unsigned char e, f;
 * ```
 */
abstract class CharType extends IntegralType { }

/**
 * The C/C++ `char` type (which is distinct from `signed char` and
 * `unsigned char`).  For example:
 * ```
 * char a, b;
 * ```
 */
class PlainCharType extends CharType {
  PlainCharType() { builtintypes(underlyingElement(this), _, 5, _, _, _) }

  override string getAPrimaryQlClass() { result = "PlainCharType" }
}

/**
 * The C/C++ `unsigned char` type (which is distinct from plain `char`
 * even when `char` is `unsigned` by default).
 * ```
 * unsigned char e, f;
 * ```
 */
class UnsignedCharType extends CharType {
  UnsignedCharType() { builtintypes(underlyingElement(this), _, 6, _, _, _) }

  override string getAPrimaryQlClass() { result = "UnsignedCharType" }
}

/**
 * The C/C++ `signed char` type (which is distinct from plain `char`
 * even when `char` is `signed` by default).
 * ```
 * signed char c, d;
 * ```
 */
class SignedCharType extends CharType {
  SignedCharType() { builtintypes(underlyingElement(this), _, 7, _, _, _) }

  override string getAPrimaryQlClass() { result = "SignedCharType" }
}

/**
 * The C/C++ short types. See 4.3.  This includes `short`, `signed short`
 * and `unsigned short`.
 * ```
 * signed short ss;
 * ```
 */
class ShortType extends IntegralType {
  ShortType() {
    builtintypes(underlyingElement(this), _, 8, _, _, _) or
    builtintypes(underlyingElement(this), _, 9, _, _, _) or
    builtintypes(underlyingElement(this), _, 10, _, _, _)
  }

  override string getAPrimaryQlClass() { result = "ShortType" }
}

/**
 * The C/C++ integer types. See 4.4.  This includes `int`, `signed int`
 * and `unsigned int`.
 * ```
 * unsigned int ui;
 * ```
 */
class IntType extends IntegralType {
  IntType() {
    builtintypes(underlyingElement(this), _, 11, _, _, _) or
    builtintypes(underlyingElement(this), _, 12, _, _, _) or
    builtintypes(underlyingElement(this), _, 13, _, _, _)
  }

  override string getAPrimaryQlClass() { result = "IntType" }
}

/**
 * The C/C++ long types. See 4.4.  This includes `long`, `signed long`
 * and `unsigned long`.
 * ```
 * long l;
 * ```
 */
class LongType extends IntegralType {
  LongType() {
    builtintypes(underlyingElement(this), _, 14, _, _, _) or
    builtintypes(underlyingElement(this), _, 15, _, _, _) or
    builtintypes(underlyingElement(this), _, 16, _, _, _)
  }

  override string getAPrimaryQlClass() { result = "LongType" }
}

/**
 * The C/C++ long long types. See 4.4.  This includes `long long`, `signed long long`
 * and `unsigned long long`.
 * ```
 * signed long long sll;
 * ```
 */
class LongLongType extends IntegralType {
  LongLongType() {
    builtintypes(underlyingElement(this), _, 17, _, _, _) or
    builtintypes(underlyingElement(this), _, 18, _, _, _) or
    builtintypes(underlyingElement(this), _, 19, _, _, _)
  }

  override string getAPrimaryQlClass() { result = "LongLongType" }
}

/**
 * The GNU C __int128 primitive types.  They are not part of standard C/C++.
 *
 * This includes `__int128`, `signed __int128` and `unsigned __int128`.
 * ```
 * unsigned __int128 ui128;
 * ```
 */
class Int128Type extends IntegralType {
  Int128Type() {
    builtintypes(underlyingElement(this), _, 35, _, _, _) or
    builtintypes(underlyingElement(this), _, 36, _, _, _) or
    builtintypes(underlyingElement(this), _, 37, _, _, _)
  }

  override string getAPrimaryQlClass() { result = "Int128Type" }
}

private newtype TTypeDomain =
  TRealDomain() or
  TComplexDomain() or
  TImaginaryDomain()

/**
 * The type domain of a floating-point type. One of `RealDomain`, `ComplexDomain`, or
 * `ImaginaryDomain`.
 */
class TypeDomain extends TTypeDomain {
  /** Gets a textual representation of this type domain. */
  string toString() { none() }
}

/**
 * The type domain of a floating-point type that represents a real number.
 */
class RealDomain extends TypeDomain, TRealDomain {
  final override string toString() { result = "real" }
}

/**
 * The type domain of a floating-point type that represents a complex number.
 */
class ComplexDomain extends TypeDomain, TComplexDomain {
  final override string toString() { result = "complex" }
}

/**
 * The type domain of a floating-point type that represents an imaginary number.
 */
class ImaginaryDomain extends TypeDomain, TImaginaryDomain {
  final override string toString() { result = "imaginary" }
}

/**
 * Data for floating-point types.
 *
 * kind: The original type kind. Can be any floating-point type kind.
 * base: The numeric base of the number's representation. Can be 2 (binary) or 10 (decimal).
 * domain: The type domain of the type. Can be `RealDomain`, `ComplexDomain`, or `ImaginaryDomain`.
 * realKind: The type kind of the corresponding real type. For example, the corresponding real type
 *   of `_Complex double` is `double`.
 * extended: `true` if the number is an extended-precision floating-point number, such as
 *   `_Float32x`.
 */
private predicate floatingPointTypeMapping(
  int kind, int base, TTypeDomain domain, int realKind, boolean extended
) {
  // float
  kind = 24 and base = 2 and domain = TRealDomain() and realKind = 24 and extended = false
  or
  // double
  kind = 25 and base = 2 and domain = TRealDomain() and realKind = 25 and extended = false
  or
  // long double
  kind = 26 and base = 2 and domain = TRealDomain() and realKind = 26 and extended = false
  or
  // _Complex float
  kind = 27 and base = 2 and domain = TComplexDomain() and realKind = 24 and extended = false
  or
  // _Complex double
  kind = 28 and base = 2 and domain = TComplexDomain() and realKind = 25 and extended = false
  or
  // _Complex long double
  kind = 29 and base = 2 and domain = TComplexDomain() and realKind = 26 and extended = false
  or
  // _Imaginary float
  kind = 30 and base = 2 and domain = TImaginaryDomain() and realKind = 24 and extended = false
  or
  // _Imaginary double
  kind = 31 and base = 2 and domain = TImaginaryDomain() and realKind = 25 and extended = false
  or
  // _Imaginary long double
  kind = 32 and base = 2 and domain = TImaginaryDomain() and realKind = 26 and extended = false
  or
  // __float128
  kind = 38 and base = 2 and domain = TRealDomain() and realKind = 38 and extended = false
  or
  // _Complex __float128
  kind = 39 and base = 2 and domain = TComplexDomain() and realKind = 38 and extended = false
  or
  // _Decimal32
  kind = 40 and base = 10 and domain = TRealDomain() and realKind = 40 and extended = false
  or
  // _Decimal64
  kind = 41 and base = 10 and domain = TRealDomain() and realKind = 41 and extended = false
  or
  // _Decimal128
  kind = 42 and base = 10 and domain = TRealDomain() and realKind = 42 and extended = false
  or
  // _Float32
  kind = 45 and base = 2 and domain = TRealDomain() and realKind = 45 and extended = false
  or
  // _Float32x
  kind = 46 and base = 2 and domain = TRealDomain() and realKind = 46 and extended = true
  or
  // _Float64
  kind = 47 and base = 2 and domain = TRealDomain() and realKind = 47 and extended = false
  or
  // _Float64x
  kind = 48 and base = 2 and domain = TRealDomain() and realKind = 48 and extended = true
  or
  // _Float128
  kind = 49 and base = 2 and domain = TRealDomain() and realKind = 49 and extended = false
  or
  // _Float128x
  kind = 50 and base = 2 and domain = TRealDomain() and realKind = 50 and extended = true
}

/**
 * The C/C++ floating point types. See 4.5.  This includes `float`, `double` and `long double`, the
 * fixed-size floating-point types like `_Float32`, the extended-precision floating-point types like
 * `_Float64x`, and the decimal floating-point types like `_Decimal32`. It also includes the complex
 * and imaginary versions of all of these types.
 */
class FloatingPointType extends ArithmeticType {
  final int base;
  final TypeDomain domain;
  final int realKind;
  final boolean extended;

  FloatingPointType() {
    exists(int kind |
      builtintypes(underlyingElement(this), _, kind, _, _, _) and
      floatingPointTypeMapping(kind, base, domain, realKind, extended)
    )
  }

  /** Gets the numeric base of this type's representation: 2 (binary) or 10 (decimal). */
  final int getBase() { result = base }

  /**
   * Gets the type domain of this type. Can be `RealDomain`, `ComplexDomain`, or `ImaginaryDomain`.
   */
  final TypeDomain getDomain() { result = domain }

  /**
   * Gets the corresponding real type of this type. For example, the corresponding real type of
   * `_Complex double` is `double`.
   */
  final RealNumberType getRealType() {
    builtintypes(unresolveElement(result), _, realKind, _, _, _)
  }

  /** Holds if this type is an extended precision floating-point type, such as `_Float32x`. */
  final predicate isExtendedPrecision() { extended = true }
}

/**
 * A floating-point type representing a real number.
 */
class RealNumberType extends FloatingPointType {
  RealNumberType() { domain instanceof RealDomain }
}

/**
 * A floating-point type representing a complex number.
 */
class ComplexNumberType extends FloatingPointType {
  ComplexNumberType() { domain instanceof ComplexDomain }
}

/**
 * A floating-point type representing an imaginary number.
 */
class ImaginaryNumberType extends FloatingPointType {
  ImaginaryNumberType() { domain instanceof ImaginaryDomain }
}

/**
 * A floating-point type whose representation is base 2.
 */
class BinaryFloatingPointType extends FloatingPointType {
  BinaryFloatingPointType() { base = 2 }
}

/**
 * A floating-point type whose representation is base 10.
 */
class DecimalFloatingPointType extends FloatingPointType {
  DecimalFloatingPointType() { base = 10 }
}

/**
 * The C/C++ `float` type.
 * ```
 * float f;
 * ```
 */
class FloatType extends RealNumberType, BinaryFloatingPointType {
  FloatType() { builtintypes(underlyingElement(this), _, 24, _, _, _) }

  override string getAPrimaryQlClass() { result = "FloatType" }
}

/**
 * The C/C++ `double` type.
 * ```
 * double d;
 * ```
 */
class DoubleType extends RealNumberType, BinaryFloatingPointType {
  DoubleType() { builtintypes(underlyingElement(this), _, 25, _, _, _) }

  override string getAPrimaryQlClass() { result = "DoubleType" }
}

/**
 * The C/C++ `long double` type.
 * ```
 * long double ld;
 * ```
 */
class LongDoubleType extends RealNumberType, BinaryFloatingPointType {
  LongDoubleType() { builtintypes(underlyingElement(this), _, 26, _, _, _) }

  override string getAPrimaryQlClass() { result = "LongDoubleType" }
}

/**
 * The GNU C `__float128` primitive type.  This is not standard C/C++.
 * ```
 * __float128 f128;
 * ```
 */
class Float128Type extends RealNumberType, BinaryFloatingPointType {
  Float128Type() { builtintypes(underlyingElement(this), _, 38, _, _, _) }

  override string getAPrimaryQlClass() { result = "Float128Type" }
}

/**
 * The GNU C `_Decimal32` primitive type.  This is not standard C/C++.
 * ```
 * _Decimal32 d32;
 * ```
 */
class Decimal32Type extends RealNumberType, DecimalFloatingPointType {
  Decimal32Type() { builtintypes(underlyingElement(this), _, 40, _, _, _) }

  override string getAPrimaryQlClass() { result = "Decimal32Type" }
}

/**
 * The GNU C `_Decimal64` primitive type.  This is not standard C/C++.
 * ```
 * _Decimal64 d64;
 * ```
 */
class Decimal64Type extends RealNumberType, DecimalFloatingPointType {
  Decimal64Type() { builtintypes(underlyingElement(this), _, 41, _, _, _) }

  override string getAPrimaryQlClass() { result = "Decimal64Type" }
}

/**
 * The GNU C `_Decimal128` primitive type.  This is not standard C/C++.
 * ```
 * _Decimal128 d128;
 * ```
 */
class Decimal128Type extends RealNumberType, DecimalFloatingPointType {
  Decimal128Type() { builtintypes(underlyingElement(this), _, 42, _, _, _) }

  override string getAPrimaryQlClass() { result = "Decimal128Type" }
}

/**
 * The C/C++ `void` type. See 4.7.
 * ```
 * void foo();
 * ```
 */
class VoidType extends BuiltInType {
  VoidType() { builtintypes(underlyingElement(this), _, 3, _, _, _) }

  override string getAPrimaryQlClass() { result = "VoidType" }
}

/**
 * The C/C++ wide character type.
 *
 * Note that on some platforms `wchar_t` doesn't exist as a built-in
 * type but a typedef is provided.  Consider using the `Wchar_t` QL
 * class to include these types.
 * ```
 * wchar_t wc;
 * ```
 */
class WideCharType extends IntegralType {
  WideCharType() { builtintypes(underlyingElement(this), _, 33, _, _, _) }

  override string getAPrimaryQlClass() { result = "WideCharType" }
}

/**
 * The C/C++ `char8_t` type.  This is available starting with C++20.
 * ```
 * char8_t c8;
 * ```
 */
class Char8Type extends IntegralType {
  Char8Type() { builtintypes(underlyingElement(this), _, 51, _, _, _) }

  override string getAPrimaryQlClass() { result = "Char8Type" }
}

/**
 * The C/C++ `char16_t` type.  This is available starting with C11 and C++11.
 * ```
 * char16_t c16;
 * ```
 */
class Char16Type extends IntegralType {
  Char16Type() { builtintypes(underlyingElement(this), _, 43, _, _, _) }

  override string getAPrimaryQlClass() { result = "Char16Type" }
}

/**
 * The C/C++ `char32_t` type.  This is available starting with C11 and C++11.
 * ```
 * char32_t c32;
 * ```
 */
class Char32Type extends IntegralType {
  Char32Type() { builtintypes(underlyingElement(this), _, 44, _, _, _) }

  override string getAPrimaryQlClass() { result = "Char32Type" }
}

/**
 * The (primitive) type of the C++11 `nullptr` constant.  It is a
 * distinct type, denoted by `decltype(nullptr)`, that is not itself a pointer
 * type or a pointer to member type.  The `<cstddef>` header usually defines
 * the `std::nullptr_t` type as follows:
 * ```
 * typedef decltype(nullptr) nullptr_t;
 * ```
 */
class NullPointerType extends BuiltInType {
  NullPointerType() { builtintypes(underlyingElement(this), _, 34, _, _, _) }

  override string getAPrimaryQlClass() { result = "NullPointerType" }
}

/**
 * A C/C++ derived type.
 *
 * These are pointer and reference types, array and GNU vector types, and `const` and `volatile` types.
 * In all cases, the type is formed from a single base type.  For example:
 * ```
 * int *pi;
 * int &ri = *pi;
 * const float fa[40];
 * ```
 */
class DerivedType extends Type, @derivedtype {
  override string toString() { result = this.getName() }

  override string getName() { derivedtypes(underlyingElement(this), result, _, _) }

  /**
   * Gets the base type of this derived type.
   *
   * This predicate strips off one level of decoration from a type. For example, it returns `char*` for the PointerType `char**`,
   * `const int` for the ReferenceType `const int&amp;`, and `long` for the SpecifiedType `volatile long`.
   */
  Type getBaseType() { derivedtypes(underlyingElement(this), _, _, unresolveElement(result)) }

  override predicate refersToDirectly(Type t) { t = this.getBaseType() }

  override predicate involvesReference() { getBaseType().involvesReference() }

  override predicate involvesTemplateParameter() { getBaseType().involvesTemplateParameter() }

  override Type stripType() { result = getBaseType().stripType() }

  /**
   * Holds if this type has the `__autoreleasing` specifier or if it points to
   * a type with the `__autoreleasing` specifier.
   *
   * DEPRECATED: use `hasSpecifier` directly instead.
   */
  deprecated predicate isAutoReleasing() {
    this.hasSpecifier("__autoreleasing") or
    this.(PointerType).getBaseType().hasSpecifier("__autoreleasing")
  }

  /**
   * Holds if this type has the `__strong` specifier or if it points to
   * a type with the `__strong` specifier.
   *
   * DEPRECATED: use `hasSpecifier` directly instead.
   */
  deprecated predicate isStrong() {
    this.hasSpecifier("__strong") or
    this.(PointerType).getBaseType().hasSpecifier("__strong")
  }

  /**
   * Holds if this type has the `__unsafe_unretained` specifier or if it points
   * to a type with the `__unsafe_unretained` specifier.
   *
   * DEPRECATED: use `hasSpecifier` directly instead.
   */
  deprecated predicate isUnsafeRetained() {
    this.hasSpecifier("__unsafe_unretained") or
    this.(PointerType).getBaseType().hasSpecifier("__unsafe_unretained")
  }

  /**
   * Holds if this type has the `__weak` specifier or if it points to
   * a type with the `__weak` specifier.
   *
   * DEPRECATED: use `hasSpecifier` directly instead.
   */
  deprecated predicate isWeak() {
    this.hasSpecifier("__weak") or
    this.(PointerType).getBaseType().hasSpecifier("__weak")
  }
}

/**
 * An instance of the C++11 `decltype` operator.  For example:
 * ```
 * int a;
 * decltype(a) b;
 * ```
 */
class Decltype extends Type, @decltype {
  override string getAPrimaryQlClass() { result = "Decltype" }

  /**
   * The expression whose type is being obtained by this decltype.
   */
  Expr getExpr() { decltypes(underlyingElement(this), unresolveElement(result), _, _) }

  /**
   * The type immediately yielded by this decltype.
   */
  Type getBaseType() { decltypes(underlyingElement(this), _, unresolveElement(result), _) }

  /**
   * Whether an extra pair of parentheses around the expression would change the semantics of this decltype.
   *
   * The following example shows the effect of an extra pair of parentheses:
   * ```
   * struct A { double x; };
   * const A* a = new A();
   * decltype( a->x ); // type is double
   * decltype((a->x)); // type is const double&
   * ```
   * Please consult the C++11 standard for more details.
   */
  predicate parenthesesWouldChangeMeaning() { decltypes(underlyingElement(this), _, _, true) }

  override Type getUnderlyingType() { result = getBaseType().getUnderlyingType() }

  override Type stripTopLevelSpecifiers() { result = getBaseType().stripTopLevelSpecifiers() }

  override Type stripType() { result = getBaseType().stripType() }

  override Type resolveTypedefs() { result = getBaseType().resolveTypedefs() }

  override Location getLocation() { result = getExpr().getLocation() }

  override string toString() { result = "decltype(...)" }

  override string getName() { none() }

  override int getSize() { result = getBaseType().getSize() }

  override int getAlignment() { result = getBaseType().getAlignment() }

  override int getPointerIndirectionLevel() { result = getBaseType().getPointerIndirectionLevel() }

  override string explain() {
    result = "decltype resulting in {" + this.getBaseType().explain() + "}"
  }

  override predicate involvesReference() { getBaseType().involvesReference() }

  override predicate involvesTemplateParameter() { getBaseType().involvesTemplateParameter() }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConstBelow() }

  override Specifier internal_getAnAdditionalSpecifier() {
    result = this.getBaseType().getASpecifier()
  }
}

/**
 * A C/C++ pointer type. See 4.9.1.
 * ```
 * void *ptr;
 * void **ptr2 = &ptr;
 * ```
 */
class PointerType extends DerivedType {
  PointerType() { derivedtypes(underlyingElement(this), _, 1, _) }

  override string getAPrimaryQlClass() { result = "PointerType" }

  override int getPointerIndirectionLevel() {
    result = 1 + this.getBaseType().getPointerIndirectionLevel()
  }

  override string explain() { result = "pointer to {" + this.getBaseType().explain() + "}" }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }

  override Type resolveTypedefs() {
    result.(PointerType).getBaseType() = getBaseType().resolveTypedefs()
  }
}

/**
 * A C++ reference type. See 4.9.1.
 *
 * For C++11 code bases, this includes both _lvalue_ references (`&`) and _rvalue_ references (`&&`).
 * To distinguish between them, use the LValueReferenceType and RValueReferenceType QL classes.
 */
class ReferenceType extends DerivedType {
  ReferenceType() {
    derivedtypes(underlyingElement(this), _, 2, _) or derivedtypes(underlyingElement(this), _, 8, _)
  }

  override string getAPrimaryQlClass() { result = "ReferenceType" }

  override int getPointerIndirectionLevel() { result = getBaseType().getPointerIndirectionLevel() }

  override string explain() { result = "reference to {" + this.getBaseType().explain() + "}" }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() } // No such thing as a const reference type

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }

  override predicate involvesReference() { any() }

  override Type resolveTypedefs() {
    result.(ReferenceType).getBaseType() = getBaseType().resolveTypedefs()
  }
}

/**
 * A C++11 lvalue reference type (e.g. `int &`).
 * ```
 * int a;
 * int& b = a;
 * ```
 */
class LValueReferenceType extends ReferenceType {
  LValueReferenceType() { derivedtypes(underlyingElement(this), _, 2, _) }

  override string getAPrimaryQlClass() { result = "LValueReferenceType" }
}

/**
 * A C++11 rvalue reference type (e.g., `int &&`).  It is used to
 * implement "move" semantics for object construction and assignment.
 * ```
 * class C {
 *   E e;
 *   C(C&& from): e(std::move(from.e)) { }
 * };
 * ```
 */
class RValueReferenceType extends ReferenceType {
  RValueReferenceType() { derivedtypes(underlyingElement(this), _, 8, _) }

  override string getAPrimaryQlClass() { result = "RValueReferenceType" }

  override string explain() { result = "rvalue " + super.explain() }
}

/**
 * A type with specifiers.
 * ```
 * const int a;
 * volatile char v;
 * ```
 */
class SpecifiedType extends DerivedType {
  SpecifiedType() { derivedtypes(underlyingElement(this), _, 3, _) }

  override string getAPrimaryQlClass() { result = "SpecifiedType" }

  override int getSize() { result = this.getBaseType().getSize() }

  override int getAlignment() { result = this.getBaseType().getAlignment() }

  override int getPointerIndirectionLevel() {
    result = this.getBaseType().getPointerIndirectionLevel()
  }

  /**
   * INTERNAL: Do not use.
   *
   * Gets all the specifiers of this type as a string in a fixed order (the order
   * only depends on the specifiers, not on the source program). This is intended
   * for debugging queries only and is an expensive operation.
   */
  string getSpecifierString() { result = concat(this.getASpecifier().getName(), " ") }

  override string explain() {
    result = this.getSpecifierString() + " {" + this.getBaseType().explain() + "}"
  }

  override predicate isDeeplyConst() {
    this.getASpecifier().getName() = "const" and this.getBaseType().isDeeplyConstBelow()
  }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConstBelow() }

  override Specifier internal_getAnAdditionalSpecifier() {
    result = this.getBaseType().getASpecifier()
  }

  override Type resolveTypedefs() {
    result.(SpecifiedType).getBaseType() = getBaseType().resolveTypedefs() and
    result.getASpecifier() = getASpecifier()
  }

  override Type stripTopLevelSpecifiers() { result = getBaseType().stripTopLevelSpecifiers() }
}

/**
 * A C/C++ array type. See 4.9.1.
 * ```
 * char table[32];
 * ```
 */
class ArrayType extends DerivedType {
  ArrayType() { derivedtypes(underlyingElement(this), _, 4, _) }

  override string getAPrimaryQlClass() { result = "ArrayType" }

  /**
   * Holds if this array is declared to be of a constant size. See
   * `getArraySize` and `getByteSize` to get the size of the array.
   */
  predicate hasArraySize() { arraysizes(underlyingElement(this), _, _, _) }

  /**
   * Gets the number of elements in this array. Only has a result for arrays declared to be of a
   * constant size. See `getByteSize` for getting the number of bytes.
   */
  int getArraySize() { arraysizes(underlyingElement(this), result, _, _) }

  /**
   * Gets the byte size of this array. Only has a result for arrays declared to be of a constant
   * size. See `getArraySize` for getting the number of elements.
   */
  int getByteSize() { arraysizes(underlyingElement(this), _, result, _) }

  override int getAlignment() { arraysizes(underlyingElement(this), _, _, result) }

  /**
   * Gets the byte size of this array. Only has a result for arrays declared to be of a constant
   * size. This predicate is a synonym for `getByteSize`. See `getArraySize` for getting the number
   * of elements.
   */
  override int getSize() { result = this.getByteSize() }

  override string explain() {
    if exists(this.getArraySize())
    then
      result =
        "array of " + this.getArraySize().toString() + " {" + this.getBaseType().explain() + "}"
    else result = "array of {" + this.getBaseType().explain() + "}"
  }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() } // No such thing as a const array type

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }
}

/**
 * A GNU/Clang vector type.
 *
 * In both Clang and GNU compilers, vector types can be introduced using the
 * `__attribute__((vector_size(byte_size)))` syntax. The Clang compiler also
 * allows vector types to be introduced using the `ext_vector_type`,
 * `neon_vector_type`, and `neon_polyvector_type` attributes (all of which take
 * an element count rather than a byte size).
 *
 * In the example below, both `v4si` and `float4` are GNU vector types:
 * ```
 * typedef int v4si __attribute__ (( vector_size(4*sizeof(int)) ));
 * typedef float float4 __attribute__((ext_vector_type(4)));
 * ```
 */
class GNUVectorType extends DerivedType {
  GNUVectorType() { derivedtypes(underlyingElement(this), _, 5, _) }

  /**
   * Get the number of elements in this vector type.
   *
   * For vector types declared using Clang's ext_vector_type, neon_vector_type,
   * or neon_polyvector_type attribute, this is the value which appears within
   * the attribute. For vector types declared using the vector_size attribute,
   * the number of elements is the value in the attribute divided by the size
   * of a single element.
   */
  int getNumElements() { arraysizes(underlyingElement(this), result, _, _) }

  override string getAPrimaryQlClass() { result = "GNUVectorType" }

  /**
   * Gets the size, in bytes, of this vector type.
   *
   * For vector types declared using the vector_size attribute, this is the
   * value which appears within the attribute. For vector types declared using
   * Clang's ext_vector_type, neon_vector_type, or neon_polyvector_type
   * attribute, the byte size is the value in the attribute multiplied by the
   * byte size of a single element.
   */
  override int getSize() { arraysizes(underlyingElement(this), _, result, _) }

  override int getAlignment() { arraysizes(underlyingElement(this), _, _, result) }

  override string explain() {
    result = "GNU " + getNumElements() + " element vector of {" + this.getBaseType().explain() + "}"
  }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }
}

/**
 * A C/C++ pointer to a function. See 7.7.
 * ```
 * int(* pointer)(const void *element1, const void *element2);
 * ```
 */
class FunctionPointerType extends FunctionPointerIshType {
  FunctionPointerType() { derivedtypes(underlyingElement(this), _, 6, _) }

  override string getAPrimaryQlClass() { result = "FunctionPointerType" }

  override int getPointerIndirectionLevel() { result = 1 }

  override string explain() {
    result = "pointer to {" + this.getBaseType().(RoutineType).explain() + "}"
  }
}

/**
 * A C++ reference to a function.
 * ```
 * int(& reference)(const void *element1, const void *element2);
 * ```
 */
class FunctionReferenceType extends FunctionPointerIshType {
  FunctionReferenceType() { derivedtypes(underlyingElement(this), _, 7, _) }

  override string getAPrimaryQlClass() { result = "FunctionReferenceType" }

  override int getPointerIndirectionLevel() { result = getBaseType().getPointerIndirectionLevel() }

  override string explain() {
    result = "reference to {" + this.getBaseType().(RoutineType).explain() + "}"
  }
}

/**
 * A block type, for example, `int(^)(char, float)`.
 *
 * Block types (along with blocks themselves) are a language extension
 * supported by Clang, and by Apple's branch of GCC.
 * ```
 * int(^ block)(const char *element1, const char *element2)
 *   = ^int (const char *element1, const char *element2) { return element1 - element 2; }
 * ```
 */
class BlockType extends FunctionPointerIshType {
  BlockType() { derivedtypes(underlyingElement(this), _, 10, _) }

  override int getPointerIndirectionLevel() { result = 0 }

  override string explain() {
    result = "block of {" + this.getBaseType().(RoutineType).explain() + "}"
  }
}

/**
 * A C/C++ pointer to a function, a C++ function reference, or a clang/Apple block.
 *
 * See `FunctionPointerType`, `FunctionReferenceType` and `BlockType` for more information.
 */
class FunctionPointerIshType extends DerivedType {
  FunctionPointerIshType() {
    derivedtypes(underlyingElement(this), _, 6, _) or
    derivedtypes(underlyingElement(this), _, 7, _) or
    derivedtypes(underlyingElement(this), _, 10, _)
  }

  /** the return type of this function pointer type */
  Type getReturnType() {
    exists(RoutineType t |
      derivedtypes(underlyingElement(this), _, _, unresolveElement(t)) and
      result = t.getReturnType()
    )
  }

  /** the type of the ith argument of this function pointer type */
  Type getParameterType(int i) {
    exists(RoutineType t |
      derivedtypes(underlyingElement(this), _, _, unresolveElement(t)) and
      result = t.getParameterType(i)
    )
  }

  /** the type of an argument of this function pointer type */
  Type getAParameterType() {
    exists(RoutineType t |
      derivedtypes(underlyingElement(this), _, _, unresolveElement(t)) and
      result = t.getAParameterType()
    )
  }

  /** the number of arguments of this function pointer type */
  int getNumberOfParameters() { result = count(int i | exists(this.getParameterType(i))) }

  override predicate involvesTemplateParameter() {
    getReturnType().involvesTemplateParameter() or
    getAParameterType().involvesTemplateParameter()
  }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }
}

/**
 * A C++ pointer to data member. See 15.5.
 * ```
 * class C { int m; };
 * int C::* p = &C::m;          // pointer to data member m of class C
 * class C *;
 * int val = c.*p;              // access data member
 * ```
 */
class PointerToMemberType extends Type, @ptrtomember {
  /** a printable representation of this named element */
  override string toString() { result = this.getName() }

  override string getAPrimaryQlClass() { result = "PointerToMemberType" }

  /** the name of this type */
  override string getName() { result = "..:: *" }

  /** the base type of this pointer to member type */
  Type getBaseType() { ptrtomembers(underlyingElement(this), unresolveElement(result), _) }

  /** the class referred by this pointer to member type */
  Type getClass() { ptrtomembers(underlyingElement(this), _, unresolveElement(result)) }

  override predicate refersToDirectly(Type t) {
    t = this.getBaseType() or
    t = this.getClass()
  }

  override int getPointerIndirectionLevel() {
    result = 1 + this.getBaseType().getPointerIndirectionLevel()
  }

  override string explain() {
    result =
      "pointer to member of " + this.getClass().toString() + " with type {" +
        this.getBaseType().explain() + "}"
  }

  override predicate involvesTemplateParameter() { getBaseType().involvesTemplateParameter() }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }
}

/**
 * A C/C++ routine type. Conceptually, this is what results from stripping
 * away the pointer from a function pointer type.  It can also occur in C++
 * code, for example the base type of `myRoutineType` in the following code:
 * ```
 * using myRoutineType = int(int);
 *
 * myRoutineType *fp = 0;
 * ```
 */
class RoutineType extends Type, @routinetype {
  /** a printable representation of this named element */
  override string toString() { result = this.getName() }

  override string getAPrimaryQlClass() { result = "RoutineType" }

  override string getName() { result = "..()(..)" }

  /**
   * Gets the type of the `n`th parameter to this routine.
   */
  Type getParameterType(int n) {
    routinetypeargs(underlyingElement(this), n, unresolveElement(result))
  }

  /**
   * Gets the type of a parameter to this routine.
   */
  Type getAParameterType() { routinetypeargs(underlyingElement(this), _, unresolveElement(result)) }

  /**
   * Gets the return type of this routine.
   */
  Type getReturnType() { routinetypes(underlyingElement(this), unresolveElement(result)) }

  override string explain() {
    result =
      "function returning {" + this.getReturnType().explain() + "} with arguments (" +
        this.explainParameters(0) + ")"
  }

  /**
   * Gets a string with the `explain()` values for the parameters of
   * this function, for instance "int,int".
   *
   * The integer argument is the index of the first parameter to explain.
   */
  private string explainParameters(int i) {
    i = 0 and result = "" and not exists(this.getAParameterType())
    or
    (
      exists(this.getParameterType(i)) and
      if i < max(int j | exists(this.getParameterType(j)))
      then
        // Not the last one
        result = this.getParameterType(i).explain() + "," + this.explainParameters(i + 1)
      else
        // Last parameter
        result = this.getParameterType(i).explain()
    )
  }

  override predicate refersToDirectly(Type t) {
    t = this.getReturnType() or
    t = this.getAParameterType()
  }

  override predicate isDeeplyConst() { none() } // Current limitation: no such thing as a const routine type

  override predicate isDeeplyConstBelow() { none() } // Current limitation: no such thing as a const routine type

  override predicate involvesTemplateParameter() {
    getReturnType().involvesTemplateParameter() or
    getAParameterType().involvesTemplateParameter()
  }
}

/**
 * A C++ `typename` (or `class`) template parameter.
 *
 * In the example below, `T` is a template parameter:
 * ```
 * template <class T>
 * class C { };
 * ```
 */
class TemplateParameter extends UserType {
  TemplateParameter() {
    usertypes(underlyingElement(this), _, 7) or usertypes(underlyingElement(this), _, 8)
  }

  override string getAPrimaryQlClass() { result = "TemplateParameter" }

  override predicate involvesTemplateParameter() { any() }
}

/**
 * A C++ template template parameter.
 *
 * In the example below, `T` is a template template parameter (although its name
 * may be omitted):
 * ```
 * template <template <typename T> class Container, class Elem>
 * void foo(const Container<Elem> &value) { }
 * ```
 */
class TemplateTemplateParameter extends TemplateParameter {
  TemplateTemplateParameter() { usertypes(underlyingElement(this), _, 8) }

  override string getAPrimaryQlClass() { result = "TemplateTemplateParameter" }
}

/**
 * A type representing the use of the C++11 `auto` keyword.
 * ```
 * auto val = some_typed_expr();
 * ```
 */
class AutoType extends TemplateParameter {
  AutoType() { usertypes(underlyingElement(this), "auto", 7) }

  override string getAPrimaryQlClass() { result = "AutoType" }

  override Location getLocation() {
    suppressUnusedThis(this) and
    result instanceof UnknownDefaultLocation
  }
}

private predicate suppressUnusedThis(Type t) { any() }

/** A source code location referring to a type */
class TypeMention extends Locatable, @type_mention {
  override string toString() { result = "type mention" }

  override string getAPrimaryQlClass() { result = "TypeMention" }

  /**
   * Gets the type being referenced by this type mention.
   */
  Type getMentionedType() { type_mentions(underlyingElement(this), unresolveElement(result), _, _) }

  override Location getLocation() { type_mentions(underlyingElement(this), _, result, _) }
}
