import java
import semmle.code.xml.XML

/**
 * Holds if any struts XML files are included in this snapshot.
 */
predicate isStrutsXMLIncluded() { exists(StrutsXMLFile strutsXML) }

/**
 * A struts 2 configuration file.
 */
abstract class StrutsXMLFile extends XMLFile {
  StrutsXMLFile() {
    // Contains a single top-level XML node named "struts".
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "struts"
  }

  /**
   * Gets a "root" struts configuration file that includes this file.
   */
  StrutsRootXMLFile getARoot() { result.getAnIncludedFile() = this }

  /**
   * Gets a directly included file.
   */
  StrutsXMLFile getADirectlyIncludedFile() {
    exists(StrutsXMLInclude include | include.getFile() = this | result = include.getIncludedFile())
  }

  /**
   * Gets a transitively included file.
   */
  StrutsXMLFile getAnIncludedFile() { result = getADirectlyIncludedFile*() }

  /**
   * Gets a `<constant>` defined in this file, or an included file.
   */
  StrutsXMLConstant getAConstant() { result.getFile() = getAnIncludedFile() }

  /**
   * Gets the value of the constant with the given `name`.
   */
  string getConstantValue(string name) {
    exists(StrutsXMLConstant constant | constant = getAConstant() |
      constant.getConstantName() = name and
      result = constant.getConstantValue()
    )
  }
}

/**
 * A Struts 2 "root" configuration XML file directly read by struts.
 *
 * Root configurations either have the name `struts.xml` or `struts-plugin.xml`.
 */
class StrutsRootXMLFile extends StrutsXMLFile {
  StrutsRootXMLFile() {
    getBaseName() = "struts.xml" or
    getBaseName() = "struts-plugin.xml"
  }
}

/**
 * A Struts 2 configuration XML file included, directly or indirectly, by a root Struts configuration.
 */
class StrutsIncludedXMLFile extends StrutsXMLFile {
  StrutsIncludedXMLFile() { exists(StrutsXMLInclude include | this = include.getIncludedFile()) }
}

/**
 * A Folder which has one or more Struts 2 root configurations.
 */
class StrutsFolder extends Folder {
  StrutsFolder() {
    exists(Container c | c = getAChildContainer() |
      c instanceof StrutsFolder or
      c instanceof StrutsXMLFile
    )
  }

  /**
   * Holds if this folder has a unique Struts root configuration file.
   */
  predicate isUnique() { count(getAStrutsRootFile()) = 1 }

  /**
   * Gets a struts root configuration that applies to this folder.
   */
  StrutsRootXMLFile getAStrutsRootFile() {
    result = getAChildContainer() or
    result = getAChildContainer().(StrutsFolder).getAStrutsRootFile()
  }
}

/**
 * An XML element in a `StrutsXMLFile`.
 */
class StrutsXMLElement extends XMLElement {
  StrutsXMLElement() { this.getFile() instanceof StrutsXMLFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = allCharactersString().trim() }
}

/**
 * A `<include>` element within a `struts.xml` file.
 *
 * This indicates that the file specified in the `file` attribute should be included in the struts
 * configuration. The file is looked up using the classpath.
 */
class StrutsXMLInclude extends StrutsXMLElement {
  StrutsXMLInclude() { this.getName() = "include" }

  /**
   * Gets the XMLFile that we believe is included by this include statement.
   *
   * We have no notion of classpath, so we assume that any file that matches the path could
   * potentially be included.
   */
  XMLFile getIncludedFile() {
    exists(string file | file = getAttribute("file").getValue() |
      result.getAbsolutePath().matches("%" + escapeForMatch(file))
    )
  }
}

/**
 * Escape a string for use as the matcher in a string.match(..) call.
 */
bindingset[s]
private string escapeForMatch(string s) { result = s.replaceAll("%", "\\%").replaceAll("_", "\\_") }

/**
 * Struts 2 wildcard matching.
 *
 * In Struts 2, certain strings may include wildcards of the form "{n}", where n is between 0 and 9.
 * These can be replaced by arbitrary input provided in the URL. `matches` will be constrained to be
 * only those strings that are valid substitutions into the matching string.
 */
bindingset[matches, wildcardstring]
private predicate strutsWildcardMatching(string matches, string wildcardstring) {
  if wildcardstring.matches("%{%}%")
  then matches.matches(escapeForMatch(wildcardstring).regexpReplaceAll("\\{[0-9]\\}", "%"))
  else matches = wildcardstring
}

/**
 * A `<action>` element within a `struts.xml` file.
 */
class StrutsXMLAction extends StrutsXMLElement {
  StrutsXMLAction() { this.getName() = "action" }

  /**
   * Gets the `Class` that is referenced by this Struts action.
   */
  Class getActionClass() {
    strutsWildcardMatching(result.getQualifiedName(), getAttribute("class").getValue())
  }

  string getMethodName() { result = getAttribute("method").getValue() }

  /**
   * Gets the `Method` which is referenced by this action.
   *
   * If no method is specified in the attributes of this element, a method named `execute` is chosen.
   */
  Method getActionMethod() {
    getActionClass().inherits(result) and
    if exists(getMethodName())
    then strutsWildcardMatching(result.getName(), getMethodName())
    else result.hasName("execute")
  }
}

/**
 * A `<constant>` property, representing a configuration parameter to struts.
 */
class StrutsXMLConstant extends StrutsXMLElement {
  StrutsXMLConstant() { getName() = "constant" }

  string getConstantName() { result = getAttribute("name").getValue() }

  string getConstantValue() { result = getAttribute("value").getValue() }
}
