/**
 * Provides classes representing various types.
 */

private import CIL
private import dotnet

/** A type parameter. */
deprecated class TypeParameter extends DotNet::TypeParameter, Type, @cil_typeparameter {
  override int getIndex() { cil_type_parameter(_, result, this) }

  /** Gets the generic type/method declaring this type parameter. */
  TypeContainer getGeneric() { cil_type_parameter(result, _, this) }

  override Location getLocation() { result = this.getParent().getLocation() }

  /** Holds if this type parameter has the `new` constraint. */
  predicate isDefaultConstructible() { cil_typeparam_new(this) }

  /** Holds if this type parameter has the `struct` constraint. */
  predicate isStruct() { cil_typeparam_struct(this) }

  override predicate isClass() { cil_typeparam_class(this) }

  /** Holds if this type parameter is covariant/is `in`. */
  predicate isCovariant() { cil_typeparam_covariant(this) }

  /** Holds if this type parameter is contravariant/is `out`. */
  predicate isContravariant() { cil_typeparam_contravariant(this) }

  /** Gets a type constraint on this type parameter, if any. */
  Type getATypeConstraint() { cil_typeparam_constraint(this, result) }
}

/** A value or reference type. */
deprecated class ValueOrRefType extends DotNet::ValueOrRefType, Type, @cil_valueorreftype {
  override ValueOrRefType getDeclaringType() { result = this.getParent() }

  override string getUndecoratedName() { cil_type(this, result, _, _, _) }

  override Namespace getDeclaringNamespace() { result = this.getNamespace() }

  override ValueOrRefType getABaseType() { result = Type.super.getABaseType() }
}

/** An `enum`. */
deprecated class Enum extends ValueOrRefType {
  Enum() { this.isEnum() }

  override IntegralType getUnderlyingType() {
    cil_enum_underlying_type(this, result)
    or
    not cil_enum_underlying_type(this, _) and
    result instanceof IntType
  }
}

/** A `class`. */
deprecated class Class extends ValueOrRefType {
  Class() { this.isClass() }
}

/** An `interface`. */
deprecated class Interface extends ValueOrRefType {
  Interface() { this.isInterface() }
}

/** An array. */
deprecated class ArrayType extends DotNet::ArrayType, Type, @cil_array_type {
  override Type getElementType() { cil_array_type(this, result, _) }

  /** Gets the rank of this array. */
  int getRank() { cil_array_type(this, _, result) }

  override string toStringWithTypes() { result = DotNet::ArrayType.super.toStringWithTypes() }

  override Location getLocation() { result = this.getElementType().getLocation() }

  override ValueOrRefType getABaseType() { result = Type.super.getABaseType() }
}

/** A pointer type. */
deprecated class PointerType extends DotNet::PointerType, PrimitiveType, @cil_pointer_type {
  override Type getReferentType() { cil_pointer_type(this, result) }

  override IntType getUnderlyingType() { any() }

  override string getName() { result = DotNet::PointerType.super.getName() }

  override Location getLocation() { result = this.getReferentType().getLocation() }

  override string toString() { result = DotNet::PointerType.super.toString() }

  override string toStringWithTypes() { result = DotNet::PointerType.super.toStringWithTypes() }
}

/** A primitive type, built into the runtime. */
abstract deprecated class PrimitiveType extends Type { }

/**
 * A primitive numeric type.
 * Either an integral type (`IntegralType`) or a floating point type (`FloatingPointType`).
 */
abstract deprecated class NumericType extends PrimitiveType, ValueOrRefType { }

/** A floating point type. Either single precision (`FloatType`) or double precision (`DoubleType`). */
abstract deprecated class FloatingPointType extends NumericType { }

/**
 * An integral numeric type. Either a signed integral type (`SignedIntegralType`)
 * or an unsigned integral type (`UnsignedIntegralType`).
 */
abstract deprecated class IntegralType extends NumericType { }

/** A signed integral type. */
abstract deprecated class SignedIntegralType extends IntegralType { }

/** An unsigned integral type. */
abstract deprecated class UnsignedIntegralType extends IntegralType { }

/** The `void` type, `System.Void`. */
deprecated class VoidType extends PrimitiveType {
  VoidType() { this.isSystemType("Void") }

  override string toString() { result = "void" }

  override string toStringWithTypes() { result = "void" }
}

/** The type `System.Int32`. */
deprecated class IntType extends SignedIntegralType {
  IntType() { this.isSystemType("Int32") }

  override string toStringWithTypes() { result = "int" }

  override int getConversionIndex() { result = 8 }

  override IntType getUnderlyingType() { result = this }
}

/** The type `System.IntPtr`. */
deprecated class IntPtrType extends PrimitiveType {
  IntPtrType() { this.isSystemType("IntPtr") }

  override IntType getUnderlyingType() { any() }
}

/** The type `System.UIntPtr`. */
deprecated class UIntPtrType extends PrimitiveType {
  UIntPtrType() { this.isSystemType("UIntPtr") }

  override IntType getUnderlyingType() { any() }
}

/** The type `System.UInt32`. */
deprecated class UIntType extends UnsignedIntegralType {
  UIntType() { this.isSystemType("UInt32") }

  override string toStringWithTypes() { result = "uint" }

  override int getConversionIndex() { result = 7 }

  override IntType getUnderlyingType() { any() }
}

/** The type `System.SByte`. */
deprecated class SByteType extends SignedIntegralType {
  SByteType() { this.isSystemType("SByte") }

  override string toStringWithTypes() { result = "sbyte" }

  override int getConversionIndex() { result = 2 }
}

/** The type `System.Byte`. */
deprecated class ByteType extends UnsignedIntegralType {
  ByteType() { this.isSystemType("Byte") }

  override string toStringWithTypes() { result = "byte" }

  override int getConversionIndex() { result = 1 }

  override SByteType getUnderlyingType() { any() }
}

/** The type `System.Int16`. */
deprecated class ShortType extends SignedIntegralType {
  ShortType() { this.isSystemType("Int16") }

  override string toStringWithTypes() { result = "short" }

  override int getConversionIndex() { result = 4 }
}

/** The type `System.UInt16`. */
deprecated class UShortType extends UnsignedIntegralType {
  UShortType() { this.isSystemType("UInt16") }

  override string toStringWithTypes() { result = "ushort" }

  override int getConversionIndex() { result = 3 }

  override ShortType getUnderlyingType() { any() }
}

/** The type `System.Int64`. */
deprecated class LongType extends SignedIntegralType {
  LongType() { this.isSystemType("Int64") }

  override string toStringWithTypes() { result = "long" }

  override int getConversionIndex() { result = 10 }
}

/** The type `System.UInt64`. */
deprecated class ULongType extends UnsignedIntegralType {
  ULongType() { this.isSystemType("UInt64") }

  override string toStringWithTypes() { result = "ulong" }

  override int getConversionIndex() { result = 9 }

  override LongType getUnderlyingType() { any() }
}

/** The type `System.Decimal`. */
deprecated class DecimalType extends SignedIntegralType {
  DecimalType() { this.isSystemType("Decimal") }

  override string toStringWithTypes() { result = "decimal" }

  override int getConversionIndex() { result = 13 }
}

/** The type `System.String`. */
deprecated class StringType extends PrimitiveType, ValueOrRefType {
  StringType() { this.isSystemType("String") }

  override string toStringWithTypes() { result = "string" }
}

/** The type `System.Object`. */
deprecated class ObjectType extends ValueOrRefType {
  ObjectType() { this.isSystemType("Object") }

  override string toStringWithTypes() { result = "object" }
}

/** The type `System.Boolean`. */
deprecated class BoolType extends PrimitiveType, ValueOrRefType {
  BoolType() { this.isSystemType("Boolean") }

  override string toStringWithTypes() { result = "bool" }

  override IntType getUnderlyingType() { any() }
}

/** The type `System.Double`. */
deprecated class DoubleType extends FloatingPointType {
  DoubleType() { this.isSystemType("Double") }

  override string toStringWithTypes() { result = "double" }

  override int getConversionIndex() { result = 12 }
}

/** The type `System.Single`. */
deprecated class FloatType extends FloatingPointType {
  FloatType() { this.isSystemType("Single") }

  override string toStringWithTypes() { result = "float" }

  override int getConversionIndex() { result = 4 }
}

/** The type `System.Char`. */
deprecated class CharType extends IntegralType {
  CharType() { this.isSystemType("Char") }

  override string toStringWithTypes() { result = "char" }

  override int getConversionIndex() { result = 6 }

  override IntType getUnderlyingType() { any() }
}

/** The type `System.Type`. */
deprecated class SystemType extends ValueOrRefType {
  SystemType() { this.isSystemType("Type") }
}

/**
 * A function pointer type, for example
 *
 * ```csharp
 * delegate*<int, void>
 * ```
 */
deprecated class FunctionPointerType extends Type, CustomModifierReceiver, Parameterizable,
  @cil_function_pointer_type
{
  /** Gets the return type of this function pointer. */
  Type getReturnType() { cil_function_pointer_return_type(this, result) }

  /** Gets the calling convention. */
  int getCallingConvention() { cil_function_pointer_calling_conventions(this, result) }

  /** Holds if the return type is `void`. */
  predicate returnsVoid() { this.getReturnType() instanceof VoidType }

  /** Gets the number of stack items pushed in a call to this method. */
  int getCallPushCount() { if this.returnsVoid() then result = 0 else result = 1 }

  /** Gets the number of stack items popped in a call to this method. */
  int getCallPopCount() { result = count(this.getRawParameter(_)) }

  override string getLabel() { result = this.getName() }
}
