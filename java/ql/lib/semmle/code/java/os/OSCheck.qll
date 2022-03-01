/**
 * Provides classes and predicates for guards that check for the current OS.
 */

import java
import semmle.code.java.controlflow.Guards
private import semmle.code.java.frameworks.apache.Lang
private import semmle.code.java.dataflow.DataFlow

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
bindingset[osString]
private predicate isOsFromSystemProp(MethodAccess ma, string osString) {
  exists(MethodAccessSystemGetProperty sgpMa, Expr sgpFlowsToExpr |
    sgpMa.hasCompileTimeConstantGetPropertyName("os.name")
  |
    DataFlow::localExprFlow(sgpMa, sgpFlowsToExpr) and
    ma.getAnArgument().(CompileTimeConstantExpr).getStringValue().toLowerCase().matches(osString) and // Call from System.getProperty to some partial match method
    (
      sgpFlowsToExpr = ma.getQualifier()
      or
      exists(MethodAccess caseChangeMa |
        caseChangeMa.getMethod() =
          any(Method m |
            m.getDeclaringType() instanceof TypeString and m.hasName(["toLowerCase", "toUpperCase"])
          )
      |
        sgpFlowsToExpr = caseChangeMa.getQualifier() and // Call from System.getProperty to case-switching method
        DataFlow::localExprFlow(caseChangeMa, ma.getQualifier()) // Call from case-switching method to some partial match method
      )
    )
  ) and
  ma.getMethod() instanceof StringPartialMatchMethod
}

private class IsWindowsFromSystemProp extends IsWindowsGuard instanceof MethodAccess {
  IsWindowsFromSystemProp() { isOsFromSystemProp(this, "window%") }
}

private class IsUnixFromSystemProp extends IsUnixGuard instanceof MethodAccess {
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
  IsWindowsFromApacheCommons() { isOsFromApacheCommons(this, "IS_OS_WINDOWS%") }
}

private class IsUnixFromApacheCommons extends IsUnixGuard instanceof FieldAccess {
  IsUnixFromApacheCommons() { isOsFromApacheCommons(this, "IS_OS_UNIX") }
}

/**
 * A guard that checks if the `java.nio.file.FileSystem` supports posix file permissions.
 * This is often used to infer if the OS is unix-based.
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
