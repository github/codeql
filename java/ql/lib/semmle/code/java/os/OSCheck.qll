/**
 * Provides classes and predicates for guards that check for the current OS.
 */

import java
import semmle.code.java.controlflow.Guards
private import semmle.code.java.environment.SystemProperty
private import semmle.code.java.frameworks.apache.Lang
private import semmle.code.java.dataflow.DataFlow

/**
 * A guard that checks if the current os is Windows.
 * When True, the OS is Windows.
 * When False, the OS is not Windows.
 */
abstract class IsWindowsGuard extends Guard { }

/**
 * A guard that checks if the current OS is any Windows.
 * When True, the OS is Windows.
 * When False, the OS *may* still be Windows.
 */
abstract class IsAnyWindowsGuard extends Guard { }

/**
 * A guard that checks if the current OS is unix or unix-like.
 * When True, the OS is unix or unix-like.
 * When False, the OS is not unix or unix-like.
 */
abstract class IsUnixGuard extends Guard { }

/**
 * A guard that checks if the current OS is unix or unix-like.
 * When True, the OS is unix or unix-like.
 * When False, the OS *may* still be unix or unix-like.
 */
abstract class IsAnyUnixGuard extends Guard { }

/**
 * Holds when the MethodAccess is a call to check the current OS using either the upper case `osUpperCase` or lower case `osLowerCase` string constants.
 */
bindingset[osString]
private predicate isOsFromSystemProp(MethodAccess ma, string osString) {
  exists(Expr systemGetPropertyExpr, Expr systemGetPropertyFlowsToExpr |
    systemGetPropertyExpr = getSystemProperty("os.name")
  |
    DataFlow::localExprFlow(systemGetPropertyExpr, systemGetPropertyFlowsToExpr) and
    ma.getAnArgument().(CompileTimeConstantExpr).getStringValue().toLowerCase().matches(osString) and // Call from System.getProperty to some partial match method
    (
      systemGetPropertyFlowsToExpr = ma.getQualifier()
      or
      exists(MethodAccess caseChangeMa |
        caseChangeMa.getMethod() =
          any(Method m |
            m.getDeclaringType() instanceof TypeString and m.hasName(["toLowerCase", "toUpperCase"])
          )
      |
        systemGetPropertyFlowsToExpr = caseChangeMa.getQualifier() and // Call from System.getProperty to case-switching method
        DataFlow::localExprFlow(caseChangeMa, ma.getQualifier()) // Call from case-switching method to some partial match method
      )
    )
  ) and
  ma.getMethod() instanceof StringPartialMatchMethod
}

private class IsWindowsFromSystemProp extends IsWindowsGuard instanceof MethodAccess {
  IsWindowsFromSystemProp() { isOsFromSystemProp(this, "window%") }
}

/**
 * Holds when the Guard is an equality check between the system property with the name `propertyName`
 * and the string or char constant `compareToLiteral`.
 */
private Guard isOsFromFieldEqualityCheck(string propertyName, string compareToLiteral) {
  result
      .isEquality(getSystemProperty(propertyName),
        any(Literal literal |
          (literal instanceof CharacterLiteral or literal instanceof StringLiteral) and
          literal.getValue() = compareToLiteral
        ), _)
}

private class IsWindowsFromCharPathSeperator extends IsWindowsGuard {
  IsWindowsFromCharPathSeperator() { this = isOsFromFieldEqualityCheck("path.separator", "\\") }
}

private class IsWindowsFromCharSeperator extends IsWindowsGuard {
  IsWindowsFromCharSeperator() { this = isOsFromFieldEqualityCheck("file.separator", ";") }
}

private class IsUnixFromCharPathSeperator extends IsUnixGuard {
  IsUnixFromCharPathSeperator() { this = isOsFromFieldEqualityCheck("path.separator", "/") }
}

private class IsUnixFromCharSeperator extends IsUnixGuard {
  IsUnixFromCharSeperator() { this = isOsFromFieldEqualityCheck("file.separator", ":") }
}

private class IsUnixFromSystemProp extends IsAnyUnixGuard instanceof MethodAccess {
  IsUnixFromSystemProp() { isOsFromSystemProp(this, ["mac%", "linux%"]) }
}

bindingset[fieldNamePattern]
private predicate isOsFromApacheCommons(FieldAccess fa, string fieldNamePattern) {
  exists(Field f | f = fa.getField() |
    f.getDeclaringType() instanceof ApacheSystemUtils and
    f.getName().matches(fieldNamePattern)
  )
}

private class IsWindowsFromApacheCommons extends IsWindowsGuard instanceof FieldAccess {
  IsWindowsFromApacheCommons() { isOsFromApacheCommons(this, "IS_OS_WINDOWS") }
}

private class IsAnyWindowsFromApacheCommons extends IsAnyWindowsGuard instanceof FieldAccess {
  IsAnyWindowsFromApacheCommons() { isOsFromApacheCommons(this, "IS_OS_WINDOWS_%") }
}

private class IsUnixFromApacheCommons extends IsUnixGuard instanceof FieldAccess {
  IsUnixFromApacheCommons() { isOsFromApacheCommons(this, "IS_OS_UNIX") }
}

private class IsAnyUnixFromApacheCommons extends IsAnyUnixGuard instanceof FieldAccess {
  IsAnyUnixFromApacheCommons() {
    isOsFromApacheCommons(this,
      [
        "IS_OS_AIX", "IS_OS_HP_UX", "IS_OS_IRIX", "IS_OS_LINUX", "IS_OS_MAC%", "IS_OS_FREE_BSD",
        "IS_OS_OPEN_BSD", "IS_OS_NET_BSD", "IS_OS_SOLARIS", "IS_OS_SUN_OS", "IS_OS_ZOS"
      ])
  }
}

/**
 * A guard that checks if the `java.nio.file.FileSystem` supports posix file permissions.
 * This is often used to infer if the OS is unix-based and can generally be considered to be true for all unix-based OSes
 * ([source](https://en.wikipedia.org/wiki/POSIX#POSIX-oriented_operating_systems)).
 * Looks for calls to `contains("posix")` on the `supportedFileAttributeViews()` method returned by `FileSystem`.
 */
private class IsUnixFromPosixFromFileSystem extends IsUnixGuard instanceof MethodAccess {
  IsUnixFromPosixFromFileSystem() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType()
          .getASupertype*()
          .getSourceDeclaration()
          .hasQualifiedName("java.util", "Set") and
      m.hasName("contains")
    ) and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "posix" and
    exists(Method supportedFileAttribtueViewsMethod |
      supportedFileAttribtueViewsMethod.hasName("supportedFileAttributeViews") and
      supportedFileAttribtueViewsMethod.getDeclaringType() instanceof TypeFileSystem
    |
      DataFlow::localExprFlow(any(MethodAccess ma |
          ma.getMethod() = supportedFileAttribtueViewsMethod
        ), super.getQualifier())
    )
  }
}
