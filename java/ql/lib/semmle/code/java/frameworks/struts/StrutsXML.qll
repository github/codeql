import java

/**
 * Holds if any struts XML files are included in this snapshot.
 */
predicate isStrutsXmlIncluded() { exists(StrutsXmlFile strutsXml) }

/**
 * A struts 2 configuration file.
 */
abstract class StrutsXmlFile extends XmlFile {
  StrutsXmlFile() {
    // Contains a single top-level XML node named "struts".
    count(XmlElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "struts"
  }

  /**
   * Gets a "root" struts configuration file that includes this file.
   */
  StrutsRootXmlFile getARoot() { result.getAnIncludedFile() = this }

  /**
   * Gets a directly included file.
   */
  StrutsXmlFile getADirectlyIncludedFile() {
    exists(StrutsXmlInclude include | include.getFile() = this | result = include.getIncludedFile())
  }

  /**
   * Gets a transitively included file.
   */
  StrutsXmlFile getAnIncludedFile() { result = this.getADirectlyIncludedFile*() }

  /**
   * Gets a `<constant>` defined in this file, or an included file.
   */
  StrutsXmlConstant getAConstant() { result.getFile() = this.getAnIncludedFile() }

  /**
   * Gets the value of the constant with the given `name`.
   */
  string getConstantValue(string name) {
    exists(StrutsXmlConstant constant | constant = this.getAConstant() |
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
class StrutsRootXmlFile extends StrutsXmlFile {
  StrutsRootXmlFile() {
    this.getBaseName() = "struts.xml" or
    this.getBaseName() = "struts-plugin.xml"
  }
}

/**
 * A Struts 2 configuration XML file included, directly or indirectly, by a root Struts configuration.
 */
class StrutsIncludedXmlFile extends StrutsXmlFile {
  StrutsIncludedXmlFile() { exists(StrutsXmlInclude include | this = include.getIncludedFile()) }
}

/**
 * A Folder which has one or more Struts 2 root configurations.
 */
class StrutsFolder extends Folder {
  StrutsFolder() {
    exists(Container c | c = this.getAChildContainer() |
      c instanceof StrutsFolder or
      c instanceof StrutsXmlFile
    )
  }

  /**
   * Holds if this folder has a unique Struts root configuration file.
   */
  predicate isUnique() { count(this.getAStrutsRootFile()) = 1 }

  /**
   * Gets a struts root configuration that applies to this folder.
   */
  StrutsRootXmlFile getAStrutsRootFile() {
    result = this.getAChildContainer() or
    result = this.getAChildContainer().(StrutsFolder).getAStrutsRootFile()
  }
}

/**
 * An XML element in a `StrutsXMLFile`.
 */
class StrutsXmlElement extends XmlElement {
  StrutsXmlElement() { this.getFile() instanceof StrutsXmlFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = this.allCharactersString().trim() }
}

/**
 * A `<include>` element within a `struts.xml` file.
 *
 * This indicates that the file specified in the `file` attribute should be included in the struts
 * configuration. The file is looked up using the classpath.
 */
class StrutsXmlInclude extends StrutsXmlElement {
  StrutsXmlInclude() { this.getName() = "include" }

  /**
   * Gets the XMLFile that we believe is included by this include statement.
   *
   * We have no notion of classpath, so we assume that any file that matches the path could
   * potentially be included.
   */
  XmlFile getIncludedFile() {
    exists(string file | file = this.getAttribute("file").getValue() |
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
class StrutsXmlAction extends StrutsXmlElement {
  StrutsXmlAction() { this.getName() = "action" }

  /**
   * Gets the `Class` that is referenced by this Struts action.
   */
  Class getActionClass() {
    strutsWildcardMatching(result.getQualifiedName(), this.getAttribute("class").getValue())
  }

  string getMethodName() { result = this.getAttribute("method").getValue() }

  /**
   * Gets the `Method` which is referenced by this action.
   *
   * If no method is specified in the attributes of this element, a method named `execute` is chosen.
   */
  Method getActionMethod() {
    this.getActionClass().inherits(result) and
    if exists(this.getMethodName())
    then strutsWildcardMatching(result.getName(), this.getMethodName())
    else result.hasName("execute")
  }
}

/**
 * A `<constant>` property, representing a configuration parameter to struts.
 */
class StrutsXmlConstant extends StrutsXmlElement {
  StrutsXmlConstant() { this.getName() = "constant" }

  string getConstantName() { result = this.getAttribute("name").getValue() }

  string getConstantValue() { result = this.getAttribute("value").getValue() }
}
