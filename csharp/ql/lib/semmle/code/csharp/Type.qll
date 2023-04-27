/** Provides classes for types. */

import Callable
import Event
import Generics
import Location
import Namespace
import Property
private import Conversion
private import dotnet
private import semmle.code.csharp.metrics.Coupling
private import TypeRef
private import semmle.code.csharp.frameworks.System

/**
 * A type.
 *
 * Either a value or reference type (`ValueOrRefType`), the `void` type (`VoidType`),
 * a pointer type (`PointerType`), the arglist type (`ArglistType`), an unknown
 * type (`UnknownType`), or a type parameter (`TypeParameter`).
 */
class Type extends DotNet::Type, Member, TypeContainer, @type {
  override string getName() { types(this, _, result) }

  override Type getUnboundDeclaration() { result = this }

  /** Holds if this type is implicitly convertible to `that` type. */
  predicate isImplicitlyConvertibleTo(Type that) { implicitConversion(this, that) }

  override Location getALocation() { type_location(this, result) }

  override Type getChild(int n) { none() }

  override Type getAChild() { result = this.getChild(_) }

  /** Holds if this type contains one or more type parameters. */
  predicate containsTypeParameters() {
    this instanceof TypeParameter
    or
    not this instanceof UnboundGenericType and this.getAChild().containsTypeParameters()
  }

  /** Holds if this type is a reference type, or a type parameter that is a reference type. */
  predicate isRefType() { none() }

  /** Holds if this type is a value type, or a type parameter that is a value type. */
  predicate isValueType() { none() }
}

pragma[nomagic]
private predicate isObjectClass(Class c) { c instanceof ObjectType }

/**
 * A value or reference type.
 *
 * Either a value type (`ValueType`) or a reference type (`RefType`).
 */
class ValueOrRefType extends DotNet::ValueOrRefType, Type, Attributable, @value_or_ref_type {
  /**
   * Holds if this type has the qualified name `qualifier`.`name`.
   *
   * For example the class `System.IO.IOException` has
   * `qualifier`=`System.IO` and `name`=`IOException`.
   */
  override predicate hasQualifiedName(string qualifier, string name) {
    exists(string enclosing |
      this.getDeclaringType().hasQualifiedName(qualifier, enclosing) and
      name = enclosing + "+" + this.getUndecoratedName()
    )
    or
    not exists(this.getDeclaringType()) and
    qualifier = this.getNamespace().getFullName() and
    name = this.getUndecoratedName()
  }

  /** Gets the namespace containing this type. */
  Namespace getNamespace() {
    if exists(this.getDeclaringType())
    then result = this.getDeclaringType().getNamespace()
    else result.getATypeDeclaration() = this
  }

  override Namespace getDeclaringNamespace() { this = result.getATypeDeclaration() }

  override ValueOrRefType getDeclaringType() { none() }

  override string getUndecoratedName() { types(this, _, result) }

  /** Gets a nested child type, if any. */
  NestedType getAChildType() { nested_types(result, this, _) }

  /**
   * Gets the source namespace declaration in which this type is declared, if any.
   * This only holds for non-nested types.
   *
   * In the following example, only the class `C2` has a parent namespace declaration
   * returned by `getParentNamespaceDeclaration`.
   *
   * ```csharp
   * class C1 { ... }
   *
   * namespace N {
   *   class C2 {
   *     class C3 { ... }
   *   }
   * }
   * ```
   */
  NamespaceDeclaration getParentNamespaceDeclaration() {
    parent_namespace_declaration(this, result)
  }

  /** Gets the immediate base class of this class, if any. */
  final Class getBaseClass() {
    extend(this, getTypeRef(result))
    or
    not extend(this, _) and
    not isObjectClass(this) and
    not this instanceof DynamicType and
    not this instanceof NullType and
    isObjectClass(result)
  }

  /** Gets an immediate base interface of this type, if any. */
  Interface getABaseInterface() { implement(this, getTypeRef(result)) }

  /** Gets an immediate base type of this type, if any. */
  override ValueOrRefType getABaseType() {
    result = this.getBaseClass() or
    result = this.getABaseInterface()
  }

  /** Gets an immediate subtype of this type, if any. */
  ValueOrRefType getASubType() { result.getABaseType() = this }

  /** Gets a member of this type, if any. */
  Member getAMember() { result.getDeclaringType() = this }

  /** Gets a member of this type with the given name. */
  Member getAMember(string name) {
    result.getDeclaringType() = this and
    result.hasName(name)
  }

  /**
   * Holds if this type has method `m`, that is, either `m` is declared in this
   * type, or `m` is inherited by this type.
   *
   * For example, `C` has the methods `A.M1()`, `B.M3()`, and `C.M4()` in
   *
   * ```csharp
   * class A {
   *   public void M1() { }
   *   private void M2() { }
   *   public virtual void M3() { }
   * }
   *
   * class B : A {
   *   public override void M3() { }
   * }
   *
   * class C : B {
   *   void M4() { }
   * }
   * ```
   */
  pragma[inline]
  predicate hasMethod(Method m) { this.hasMember(m) }

  /**
   * Holds if this type has callable `c`, that is, either `c` is declared in this
   * type, or `c` is inherited by this type.
   *
   * For example, `C` has the callables `A.get_P1`, `A.set_P1`, `A.M2()`, `B.get_P2`,
   * `B.set_P2`, and `C.M3()` in
   *
   * ```csharp
   * class A {
   *   public int P1 { get; set; }
   *   public virtual int P2 { get; set; }
   *   private void M1() { }
   *   protected void M2() { }
   * }
   *
   * class B : A {
   *   public override int P2 { get; set; }
   * }
   *
   * class C : B {
   *   private void M3() { }
   * }
   * ```
   */
  pragma[inline]
  predicate hasCallable(Callable c) {
    this.hasMethod(c)
    or
    this.hasMember(c.(Accessor).getDeclaration())
  }

  /**
   * Holds if this type has member `m`, that is, either `m` is declared in this
   * type, or `m` is inherited by this type.
   *
   * For example, `C` has the members `A.P1`, `A.M2()`, `B.P2`, and `C.M3()` in
   *
   * ```csharp
   * class A {
   *   public int P1 { get; set; }
   *   public virtual int P2 { get; set; }
   *   private void M1() { }
   *   protected void M2() { }
   * }
   *
   * class B : A {
   *   public override int P2 { get; set; }
   * }
   *
   * class C : B {
   *   private void M3() { }
   * }
   * ```
   */
  pragma[inline]
  predicate hasMember(Member m) {
    m = this.getAMember()
    or
    hasNonOverriddenMember(this.getBaseClass+(), m)
    or
    this.hasOverriddenMember(m)
  }

  cached
  private predicate hasOverriddenMember(Virtualizable v) {
    v.isOverridden() and
    v = this.getAMember()
    or
    this.getBaseClass().(ValueOrRefType).hasOverriddenMember(v) and
    not v.isPrivate() and
    not this.memberOverrides(v)
  }

  // Predicate folding for proper join-order
  pragma[noinline]
  private predicate memberOverrides(Virtualizable v) {
    this.getAMember().(Virtualizable).getOverridee() = v
  }

  /** Gets a field (or member constant) with the given name. */
  Field getField(string name) { result = this.getAMember() and result.hasName(name) }

  /** Gets a field (or member constant) of this type, if any. */
  Field getAField() { result = this.getField(_) }

  /** Gets a member constant of this type, if any. */
  MemberConstant getAConstant() { result = this.getAMember() }

  /** Gets a method of this type, if any. */
  Method getAMethod() { result = this.getAMember() }

  /** Gets a method of this type with the given name. */
  Method getAMethod(string name) { result = this.getAMember() and result.hasName(name) }

  /** Gets a property of this type, if any. */
  Property getAProperty() { result = this.getAMember() }

  /** Gets a named property of this type. */
  Property getProperty(string name) { result = this.getAMember() and result.hasName(name) }

  /** Gets an indexer of this type, if any. */
  Indexer getAnIndexer() { result = this.getAMember() }

  /** Gets an event of this type, if any. */
  Event getAnEvent() { result = this.getAMember() }

  /** Gets a user-defined operator of this type, if any. */
  Operator getAnOperator() { result = this.getAMember() }

  /** Gets a static or instance constructor of this type, if any. */
  Constructor getAConstructor() { result = this.getAMember() }

  /** Gets the static constructor of this type, if any. */
  StaticConstructor getStaticConstructor() { result = this.getAMember() }

  /** Gets a nested type of this type, if any. */
  NestedType getANestedType() { result = this.getAMember() }

  /** Gets the number of types that directly depend on this type. */
  int getAfferentCoupling() { afferentCoupling(this, result) }

  /** Gets the number of types that this type directly depends upon. */
  int getEfferentCoupling() { efferentCoupling(this, result) }

  /** Gets the length of *some* path to the root of the hierarchy. */
  int getADepth() {
    this.hasQualifiedName("System", "Object") and result = 0
    or
    result = this.getABaseType().getADepth() + 1 and
    //prevent recursion on cyclic inheritance (only for incorrect databases)
    not this = this.getABaseType+()
  }

  /**
   * Gets the depth of inheritance, which is the maximum distance from
   * `object` in the type hierarchy. Types that are very deeply nested
   * may be difficult to maintain.
   */
  int getInheritanceDepth() { result = max(this.getADepth()) }

  /** Gets the number of (direct or indirect) base types. */
  int getNumberOfAncestors() { result = count(this.getABaseType+()) }

  /**
   * Gets the Henderson-Sellers lack of cohesion metric.
   *
   * This is defined as `(r-M)/(1-M)`, where `M` is the total
   * number of methods in this class, and `r` is the average
   * number of methods that access each field in this type.
   *
   * Types with a high Henderson-Sellers metric have methods
   * which access many fields, and can be a maintainability problem.
   */
  float getLackOfCohesionHS() { lackOfCohesionHS(this, result) }

  /**
   * Gets the Chidamber and Kemerer lack of cohesion metric.
   *
   * This is defined as  as the number of pairs of methods in this type that do not
   * have at least one field in common, minus the number of pairs of methods in
   * this type that do share at least one field. When this value is negative,
   * the metric value is set to 0.
   *
   * Types with a high Chidamber and Kemerer metric have multiple
   * responsibilities so could be refactored.
   */
  float getLackOfCohesionCK() { lackOfCohesionCK(this, result) }

  /**
   * Gets the *response* of this type, which is defined as the total number
   * of callables invoked by this type. This is computed as the total number of
   * calls made by callables in this type, excluding member accesses.
   */
  int getResponse() {
    result =
      sum(Callable c |
        c.getDeclaringType() = this
      |
        count(Call call |
            call.getEnclosingCallable() = c and
            not call instanceof MemberAccess // property, indexer, and event accesses are not counted
          )
      )
  }

  /** Gets the number of callables in this type. */
  int getNumberOfCallables() { result = count(Callable c | this.getAMember() = c) }

  override ValueOrRefType getUnboundDeclaration() {
    result = this and
    not this instanceof NestedType
    or
    // We must use `nested_types` here, rather than overriding `getUnboundDeclaration`
    // in the class `NestedType` below. Otherwise, the overrides in `UnboundGenericType`
    // and its subclasses will not work
    nested_types(this, _, result)
  }

  override predicate isRecord() { this.hasModifier("record") }

  override string toString() { result = Type.super.toString() }
}

/**
 * A nested type, for example `class B` in
 *
 * ```csharp
 * class A {
 *   class B {
 *     ...
 *   }
 * }
 * ```
 */
class NestedType extends ValueOrRefType {
  NestedType() { nested_types(this, _, _) }

  override ValueOrRefType getDeclaringType() { nested_types(this, result, _) }
}

/**
 * A non-nested type, that is declared directly in a namespace.
 */
class NonNestedType extends ValueOrRefType {
  NonNestedType() { exists(Namespace n | parent_namespace(this, n)) }
}

/**
 * The `void` type.
 */
class VoidType extends DotNet::ValueOrRefType, Type, @void_type {
  override predicate hasQualifiedName(string qualifier, string name) {
    qualifier = "System" and
    name = "Void"
  }

  final override string getName() { result = "Void" }

  final override string getUndecoratedName() { result = "Void" }

  override SystemNamespace getDeclaringNamespace() { any() }

  override string getAPrimaryQlClass() { result = "VoidType" }
}

/**
 * A value type.
 *
 * Either a simple type (`SimpleType`), an `enum` (`Enum`), a `struct` (`Struct`),
 * or a nullable type (`NullableType`).
 */
class ValueType extends ValueOrRefType, @value_type {
  override predicate isValueType() { any() }
}

/**
 * A simple type. Simple types in C# are predefined `struct` types.
 * Here, however, they are not modeled as such, and we reserve the
 * notion of `struct`s to user-defined `struct`s.
 *
 * Either a Boolean type (`BoolType`), a character type (`CharType`),
 * an integral type (`IntegralType`), a floating point type
 * (`FloatingPointType`), or a decimal type (`DecimalType`).
 */
class SimpleType extends ValueType, @simple_type {
  /** Gets the size of this type, in bytes. */
  int getSize() { none() }

  /** Gets the minimum integral value of this type, if any. */
  int minValue() { none() }

  /** Gets the maximum integral value of this type, if any. */
  int maxValue() { none() }

  override SystemNamespace getDeclaringNamespace() { any() }
}

/**
 * A `record` like type.
 * This can be either a `class` or a `struct`.
 */
class RecordType extends ValueOrRefType {
  RecordType() { this.isRecord() }
}

/**
 * The Boolean type, `bool`.
 */
class BoolType extends SimpleType, @bool_type {
  override string toStringWithTypes() { result = "bool" }

  override int getSize() { result = 1 }

  override string getAPrimaryQlClass() { result = "BoolType" }
}

/**
 * The Unicode character type, `char`.
 */
class CharType extends SimpleType, @char_type {
  override string toStringWithTypes() { result = "char" }

  override int getSize() { result = 2 }

  override int minValue() { result = 0 }

  override int maxValue() { result = 65535 }

  override string getAPrimaryQlClass() { result = "CharType" }
}

/**
 * An integral type.
 *
 * Either a signed integral type (`SignedIntegralType`) or an unsigned integral type
 * (`UnsignedIntegralType`).
 */
class IntegralType extends SimpleType, @integral_type { }

/**
 * An unsigned integral type.
 *
 * Either a `byte` (`ByteType`), a `ushort` (`UShortType`), a `uint` (`UIntType`),
 * or a `ulong` (`ULongType`).
 */
class UnsignedIntegralType extends IntegralType, @unsigned_integral_type {
  override int minValue() { result = 0 }
}

/**
 * A signed integral type.
 *
 * Either an `sbyte` (`SByteType`), a `short` (`ShortType`), an `int`
 * (`IntType`), or a `long` (`LongType`).
 */
class SignedIntegralType extends IntegralType, @signed_integral_type { }

/**
 * The signed byte type, `sbyte`.
 */
class SByteType extends SignedIntegralType, @sbyte_type {
  override string toStringWithTypes() { result = "sbyte" }

  override int getSize() { result = 1 }

  override int minValue() { result = -128 }

  override int maxValue() { result = 127 }

  override string getAPrimaryQlClass() { result = "SByteType" }
}

/**
 * The `short` type.
 */
class ShortType extends SignedIntegralType, @short_type {
  override string toStringWithTypes() { result = "short" }

  override int getSize() { result = 2 }

  override int minValue() { result = -32768 }

  override int maxValue() { result = 32767 }

  override string getAPrimaryQlClass() { result = "ShortType" }
}

/**
 * The `int` type.
 */
class IntType extends SignedIntegralType, @int_type {
  override string toStringWithTypes() { result = "int" }

  override int getSize() { result = 4 }

  override int minValue() { result = -2147483647 - 1 }

  override int maxValue() { result = 2147483647 }

  override string getAPrimaryQlClass() { result = "IntType" }
}

/**
 * The `long` type.
 */
class LongType extends SignedIntegralType, @long_type {
  override string toStringWithTypes() { result = "long" }

  override int getSize() { result = 8 }

  override string getAPrimaryQlClass() { result = "LongType" }
}

/**
 * The `byte` type.
 */
class ByteType extends UnsignedIntegralType, @byte_type {
  override string toStringWithTypes() { result = "byte" }

  override int getSize() { result = 1 }

  override int maxValue() { result = 255 }

  override string getAPrimaryQlClass() { result = "ByteType" }
}

/**
 * The unsigned short type, `ushort`.
 */
class UShortType extends UnsignedIntegralType, @ushort_type {
  override string toStringWithTypes() { result = "ushort" }

  override int getSize() { result = 2 }

  override int maxValue() { result = 65535 }

  override string getAPrimaryQlClass() { result = "UShortType" }
}

/**
 * The unsigned int type, `uint`.
 */
class UIntType extends UnsignedIntegralType, @uint_type {
  override string toStringWithTypes() { result = "uint" }

  override int getSize() { result = 4 }

  override string getAPrimaryQlClass() { result = "UIntType" }
}

/**
 * The unsigned long type, `ulong`.
 */
class ULongType extends UnsignedIntegralType, @ulong_type {
  override string toStringWithTypes() { result = "ulong" }

  override int getSize() { result = 8 }

  override string getAPrimaryQlClass() { result = "ULongType" }
}

/**
 * A floating point type.
 *
 * Either a `float` (`FloatType`) or a `double` (`DoubleType`).
 */
class FloatingPointType extends SimpleType, @floating_point_type { }

/**
 * The `float` type.
 */
class FloatType extends FloatingPointType, @float_type {
  override string toStringWithTypes() { result = "float" }

  override int getSize() { result = 4 }

  override string getAPrimaryQlClass() { result = "FloatType" }
}

/**
 * The `double` type.
 */
class DoubleType extends FloatingPointType, @double_type {
  override string toStringWithTypes() { result = "double" }

  override int getSize() { result = 8 }

  override string getAPrimaryQlClass() { result = "DoubleType" }
}

/**
 * The high-precision decimal type, `decimal`.
 */
class DecimalType extends SimpleType, @decimal_type {
  override string toStringWithTypes() { result = "decimal" }

  override int getSize() { result = 16 }

  override string getAPrimaryQlClass() { result = "DecimalType" }
}

/**
 * An `enum`. For example
 *
 * ```csharp
 * enum Parity {
 *   Even,
 *   Odd
 * }
 * ```
 */
class Enum extends ValueType, @enum_type {
  /**
   * Gets the underlying integral type of this enum, not to be confused with
   * its base type which is always `System.Enum`.
   *
   * For example, the underlying type of `Parity` is `int` in
   *
   * ```csharp
   * enum Parity : int {
   *   Even,
   *   Odd
   * }
   * ```
   */
  IntegralType getUnderlyingType() { enum_underlying_type(this, getTypeRef(result)) }

  /**
   * Gets an `enum` constant declared in this `enum`, for example `Even`
   * and `Odd` in
   *
   * ```csharp
   * enum Parity : int {
   *   Even,
   *   Odd
   * }
   * ```
   */
  EnumConstant getAnEnumConstant() { result.getDeclaringEnum() = this }

  /** Gets the `enum` constant with the given value `value`. */
  EnumConstant getEnumConstant(string value) {
    result = this.getAnEnumConstant() and result.getValue() = value
  }

  override string getAPrimaryQlClass() { result = "Enum" }
}

/**
 * A `struct`, for example
 *
 * ```csharp
 * struct S {
 *   ...
 * }
 * ```
 */
class Struct extends ValueType, @struct_type {
  /** Holds if this `struct` has a `ref` modifier. */
  predicate isRef() { this.hasModifier("ref") }

  /** Holds if this `struct` has a `readonly` modifier. */
  predicate isReadonly() { this.hasModifier("readonly") }

  override string getAPrimaryQlClass() { result = "Struct" }
}

/**
 * A `record struct`, for example
 * ```csharp
 * record struct RS {
 *   ...
 * }
 * ```
 */
class RecordStruct extends RecordType, Struct {
  override string getAPrimaryQlClass() { result = "RecordStruct" }
}

/**
 * A reference type.
 *
 * Either a `class` (`Class`), an `interface` (`Interface`), a `delegate` (`DelegateType`),
 * `null` (`NullType`), `dynamic` (`DynamicType`), or an array (`ArrayType`).
 */
class RefType extends ValueOrRefType, @ref_type {
  /** Gets the number of overridden methods (NORM) of this reference type. */
  int getNumberOverridden() { result = count(this.getAnOverrider()) }

  /** Gets a member that overrides a non-abstract member in a super type, if any. */
  private Virtualizable getAnOverrider() {
    this.getAMember() = result and
    exists(Virtualizable v | result.getOverridee() = v and not v.isAbstract())
  }

  /**
   * Gets the specialization index of this type.
   *
   * This is defined as the proportion of overridden methods multiplied
   * by the inheritance depth of this type.
   *
   * This measures the inheritance complexity of this type.
   */
  float getSpecialisationIndex() {
    this.getNumberOfCallables() != 0 and
    result =
      (this.getNumberOverridden() * this.getInheritanceDepth()) /
        this.getNumberOfCallables().(float)
  }

  override predicate isRefType() { any() }
}

pragma[noinline]
private predicate hasNonOverriddenMember(Class c, Member m) {
  m = c.getAMember() and
  not m.(Virtualizable).isOverridden() and
  not m.isPrivate()
}

/**
 * A `class`, for example
 *
 * ```csharp
 * class C {
 *   ...
 * }
 * ```
 */
class Class extends RefType, @class_type {
  override string getAPrimaryQlClass() { result = "Class" }
}

/**
 * DEPRECATED: Use `RecordClass` instead.
 */
deprecated class Record extends Class {
  Record() { this.isRecord() }

  /** Gets the clone method of this record. */
  RecordCloneMethod getCloneMethod() { result = this.getAMember() }
}

/**
 * A `record`, for example
 *
 * ```csharp
 * record R(object Prop) {
 *   ...
 * }
 * ```
 */
class RecordClass extends RecordType, Class {
  /** Gets the clone method of this record. */
  RecordCloneMethod getCloneMethod() { result = this.getAMember() }

  override string getAPrimaryQlClass() { result = "RecordClass" }
}

/**
 * A class generated by the compiler from an anonymous object creation.
 *
 * For example, the class with fields `X` and `Y` in
 *
 * ```csharp
 * new { X = 0, Y = 0 };
 * ```
 */
class AnonymousClass extends Class {
  AnonymousClass() { anonymous_types(this) }

  override string getAPrimaryQlClass() { result = "AnonymousClass" }
}

/**
 * The `object` type, `System.Object`.
 */
class ObjectType extends Class {
  ObjectType() { this.hasQualifiedName("System", "Object") }

  override string toStringWithTypes() { result = "object" }

  override string getAPrimaryQlClass() { result = "ObjectType" }
}

/**
 * The `string` type, `System.String`.
 */
class StringType extends Class {
  StringType() { this.hasQualifiedName("System", "String") }

  override string toStringWithTypes() { result = "string" }

  override string getAPrimaryQlClass() { result = "StringType" }
}

/**
 * An `interface`, for example
 *
 * ```csharp
 * interface I {
 *   ...
 * }
 * ```
 */
class Interface extends RefType, @interface_type {
  override string getAPrimaryQlClass() { result = "Interface" }
}

/**
 * A `delegate` type, for example
 *
 * ```csharp
 * delegate int D(int p);
 * ```
 */
class DelegateType extends RefType, Parameterizable, @delegate_type {
  /** Gets the return type of this delegate. */
  Type getReturnType() { delegate_return_type(this, getTypeRef(result)) }

  /** Gets the annotated return type of this delegate. */
  AnnotatedType getAnnotatedReturnType() { result.appliesTo(this) }

  override string getAPrimaryQlClass() { result = "DelegateType" }
}

private newtype TCallingConvention =
  MkCallingConvention(int i) { function_pointer_calling_conventions(_, i) }

/**
 * A signature representing a calling convention. Specifies how arguments in a given
 * signature are passed from the caller to the callee.
 */
class CallingConvention extends TCallingConvention {
  /** Gets a textual representation of this calling convention. */
  string toString() { result = "CallingConvention" }
}

/** A managed calling convention with fixed-length argument list. */
class DefaultCallingConvention extends CallingConvention {
  DefaultCallingConvention() { this = MkCallingConvention(0) }

  override string toString() { result = "DefaultCallingConvention" }
}

/** An unmanaged C/C++-style calling convention where the call stack is cleaned by the caller. */
class CDeclCallingConvention extends CallingConvention {
  CDeclCallingConvention() { this = MkCallingConvention(1) }

  override string toString() { result = "CDeclCallingConvention" }
}

/** An unmanaged calling convention where call stack is cleaned up by the callee. */
class StdCallCallingConvention extends CallingConvention {
  StdCallCallingConvention() { this = MkCallingConvention(2) }

  override string toString() { result = "StdCallCallingConvention" }
}

/**
 * An unmanaged C++-style calling convention for calling instance member functions
 * with a fixed argument list.
 */
class ThisCallCallingConvention extends CallingConvention {
  ThisCallCallingConvention() { this = MkCallingConvention(3) }

  override string toString() { result = "ThisCallCallingConvention" }
}

/** An unmanaged calling convention where arguments are passed in registers when possible. */
class FastCallCallingConvention extends CallingConvention {
  FastCallCallingConvention() { this = MkCallingConvention(4) }

  override string toString() { result = "FastCallCallingConvention" }
}

/** A managed calling convention for passing extra arguments. */
class VarArgsCallingConvention extends CallingConvention {
  VarArgsCallingConvention() { this = MkCallingConvention(5) }

  override string toString() { result = "VarArgsCallingConvention" }
}

/**
 * An unmanaged calling convention that indicates that the specifics
 * are encoded as modopts.
 */
class UnmanagedCallingConvention extends CallingConvention {
  UnmanagedCallingConvention() { this = MkCallingConvention(9) }

  override string toString() { result = "UnmanagedCallingConvention" }
}

/**
 * A function pointer type, for example
 *
 * ```csharp
 * delegate*<int, void>
 * ```
 */
class FunctionPointerType extends Type, Parameterizable, @function_pointer_type {
  /** Gets the return type of this function pointer. */
  Type getReturnType() { function_pointer_return_type(this, getTypeRef(result)) }

  /** Gets the calling convention. */
  CallingConvention getCallingConvention() {
    exists(int i |
      function_pointer_calling_conventions(this, i) and result = MkCallingConvention(i)
    )
  }

  /** Gets the unmanaged calling convention at index `i`. */
  Type getUnmanagedCallingConvention(int i) {
    has_unmanaged_calling_conventions(this, i, getTypeRef(result))
  }

  /** Gets an unmanaged calling convention. */
  Type getAnUnmanagedCallingConvention() { result = this.getUnmanagedCallingConvention(_) }

  /** Gets the annotated return type of this function pointer type. */
  AnnotatedType getAnnotatedReturnType() { result.appliesTo(this) }

  override string getAPrimaryQlClass() { result = "FunctionPointerType" }

  override string getLabel() { result = this.getName() }
}

/**
 * The `null` type. The type of the `null` literal.
 */
class NullType extends RefType, @null_type {
  override string getAPrimaryQlClass() { result = "NullType" }
}

/**
 * A nullable type, for example `int?`.
 */
class NullableType extends ValueType, DotNet::ConstructedGeneric, @nullable_type {
  /**
   * Gets the underlying value type of this nullable type.
   * For example `int` in `int?`.
   */
  Type getUnderlyingType() { nullable_underlying_type(this, getTypeRef(result)) }

  override string toStringWithTypes() {
    result = this.getUnderlyingType().toStringWithTypes() + "?"
  }

  override Type getChild(int n) { result = this.getUnderlyingType() and n = 0 }

  override Location getALocation() { result = this.getUnderlyingType().getALocation() }

  override Type getTypeArgument(int p) { p = 0 and result = this.getUnderlyingType() }

  override string getAPrimaryQlClass() { result = "NullableType" }

  final override string getName() {
    result = "Nullable<" + this.getUnderlyingType().getName() + ">"
  }

  final override predicate hasQualifiedName(string qualifier, string name) {
    qualifier = "System" and
    name = "Nullable<" + this.getUnderlyingType().getQualifiedName() + ">"
  }
}

/**
 * An array type, for example `int[]`.
 */
class ArrayType extends DotNet::ArrayType, RefType, @array_type {
  /**
   * Gets the dimension of this array type. For example `int[][]` is of
   * dimension 2, while `int[]` is of dimension 1.
   */
  int getDimension() { array_element_type(this, result, _, _) }

  /**
   * Gets the rank of this array type. For example `int[,]` is of
   * rank 2, while `int[]` is of rank 1.
   */
  int getRank() { array_element_type(this, _, result, _) }

  /** Holds if this array is multi-dimensional. */
  predicate isMultiDimensional() { this.getRank() > 1 }

  /** Gets the element type of this array, for example `int` in `int[]`. */
  override Type getElementType() { array_element_type(this, _, _, getTypeRef(result)) }

  /** Holds if this array type has the same shape (dimension and rank) as `that` array type. */
  predicate hasSameShapeAs(ArrayType that) {
    this.getDimension() = that.getDimension() and
    this.getRank() = that.getRank()
  }

  /**
   * INTERNAL: Do not use.
   * Gets a string representing the array suffix, for example `[,,,]`.
   */
  string getArraySuffix() {
    result = "[" + concat(int i | i in [0 .. this.getRank() - 2] | ",") + "]"
  }

  private string getDimensionString(Type elementType) {
    exists(Type et, string res |
      et = this.getElementType() and
      res = this.getArraySuffix() and
      if et instanceof ArrayType
      then result = res + et.(ArrayType).getDimensionString(elementType)
      else (
        result = res and elementType = et
      )
    )
  }

  override string toStringWithTypes() {
    exists(Type elementType |
      result = elementType.toString() + this.getDimensionString(elementType)
    )
  }

  override Type getChild(int n) { result = this.getElementType() and n = 0 }

  override Location getALocation() {
    type_location(this, result)
    or
    not type_location(this, _) and
    result = this.getElementType().getALocation()
  }

  final override predicate hasQualifiedName(string qualifier, string name) {
    exists(Type elementType, string name0 |
      elementType.hasQualifiedName(qualifier, name0) and
      name = name0 + this.getDimensionString(elementType)
    )
  }
}

/**
 * A pointer type, for example `char*`.
 */
class PointerType extends DotNet::PointerType, Type, @pointer_type {
  override Type getReferentType() { pointer_referent_type(this, getTypeRef(result)) }

  override string toStringWithTypes() { result = DotNet::PointerType.super.toStringWithTypes() }

  override Type getChild(int n) { result = this.getReferentType() and n = 0 }

  final override string getName() { types(this, _, result) }

  final override string getUndecoratedName() {
    result = this.getReferentType().getUndecoratedName()
  }

  override Location getALocation() { result = this.getReferentType().getALocation() }

  override string toString() { result = DotNet::PointerType.super.toString() }

  override string getAPrimaryQlClass() { result = "PointerType" }

  final override predicate hasQualifiedName(string qualifier, string name) {
    exists(string name0 |
      this.getReferentType().hasQualifiedName(qualifier, name0) and
      name = name0 + "*"
    )
  }
}

/**
 * The `dynamic` type.
 */
class DynamicType extends RefType, @dynamic_type {
  override string toStringWithTypes() { result = "dynamic" }

  override string getAPrimaryQlClass() { result = "DynamicType" }
}

/**
 * The `__arglist` type, modeling varargs invocation in C++.
 */
class ArglistType extends Type, @arglist_type {
  override string toStringWithTypes() { result = "__arglist" }

  override string getAPrimaryQlClass() { result = "ArglistType" }
}

/**
 * A type that could not be resolved. This could happen if an indirect reference
 * is not available at compilation time.
 */
class UnknownType extends Type, @unknown_type { }

/**
 * A type representing a tuple. For example, `(int, bool, string)`.
 */
class TupleType extends ValueType, @tuple_type {
  /** Gets the underlying type of this tuple, which is of type `System.ValueTuple`. */
  Struct getUnderlyingType() { tuple_underlying_type(this, getTypeRef(result)) }

  /**
   * Gets the `n`th element of this tuple, indexed from 0.
   * For example, the 0th (first) element of `(int, string)` is the field `Item1 int`.
   */
  Field getElement(int n) { tuple_element(this, n, result) }

  /**
   * Gets the type of the `n`th element of this tuple, indexed from 0.
   * For example, the 0th (first) element type of `(int, string)` is `int`.
   */
  Type getElementType(int n) { result = this.getElement(n).getType() }

  /** Gets an element of this tuple. */
  Field getAnElement() { result = this.getElement(_) }

  override Location getALocation() { type_location(this, result) }

  /**
   * Gets the arity of this tuple. For example, the arity of
   * `(int, int, double)` is 3.
   */
  int getArity() { result = count(this.getAnElement()) }

  language[monotonicAggregates]
  override string toStringWithTypes() {
    result =
      "(" +
        concat(Type t, int i |
          t = this.getElement(i).getType()
        |
          t.toStringWithTypes(), ", " order by i
        ) + ")"
  }

  language[monotonicAggregates]
  override string getName() {
    result =
      "(" + concat(Type t, int i | t = this.getElement(i).getType() | t.getName(), "," order by i) +
        ")"
  }

  override string getLabel() { result = this.getUnderlyingType().getLabel() }

  override Type getChild(int i) { result = this.getUnderlyingType().getChild(i) }

  final override predicate hasQualifiedName(string qualifier, string name) {
    this.getUnderlyingType().hasQualifiedName(qualifier, name)
  }

  override string getAPrimaryQlClass() { result = "TupleType" }
}

/**
 * A type mention, that is, any mention of a type in a source code file.
 * For example, `int` is mentioned in `int M() { return 1; }`.
 */
class TypeMention extends @type_mention {
  Type type;
  @type_mention_parent parent;

  TypeMention() { type_mention(this, getTypeRef(type), parent) }

  /** Gets the type being mentioned. */
  Type getType() { result = type }

  /**
   * Gets the element to which this type mention belongs, if any.
   * For example, `IEnumerable<int>` belongs to parameter `p` in
   *
   * ```csharp
   * void M(IEnumerable<int> p) { }
   * ```
   */
  Element getTarget() { result = parent }

  /**
   * Gets the parent of this type mention, if any.
   * For example, the parent of `int` is `IEnumerable<int>` in
   *
   * ```csharp
   * void M(IEnumerable<int> p) {
   *   ...
   * }
   * ```
   */
  TypeMention getParent() { result = parent }

  /** Gets a textual representation of this type mention. */
  string toString() { result = type.toString() }

  /** Gets the location of this type mention. */
  Location getLocation() { type_mention_location(this, result) }
}
