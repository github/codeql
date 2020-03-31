/**
 * Provides classes and predicates for working with standard classes and methods from the JDK.
 */

import Member

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
  TypeProcessBuilder() { hasQualifiedName("java.lang", "ProcessBuilder") }
}

/** The class `java.lang.Runtime`. */
class TypeRuntime extends Class {
  TypeRuntime() { hasQualifiedName("java.lang", "Runtime") }
}

/** The class `java.lang.String`. */
class TypeString extends Class {
  TypeString() { this.hasQualifiedName("java.lang", "String") }
}

/** The `length()` method of the class `java.lang.String`. */
class StringLengthMethod extends Method {
  StringLengthMethod() { this.hasName("length") and this.getDeclaringType() instanceof TypeString }
}

/** The class `java.lang.StringBuffer`. */
class TypeStringBuffer extends Class {
  TypeStringBuffer() { this.hasQualifiedName("java.lang", "StringBuffer") }
}

/** The class `java.lang.StringBuilder`. */
class TypeStringBuilder extends Class {
  TypeStringBuilder() { this.hasQualifiedName("java.lang", "StringBuilder") }
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
  NumberType() { exists(TypeNumber number | hasSubtype*(number, this)) }
}

/** A numeric type, including both primitive and boxed types. */
class NumericType extends Type {
  NumericType() {
    exists(string name |
      name = this.(PrimitiveType).getName() or
      name = this.(BoxedType).getPrimitiveType().getName()
    |
      name.regexpMatch("byte|short|int|long|double|float")
    )
  }
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
  TypeSerializable() { hasQualifiedName("java.io", "Serializable") }
}

/** The interface `java.io.ObjectOutput`. */
class TypeObjectOutput extends Interface {
  TypeObjectOutput() { hasQualifiedName("java.io", "ObjectOutput") }
}

/** The type `java.io.ObjectOutputStream`. */
class TypeObjectOutputStream extends RefType {
  TypeObjectOutputStream() { hasQualifiedName("java.io", "ObjectOutputStream") }
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
 * Any of the methods named `command` on class `java.lang.ProcessBuilder`.
 */
class MethodProcessBuilderCommand extends Method {
  MethodProcessBuilderCommand() {
    hasName("command") and
    getDeclaringType() instanceof TypeProcessBuilder
  }
}

/**
 * Any method named `exec` on class `java.lang.Runtime`.
 */
class MethodRuntimeExec extends Method {
  MethodRuntimeExec() {
    hasName("exec") and
    getDeclaringType() instanceof TypeRuntime
  }
}

/**
 * Any method named `getenv` on class `java.lang.System`.
 */
class MethodSystemGetenv extends Method {
  MethodSystemGetenv() {
    hasName("getenv") and
    getDeclaringType() instanceof TypeSystem
  }
}

/**
 * Any method named `getProperty` on class `java.lang.System`.
 */
class MethodSystemGetProperty extends Method {
  MethodSystemGetProperty() {
    hasName("getProperty") and
    getDeclaringType() instanceof TypeSystem
  }
}

/**
 * Any method named `exit` on class `java.lang.Runtime` or `java.lang.System`.
 */
class MethodExit extends Method {
  MethodExit() {
    hasName("exit") and
    (getDeclaringType() instanceof TypeRuntime or getDeclaringType() instanceof TypeSystem)
  }
}

/**
 * A method named `writeObject` on type `java.io.ObjectOutput`
 * or `java.io.ObjectOutputStream`.
 */
class WriteObjectMethod extends Method {
  WriteObjectMethod() {
    hasName("writeObject") and
    (
      getDeclaringType() instanceof TypeObjectOutputStream or
      getDeclaringType() instanceof TypeObjectOutput
    )
  }
}

/**
 * A method that reads an object on type `java.io.ObjectInputStream`,
 * including `readObject`, `readObjectOverride`, `readUnshared` and `resolveObject`.
 */
class ReadObjectMethod extends Method {
  ReadObjectMethod() {
    this.getDeclaringType().hasQualifiedName("java.io", "ObjectInputStream") and
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
    hasName("getName") and
    getDeclaringType() instanceof TypeClass
  }
}

/** The method `Class.getSimpleName()`. */
class ClassSimpleNameMethod extends Method {
  ClassSimpleNameMethod() {
    hasName("getSimpleName") and
    getDeclaringType() instanceof TypeClass
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
    hasName("in") and
    getDeclaringType() instanceof TypeSystem
  }
}

/** The field `System.out`. */
class SystemOut extends Field {
  SystemOut() {
    hasName("out") and
    getDeclaringType() instanceof TypeSystem
  }
}

/** The field `System.err`. */
class SystemErr extends Field {
  SystemErr() {
    hasName("err") and
    getDeclaringType() instanceof TypeSystem
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
    this.getNumberOfParameters() = 0
  }
}

/** A method with the same signature as `java.lang.Object.clone`. */
class CloneMethod extends Method {
  CloneMethod() {
    this.hasName("clone") and
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
  ThrowableType() { exists(TypeThrowable throwable | hasSubtype*(throwable, this)) }
}

/** An unchecked exception. That is, a (reflexive, transitive) subtype of `java.lang.Error` or `java.lang.RuntimeException`. */
class UncheckedThrowableType extends RefType {
  UncheckedThrowableType() {
    exists(TypeError e | hasSubtype*(e, this)) or
    exists(TypeRuntimeException e | hasSubtype*(e, this))
  }
}
