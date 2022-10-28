/** Definitions for the keyboard cache query */

import java
import semmle.code.java.security.SensitiveActions
import semmle.code.xml.AndroidManifest

/** An Android Layout XML file. */
private class AndroidLayoutXmlFile extends XmlFile {
  AndroidLayoutXmlFile() { this.getRelativePath().matches("%/res/layout/%.xml") }
}

/** A component declared in an Android layout file. */
class AndroidLayoutXmlElement extends XmlElement {
  AndroidXmlAttribute id;

  AndroidLayoutXmlElement() {
    this.getFile() instanceof AndroidLayoutXmlFile and
    id = this.getAttribute("id")
  }

  /** Gets the ID of this component. */
  string getId() { result = id.getValue() }

  /** Gets the class of this component. */
  Class getClass() {
    this.getName() = "view" and
    this.getAttribute("class").getValue() = result.getQualifiedName()
    or
    this.getName() = result.getQualifiedName()
    or
    result.hasQualifiedName(["android.widget", "android.view"], this.getName())
  }
}

/** An XML element that represents an editable text field. */
class AndroidEditableXmlElement extends AndroidLayoutXmlElement {
  AndroidEditableXmlElement() {
    exists(Class editText |
      editText.hasQualifiedName("android.widget", "EditText") and
      editText = this.getClass().getASourceSupertype*()
    )
  }

  /** Gets the input type of this field, if any. */
  string getInputType() { result = this.getAttribute("inputType").(AndroidXmlAttribute).getValue() }
}

/** Gets a regex indicating that an input field may contain sensitive data. */
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
