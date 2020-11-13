/** Provides definitions related to the namespace `System`. */

import csharp
private import system.Reflection

/** The `System` namespace. */
class SystemNamespace extends Namespace {
  SystemNamespace() {
    this.getParentNamespace() instanceof GlobalNamespace and
    this.hasName("System")
  }
}

/** A class in the `System` namespace. */
class SystemClass extends Class {
  SystemClass() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic class in the `System` namespace. */
class SystemUnboundGenericClass extends UnboundGenericClass {
  SystemUnboundGenericClass() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic struct in the `System` namespace. */
class SystemUnboundGenericStruct extends UnboundGenericStruct {
  SystemUnboundGenericStruct() { this.getNamespace() instanceof SystemNamespace }
}

/** An interface in the `System` namespace. */
class SystemInterface extends Interface {
  SystemInterface() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic interface in the `System` namespace. */
class SystemUnboundGenericInterface extends UnboundGenericInterface {
  SystemUnboundGenericInterface() { this.getNamespace() instanceof SystemNamespace }
}

/** A delegate type in the `System` namespace. */
class SystemDelegateType extends DelegateType {
  SystemDelegateType() { this.getNamespace() instanceof SystemNamespace }
}

/** An unbound generic delegate type in the `System` namespace. */
class SystemUnboundGenericDelegateType extends UnboundGenericDelegateType {
  SystemUnboundGenericDelegateType() { this.getNamespace() instanceof SystemNamespace }
}

/** The `System.Action` delegate type. */
class SystemActionDelegateType extends SystemDelegateType {
  SystemActionDelegateType() { this.getName() = "Action" }
}

/** The `System.Action<T1, ..., Tn>` delegate type. */
class SystemActionTDelegateType extends SystemUnboundGenericDelegateType {
  SystemActionTDelegateType() { this.getName().regexpMatch("Action<,*>") }
}

/** `System.Array` class. */
class SystemArrayClass extends SystemClass {
  SystemArrayClass() { this.hasName("Array") }

  /** Gets the `Length` property. */
  Property getLengthProperty() { result = this.getProperty("Length") }
}

/** `System.Attribute` class. */
class SystemAttributeClass extends SystemClass {
  SystemAttributeClass() { this.hasName("Attribute") }
}

/** The `System.Boolean` structure. */
class SystemBooleanStruct extends BoolType {
  /** Gets the `Parse(string)` method. */
  Method getParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `TryParse(string, out bool)` method. */
  Method getTryParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("TryParse") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(1).getType() instanceof BoolType and
    result.getReturnType() instanceof BoolType
  }
}

/** The `System.Convert` class. */
class SystemConvertClass extends SystemClass {
  SystemConvertClass() { this.hasName("Convert") }
}

/** `System.Delegate` class. */
class SystemDelegateClass extends SystemClass {
  SystemDelegateClass() { this.hasName("Delegate") }
}

/** The `System.DivideByZeroException` class. */
class SystemDivideByZeroExceptionClass extends SystemClass {
  SystemDivideByZeroExceptionClass() { this.hasName("DivideByZeroException") }
}

/** The `System.Enum` class. */
class SystemEnumClass extends SystemClass {
  SystemEnumClass() { this.hasName("Enum") }
}

/** The `System.Exception` class. */
class SystemExceptionClass extends SystemClass {
  SystemExceptionClass() { this.hasName("Exception") }
}

/** The `System.Func<T1, ..., Tn, TResult>` delegate type. */
class SystemFuncDelegateType extends SystemUnboundGenericDelegateType {
  SystemFuncDelegateType() { this.getName().regexpMatch("Func<,*>") }

  /** Gets one of the `Ti` input type parameters. */
  TypeParameter getAnInputTypeParameter() {
    exists(int i | i in [0 .. this.getNumberOfTypeParameters() - 2] |
      result = this.getTypeParameter(i)
    )
  }

  /** Gets the `TResult` output type parameter. */
  TypeParameter getReturnTypeParameter() {
    result = this.getTypeParameter(this.getNumberOfTypeParameters() - 1)
  }
}

/** The `System.IComparable` interface. */
class SystemIComparableInterface extends SystemInterface {
  SystemIComparableInterface() { this.hasName("IComparable") }

  /** Gets the `CompareTo(object)` method. */
  Method getCompareToMethod() {
    result.getDeclaringType() = this and
    result.hasName("CompareTo") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.IComparable<T>` interface. */
class SystemIComparableTInterface extends SystemUnboundGenericInterface {
  SystemIComparableTInterface() { this.hasName("IComparable<>") }

  /** Gets the `CompareTo(T)` method. */
  Method getCompareToMethod() {
    result.getDeclaringType() = this and
    result.hasName("CompareTo") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = getTypeParameter(0) and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.IEquatable<T>` interface. */
class SystemIEquatableTInterface extends SystemUnboundGenericInterface {
  SystemIEquatableTInterface() { this.hasName("IEquatable<>") }

  /** Gets the `Equals(T)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = getTypeParameter(0) and
    result.getReturnType() instanceof BoolType
  }
}

/** The `System.IFormatProvider` interface. */
class SystemIFormatProviderInterface extends SystemInterface {
  SystemIFormatProviderInterface() { this.hasName("IFormatProvider") }
}

/** The `System.Int32` structure. */
class SystemInt32Struct extends IntType {
  /** Gets the `Parse(string, ...)` method. */
  Method getParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse") and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof IntType
  }

  /** Gets the `TryParse(string, ..., out int)` method. */
  Method getTryParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("TryParse") and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(result.getNumberOfParameters() - 1).getType() instanceof IntType and
    result.getReturnType() instanceof BoolType
  }
}

/** The `System.InvalidCastException` class. */
class SystemInvalidCastExceptionClass extends SystemClass {
  SystemInvalidCastExceptionClass() { this.hasName("InvalidCastException") }
}

/** The `System.Lazy<T>` class. */
class SystemLazyClass extends SystemUnboundGenericClass {
  SystemLazyClass() {
    this.hasName("Lazy<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = getTypeParameter(0)
  }
}

/** The `System.Nullable<T>` struct. */
class SystemNullableStruct extends SystemUnboundGenericStruct {
  SystemNullableStruct() {
    this.hasName("Nullable<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = getTypeParameter(0)
  }

  /** Gets the `HasValue` property. */
  Property getHasValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("HasValue") and
    result.getType() instanceof BoolType
  }

  /** Gets a `GetValueOrDefault()` method. */
  Method getAGetValueOrDefaultMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetValueOrDefault") and
    result.getReturnType() = getTypeParameter(0)
  }
}

/** The `System.NullReferenceException` class. */
class SystemNullReferenceExceptionClass extends SystemClass {
  SystemNullReferenceExceptionClass() { this.hasName("NullReferenceException") }
}

/** The `System.Object` class. */
class SystemObjectClass extends SystemClass {
  SystemObjectClass() { this instanceof ObjectType }

  /** Gets the `Equals(object)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `Equals(object, object)` method. */
  Method getStaticEqualsMethod() {
    result.isStatic() and
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `ReferenceEquals(object, object)` method. */
  Method getReferenceEqualsMethod() {
    result.isStatic() and
    result.getDeclaringType() = this and
    result.hasName("ReferenceEquals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType() instanceof ObjectType and
    result.getReturnType() instanceof BoolType
  }

  /** Gets the `GetHashCode()` method. */
  Method getGetHashCodeMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetHashCode") and
    result.hasNoParameters() and
    result.getReturnType() instanceof IntType
  }

  /** Gets the `GetType()` method. */
  Method getGetTypeMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetType") and
    result.hasNoParameters() and
    result.getReturnType() instanceof SystemTypeClass
  }

  /** Gets the `ToString()` method. */
  Method getToStringMethod() {
    result.getDeclaringType() = this and
    result.hasName("ToString") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof StringType
  }
}

/** The `System.OutOfMemoryException` class. */
class SystemOutOfMemoryExceptionClass extends SystemClass {
  SystemOutOfMemoryExceptionClass() { this.hasName("OutOfMemoryException") }
}

/** The `System.OverflowException` class. */
class SystemOverflowExceptionClass extends SystemClass {
  SystemOverflowExceptionClass() { this.hasName("OverflowException") }
}

/** The `System.Predicate<T>` delegate type. */
class SystemPredicateDelegateType extends SystemUnboundGenericDelegateType {
  SystemPredicateDelegateType() {
    this.hasName("Predicate<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** The `System.String` class. */
class SystemStringClass extends StringType {
  /** Gets the `Equals(object)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals")
  }

  /** Gets the `==` operator. */
  Operator getEqualsOperator() {
    result.getDeclaringType() = this and
    result.hasName("==")
  }

  /** Gets the `Replace(string/char, string/char)` method. */
  Method getReplaceMethod() {
    result.getDeclaringType() = this and
    result.hasName("Replace") and
    result.getNumberOfParameters() = 2 and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Format(...)` method. */
  Method getFormatMethod() {
    result.getDeclaringType() = this and
    result.hasName("Format") and
    result.getNumberOfParameters() in [2 .. 5] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Split(...)` method. */
  Method getSplitMethod() {
    result.getDeclaringType() = this and
    result.hasName("Split") and
    result.getNumberOfParameters() in [1 .. 3] and
    result.getReturnType().(ArrayType).getElementType() instanceof StringType
  }

  /** Gets a `Substring(...)` method. */
  Method getSubstringMethod() {
    result.getDeclaringType() = this and
    result.hasName("Substring") and
    result.getNumberOfParameters() in [1 .. 2] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Concat(...)` method. */
  Method getConcatMethod() {
    result.getDeclaringType() = this and
    result.hasName("Concat") and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Copy()` method. */
  Method getCopyMethod() {
    result.getDeclaringType() = this and
    result.hasName("Copy") and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Join(...)` method. */
  Method getJoinMethod() {
    result.getDeclaringType() = this and
    result.hasName("Join") and
    result.getNumberOfParameters() > 1 and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Clone()` method. */
  Method getCloneMethod() {
    result.getDeclaringType() = this and
    result.hasName("Clone") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof ObjectType
  }

  /** Gets the `Insert(int, string)` method. */
  Method getInsertMethod() {
    result.getDeclaringType() = this and
    result.hasName("Insert") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof IntType and
    result.getParameter(1).getType() instanceof StringType and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `Normalize(...)` method. */
  Method getNormalizeMethod() {
    result.getDeclaringType() = this and
    result.hasName("Normalize") and
    result.getNumberOfParameters() in [0 .. 1] and
    result.getReturnType() instanceof StringType
  }

  /** Gets a `Remove(...)` method. */
  Method getRemoveMethod() {
    result.getDeclaringType() = this and
    result.hasName("Remove") and
    result.getNumberOfParameters() in [1 .. 2] and
    result.getReturnType() instanceof StringType
  }

  /** Gets the `IsNullOrEmpty(string)` method. */
  Method getIsNullOrEmptyMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNullOrEmpty") and
    result.isStatic() and
    result.getNumberOfParameters() = 1 and
    result.getReturnType() instanceof BoolType
  }
}

/** A `ToString()` method. */
class ToStringMethod extends Method {
  ToStringMethod() { this = any(SystemObjectClass c).getToStringMethod().getAnOverrider*() }
}

/** The `System.Type` class */
class SystemTypeClass extends SystemClass {
  SystemTypeClass() { this.hasName("Type") }

  /** Gets the `FullName` property. */
  Property getFullNameProperty() {
    result.getDeclaringType() = this and
    result.hasName("FullName") and
    result.getType() instanceof StringType
  }

  /** Gets the `InvokeMember(string, ...)` method. */
  Method getInvokeMemberMethod() {
    result.getDeclaringType() = this and
    result.hasName("InvokeMember") and
    result.getParameter(0).getType() instanceof StringType and
    result.getParameter(3).getType() instanceof ObjectType and
    result.getParameter(4).getType().(ArrayType).getElementType() instanceof ObjectType and
    result.getReturnType() instanceof ObjectType
  }

  /** Gets the `GetMethod(string, ...)` method. */
  Method getGetMethodMethod() {
    result.getDeclaringType() = this and
    result.hasName("GetMethod") and
    result.getParameter(0).getType() instanceof StringType and
    result.getReturnType() instanceof SystemReflectionMethodInfoClass
  }
}

/** The `System.Uri` class. */
class SystemUriClass extends SystemClass {
  SystemUriClass() { this.hasName("Uri") }

  /** Gets the `PathAndQuery` property. */
  Property getPathAndQueryProperty() {
    result.getDeclaringType() = this and
    result.hasName("PathAndQuery") and
    result.getType() instanceof StringType
  }

  /** Gets the `Query` property. */
  Property getQueryProperty() {
    result.getDeclaringType() = this and
    result.hasName("Query") and
    result.getType() instanceof StringType
  }

  /** Gets the `OriginalString` property. */
  Property getOriginalStringProperty() {
    result.getDeclaringType() = this and
    result.hasName("OriginalString") and
    result.getType() instanceof StringType
  }
}

/** The `System.ValueType` class. */
class SystemValueTypeClass extends SystemClass {
  SystemValueTypeClass() { this.hasName("ValueType") }
}

/** The `System.IntPtr` type. */
class SystemIntPtrType extends ValueType {
  SystemIntPtrType() {
    this = any(SystemNamespace n).getATypeDeclaration() and
    this.hasName("IntPtr")
  }
}

/** The `System.IDisposable` interface. */
class SystemIDisposableInterface extends SystemInterface {
  SystemIDisposableInterface() { this.hasName("IDisposable") }

  /** Gets the `Dispose()` method. */
  Method getDisposeMethod() {
    result.getDeclaringType() = this and
    result.hasName("Dispose") and
    result.getNumberOfParameters() = 0 and
    result.getReturnType() instanceof VoidType
  }
}

/** A method that overrides `int object.GetHashCode()`. */
class GetHashCodeMethod extends Method {
  GetHashCodeMethod() {
    exists(Method m | m = any(SystemObjectClass c).getGetHashCodeMethod() |
      this = m.getAnOverrider*()
    )
  }
}

/** A method that overrides `bool object.Equals(object)`. */
class EqualsMethod extends Method {
  EqualsMethod() {
    exists(Method m | m = any(SystemObjectClass c).getEqualsMethod() | this = m.getAnOverrider*())
  }
}

/** A method that implements `bool IEquatable<T>.Equals(T)`. */
class IEquatableEqualsMethod extends Method {
  IEquatableEqualsMethod() {
    exists(Method m |
      m = any(SystemIEquatableTInterface i).getAConstructedGeneric().getAMethod() and
      m.getSourceDeclaration() = any(SystemIEquatableTInterface i).getEqualsMethod()
    |
      this = m or getAnUltimateImplementee() = m
    )
  }
}

/**
 * Whether the type `t` defines an equals method.
 *
 * Either the equals method is (an override of) `object.Equals(object)`,
 * or an implementation of `IEquatable<T>.Equals(T)` which is called
 * from the `object.Equals(object)` method inherited by `t`.
 */
predicate implementsEquals(ValueOrRefType t) { getInvokedEqualsMethod(t).getDeclaringType() = t }

/**
 * Gets the equals method that will be invoked on a value `x`
 * of type `t` when `x.Equals(object)` is called.
 *
 * Either the equals method is (an override of) `object.Equals(object)`,
 * or an implementation of `IEquatable<T>.Equals(T)` which is called
 * from the `object.Equals(object)` method inherited by `t`.
 */
Method getInvokedEqualsMethod(ValueOrRefType t) {
  result = getInheritedEqualsMethod(t) and
  not exists(getInvokedIEquatableEqualsMethod(t, result))
  or
  exists(EqualsMethod eq |
    result = getInvokedIEquatableEqualsMethod(t, eq) and
    getInheritedEqualsMethod(t) = eq
  )
}

private EqualsMethod getInheritedEqualsMethod(ValueOrRefType t) { t.hasMethod(result) }

/**
 * Equals method `eq` is inherited by `t`, `t` overrides `IEquatable<T>.Equals(T)`
 * from the declaring type of `eq`, and `eq` calls the overridden method (provided
 * that `eq` is from source code).
 *
 * Example:
 *
 * ```csharp
 * abstract class A<T> : IEquatable<T> {
 *   public abstract bool Equals(T other);
 *   public override bool Equals(object other) { return other != null && GetType() == other.GetType() && Equals((T)other); }
 * }
 *
 * class B : A<B> {
 *   public override bool Equals(B other) { ... }
 * }
 * ```
 *
 * In the example, `t = B`, `eq = A<B>.Equals(object)`, and `result = B.Equals(B)`.
 */
private IEquatableEqualsMethod getInvokedIEquatableEqualsMethod(ValueOrRefType t, EqualsMethod eq) {
  t.hasMethod(result) and
  eq = getInheritedEqualsMethod(t.getBaseClass()) and
  exists(IEquatableEqualsMethod ieem |
    result = ieem.getAnOverrider*() and
    eq.getDeclaringType() = ieem.getDeclaringType()
  |
    not ieem.fromSource()
    or
    callsEqualsMethod(eq, ieem)
  )
}

/** Whether `eq` calls `ieem` */
private predicate callsEqualsMethod(EqualsMethod eq, IEquatableEqualsMethod ieem) {
  exists(MethodCall callToDerivedEquals |
    callToDerivedEquals.getEnclosingCallable() = eq.getSourceDeclaration() and
    callToDerivedEquals.getTarget() = ieem.getSourceDeclaration()
  )
}

/** A method that implements `void IDisposable.Dispose()`. */
class DisposeMethod extends Method {
  DisposeMethod() {
    exists(Method m | m = any(SystemIDisposableInterface i).getDisposeMethod() |
      this = m or this.getAnUltimateImplementee() = m
    )
  }
}

/** A method with the signature `void Dispose(bool)`. */
library class DisposeBoolMethod extends Method {
  DisposeBoolMethod() {
    hasName("Dispose") and
    this.getReturnType() instanceof VoidType and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof BoolType
  }
}

/**
 * Whether the type `t` defines a dispose method.
 *
 * Either the dispose method is (an override of) `IDisposable.Dispose()`,
 * or an implementation of a method `Dispose(bool)` which is called
 * from the `IDisposable.Dispose()` method inherited by `t`.
 */
predicate implementsDispose(ValueOrRefType t) { getInvokedDisposeMethod(t).getDeclaringType() = t }

/**
 * Gets the dispose method that will be invoked on a value `x`
 * of type `t` when `x.Dipsose()` is called.
 *
 * Either the dispose method is (an override of) `IDisposable.Dispose()`,
 * or an implementation of a method `Dispose(bool)` which is called
 * from the `IDisposable.Dispose()` method inherited by `t`.
 */
Method getInvokedDisposeMethod(ValueOrRefType t) {
  result = getInheritedDisposeMethod(t) and
  not exists(getInvokedDiposeBoolMethod(t, result))
  or
  exists(DisposeMethod eq |
    result = getInvokedDiposeBoolMethod(t, eq) and
    getInheritedDisposeMethod(t) = eq
  )
}

private DisposeMethod getInheritedDisposeMethod(ValueOrRefType t) { t.hasMethod(result) }

/**
 * Dispose method `disp` is inherited by `t`, `t` overrides a `void Dispose(bool)`
 * method from the declaring type of `disp`, and `disp` calls the overridden method
 * (provided that `disp` is from source code).
 *
 * Example:
 *
 * ```csharp
 * class A : IDisposable {
 *   public void Dispose() { Dispose(true); }
 *   public virtual void Dispose(bool disposing) { ... }
 * }
 *
 * class B : A {
 *   public override bool Dispose(bool disposing) { base.Dispose(disposing); ... }
 * }
 * ```
 *
 * In the example, `t = B`, `disp = A.Dispose()`, and `result = B.Dispose(bool)`.
 */
private DisposeBoolMethod getInvokedDiposeBoolMethod(ValueOrRefType t, DisposeMethod disp) {
  t.hasMethod(result) and
  disp = getInheritedDisposeMethod(t.getBaseClass()) and
  exists(DisposeBoolMethod dbm |
    result = dbm.getAnOverrider*() and
    disp.getDeclaringType() = dbm.getDeclaringType()
  |
    not disp.fromSource()
    or
    exists(MethodCall callToDerivedDispose |
      callToDerivedDispose.getEnclosingCallable() = disp.getSourceDeclaration() and
      callToDerivedDispose.getTarget() = dbm.getSourceDeclaration()
    )
  )
}

/** A struct in the `System` namespace. */
class SystemStruct extends Struct {
  SystemStruct() { this.getNamespace() instanceof SystemNamespace }
}

/** `System.Guid` struct. */
class SystemGuid extends SystemStruct {
  SystemGuid() { this.hasName("Guid") }
}

/** The `System.NotImplementedException` class. */
class SystemNotImplementedExceptionClass extends SystemClass {
  SystemNotImplementedExceptionClass() { this.hasName("NotImplementedException") }
}

/** The `System.DateTime` struct. */
class SystemDateTimeStruct extends SystemStruct {
  SystemDateTimeStruct() { this.hasName("DateTime") }
}
