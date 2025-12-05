/**
 * Provides CIL-specific implementations of the Callable framework.
 * This module bridges CIL instructions and methods to the abstract Callable interface.
 */

private import binary
private import semmle.code.binary.ast.internal.CilInstructions

/**
 * A CIL type (class, struct, interface, etc.).
 */
class CilType extends @type {
  string toString() { result = this.getName() }

  /** Gets the full name of this type (e.g., "System.Collections.Generic.List`1"). */
  string getFullName() { types(this, result, _, _) }

  /** Gets the namespace of this type (e.g., "System.Collections.Generic"). */
  string getNamespace() { types(this, _, result, _) }

  /** Gets the simple name of this type (e.g., "List`1"). */
  string getName() { types(this, _, _, result) }

  /** Gets a method declared in this type. */
  CilMethodExt getAMethod() { result.getDeclaringType() = this }
}

/**
 * A CIL method with enhanced metadata for the Callable framework.
 * Extends the base CilMethod with type information and qualified names.
 */
class CilMethodExt extends CilMethod {
  /** Gets the type that declares this method. */
  CilType getDeclaringType() { methods(this, _, _, result) }

  /**
   * Gets the fully qualified name of this method in the format:
   * "Namespace.ClassName.MethodName"
   */
  string getFullyQualifiedName() {
    exists(CilType t | t = this.getDeclaringType() |
      result = t.getFullName() + "." + this.getName()
    )
  }

  /**
   * Holds if this method matches the given namespace, class name, and method name.
   */
  predicate hasFullyQualifiedName(string namespace, string className, string methodName) {
    exists(CilType t | t = this.getDeclaringType() |
      t.getNamespace() = namespace and
      t.getName() = className and
      this.getName() = methodName
    )
  }

  /** Holds if this method is publicly accessible. */
  predicate isPublic() {
    // TODO: Check actual visibility flags when available in dbscheme
    // For now, we can't determine visibility from IL alone
    any()
  }

  /** Gets the location of this method. */
  Location getMethodLocation() {
    result = this.getInstruction(0).getLocation()
    or
    not exists(this.getInstruction(0)) and
    result instanceof EmptyLocation
  }
}

/**
 * A CIL call instruction with enhanced target resolution.
 */
class CilCallExt extends CilCall {
  CilCallExt() { any() }

  /**
   * Gets the fully qualified name of the call target.
   * This is extracted from il_call_target_unresolved.
   */
  string getCallTargetFullyQualifiedName() { result = this.getExternalName() }

  /**
   * Holds if this call targets a method matching the given fully qualified components.
   * The external name format is "Namespace.ClassName.MethodName" (e.g., "System.Console.WriteLine").
   */
  predicate targetsMethod(string namespace, string className, string methodName) {
    exists(string target | target = this.getExternalName() |
      // Format: Namespace.ClassName.MethodName
      // We need to find the last two dots to split namespace, class, and method
      exists(int lastDot, int secondLastDot, string nsAndClass |
        lastDot = max(int i | target.charAt(i) = ".") and
        methodName = target.suffix(lastDot + 1) and
        nsAndClass = target.prefix(lastDot) and
        secondLastDot = max(int i | nsAndClass.charAt(i) = ".") and
        namespace = nsAndClass.prefix(secondLastDot) and
        className = nsAndClass.substring(secondLastDot + 1, nsAndClass.length())
      )
    )
  }

  /** Gets the enclosing method with extended metadata. */
  CilMethodExt getEnclosingMethodExt() { result = this.getEnclosingMethod() }
}

/**
 * Holds if `caller` contains a call to a method identified by `(namespace, className, methodName)`.
 */
predicate hasCallTo(CilMethodExt caller, string namespace, string className, string methodName) {
  exists(CilCallExt call |
    call.getEnclosingMethodExt() = caller and
    call.targetsMethod(namespace, className, methodName)
  )
}

/**
 * Holds if `caller` contains a call to a method with the given fully qualified target name.
 */
predicate hasCallToTarget(CilMethodExt caller, string targetFqn) {
  exists(CilCallExt call |
    call.getEnclosingMethodExt() = caller and
    call.getCallTargetFullyQualifiedName() = targetFqn
  )
}
