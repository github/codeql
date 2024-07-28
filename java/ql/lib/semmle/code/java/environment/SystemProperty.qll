/**
 * Provides classes and predicates for working with java system properties.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.Properties
private import semmle.code.java.frameworks.apache.Lang

/**
 * Gets an expression that retrieves the value of `propertyName` from `System.getProperty()`.
 *
 * Note: Expression type is not just `String`.
 */
Expr getSystemProperty(string propertyName) {
  result = getSystemPropertyFromSystem(propertyName) or
  result = getSystemPropertyFromSystemGetProperties(propertyName) or
  result = getSystemPropertyFromFile(propertyName) or
  result = getSystemPropertyFromApacheSystemUtils(propertyName) or
  result = getSystemPropertyFromApacheFileUtils(propertyName) or
  result = getSystemPropertyFromGuava(propertyName) or
  result = getSystemPropertyFromOperatingSystemMXBean(propertyName) or
  result = getSystemPropertyFromSpringProperties(propertyName)
}

private MethodCall getSystemPropertyFromSystem(string propertyName) {
  result.(MethodCallSystemGetProperty).hasCompileTimeConstantGetPropertyName(propertyName)
  or
  result.getMethod().hasName("lineSeparator") and propertyName = "line.separator"
}

/**
 * A method access that retrieves the value of `propertyName` from the following methods:
 *  - `System.getProperties().getProperty(...)`
 *  - `System.getProperties().get(...)`
 */
private MethodCall getSystemPropertyFromSystemGetProperties(string propertyName) {
  exists(Method getMethod |
    getMethod instanceof PropertiesGetMethod
    or
    getMethod instanceof PropertiesGetPropertyMethod and
    result.getMethod() = getMethod
  ) and
  result.getArgument(0).(CompileTimeConstantExpr).getStringValue() = propertyName and
  localExprFlowPlusInitializers(any(MethodCall m |
      m.getMethod().getDeclaringType() instanceof TypeSystem and
      m.getMethod().hasName("getProperties")
    ), result.getQualifier())
}

private FieldAccess getSystemPropertyFromFile(string propertyName) {
  result.getField() instanceof FieldFileSeparator and propertyName = "file.separator"
  or
  result.getField() instanceof FieldFilePathSeparator and propertyName = "path.separator"
}

/** The field `java.io.File.separator` or `java.io.File.separatorChar` */
private class FieldFileSeparator extends Field {
  FieldFileSeparator() {
    this.getDeclaringType() instanceof TypeFile and this.hasName(["separator", "separatorChar"])
  }
}

/* The field `java.io.File.pathSeparator` or `java.io.File.pathSeparatorChar` */
private class FieldFilePathSeparator extends Field {
  FieldFilePathSeparator() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName(["pathSeparator", "pathSeparatorChar"])
  }
}

/**
 * A field access to the system property.
 * See: https://commons.apache.org/proper/commons-lang/apidocs/org/apache/commons/lang3/SystemUtils.html
 */
private FieldAccess getSystemPropertyFromApacheSystemUtils(string propertyName) {
  exists(Field f | f = result.getField() and f.getDeclaringType() instanceof TypeApacheSystemUtils |
    f.hasName("AWT_TOOLKIT") and propertyName = "awt.toolkit"
    or
    f.hasName("FILE_ENCODING") and propertyName = "file.encoding"
    or
    f.hasName("FILE_SEPARATOR") and propertyName = "file.separator"
    or
    f.hasName("JAVA_AWT_FONTS") and propertyName = "java.awt.fonts"
    or
    f.hasName("JAVA_AWT_GRAPHICSENV") and propertyName = "java.awt.graphicsenv"
    or
    f.hasName("JAVA_AWT_HEADLESS") and propertyName = "java.awt.headless"
    or
    f.hasName("JAVA_AWT_PRINTERJOB") and propertyName = "java.awt.printerjob"
    or
    f.hasName("JAVA_CLASS_PATH") and propertyName = "java.class.path"
    or
    f.hasName("JAVA_CLASS_VERSION") and propertyName = "java.class.version"
    or
    f.hasName("JAVA_COMPILER") and propertyName = "java.compiler"
    or
    f.hasName("JAVA_EXT_DIRS") and propertyName = "java.ext.dirs"
    or
    f.hasName("JAVA_HOME") and propertyName = "java.home"
    or
    f.hasName("JAVA_IO_TMPDIR") and propertyName = "java.io.tmpdir"
    or
    f.hasName("JAVA_LIBRARY_PATH") and propertyName = "java.library.path"
    or
    f.hasName("JAVA_RUNTIME_NAME") and propertyName = "java.runtime.name"
    or
    f.hasName("JAVA_RUNTIME_VERSION") and propertyName = "java.runtime.version"
    or
    f.hasName("JAVA_SPECIFICATION_NAME") and propertyName = "java.specification.name"
    or
    f.hasName("JAVA_SPECIFICATION_VENDOR") and propertyName = "java.specification.vendor"
    or
    f.hasName("JAVA_UTIL_PREFS_PREFERENCES_FACTORY") and
    propertyName = "java.util.prefs.PreferencesFactory" // This really does break the lowercase convention obeyed everywhere else
    or
    f.hasName("JAVA_VENDOR") and propertyName = "java.vendor"
    or
    f.hasName("JAVA_VENDOR_URL") and propertyName = "java.vendor.url"
    or
    f.hasName("JAVA_VERSION") and propertyName = "java.version"
    or
    f.hasName("JAVA_VM_INFO") and propertyName = "java.vm.info"
    or
    f.hasName("JAVA_VM_NAME") and propertyName = "java.vm.name"
    or
    f.hasName("JAVA_VM_SPECIFICATION_NAME") and propertyName = "java.vm.specification.name"
    or
    f.hasName("JAVA_VM_SPECIFICATION_VENDOR") and propertyName = "java.vm.specification.vendor"
    or
    f.hasName("JAVA_VM_VENDOR") and propertyName = "java.vm.vendor"
    or
    f.hasName("JAVA_VM_VERSION") and propertyName = "java.vm.version"
    or
    f.hasName("LINE_SEPARATOR") and propertyName = "line.separator"
    or
    f.hasName("OS_ARCH") and propertyName = "os.arch"
    or
    f.hasName("OS_NAME") and propertyName = "os.name"
    or
    f.hasName("OS_VERSION") and propertyName = "os.version"
    or
    f.hasName("PATH_SEPARATOR") and propertyName = "path.separator"
    or
    f.hasName("USER_COUNTRY") and propertyName = "user.country"
    or
    f.hasName("USER_DIR") and propertyName = "user.dir"
    or
    f.hasName("USER_HOME") and propertyName = "user.home"
    or
    f.hasName("USER_LANGUAGE") and propertyName = "user.language"
    or
    f.hasName("USER_NAME") and propertyName = "user.name"
    or
    f.hasName("USER_TIMEZONE") and propertyName = "user.timezone"
  )
}

private MethodCall getSystemPropertyFromApacheFileUtils(string propertyName) {
  exists(Method m |
    result.getMethod() = m and
    m.getDeclaringType().hasQualifiedName("org.apache.commons.io", "FileUtils")
  |
    m.hasName(["getTempDirectory", "getTempDirectoryPath"]) and propertyName = "java.io.tmpdir"
    or
    m.hasName(["getUserDirectory", "getUserDirectoryPath"]) and propertyName = "user.home"
  )
}

private MethodCall getSystemPropertyFromGuava(string propertyName) {
  exists(EnumConstant ec |
    ec.getDeclaringType().hasQualifiedName("com.google.common.base", "StandardSystemProperty") and
    // Example: `StandardSystemProperty.JAVA_IO_TMPDIR.value()`
    (
      localExprFlowPlusInitializers(ec.getAnAccess(), result.getQualifier()) and
      result.getMethod().hasName("value")
    )
    or
    // Example: `System.getProperty(StandardSystemProperty.JAVA_IO_TMPDIR.key())`
    exists(MethodCall keyMa |
      localExprFlowPlusInitializers(ec.getAnAccess(), keyMa.getQualifier()) and
      keyMa.getMethod().hasName("key") and
      localExprFlowPlusInitializers(keyMa, result.(MethodCallSystemGetProperty).getArgument(0))
    )
  |
    ec.hasName("JAVA_VERSION") and propertyName = "java.version"
    or
    ec.hasName("JAVA_VENDOR") and propertyName = "java.vendor"
    or
    ec.hasName("JAVA_VENDOR_URL") and propertyName = "java.vendor.url"
    or
    ec.hasName("JAVA_HOME") and propertyName = "java.home"
    or
    ec.hasName("JAVA_VM_SPECIFICATION_VERSION") and propertyName = "java.vm.specification.version"
    or
    ec.hasName("JAVA_VM_SPECIFICATION_VENDOR") and propertyName = "java.vm.specification.vendor"
    or
    ec.hasName("JAVA_VM_SPECIFICATION_NAME") and propertyName = "java.vm.specification.name"
    or
    ec.hasName("JAVA_VM_VERSION") and propertyName = "java.vm.version"
    or
    ec.hasName("JAVA_VM_VENDOR") and propertyName = "java.vm.vendor"
    or
    ec.hasName("JAVA_VM_NAME") and propertyName = "java.vm.name"
    or
    ec.hasName("JAVA_SPECIFICATION_VERSION") and propertyName = "java.specification.version"
    or
    ec.hasName("JAVA_SPECIFICATION_VENDOR") and propertyName = "java.specification.vendor"
    or
    ec.hasName("JAVA_SPECIFICATION_NAME") and propertyName = "java.specification.name"
    or
    ec.hasName("JAVA_CLASS_VERSION") and propertyName = "java.class.version"
    or
    ec.hasName("JAVA_CLASS_PATH") and propertyName = "java.class.path"
    or
    ec.hasName("JAVA_LIBRARY_PATH") and propertyName = "java.library.path"
    or
    ec.hasName("JAVA_IO_TMPDIR") and propertyName = "java.io.tmpdir"
    or
    ec.hasName("JAVA_COMPILER") and propertyName = "java.compiler"
    or
    ec.hasName("JAVA_EXT_DIRS") and propertyName = "java.ext.dirs"
    or
    ec.hasName("OS_NAME") and propertyName = "os.name"
    or
    ec.hasName("OS_ARCH") and propertyName = "os.arch"
    or
    ec.hasName("OS_VERSION") and propertyName = "os.version"
    or
    ec.hasName("FILE_SEPARATOR") and propertyName = "file.separator"
    or
    ec.hasName("PATH_SEPARATOR") and propertyName = "path.separator"
    or
    ec.hasName("LINE_SEPARATOR") and propertyName = "line.separator"
    or
    ec.hasName("USER_NAME") and propertyName = "user.name"
    or
    ec.hasName("USER_HOME") and propertyName = "user.home"
    or
    ec.hasName("USER_DIR") and propertyName = "user.dir"
  )
}

private MethodCall getSystemPropertyFromOperatingSystemMXBean(string propertyName) {
  exists(Method m |
    m = result.getMethod() and
    m.getDeclaringType().hasQualifiedName("java.lang.management", "OperatingSystemMXBean")
  |
    m.getName() = "getName" and propertyName = "os.name"
    or
    m.getName() = "getArch" and propertyName = "os.arch"
    or
    m.getName() = "getVersion" and propertyName = "os.version"
  )
}

private MethodCall getSystemPropertyFromSpringProperties(string propertyName) {
  exists(Method m |
    m = result.getMethod() and
    m.getDeclaringType().hasQualifiedName("org.springframework.core", "SpringProperties") and
    m.hasName("getProperty")
  ) and
  result.getArgument(0).(CompileTimeConstantExpr).getStringValue() = propertyName
}

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps or via local variable intializers
 * for final variables.
 */
private predicate localExprFlowPlusInitializers(Expr e1, Expr e2) {
  localFlowPlusInitializers(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

/**
 * Holds if data can flow from `pred` to `succ` in zero or more
 * local (intra-procedural) steps or via instance or static variable intializers
 * for final variables.
 */
private predicate localFlowPlusInitializers(DataFlow::Node pred, DataFlow::Node succ) {
  exists(Variable v | v.isFinal() and pred.asExpr() = v.getInitializer() |
    DataFlow::localFlow(DataFlow::exprNode(v.getAnAccess()), succ)
  )
  or
  DataFlow::localFlow(pred, succ)
}
