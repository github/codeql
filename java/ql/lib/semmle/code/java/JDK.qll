/**
 * Provides classes and predicates for working with standard classes and methods from the JDK.
 */

import Member
import semmle.code.java.security.ExternalProcess
private import semmle.code.java.dataflow.FlowSteps

// --- Standard types ---
/** The class `java.lang.Object`. */
class TypeObject extends Class {
  pragma[noinline]
  TypeObject() { this.hasQualifiedName("java.lang", "Object") }
}

/** The interface `java.lang.Cloneable`. */
class TypeCloneable extends Interface {
  TypeCloneable() { this.hasQualifiedName("java.lang", "Cloneable") }
}

/** The class `java.lang.ProcessBuilder`. */
class TypeProcessBuilder extends Class {
  TypeProcessBuilder() { this.hasQualifiedName("java.lang", "ProcessBuilder") }
}

/** The class `java.lang.Runtime`. */
class TypeRuntime extends Class {
  TypeRuntime() { this.hasQualifiedName("java.lang", "Runtime") }
}

/** The class `java.lang.String`. */
class TypeString extends Class {
  TypeString() { this.hasQualifiedName("java.lang", "String") }
}

/** The `length()` method of the class `java.lang.String`. */
class StringLengthMethod extends Method {
  StringLengthMethod() { this.hasName("length") and this.getDeclaringType() instanceof TypeString }
}

/** The `contains()` method of the class `java.lang.String`. */
class StringContainsMethod extends Method {
  StringContainsMethod() {
    this.hasName("contains") and this.getDeclaringType() instanceof TypeString
  }
}

/**
 * The methods on the class `java.lang.String` that are used to perform partial matches with a specified substring or char.
 */
class StringPartialMatchMethod extends Method {
  StringPartialMatchMethod() {
    this.hasName([
        "contains", "startsWith", "endsWith", "matches", "indexOf", "lastIndexOf", "regionMatches"
      ]) and
    this.getDeclaringType() instanceof TypeString
  }

  /**
   * Gets the index of the parameter that is being matched against.
   */
  int getMatchParameterIndex() {
    if this.hasName("regionMatches")
    then this.getParameterType(result) instanceof TypeString
    else result = 0
  }
}

/** The class `java.lang.StringBuffer`. */
class TypeStringBuffer extends Class {
  TypeStringBuffer() { this.hasQualifiedName("java.lang", "StringBuffer") }
}

/** The class `java.lang.StringBuilder`. */
class TypeStringBuilder extends Class {
  TypeStringBuilder() { this.hasQualifiedName("java.lang", "StringBuilder") }
}

/** Class `java.lang.StringBuffer` or `java.lang.StringBuilder`. */
class StringBuildingType extends Class {
  StringBuildingType() { this instanceof TypeStringBuffer or this instanceof TypeStringBuilder }
}

/** The class `java.lang.System`. */
class TypeSystem extends Class {
  TypeSystem() { this.hasQualifiedName("java.lang", "System") }
}

/** The class `java.lang.Throwable`. */
class TypeThrowable extends Class {
  TypeThrowable() { this.hasQualifiedName("java.lang", "Throwable") }
}

/** The class `java.lang.Exception`. */
class TypeException extends Class {
  TypeException() { this.hasQualifiedName("java.lang", "Exception") }
}

/** The class `java.lang.Error`. */
class TypeError extends Class {
  TypeError() { this.hasQualifiedName("java.lang", "Error") }
}

/** The class `java.lang.RuntimeException`. */
class TypeRuntimeException extends Class {
  TypeRuntimeException() { this.hasQualifiedName("java.lang", "RuntimeException") }
}

/** The class `java.lang.ClassCastException`. */
class TypeClassCastException extends Class {
  TypeClassCastException() { this.hasQualifiedName("java.lang", "ClassCastException") }
}

/** The class `java.lang.NullPointerException`. */
class TypeNullPointerException extends Class {
  TypeNullPointerException() { this.hasQualifiedName("java.lang", "NullPointerException") }
}

/**
 * The class `java.lang.Class`.
 *
 * This includes the generic source declaration, any parameterized instances and the raw type.
 */
class TypeClass extends Class {
  TypeClass() { this.getSourceDeclaration().hasQualifiedName("java.lang", "Class") }
}

/**
 * The class `java.lang.Constructor`.
 *
 * This includes the generic source declaration, any parameterized instances and the raw type.
 */
class TypeConstructor extends Class {
  TypeConstructor() {
    this.getSourceDeclaration().hasQualifiedName("java.lang.reflect", "Constructor")
  }
}

/** The class `java.lang.Math`. */
class TypeMath extends Class {
  TypeMath() { this.hasQualifiedName("java.lang", "Math") }
}

/** The class `java.lang.Number`. */
class TypeNumber extends RefType {
  TypeNumber() { this.hasQualifiedName("java.lang", "Number") }
}

/** A (reflexive, transitive) subtype of `java.lang.Number`. */
class NumberType extends RefType {
  pragma[nomagic]
  NumberType() { this.getASupertype*() instanceof TypeNumber }
}

/** An immutable type. */
class ImmutableType extends Type {
  ImmutableType() {
    this instanceof PrimitiveType or
    this instanceof NullType or
    this instanceof VoidType or
    this instanceof BoxedType or
    this instanceof TypeString
  }
}

// --- Java IO ---
/** The interface `java.io.Serializable`. */
class TypeSerializable extends Interface {
  TypeSerializable() { this.hasQualifiedName("java.io", "Serializable") }
}

/** The interface `java.io.ObjectOutput`. */
class TypeObjectOutput extends Interface {
  TypeObjectOutput() { this.hasQualifiedName("java.io", "ObjectOutput") }
}

/** The type `java.io.ObjectOutputStream`. */
class TypeObjectOutputStream extends RefType {
  TypeObjectOutputStream() { this.hasQualifiedName("java.io", "ObjectOutputStream") }
}

/** The type `java.io.ObjectInputStream`. */
class TypeObjectInputStream extends RefType {
  TypeObjectInputStream() { this.hasQualifiedName("java.io", "ObjectInputStream") }
}

/** The class `java.io.InputStream`. */
class TypeInputStream extends RefType {
  TypeInputStream() { this.hasQualifiedName("java.io", "InputStream") }
}

/** The class `java.nio.file.Paths`. */
class TypePaths extends Class {
  TypePaths() { this.hasQualifiedName("java.nio.file", "Paths") }
}

/** The type `java.nio.file.Path`. */
class TypePath extends RefType {
  TypePath() { this.hasQualifiedName("java.nio.file", "Path") }
}

/** The class `java.nio.file.FileSystem`. */
class TypeFileSystem extends Class {
  TypeFileSystem() { this.hasQualifiedName("java.nio.file", "FileSystem") }
}

/** The class `java.io.File`. */
class TypeFile extends Class {
  TypeFile() { this.hasQualifiedName("java.io", "File") }
}

// --- Standard methods ---
/**
 * Any method named `getenv` on class `java.lang.System`.
 */
class MethodSystemGetenv extends Method {
  MethodSystemGetenv() {
    this.hasName("getenv") and
    this.getDeclaringType() instanceof TypeSystem
  }
}

/**
 * Any method named `getProperty` on class `java.lang.System`.
 */
class MethodSystemGetProperty extends ValuePreservingMethod {
  MethodSystemGetProperty() {
    this.hasName("getProperty") and
    this.getDeclaringType() instanceof TypeSystem
  }

  override predicate returnsValue(int arg) { arg = 1 }
}

/**
 * A call to a method named `getProperty` on class `java.lang.System`.
 */
class MethodCallSystemGetProperty extends MethodCall {
  MethodCallSystemGetProperty() { this.getMethod() instanceof MethodSystemGetProperty }

  /**
   * Holds if this call has a compile-time constant first argument with the value `propertyName`.
   * For example: `System.getProperty("user.dir")`.
   *
   * Note: Better to use `semmle.code.java.environment.SystemProperty#getSystemProperty` instead
   * as that predicate covers ways of accessing the same information via various libraries.
   */
  predicate hasCompileTimeConstantGetPropertyName(string propertyName) {
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = propertyName
  }
}

/**
 * Any method named `exit` on class `java.lang.Runtime` or `java.lang.System`.
 */
class MethodExit extends Method {
  MethodExit() {
    this.hasName("exit") and
    (
      this.getDeclaringType() instanceof TypeRuntime or
      this.getDeclaringType() instanceof TypeSystem
    )
  }
}

/**
 * A method named `writeObject` on type `java.io.ObjectOutput`
 * or `java.io.ObjectOutputStream`.
 */
class WriteObjectMethod extends Method {
  WriteObjectMethod() {
    this.hasName("writeObject") and
    (
      this.getDeclaringType() instanceof TypeObjectOutputStream or
      this.getDeclaringType() instanceof TypeObjectOutput
    )
  }
}

/**
 * A method that reads an object on type `java.io.ObjectInputStream`,
 * including `readObject`, `readObjectOverride`, `readUnshared` and `resolveObject`.
 */
class ReadObjectMethod extends Method {
  ReadObjectMethod() {
    this.getDeclaringType() instanceof TypeObjectInputStream and
    (
      this.hasName("readObject") or
      this.hasName("readObjectOverride") or
      this.hasName("readUnshared") or
      this.hasName("resolveObject")
    )
  }
}

/** The method `Class.getName()`. */
class ClassNameMethod extends Method {
  ClassNameMethod() {
    this.hasName("getName") and
    this.getDeclaringType() instanceof TypeClass
  }
}

/** The method `Class.getSimpleName()`. */
class ClassSimpleNameMethod extends Method {
  ClassSimpleNameMethod() {
    this.hasName("getSimpleName") and
    this.getDeclaringType() instanceof TypeClass
  }
}

/** The method `Math.abs`. */
class MethodAbs extends Method {
  MethodAbs() {
    this.getDeclaringType() instanceof TypeMath and
    this.getName() = "abs"
  }
}

/** The method `Math.min`. */
class MethodMathMin extends Method {
  MethodMathMin() {
    this.getDeclaringType() instanceof TypeMath and
    this.getName() = "min"
  }
}

/** The method `Math.min`. */
class MethodMathMax extends Method {
  MethodMathMax() {
    this.getDeclaringType() instanceof TypeMath and
    this.getName() = "max"
  }
}

// --- Standard fields ---
/** The field `System.in`. */
class SystemIn extends Field {
  SystemIn() {
    this.hasName("in") and
    this.getDeclaringType() instanceof TypeSystem
  }
}

/** The field `System.out`. */
class SystemOut extends Field {
  SystemOut() {
    this.hasName("out") and
    this.getDeclaringType() instanceof TypeSystem
  }
}

/** The field `System.err`. */
class SystemErr extends Field {
  SystemErr() {
    this.hasName("err") and
    this.getDeclaringType() instanceof TypeSystem
  }
}

// --- User-defined methods with a particular meaning ---
/** A method with the same signature as `java.lang.Object.equals`. */
class EqualsMethod extends Method {
  EqualsMethod() {
    this.hasName("equals") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "Object")
  }

  /** Gets the single parameter of this method. */
  Parameter getParameter() { result = this.getAParameter() }
}

/** A method with the same signature as `java.lang.Object.hashCode`. */
class HashCodeMethod extends Method {
  HashCodeMethod() {
    this.hasName("hashCode") and
    this.hasNoParameters()
  }
}

/** A method with the same signature as `java.lang.Object.clone`. */
class CloneMethod extends Method {
  CloneMethod() {
    this.hasName("clone") and
    this.hasNoParameters()
  }
}

/** A method with the same signature as `java.lang.Object.toString`. */
class ToStringMethod extends Method {
  ToStringMethod() {
    this.hasName("toString") and
    this.hasNoParameters()
  }
}

/**
 * The public static `main` method, with a single formal parameter
 * of type `String[]` and return type `void`.
 */
class MainMethod extends Method {
  MainMethod() {
    this.isPublic() and
    this.isStatic() and
    this.getReturnType().hasName("void") and
    this.hasName("main") and
    this.getNumberOfParameters() = 1 and
    exists(Array a |
      a = this.getAParameter().getType() and
      a.getDimension() = 1 and
      a.getElementType() instanceof TypeString
    )
  }
}

/** A premain method is an agent entry-point. */
class PreMainMethod extends Method {
  PreMainMethod() {
    this.isPublic() and
    this.isStatic() and
    this.getReturnType().hasName("void") and
    this.getNumberOfParameters() < 3 and
    this.getParameter(0).getType() instanceof TypeString and
    (exists(this.getParameter(1)) implies this.getParameter(1).getType().hasName("Instrumentation"))
  }
}

/** The `length` field of the array type. */
class ArrayLengthField extends Field {
  ArrayLengthField() {
    this.getDeclaringType() instanceof Array and
    this.hasName("length")
  }
}

/** A (reflexive, transitive) subtype of `java.lang.Throwable`. */
class ThrowableType extends RefType {
  ThrowableType() { exists(TypeThrowable throwable | hasDescendant(throwable, this)) }
}

/** An unchecked exception. That is, a (reflexive, transitive) subtype of `java.lang.Error` or `java.lang.RuntimeException`. */
class UncheckedThrowableType extends RefType {
  UncheckedThrowableType() {
    exists(TypeError e | hasDescendant(e, this)) or
    exists(TypeRuntimeException e | hasDescendant(e, this))
  }
}
