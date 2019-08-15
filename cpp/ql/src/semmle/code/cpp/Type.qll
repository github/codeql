import semmle.code.cpp.Element
import semmle.code.cpp.Member
import semmle.code.cpp.Function
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ type.
 */
class Type extends Locatable, @type {
  Type() { isType(underlyingElement(this)) }

  /**
   * Gets the name of this type.
   */
  string getName() {
    none()
  }

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
  predicate hasSpecifier(string name) {
    this.getASpecifier().hasName(name)
  }

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
    typespecifiers(underlyingElement(this),unresolveElement(result))
    or
    result = this.internal_getAnAdditionalSpecifier()
  }

  /**
   * Gets an attribute of this type.
   */
  Attribute getAnAttribute() { typeattributes(underlyingElement(this),unresolveElement(result)) }

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
       builtintypes(underlyingElement(this), _, _, result, _, _)
    or pointerishsize(underlyingElement(this), result, _)
    or usertypesize(underlyingElement(this), result, _)
  }

  /**
   * Gets the alignment of this type in bytes.
   */
  int getAlignment() {
       builtintypes(underlyingElement(this), _, _, _, _, result)
    or pointerishsize(underlyingElement(this), _, result)
    or usertypesize(underlyingElement(this), _, result)
  }

  /**
   * Gets the pointer indirection level of this type.
   */
  int getPointerIndirectionLevel() {
    result = 0
  }

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
      not(c.isImplicit())
      and c.getType().refersTo(this)
      and result = c
      and not c.getEnclosingFunction().isConstructedFrom(_)
    )

    // A class derivation from a type referring to T uses T. We exclude class derivations within
    // instantiations, since they do not appear directly in the source.
    or exists(ClassDerivation cd |
      cd.getBaseType().refersTo(this)
      and result = cd
      and not cd.getDerivedClass() instanceof ClassTemplateInstantiation
    )

    // A new, new array, or placement new expression with a type that refers to T uses T.
    // We exclude news within instantiations, since they do not appear directly in the source.
    or exists(Expr e |
      (
        e instanceof NewArrayExpr
        or e instanceof NewExpr
      )
      and e.getType().refersTo(this)
      and result = e
      and not e.getEnclosingFunction().isConstructedFrom(_)
    )

    // The declaration of a function that returns a type referring to T uses T. We exclude
    // declarations of function template instantiations, since their return types do not
    // appear directly in the source. We also exclude constructors and destructors, since
    // they are indexed with a dummy return type of void that does not appear in the source.
    or exists(FunctionDeclarationEntry fde, Type t |
      (
        if exists(fde.getTypedefType()) then
          t = fde.getTypedefType()
        else
          t = fde.getType()
      )
      and t.refersTo(this)
      and result = fde
      and not fde.getDeclaration().isConstructedFrom(_)
      and not(fde.getDeclaration() instanceof Constructor)
      and not(fde.getDeclaration() instanceof Destructor)
    )

    // A function call that provides an explicit template argument that refers to T uses T.
    // We exclude calls within instantiations, since they do not appear directly in the source.
    or exists(FunctionCall c |
      c.getAnExplicitTemplateArgument().refersTo(this)
      and result = c
      and not c.getEnclosingFunction().isConstructedFrom(_)
    )

    // Qualifying an expression with a type that refers to T uses T. We exclude qualifiers
    // within instantiations, since they do not appear directly in the source.
    or exists(NameQualifier nq |
      nq.getQualifyingElement().(Type).refersTo(this)
      and result = nq
      and not nq.getExpr().getEnclosingFunction().isConstructedFrom(_)
    )

    // Calculating the size of a type that refers to T uses T. We exclude sizeofs within
    // instantiations, since they do not appear directly in the source.
    or exists(SizeofTypeOperator soto |
      soto.getTypeOperand().refersTo(this)
      and result = soto
      and not soto.getEnclosingFunction().isConstructedFrom(_)
    )

    // A typedef of a type that refers to T uses T.
    or exists(TypeDeclarationEntry tde |
      tde.getDeclaration().(TypedefType).getBaseType().refersTo(this)
      and result = tde
    )

    // Using something declared within a type that refers to T uses T.
    or exists(UsingDeclarationEntry ude |
      ude.getDeclaration().getDeclaringType().refersTo(this)
      and result = ude
    )

    // The declaration of a variable with a type that refers to T uses T. We exclude declarations within
    // instantiations, since those do not appear directly in the source.
    or exists(VariableDeclarationEntry vde |
      vde.getType().refersTo(this)
      and result = vde
      and not exists(LocalScopeVariable sv | sv = vde.getDeclaration() and sv.getFunction().isConstructedFrom(_))
      and not exists(MemberVariable mv | mv = vde.getDeclaration() and mv.getDeclaringType() instanceof ClassTemplateInstantiation)
    )
  }

  /**
   * Holds if this type involves a reference.
   */
  predicate involvesReference() {
    none()
  }

  /**
   * Holds if this type involves a template parameter.
   */
  predicate involvesTemplateParameter() {
    none()
  }

  /**
   * Gets this type with any typedefs resolved. For example, given
   * `typedef C T`, this would resolve `const T&amp;` to `const C&amp;`.
   * Note that this will only work if the resolved type actually appears
   * on its own elsewhere in the program.
   */
  Type resolveTypedefs() {
    result = this
  }

  /**
   * Gets the type stripped of pointers, references and cv-qualifiers, and resolving typedefs.
   * For example, given `typedef const C&amp; T`, `stripType` returns `C`.
   */
  Type stripType() {
    result = this
  }

  override Location getLocation() {
    suppressUnusedThis(this) and
    result instanceof UnknownDefaultLocation
  }
}

/**
 * A C/C++ built-in primitive type (int, float, void, and so on). See 4.1.1.
 */
class BuiltInType extends Type, @builtintype {
  override string toString() { result = this.getName() }

  override string getName() { builtintypes(underlyingElement(this),result,_,_,_,_) }

  override string explain() { result = this.getName() }

  override predicate isDeeplyConstBelow() { any() } // No subparts
}

/**
 * An erroneous type.
 */
class ErroneousType extends BuiltInType {

  ErroneousType() { builtintypes(underlyingElement(this),_,1,_,_,_) }

  override string getCanonicalQLClass() { result = "ErroneousType" }
}

/**
 * The unknown type.
 */
class UnknownType extends BuiltInType {

  UnknownType() { builtintypes(underlyingElement(this),_,2,_,_,_) }

  override string getCanonicalQLClass() { result = "UnknownType" }
}

private predicate isArithmeticType(@builtintype type, int kind) {
  builtintypes(type, _, kind, _, _, _) and
  (kind >= 4) and
  (kind != 34)  // Exclude decltype(nullptr)
}

/**
 * The C/C++ arithmetic types. See 4.1.1.
 */
class ArithmeticType extends BuiltInType {
  ArithmeticType() {
    isArithmeticType(underlyingElement(this), _)
  }

  override string getCanonicalQLClass() { result = "ArithmeticType" }
}

private predicate isIntegralType(@builtintype type, int kind) {
  isArithmeticType(type, kind) and
  (kind < 24 or kind = 33 or (35 <= kind and kind <= 37) or
    kind = 43 or kind = 44)
}

/**
 * A C/C++ integral or enum type.
 * The definition of "integral type" in the C++ Standard excludes enum types,
 * but because an enum type holds a value of its underlying integral type,
 * it is often useful to have a common category that includes both integral
 * and enum types.
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
  or original = 5 and canonical = 5 and unsigned = 6 and signed = 7 // char
  or original = 6 and canonical = 6 and unsigned = 6 and signed = 7 // unsigned char
  or original = 7 and canonical = 7 and unsigned = 6 and signed = 7 // signed char
  or original = 8 and canonical = 8 and unsigned = 9 and signed = 10 // short
  or original = 9 and canonical = 9 and unsigned = 9 and signed = 10 // unsigned short
  or original = 10 and canonical = 8 and unsigned = 9 and signed = 10 // signed short
  or original = 11 and canonical = 11 and unsigned = 12 and signed = 13 // int
  or original = 12 and canonical = 12 and unsigned = 12 and signed = 13 // unsigned int
  or original = 13 and canonical = 11 and unsigned = 12 and signed = 13 // signed int
  or original = 14 and canonical = 14 and unsigned = 15 and signed = 16 // long
  or original = 15 and canonical = 15 and unsigned = 15 and signed = 16 // unsigned long
  or original = 16 and canonical = 14 and unsigned = 15 and signed = 16 // signed long
  or original = 17 and canonical = 17 and unsigned = 18 and signed = 19 // long long
  or original = 18 and canonical = 18 and unsigned = 18 and signed = 19 // unsigned long long
  or original = 19 and canonical = 17 and unsigned = 18 and signed = 19 // signed long long
  or original = 33 and canonical = 33 and unsigned = -1 and signed = -1 // wchar_t
  or original = 35 and canonical = 35 and unsigned = 36 and signed = 37 // __int128
  or original = 36 and canonical = 36 and unsigned = 36 and signed = 37 // unsigned __int128
  or original = 37 and canonical = 35 and unsigned = 36 and signed = 37 // signed __int128
  or original = 43 and canonical = 43 and unsigned = -1 and signed = -1 // char16_t
  or original = 44 and canonical = 44 and unsigned = -1 and signed = -1 // char32_t
}

/**
 * The C/C++ integral types. See 4.1.1.
 */
class IntegralType extends ArithmeticType, IntegralOrEnumType {
  int kind;

  IntegralType() {
    isIntegralType(underlyingElement(this), kind)
  }

  /** Holds if this integral type is signed. */
  predicate isSigned() {
    builtintypes(underlyingElement(this),_,_,_,-1,_)
  }

  /** Holds if this integral type is unsigned. */
  predicate isUnsigned() {
    builtintypes(underlyingElement(this),_,_,_,1,_)
  }

  /** Holds if this integral type is explicitly signed. */
  predicate isExplicitlySigned() {
    builtintypes(underlyingElement(this),_,7,_,_,_) or builtintypes(underlyingElement(this),_,10,_,_,_) or builtintypes(underlyingElement(this),_,13,_,_,_) or
    builtintypes(underlyingElement(this),_,16,_,_,_) or builtintypes(underlyingElement(this),_,19,_,_,_) or
    builtintypes(underlyingElement(this),_,37,_,_,_)
  }

  /** Holds if this integral type is explicitly unsigned. */
  predicate isExplicitlyUnsigned() {
    builtintypes(underlyingElement(this),_,6,_,_,_) or builtintypes(underlyingElement(this),_,9,_,_,_) or builtintypes(underlyingElement(this),_,12,_,_,_) or
    builtintypes(underlyingElement(this),_,15,_,_,_) or builtintypes(underlyingElement(this),_,18,_,_,_) or
    builtintypes(underlyingElement(this),_,36,_,_,_)
  }

  /** Holds if this integral type is implicitly signed. */
  predicate isImplicitlySigned() {
    builtintypes(underlyingElement(this),_,5,_,-1,_) or builtintypes(underlyingElement(this),_,8,_,-1,_) or builtintypes(underlyingElement(this),_,11,_,-1,_) or
    builtintypes(underlyingElement(this),_,14,_,-1,_) or builtintypes(underlyingElement(this),_,17,_,-1,_) or
    builtintypes(underlyingElement(this),_,35,_,-1,_)
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
 * The C/C++ boolean type. See 4.2.
 */
class BoolType extends IntegralType {

  BoolType() { builtintypes(underlyingElement(this),_,4,_,_,_) }

  override string getCanonicalQLClass() { result = "BoolType" }
}

/**
 * The C/C++ character types. See 4.3.
 */
abstract class CharType extends IntegralType { }

/**
 * The C/C++ char type (which is different to signed char and unsigned char).
 */
class PlainCharType extends CharType {
  PlainCharType() {
    builtintypes(underlyingElement(this),_,5,_,_,_)
  }

  override string getCanonicalQLClass() { result = "PlainCharType" }
}

/**
 * The C/C++ unsigned char type (which is different to plain char, even when chars are unsigned by default).
 */
class UnsignedCharType extends CharType {
  UnsignedCharType() {
    builtintypes(underlyingElement(this),_,6,_,_,_)
  }

  override string getCanonicalQLClass() { result = "UnsignedCharType" }
}

/**
 * The C/C++ signed char type (which is different to plain char, even when chars are signed by default).
 */
class SignedCharType extends CharType {
  SignedCharType() {
    builtintypes(underlyingElement(this),_,7,_,_,_)
  }

  override string getCanonicalQLClass() { result = "SignedCharType" }
}

/**
 * The C/C++ short types. See 4.3.
 */
class ShortType extends IntegralType {

  ShortType() {
    builtintypes(underlyingElement(this),_,8,_,_,_) or builtintypes(underlyingElement(this),_,9,_,_,_) or builtintypes(underlyingElement(this),_,10,_,_,_)
  }

  override string getCanonicalQLClass() { result = "ShortType" }
}

/**
 * The C/C++ integer types. See 4.4.
 */
class IntType extends IntegralType {

  IntType() {
    builtintypes(underlyingElement(this),_,11,_,_,_) or builtintypes(underlyingElement(this),_,12,_,_,_) or builtintypes(underlyingElement(this),_,13,_,_,_)
  }

  override string getCanonicalQLClass() { result = "IntType" }
}

/**
 * The C/C++ long types. See 4.4.
 */
class LongType extends IntegralType {

  LongType() {
    builtintypes(underlyingElement(this),_,14,_,_,_) or builtintypes(underlyingElement(this),_,15,_,_,_) or builtintypes(underlyingElement(this),_,16,_,_,_)
  }

  override string getCanonicalQLClass() { result = "LongType" }
}

/**
 * The C/C++ long long types. See 4.4.
 */
class LongLongType extends IntegralType {

  LongLongType() {
    builtintypes(underlyingElement(this),_,17,_,_,_) or builtintypes(underlyingElement(this),_,18,_,_,_) or builtintypes(underlyingElement(this),_,19,_,_,_)
  }

  override string getCanonicalQLClass() { result = "LongLongType" }
}

/**
 * The GNU C __int128 types.
 */
class Int128Type extends IntegralType {

  Int128Type() {
    builtintypes(underlyingElement(this),_,35,_,_,_) or builtintypes(underlyingElement(this),_,36,_,_,_) or builtintypes(underlyingElement(this),_,37,_,_,_)
  }

}

/**
 * The C/C++ floating point types. See 4.5.
 */
class FloatingPointType extends ArithmeticType {

  FloatingPointType() {
    exists(int kind | builtintypes(underlyingElement(this),_,kind,_,_,_) and ((kind >= 24 and kind <= 32) or (kind = 38)))
  }

}

/**
 * The C/C++ float type.
 */
class FloatType extends FloatingPointType {

  FloatType() { builtintypes(underlyingElement(this),_,24,_,_,_) }

  override string getCanonicalQLClass() { result = "FloatType" }
}

/**
 * The C/C++ double type.
 */
class DoubleType extends FloatingPointType {

  DoubleType() { builtintypes(underlyingElement(this),_,25,_,_,_) }

  override string getCanonicalQLClass() { result = "DoubleType" }
}

/**
 * The C/C++ long double type.
 */
class LongDoubleType extends FloatingPointType {

  LongDoubleType() { builtintypes(underlyingElement(this),_,26,_,_,_) }

  override string getCanonicalQLClass() { result = "LongDoubleType" }
}

/**
 * The GNU C __float128 type.
 */
class Float128Type extends FloatingPointType {

  Float128Type() { builtintypes(underlyingElement(this),_,38,_,_,_) }

}

/**
 * The GNU C _Decimal32 type.
 */
class Decimal32Type extends FloatingPointType {

  Decimal32Type() { builtintypes(underlyingElement(this),_,40,_,_,_) }

}

/**
 * The GNU C _Decimal64 type.
 */
class Decimal64Type extends FloatingPointType {

  Decimal64Type() { builtintypes(underlyingElement(this),_,41,_,_,_) }

}

/**
 * The GNU C _Decimal128 type.
 */
class Decimal128Type extends FloatingPointType {

  Decimal128Type() { builtintypes(underlyingElement(this),_,42,_,_,_) }

}

/**
 * The C/C++ void type. See 4.7.
 */
class VoidType extends BuiltInType {

  VoidType() { builtintypes(underlyingElement(this),_,3,_,_,_) }

  override string getCanonicalQLClass() { result = "VoidType" }
}

/**
 * The C/C++ wide character type.
 * 
 * Note that on some platforms `wchar_t` doesn't exist as a built-in
 * type but a typedef is provided.  Consider using the `Wchar_t` QL
 * class to include these types.
 */
class WideCharType extends IntegralType {

  WideCharType() { builtintypes(underlyingElement(this),_,33,_,_,_) }

  override string getCanonicalQLClass() { result = "WideCharType" }
}

/**
 * The C/C++ `char16_t` type.
 */
class Char16Type extends IntegralType {

  Char16Type() { builtintypes(underlyingElement(this),_,43,_,_,_) }

  override string getCanonicalQLClass() { result = "Char16Type" }
}

/**
 * The C/C++ `char32_t` type.
 */
class Char32Type extends IntegralType {

  Char32Type() { builtintypes(underlyingElement(this),_,44,_,_,_) }

  override string getCanonicalQLClass() { result = "Char32Type" }
}

/**
 * The type of the C++11 nullptr constant.
 *
 * Note that this is not `nullptr_t`, as `nullptr_t` is defined as:
 * ```
 *  typedef decltype(nullptr) nullptr_t;
 * ```
 * Instead, this is the unspeakable type given by `decltype(nullptr)`.
 */
class NullPointerType extends BuiltInType {
  NullPointerType() { builtintypes(underlyingElement(this),_,34,_,_,_) }

  override string getCanonicalQLClass() { result = "NullPointerType" }
}

/**
 * A C/C++ derived type.
 *
 * These are pointer and reference types, array and vector types, and const and volatile types.
 * In all cases, the type is formed from a single base type.
 */
class DerivedType extends Type, @derivedtype {
  override string toString() { result = this.getName() }

  override string getName() { derivedtypes(underlyingElement(this),result,_,_) }

  /**
   * Gets the base type of this derived type.
   *
   * This predicate strips off one level of decoration from a type. For example, it returns `char*` for the PointerType `char**`,
   * `const int` for the ReferenceType `const int&amp;`, and `long` for the SpecifiedType `volatile long`.
   */
  Type getBaseType() { derivedtypes(underlyingElement(this),_,_,unresolveElement(result)) }

  override predicate refersToDirectly(Type t) { t = this.getBaseType() }

  override predicate involvesReference() {
    getBaseType().involvesReference()
  }

  override predicate involvesTemplateParameter() {
    getBaseType().involvesTemplateParameter()
  }

  override Type stripType() {
    result = getBaseType().stripType()
  }

  predicate isAutoReleasing() {
    this.hasSpecifier("__autoreleasing") or
    this.(PointerType).getBaseType().hasSpecifier("__autoreleasing")
  }

  predicate isStrong() {
    this.hasSpecifier("__strong") or
    this.(PointerType).getBaseType().hasSpecifier("__strong")
  }

  predicate isUnsafeRetained() {
    this.hasSpecifier("__unsafe_unretained") or
    this.(PointerType).getBaseType().hasSpecifier("__unsafe_unretained")
  }

  predicate isWeak() {
    this.hasSpecifier("__weak") or
    this.(PointerType).getBaseType().hasSpecifier("__weak")
  }
}

/**
 * An instance of the C++11 decltype operator.
 */
class Decltype extends Type, @decltype {

  /**
   * The expression whose type is being obtained by this decltype.
   */
  Expr getExpr() {
    decltypes(underlyingElement(this), unresolveElement(result), _, _)
  }

  /**
   * The type immediately yielded by this decltype.
   */
  Type getBaseType() {
    decltypes(underlyingElement(this), _, unresolveElement(result), _)
  }

  override string getCanonicalQLClass() { result = "Decltype" }

  /**
   * Whether an extra pair of parentheses around the expression would change the semantics of this decltype.
   *
   * The following example shows the effect of an extra pair of parentheses:
   *   struct A { double x; };
   *   const A* a = new A();
   *   decltype( a->x ); // type is double
   *   decltype((a->x)); // type is const double&amp;
   * Consult the C++11 standard for more details.
   */
  predicate parenthesesWouldChangeMeaning() {
    decltypes(underlyingElement(this), _, _, true)
  }

  override Type getUnderlyingType() {
    result = getBaseType().getUnderlyingType()
  }

  override Type stripTopLevelSpecifiers() {
    result = getBaseType().stripTopLevelSpecifiers()
  }

  override Type stripType() {
    result = getBaseType().stripType()
  }

  override Type resolveTypedefs() {
    result = getBaseType().resolveTypedefs()
  }

  override Location getLocation() {
    result = getExpr().getLocation()
  }

  override string toString() {
    result = "decltype(...)"
  }

  override string getName() {
    none()
  }

  override int getSize() {
    result = getBaseType().getSize()
  }

  override int getAlignment() {
    result = getBaseType().getAlignment()
  }

  override int getPointerIndirectionLevel() {
    result = getBaseType().getPointerIndirectionLevel()
  }

  override string explain() {
    result = "decltype resulting in {" + this.getBaseType().explain() + "}"
  }

  override predicate involvesReference() {
    getBaseType().involvesReference()
  }

  override predicate involvesTemplateParameter() {
    getBaseType().involvesTemplateParameter()
  }

  override predicate isDeeplyConst() {
    this.getBaseType().isDeeplyConst()
  }

  override predicate isDeeplyConstBelow() {
    this.getBaseType().isDeeplyConstBelow()
  }

  override Specifier internal_getAnAdditionalSpecifier() {
    result = this.getBaseType().getASpecifier()
  }
}

/**
 * A C/C++ pointer type. See 4.9.1.
 */
class PointerType extends DerivedType {

  PointerType() { derivedtypes(underlyingElement(this),_,1,_) }

  override string getCanonicalQLClass() { result = "PointerType" }

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
 * For C++11 code bases, this includes both lvalue references (&amp;) and rvalue references (&amp;&amp;).
 * To distinguish between them, use the LValueReferenceType and RValueReferenceType classes.
 */
class ReferenceType extends DerivedType {

  ReferenceType() { derivedtypes(underlyingElement(this),_,2,_) or derivedtypes(underlyingElement(this),_,8,_) }

  override string getCanonicalQLClass() { result = "ReferenceType" }

  override int getPointerIndirectionLevel() {
    result = getBaseType().getPointerIndirectionLevel()
  }

  override string explain() { result = "reference to {" + this.getBaseType().explain() + "}" }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() } // No such thing as a const reference type

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }

  override predicate involvesReference() {
    any()
  }

  override Type resolveTypedefs() {
    result.(ReferenceType).getBaseType() = getBaseType().resolveTypedefs()
  }
}

/**
 * A C++11 lvalue reference type (e.g. int&amp;).
 */
class LValueReferenceType extends ReferenceType {
  LValueReferenceType() { derivedtypes(underlyingElement(this),_,2,_) }

  override string getCanonicalQLClass() { result = "LValueReferenceType" }
}

/**
 * A C++11 rvalue reference type (e.g. int&amp;&amp;).
 */
class RValueReferenceType extends ReferenceType {
  RValueReferenceType() { derivedtypes(underlyingElement(this),_,8,_) }

  override string getCanonicalQLClass() { result = "RValueReferenceType" }

  override string explain() { result = "rvalue " + super.explain() }
}

/**
 * A type with specifiers.
 */
class SpecifiedType extends DerivedType {

  SpecifiedType() { derivedtypes(underlyingElement(this),_,3,_) }

  override string getCanonicalQLClass() { result = "SpecifiedType" }

  override int getSize() { result = this.getBaseType().getSize() }

  override int getAlignment() { result = this.getBaseType().getAlignment() }

  override int getPointerIndirectionLevel() {
    result = this.getBaseType().getPointerIndirectionLevel()
  }

  /** all the specifiers of this type as a string in a fixed order (the order
      only depends on the specifiers, not on the source program). This is intended
      for debugging queries only and is an expensive operation. */
  string getSpecifierString() {
    internalSpecString(this, result, 1)
  }

  override string explain() { result = this.getSpecifierString() + "{" + this.getBaseType().explain() + "}" }

  override predicate isDeeplyConst() { this.getASpecifier().getName() = "const" and this.getBaseType().isDeeplyConstBelow() }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConstBelow() }

  override Specifier internal_getAnAdditionalSpecifier() {
    result = this.getBaseType().getASpecifier()
  }

  override Type resolveTypedefs() {
    result.(SpecifiedType).getBaseType() = getBaseType().resolveTypedefs()
    and result.getASpecifier() = getASpecifier()
  }

  override Type stripTopLevelSpecifiers() {
    result = getBaseType().stripTopLevelSpecifiers()
  }
}

/**
 * A C/C++ array type. See 4.9.1.
 */
class ArrayType extends DerivedType {

  ArrayType() { derivedtypes(underlyingElement(this),_,4,_) }

  override string getCanonicalQLClass() { result = "ArrayType" }
  
  predicate hasArraySize() { arraysizes(underlyingElement(this),_,_,_) }

  /**
   * Gets the number of elements in this array. Only has a result for arrays declared to be of a
   * constant size. See `getByteSize` for getting the number of bytes.
   */
  int getArraySize() { arraysizes(underlyingElement(this),result,_,_) }

  /**
   * Gets the byte size of this array. Only has a result for arrays declared to be of a constant
   * size. See `getArraySize` for getting the number of elements.
   */
  int getByteSize() { arraysizes(underlyingElement(this),_,result,_) }

  override int getAlignment() { arraysizes(underlyingElement(this), _, _, result) }

  /**
   * Gets the byte size of this array. Only has a result for arrays declared to be of a constant
   * size. This predicate is a synonym for `getByteSize`. See `getArraySize` for getting the number
   * of elements.
   */
  override int getSize() {
    result = this.getByteSize()
  }

  override string explain() {
    if exists(this.getArraySize()) then
      result = "array of " + this.getArraySize().toString() + " {" + this.getBaseType().explain() + "}"
    else
      result = "array of {" + this.getBaseType().explain() + "}"
  }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() } // No such thing as a const array type

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }
}

/**
 * A GNU/Clang vector type.
 *
 * In both Clang and GNU compilers, vector types can be introduced using the
 * __attribute__((vector_size(byte_size))) syntax. The Clang compiler also
 * allows vector types to be introduced using the ext_vector_type,
 * neon_vector_type, and neon_polyvector_type attributes (all of which take
 * an element type rather than a byte size).
 */
class GNUVectorType extends DerivedType {

  GNUVectorType() { derivedtypes(underlyingElement(this),_,5,_) }

  /**
   * Get the number of elements in this vector type.
   *
   * For vector types declared using Clang's ext_vector_type, neon_vector_type,
   * or neon_polyvector_type attribute, this is the value which appears within
   * the attribute. For vector types declared using the vector_size attribute,
   * the number of elements is the value in the attribute divided by the size
   * of a single element.
   */
  int getNumElements() { arraysizes(underlyingElement(this),result,_,_) }

  override string getCanonicalQLClass() { result = "GNUVectorType" }

  /**
   * Gets the size, in bytes, of this vector type.
   *
   * For vector types declared using the vector_size attribute, this is the
   * value which appears within the attribute. For vector types declared using
   * Clang's ext_vector_type, neon_vector_type, or neon_polyvector_type
   * attribute, the byte size is the value in the attribute multiplied by the
   * byte size of a single element.
   */
  override int getSize() { arraysizes(underlyingElement(this),_,result,_) }

  override int getAlignment() { arraysizes(underlyingElement(this), _, _, result) }

  override string explain() { result = "GNU " + getNumElements() + " element vector of {" + this.getBaseType().explain() + "}" }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }

}

/**
 * A C/C++ pointer to function. See 7.7.
 */
class FunctionPointerType extends FunctionPointerIshType {
  FunctionPointerType() {
    derivedtypes(underlyingElement(this),_,6,_)
  }

  override string getCanonicalQLClass() { result = "FunctionPointerType" }

  override int getPointerIndirectionLevel() {
    result = 1
  }

  override string explain() { result = "pointer to {" + this.getBaseType().(RoutineType).explain() + "}" }
}

/**
 * A C/C++ reference to function.
 */
class FunctionReferenceType extends FunctionPointerIshType {
  FunctionReferenceType() {
    derivedtypes(underlyingElement(this),_,7,_)
  }

  override string getCanonicalQLClass() { result = "FunctionReferenceType" }
  
  override int getPointerIndirectionLevel() {
    result = getBaseType().getPointerIndirectionLevel()
  }

  override string explain() { result = "reference to {" + this.getBaseType().(RoutineType).explain() + "}" }
}

/**
 * A block type, for example int(^)(char, float).
 *
 * Block types (along with blocks themselves) are a language extension
 * supported by Clang, and by Apple's branch of GCC.
 */
class BlockType extends FunctionPointerIshType {
  BlockType() {
    derivedtypes(underlyingElement(this),_,10,_)
  }

  override int getPointerIndirectionLevel() {
    result = 0
  }

  override string explain() { result = "block of {" + this.getBaseType().(RoutineType).explain() + "}" }
}

/**
 * A C/C++ pointer to function, or a block.
 */
class FunctionPointerIshType extends DerivedType {
  FunctionPointerIshType() {
    derivedtypes(underlyingElement(this),_,6, _) or
    derivedtypes(underlyingElement(this),_,7, _) or
    derivedtypes(underlyingElement(this),_,10,_)
  }

  /** the return type of this function pointer type */
  Type getReturnType() {
    exists(RoutineType t | derivedtypes(underlyingElement(this),_,_,unresolveElement(t)) and result = t.getReturnType())
  }

  /** the type of the ith argument of this function pointer type */
  Type getParameterType(int i) {
    exists(RoutineType t | derivedtypes(underlyingElement(this),_,_,unresolveElement(t)) and result = t.getParameterType(i))
  }

  /** the type of an argument of this function pointer type */
  Type getAParameterType() {
    exists(RoutineType t | derivedtypes(underlyingElement(this),_,_,unresolveElement(t)) and result = t.getAParameterType())
  }

  /** the number of arguments of this function pointer type */
  int getNumberOfParameters() {
    result = count(int i | exists(this.getParameterType(i)))
  }

  override predicate involvesTemplateParameter() {
    getReturnType().involvesTemplateParameter()
    or getAParameterType().involvesTemplateParameter()
  }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }
}

/**
 * A C++ pointer to member. See 15.5.
 */
class PointerToMemberType extends Type, @ptrtomember {
  /** a printable representation of this named element */
  override string toString() { result = this.getName() }

  override string getCanonicalQLClass() { result = "PointerToMemberType" }
  
  /** the name of this type */
  override string getName() { result = "..:: *" }

  /** the base type of this pointer to member type */
  Type getBaseType() { ptrtomembers(underlyingElement(this),unresolveElement(result),_) }

  /** the class referred by this pointer to member type */
  Type getClass() { ptrtomembers(underlyingElement(this),_,unresolveElement(result)) }

  override predicate refersToDirectly(Type t) {
    t = this.getBaseType() or
    t = this.getClass()
  }

  override int getPointerIndirectionLevel() {
    result = 1 + this.getBaseType().getPointerIndirectionLevel()
  }

  override string explain() { result = "pointer to member of " + this.getClass().toString() + " with type {" + this.getBaseType().explain() + "}" }

  override predicate involvesTemplateParameter() {
    getBaseType().involvesTemplateParameter()
  }

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConst() }
}

/**
 * A C/C++ routine type. This is what results from stripping away the pointer from a function pointer type.
 */
class RoutineType extends Type, @routinetype {
  /** a printable representation of this named element */
  override string toString() { result = this.getName() }

  override string getCanonicalQLClass() { result = "RoutineType" }

  override string getName() { result = "..()(..)" }

  Type getParameterType(int n) { routinetypeargs(underlyingElement(this),n,unresolveElement(result)) }

  Type getAParameterType() { routinetypeargs(underlyingElement(this),_,unresolveElement(result)) }

  Type getReturnType() { routinetypes(underlyingElement(this), unresolveElement(result)) }

  override string explain() {
      result = "function returning {" + this.getReturnType().explain() +
          "} with arguments (" + this.explainParameters(0) + ")"
  }

  /**
   * Gets a string with the `explain()` values for the parameters of
   * this function, for instance "int,int".
   *
   * The integer argument is the index of the first parameter to explain.
   */
  private string explainParameters(int i) {
    (i = 0 and result = "" and not exists(this.getAParameterType()))
    or
    (
      exists(this.getParameterType(i)) and
      if i < max(int j | exists(this.getParameterType(j))) then
        // Not the last one
        result = this.getParameterType(i).explain() + "," + this.explainParameters(i+1)
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
    getReturnType().involvesTemplateParameter()
    or getAParameterType().involvesTemplateParameter()
  }
}

/**
 * A C++ typename template parameter.
 */
class TemplateParameter extends UserType
{
  TemplateParameter() { usertypes(underlyingElement(this), _, 7) or usertypes(underlyingElement(this), _, 8) }

  override string getCanonicalQLClass() { result = "TemplateParameter" }

  override predicate involvesTemplateParameter() {
    any()
  }
}

/** A C++ template template parameter, e.g. template &lt;template &lt;typename,typename> class T>. */
class TemplateTemplateParameter extends TemplateParameter
{
  TemplateTemplateParameter() {
    usertypes(underlyingElement(this), _, 8)
  }
  
  override string getCanonicalQLClass() { result = "TemplateTemplateParameter" }
}

/**
 * A type representing the use of the C++11 auto keyword.
 */
class AutoType extends TemplateParameter
{
  AutoType() { usertypes(underlyingElement(this), "auto", 7) }
  
  override string getCanonicalQLClass() { result = "AutoType" }

  override Location getLocation() {
    suppressUnusedThis(this) and
    result instanceof UnknownDefaultLocation
  }
}

//
// Internal implementation predicates
//

private predicate allSpecifiers(int i, string s) {
  s = rank[i](string t | specifiers(_, t) | t)
}

private predicate internalSpecString(Type t, string res, int i) {
     (if allSpecifiers(i, t.getASpecifier().getName())
      then exists(string spec, string rest
                | allSpecifiers(i, spec) and res = spec + " " + rest
              and internalSpecString(t, rest, i+1))
      else (allSpecifiers(i, _) and internalSpecString(t, res, i+1)))
  or (i = count(Specifier s) + 1 and res = "")
}

private predicate suppressUnusedThis(Type t) { any() }

/** A source code location referring to a type */
class TypeMention extends Locatable, @type_mention {
  override string toString() {result = "type mention"}
  
  override string getCanonicalQLClass() { result = "TypeMention" }
  
  /**
   * Gets the type being referenced by this type mention.
   */
  Type getMentionedType() { type_mentions(underlyingElement(this), unresolveElement(result), _, _) }
  
  override Location getLocation() { type_mentions(underlyingElement(this), _, result, _)}
}
