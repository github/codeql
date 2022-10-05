/** Definitions for the keyboard cache query */

import java
import semmle.code.java.security.SensitiveActions

/** An Android Layout XML file. */
class AndroidLayoutXmlFile extends XmlFile {
  AndroidLayoutXmlFile() { this.getAbsolutePath().matches("%/res/layout/%.xml") }
}

/** An XML element that represents an editable text field. */
class AndroidEditableXmlElement extends XmlElement {
  XmlAttribute inputType;
  XmlAttribute id;

  AndroidEditableXmlElement() {
    this.getFile() instanceof AndroidLayoutXmlFile and
    inputType = this.getAnAttribute() and
    inputType.getNamespace().getPrefix() = "android" and
    inputType.getName() = "inputType" and
    id = this.getAnAttribute() and
    id.getNamespace().getPrefix() = "android" and
    id.getName() = "id"
  }

  /** Gets the input type of this field. */
  string getInputType() { result = inputType.getValue() }

  /** Gets the ID of this field. */
  string getId() { result = id.getValue() }
}

/** Gets a regex inidcating that an input field may contain sensitive data. */
private string getInputSensitiveInfoRegex() {
  result =
    [
      getCommonSensitiveInfoRegex(),
      "(?i).*(bank|credit|debit|(pass(wd|word|code|phrase))|security).*"
    ]
}

/** Holds if input using the given input type may be stored in the keyboard cache. */
bindingset[ty]
private predicate inputTypeCached(string ty) {
  ty.matches("%text%") and
  not ty.regexpMatch("(?i).*(nosuggestions|password).*")
}

/** Gets an input field whose contents may be sensitive and may be stored in the keyboard cache. */
AndroidEditableXmlElement getASensitiveCachedInput() {
  result.getId().regexpMatch(getInputSensitiveInfoRegex()) and
  inputTypeCached(result.getInputType())
}
