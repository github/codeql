/**
 * @name Access to unsupported JDK-internal API
 * @description Use of unsupported JDK-internal APIs may cause compatibility issues
 *              when upgrading to newer versions of Java, in particular Java 9.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/jdk-internal-api-access
 * @tags maintainability
 */

import java
import JdkInternals
import JdkInternalsReplacement

predicate importedType(Import i, RefType t) {
  i.(ImportType).getImportedType() = t or
  i.(ImportStaticTypeMember).getTypeHoldingImport() = t or
  i.(ImportStaticOnDemand).getTypeHoldingImport() = t or
  i.(ImportOnDemandFromType).getTypeHoldingImport() = t
}

predicate importedPackage(Import i, Package p) {
  i.(ImportOnDemandFromPackage).getPackageHoldingImport() = p
}

predicate typeReplacement(RefType t, string repl) {
  exists(string old | jdkInternalReplacement(old, repl) | t.getQualifiedName() = old)
}

predicate packageReplacementForType(RefType t, string repl) {
  exists(string old, string pkgName |
    jdkInternalReplacement(old, repl) and t.getPackage().getName() = pkgName
  |
    pkgName = old or
    pkgName.prefix(old.length() + 1) = old + "."
  )
}

predicate packageReplacement(Package p, string repl) {
  exists(string old | jdkInternalReplacement(old, repl) |
    p.getName() = old or
    p.getName().prefix(old.length() + 1) = old + "."
  )
}

predicate replacement(RefType t, string repl) {
  typeReplacement(t, repl)
  or
  not typeReplacement(t, _) and packageReplacementForType(t, repl)
}

abstract class JdkInternalAccess extends Element {
  abstract string getAccessedApi();

  abstract string getReplacement();
}

class JdkInternalTypeAccess extends JdkInternalAccess, TypeAccess {
  JdkInternalTypeAccess() { jdkInternalApi(this.getType().(RefType).getPackage().getName()) }

  override string getAccessedApi() { result = this.getType().(RefType).getQualifiedName() }

  override string getReplacement() {
    exists(RefType t | this.getType() = t |
      (
        replacement(t, result)
        or
        not replacement(t, _) and result = "unknown"
      )
    )
  }
}

class JdkInternalImport extends JdkInternalAccess, Import {
  JdkInternalImport() {
    exists(RefType t | importedType(this, t) | jdkInternalApi(t.getPackage().getName()))
    or
    exists(Package p | importedPackage(this, p) | jdkInternalApi(p.getName()))
  }

  override string getAccessedApi() {
    exists(RefType t | result = t.getQualifiedName() | importedType(this, t))
    or
    exists(Package p | result = p.getName() | importedPackage(this, p))
  }

  override string getReplacement() {
    exists(RefType t |
      importedType(this, t) and
      (
        replacement(t, result)
        or
        not replacement(t, _) and result = "unknown"
      )
    )
    or
    exists(Package p |
      importedPackage(this, p) and
      (
        packageReplacement(p, result)
        or
        not packageReplacement(p, _) and result = "unknown"
      )
    )
  }
}

predicate jdkPackage(Package p) {
  exists(string pkgName |
    p.getName() = pkgName or
    p.getName().prefix(pkgName.length() + 1) = pkgName + "."
  |
    pkgName =
      [
        "com.sun", "sun", "java", "javax", "com.oracle.net", "genstubs", "jdk", "build.tools",
        "org.omg.CORBA", "org.ietf.jgss"
      ]
  )
}

from JdkInternalAccess ta, string repl, string msg
where
  repl = ta.getReplacement() and
  (if repl = "unknown" then msg = "" else msg = " (" + repl + ")") and
  not jdkInternalApi(ta.getCompilationUnit().getPackage().getName()) and
  not jdkPackage(ta.getCompilationUnit().getPackage())
select ta, "Access to unsupported JDK-internal API '" + ta.getAccessedApi() + "'." + msg
