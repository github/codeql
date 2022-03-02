import java
private import semmle.code.java.frameworks.apache.Lang

Expr getSystemProperty(string propertyName) {
  result =
    any(MethodAccessSystemGetProperty methodAccessSystemGetProperty |
      methodAccessSystemGetProperty.hasCompileTimeConstantGetPropertyName(propertyName)
    ) or
  result = getSystemPropertyFromApacheSystemUtils(propertyName) or
  result = getSystemPropertyFromApacheFileUtils(propertyName) or
  result = getSystemPropertyFromOperatingSystemMXBean(propertyName)
}

/**
 * A field access to the system property.
 * See: https://commons.apache.org/proper/commons-lang/apidocs/org/apache/commons/lang3/SystemUtils.html
 */
private FieldAccess getSystemPropertyFromApacheSystemUtils(string propertyName) {
  exists(Field f | f = result.getField() and f.getDeclaringType() instanceof ApacheSystemUtils |
    f.getName() = "AWT_TOOLKIT" and propertyName = "awt.toolkit"
    or
    f.getName() = "FILE_ENCODING" and propertyName = "file.encoding"
    or
    f.getName() = "FILE_SEPARATOR" and propertyName = "file.separator"
    or
    f.getName() = "JAVA_AWT_FONTS" and propertyName = "java.awt.fonts"
    or
    f.getName() = "JAVA_AWT_GRAPHICSENV" and propertyName = "java.awt.graphicsenv"
    or
    f.getName() = "JAVA_AWT_HEADLESS" and propertyName = "java.awt.headless"
    or
    f.getName() = "JAVA_AWT_PRINTERJOB" and propertyName = "java.awt.printerjob"
    or
    f.getName() = "JAVA_CLASS_PATH" and propertyName = "java.class.path"
    or
    f.getName() = "JAVA_CLASS_VERSION" and propertyName = "java.class.version"
    or
    f.getName() = "JAVA_COMPILER" and propertyName = "java.compiler"
    or
    f.getName() = "JAVA_EXT_DIRS" and propertyName = "java.ext.dirs"
    or
    f.getName() = "JAVA_HOME" and propertyName = "java.home"
    or
    f.getName() = "JAVA_IO_TMPDIR" and propertyName = "java.io.tmpdir"
    or
    f.getName() = "JAVA_LIBRARY_PATH" and propertyName = "java.library.path"
    or
    f.getName() = "JAVA_RUNTIME_NAME" and propertyName = "java.runtime.name"
    or
    f.getName() = "JAVA_RUNTIME_VERSION" and propertyName = "java.runtime.version"
    or
    f.getName() = "JAVA_SPECIFICATION_NAME" and propertyName = "java.specification.name"
    or
    f.getName() = "JAVA_SPECIFICATION_VENDOR" and propertyName = "java.specification.vendor"
    or
    f.getName() = "JAVA_UTIL_PREFS_PREFERENCES_FACTORY" and
    propertyName = "java.util.prefs.PreferencesFactory"
    or
    f.getName() = "JAVA_VENDOR" and propertyName = "java.vendor"
    or
    f.getName() = "JAVA_VENDOR_URL" and propertyName = "java.vendor.url"
    or
    f.getName() = "JAVA_VERSION" and propertyName = "java.version"
    or
    f.getName() = "JAVA_VM_INFO" and propertyName = "java.vm.info"
    or
    f.getName() = "JAVA_VM_NAME" and propertyName = "java.vm.name"
    or
    f.getName() = "JAVA_VM_SPECIFICATION_NAME" and propertyName = "java.vm.specification.name"
    or
    f.getName() = "JAVA_VM_SPECIFICATION_VENDOR" and propertyName = "java.vm.specification.vendor"
    or
    f.getName() = "JAVA_VM_VENDOR" and propertyName = "java.vm.vendor"
    or
    f.getName() = "JAVA_VM_VERSION" and propertyName = "java.vm.version"
    or
    f.getName() = "LINE_SEPARATOR" and propertyName = "line.separator"
    or
    f.getName() = "OS_ARCH" and propertyName = "os.arch"
    or
    f.getName() = "OS_NAME" and propertyName = "os.name"
    or
    f.getName() = "OS_VERSION" and propertyName = "os.version"
    or
    f.getName() = "PATH_SEPARATOR" and propertyName = "path.separator"
    or
    f.getName() = "USER_COUNTRY" and propertyName = "user.country"
    or
    f.getName() = "USER_DIR" and propertyName = "user.dir"
    or
    f.getName() = "USER_HOME" and propertyName = "user.home"
    or
    f.getName() = "USER_LANGUAGE" and propertyName = "user.language"
    or
    f.getName() = "USER_NAME" and propertyName = "user.name"
    or
    f.getName() = "USER_TIMEZONE" and propertyName = "user.timezone"
  )
}

private MethodAccess getSystemPropertyFromApacheFileUtils(string propertyName) {
  exists(Method m |
    result.getMethod() = m and
    m.getDeclaringType().hasQualifiedName("org.apache.commons.io", "FileUtils")
  |
    m.hasName(["getTempDirectory", "getTempDirectoryPath"]) and propertyName = "java.io.tmpdir"
    or
    m.hasName(["getUserDirectory", "getUserDirectoryPath"]) and propertyName = "user.home"
  )
}

private MethodAccess getSystemPropertyFromOperatingSystemMXBean(string propertyName) {
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
