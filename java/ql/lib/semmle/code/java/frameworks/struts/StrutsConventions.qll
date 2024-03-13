import java
import semmle.code.java.frameworks.struts.StrutsAnnotations
import semmle.code.java.frameworks.struts.StrutsXML
import semmle.code.xml.MavenPom

/**
 * A Maven dependency on the Struts 2 convention plugin.
 */
class Struts2ConventionDependency extends Dependency {
  Struts2ConventionDependency() {
    this.getGroup().getValue() = "org.apache.struts" and
    this.getArtifact().getValue() = "struts2-convention-plugin"
  }
}

/**
 * Gets the folder containing the root package folder for the `compilationUnit`.
 *
 * This gets the first ancestor of the `compilationUnit` that does not represent a package. We can
 * assume that compilation units that share the same source folder are compiled and run against the
 * same set of library classes.
 */
private Folder getSourceFolder(CompilationUnit compilationUnit) {
  compilationUnit.fromSource() and
  exists(string relativePath, string fullPath |
    relativePath = compilationUnit.getPackage().getName().replaceAll(".", "/") and
    fullPath = compilationUnit.getFile().getParentContainer().getAbsolutePath()
  |
    result.getAbsolutePath() = fullPath.prefix(fullPath.length() - relativePath.length() - 1)
  )
}

private predicate strutsConventionAnnotationUsedInFolder(Folder f) {
  exists(Annotation a |
    a.getType().getPackage().hasName("org.apache.struts2.convention.annotation")
  |
    getSourceFolder(a.getAnnotatedElement().getCompilationUnit()) = f
  )
}

/**
 * Holds if we believe the Struts convention plugin applies to this `refType`.
 *
 * We use the following three heuristics to determine whether the struts convention plugin applies
 * to this `refType`:
 *
 *  1. Whether a convention annotation is used within the same source directory as the `refType`.
 *  2. Whether a convention property is set in a struts configuration file for this `refType`.
 *  3. Whether the RefType exists in a Maven project that depends on the convention plugin.
 */
private predicate isStrutsConventionPluginUsed(RefType refType) {
  // A convention annotation is used within the same source folder as this RefType.
  strutsConventionAnnotationUsedInFolder(getSourceFolder(refType.getCompilationUnit()))
  or
  // The struts configuration file for this file sets a convention property
  getRootXmlFile(refType).getAConstant().getName().matches("struts.convention%")
  or
  // We've found the POM for this RefType, and it includes a dependency on the convention plugin
  exists(Pom pom |
    pom.getASourceRefType() = refType and
    pom.getADependency() instanceof Struts2ConventionDependency
  )
}

/**
 * Gets the "root" `struts.xml` file that we believe applies to this `refType`.
 *
 * We guess by identifying the "nearest" `struts.xml` configuration file, i.e. the Struts
 * configuration file with the lowest common ancestor to this file.
 */
StrutsXmlFile getRootXmlFile(RefType refType) {
  exists(StrutsFolder strutsFolder |
    strutsFolder = refType.getFile().getParentContainer*() and
    strutsFolder.isUnique()
  |
    result = strutsFolder.getAStrutsRootFile()
  )
}

/**
 * Gets the suffix used for automatically identifying actions when using the convention plugin.
 *
 * If no configuration is supplied, or identified, the default is "Action".
 */
private string getConventionSuffix(RefType refType) {
  if exists(getRootXmlFile(refType).getConstantValue("struts.convention.action.suffix"))
  then result = getRootXmlFile(refType).getConstantValue("struts.convention.action.suffix")
  else result = "Action"
}

/**
 * A Struts 2 action class as identified by the convention plugin.
 *
 * The convention plugin identifies as an action class any class that has an ancestor package with
 * the name "struts", "struts2", "action" or "actions", and either has an indicative suffix on the
 * name, or extends com.opensymphony.xwork2.Action.
 */
class Struts2ConventionActionClass extends Class {
  Struts2ConventionActionClass() {
    isStrutsConventionPluginUsed(this) and
    exists(string ancestorPackage |
      // Has an ancestor package on the whitelist
      ancestorPackage = this.getPackage().getName().splitAt(".") and
      ancestorPackage = ["struts", "struts2", "action", "actions"]
    ) and
    (
      this.getName().matches("%" + getConventionSuffix(this)) or
      this.getAnAncestor().hasQualifiedName("com.opensymphony.xwork2", "Action")
    )
  }

  /**
   * Gets an Action method.
   */
  Method getAnActionMethod() {
    this.inherits(result) and
    // Default mapping
    (
      result.hasName("execute") or
      exists(StrutsActionAnnotation actionAnnotation |
        result = actionAnnotation.getActionCallable()
      )
    )
  }
}
