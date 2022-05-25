/**
 * Provides classes and predicates for guards that check for the current OS.
 */

import java
import semmle.code.java.controlflow.Guards
private import semmle.code.java.environment.SystemProperty
private import semmle.code.java.frameworks.apache.Lang
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking

/**
 * A guard that checks if the current OS is Windows.
 * When True, the OS is Windows.
 * When False, the OS is not Windows.
 */
abstract class IsWindowsGuard extends Guard { }

/**
 * A guard that checks if the current OS is a specific Windows variant.
 * When True, the OS is Windows.
 * When False, the OS *may* still be Windows.
 */
abstract class IsSpecificWindowsVariant extends Guard { }

/**
 * A guard that checks if the current OS is unix or unix-like.
 * When True, the OS is unix or unix-like.
 * When False, the OS is not unix or unix-like.
 */
abstract class IsUnixGuard extends Guard { }

/**
 * A guard that checks if the current OS is a specific unix or unix-like variant.
 * When True, the OS is unix or unix-like.
 * When False, the OS *may* still be unix or unix-like.
 */
abstract class IsSpecificUnixVariant extends Guard { }

/**
 * Holds when `ma` compares the current OS against the string constant `osString`.
 */
private predicate isOsFromSystemProp(MethodAccess ma, string osString) {
  TaintTracking::localExprTaint(getSystemProperty("os.name"), ma.getQualifier()) and // Call from System.getProperty (or equivalent) to some partial match method
  exists(StringPartialMatchMethod m, CompileTimeConstantExpr matchedStringConstant |
    m = ma.getMethod() and
    matchedStringConstant.getStringValue().toLowerCase() = osString
  |
    DataFlow::localExprFlow(matchedStringConstant, ma.getArgument(m.getMatchParameterIndex()))
  )
}

private class IsWindowsFromSystemProp extends IsWindowsGuard instanceof MethodAccess {
  IsWindowsFromSystemProp() { isOsFromSystemProp(this, any(string s | s.regexpMatch("windows?"))) }
}

/**
 * Holds when the Guard is an equality check between the system property with the name `propertyName`
 * and the string or char constant `compareToLiteral`, and the branch evaluates to `branch`.
 */
private Guard isOsFromSystemPropertyEqualityCheck(
  string propertyName, string compareToLiteral, boolean branch
) {
  result
      .isEquality(getSystemProperty(propertyName),
        any(Literal literal |
          (literal instanceof CharacterLiteral or literal instanceof StringLiteral) and
          literal.getValue() = compareToLiteral
        ), branch)
}

private class IsWindowsFromPathSeparator extends IsWindowsGuard {
  IsWindowsFromPathSeparator() {
    this = isOsFromSystemPropertyEqualityCheck("path.separator", ";", true) or
    this = isOsFromSystemPropertyEqualityCheck("path.separator", ":", false)
  }
}

private class IsWindowsFromFileSeparator extends IsWindowsGuard {
  IsWindowsFromFileSeparator() {
    this = isOsFromSystemPropertyEqualityCheck("file.separator", "\\", true) or
    this = isOsFromSystemPropertyEqualityCheck("file.separator", "/", false)
  }
}

private class IsUnixFromPathSeparator extends IsUnixGuard {
  IsUnixFromPathSeparator() {
    this = isOsFromSystemPropertyEqualityCheck("path.separator", ":", true) or
    this = isOsFromSystemPropertyEqualityCheck("path.separator", ";", false)
  }
}

private class IsUnixFromFileSeparator extends IsUnixGuard {
  IsUnixFromFileSeparator() {
    this = isOsFromSystemPropertyEqualityCheck("file.separator", "/", true) or
    this = isOsFromSystemPropertyEqualityCheck("file.separator", "\\", false)
  }
}

private class IsUnixFromSystemProp extends IsSpecificUnixVariant instanceof MethodAccess {
  IsUnixFromSystemProp() {
    isOsFromSystemProp(this, any(string s | s.regexpMatch(["mac.*", "linux.*"])))
  }
}

bindingset[fieldNamePattern]
private predicate isOsFromApacheCommons(FieldAccess fa, string fieldNamePattern) {
  exists(Field f | f = fa.getField() |
    f.getDeclaringType() instanceof TypeApacheSystemUtils and
    f.getName().matches(fieldNamePattern)
  )
}

private class IsWindowsFromApacheCommons extends IsWindowsGuard instanceof FieldAccess {
  IsWindowsFromApacheCommons() { isOsFromApacheCommons(this, "IS\\_OS\\_WINDOWS") }
}

private class IsSpecificWindowsVariantFromApacheCommons extends IsSpecificWindowsVariant instanceof FieldAccess {
  IsSpecificWindowsVariantFromApacheCommons() {
    isOsFromApacheCommons(this, "IS\\_OS\\_WINDOWS\\_%")
  }
}

private class IsUnixFromApacheCommons extends IsUnixGuard instanceof FieldAccess {
  IsUnixFromApacheCommons() { isOsFromApacheCommons(this, "IS\\_OS\\_UNIX") }
}

private class IsSpecificUnixVariantFromApacheCommons extends IsSpecificUnixVariant instanceof FieldAccess {
  IsSpecificUnixVariantFromApacheCommons() {
    isOsFromApacheCommons(this,
      [
        "IS\\_OS\\_AIX", "IS\\_OS\\_HP\\_UX", "IS\\_OS\\_IRIX", "IS\\_OS\\_LINUX", "IS\\_OS\\_MAC%",
        "IS\\_OS\\_FREE\\_BSD", "IS\\_OS\\_OPEN\\_BSD", "IS\\_OS\\_NET\\_BSD", "IS\\_OS\\_SOLARIS",
        "IS\\_OS\\_SUN\\_OS", "IS\\_OS\\_ZOS"
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
    exists(Method supportedFileAttributeViewsMethod |
      supportedFileAttributeViewsMethod.hasName("supportedFileAttributeViews") and
      supportedFileAttributeViewsMethod.getDeclaringType() instanceof TypeFileSystem
    |
      DataFlow::localExprFlow(any(MethodAccess ma |
          ma.getMethod() = supportedFileAttributeViewsMethod
        ), super.getQualifier())
    )
  }
}
