/** Provides definitions related to the namespace `System.Reflection`. */

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Reflection` namespace. */
class SystemReflectionNamespace extends Namespace {
  SystemReflectionNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Reflection")
  }
}

/** A class in the `System.Reflection` namespace. */
class SystemReflectionClass extends Class {
  SystemReflectionClass() { this.getNamespace() instanceof SystemReflectionNamespace }
}

/** The `System.Reflection.MethodBase` class. */
class SystemReflectionMethodBaseClass extends SystemReflectionClass {
  SystemReflectionMethodBaseClass() { this.hasName("MethodBase") }

  /** Gets the `Invoke(Object, BindingFlags, Binder, Object[], CultureInfo)` method. */
  Method getInvokeMethod1() {
    result.getDeclaringType() = this and
    result.hasName("Invoke") and
    result.getNumberOfParameters() = 5 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(3).getType().(ArrayType).getElementType() instanceof ObjectType and
    result.getReturnType() instanceof ObjectType
  }

  /** Gets the `Invoke(Object, Object[])` method. */
  Method getInvokeMethod2() {
    result.getDeclaringType() = this and
    result.hasName("Invoke") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getParameter(1).getType().(ArrayType).getElementType() instanceof ObjectType and
    result.getReturnType() instanceof ObjectType
  }
}

/** The `System.Reflection.MethodInfo` class. */
class SystemReflectionMethodInfoClass extends SystemReflectionClass {
  SystemReflectionMethodInfoClass() { this.hasName("MethodInfo") }
}
