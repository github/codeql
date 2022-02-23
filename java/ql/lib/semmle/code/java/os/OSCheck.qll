/**
 * Provides classes and predicates for guards that check for the current OS.
 */

import java
import semmle.code.java.controlflow.Guards
private import semmle.code.java.frameworks.apache.Lang
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.StringCheck

/**
 * A guard that checks if the current platform is Windows.
 */
abstract class IsWindowsGuard extends Guard { }

/**
 * A guard that checks if the current platform is unix or unix-like.
 */
abstract class IsUnixGuard extends Guard { }

/**
 * Holds when the MethodAccess is a call to check the current OS using either the upper case `osUpperCase` or lower case `osLowerCase` string constants.
 */
bindingset[osUpperCase, osLowerCase]
private predicate isOsFromSystemProp(MethodAccess ma, string osUpperCase, string osLowerCase) {
  exists(MethodAccessSystemGetProperty sgpMa |
    sgpMa.hasCompileTimeConstantGetPropertyName("os.name")
  |
    DataFlow::localExprFlow(sgpMa, ma.getQualifier()) and // Call from System.getProperty to some partial match method
    ma.getAnArgument().(CompileTimeConstantExpr).getStringValue().matches(osUpperCase)
    or
    exists(MethodAccess toLowerCaseMa |
      toLowerCaseMa.getMethod() =
        any(Method m | m.getDeclaringType() instanceof TypeString and m.hasName("toLowerCase"))
    |
      DataFlow::localExprFlow(sgpMa, toLowerCaseMa.getQualifier()) and // Call from System.getProperty to toLowerCase
      DataFlow::localExprFlow(toLowerCaseMa, ma.getQualifier()) and // Call from toLowerCase to some partial match method
      ma.getAnArgument().(CompileTimeConstantExpr).getStringValue().matches(osLowerCase)
    )
  ) and
  isStringPartialMatch(ma)
}

private class IsWindowsFromSystemProp extends IsWindowsGuard instanceof MethodAccess {
  IsWindowsFromSystemProp() { isOsFromSystemProp(this, "Window%", "window%") }
}

private class IsUnixFromSystemProp extends IsUnixGuard instanceof MethodAccess {
  IsUnixFromSystemProp() {
    isOsFromSystemProp(this, ["Mac%", "Linux%", "LINUX%"], ["mac%", "linux%"])
  }
}

bindingset[fieldNamePattern]
private predicate isOsFromApacheCommons(FieldAccess fa, string fieldNamePattern) {
  exists(Field f | f = fa.getField() |
    f.getDeclaringType() instanceof ApacheSystemUtils and
    f.getName().matches(fieldNamePattern)
  )
}

private class IsWindowsFromApacheCommons extends IsWindowsGuard instanceof FieldAccess {
  IsWindowsFromApacheCommons() { isOsFromApacheCommons(this, "IS_OS_WINDOWS%") }
}

private class IsUnixFromApacheCommons extends IsUnixGuard instanceof FieldAccess {
  IsUnixFromApacheCommons() { isOsFromApacheCommons(this, "IS_OS_UNIX") }
}

/**
 * A guard that checks if the `java.nio.file.FileSystem` supports posix file permissions.
 * This is often used to infer if the OS is unix-based.
 * Looks for calls to `contains("posix")` on the `supportedFileAttributeViews` method returned by `FileSystem`.
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
