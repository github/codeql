/** Definitions for the keyboard cache query */

import java
import semmle.code.java.dataflow.DataFlow
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
    this.getClass().getASourceSupertype*().hasQualifiedName("android.widget", "EditText")
  }

  /** Gets the input type of this field, if any. */
  string getInputType() { result = this.getAttribute("inputType").(AndroidXmlAttribute).getValue() }
}

/** A `findViewById` or `requireViewById` method on `Activity` or `View`. */
private class FindViewMethod extends Method {
  FindViewMethod() {
    this.hasQualifiedName("android.view", "View", ["findViewById", "requireViewById"])
    or
    exists(Method m |
      m.hasQualifiedName("android.app", "Activity", ["findViewById", "requireViewById"]) and
      this = m.getAnOverride*()
    )
  }
}

/** Gets a use of the view that has the given id. */
private MethodCall getAUseOfViewWithId(string id) {
  exists(string name, NestedClass r_id, Field id_field |
    id = "@+id/" + name and
    result.getMethod() instanceof FindViewMethod and
    r_id.getEnclosingType().hasName("R") and
    r_id.hasName("id") and
    id_field.getDeclaringType() = r_id and
    id_field.hasName(name)
  |
    DataFlow::localExprFlow(id_field.getAnAccess(), result.getArgument(0))
  )
}

/** Gets the argument of a use of `setInputType` called on the view with the given id. */
private Argument setInputTypeForId(string id) {
  exists(MethodCall setInputType |
    setInputType.getMethod().hasQualifiedName("android.widget", "TextView", "setInputType") and
    DataFlow::localExprFlow(getAUseOfViewWithId(id), setInputType.getQualifier()) and
    result = setInputType.getArgument(0)
  )
}

/** Holds if the given field is a constant flag indicating that an input with this type will not be cached. */
private predicate inputTypeFieldNotCached(Field f) {
  f.getDeclaringType().hasQualifiedName("android.text", "InputType") and
  (
    not f.getName().matches("%TEXT%")
    or
    f.getName().matches("%PASSWORD%")
    or
    f.hasName("TYPE_TEXT_FLAG_NO_SUGGESTIONS")
  )
}

/** Configuration that finds uses of `setInputType` for non cached fields. */
private module GoodInputTypeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    inputTypeFieldNotCached(node.asExpr().(FieldAccess).getField())
  }

  predicate isSink(DataFlow::Node node) { node.asExpr() = setInputTypeForId(_) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(OrBitwiseExpr bitOr |
      node1.asExpr() = bitOr.getAChildExpr() and
      node2.asExpr() = bitOr
    )
  }
}

private module GoodInputTypeFlow = DataFlow::Global<GoodInputTypeConfig>;

/** Gets a regex indicating that an input field may contain sensitive data. */
private string getInputSensitiveInfoRegex() {
  result =
    [
      getCommonSensitiveInfoRegex(),
      "(?i).*(bank|credit|debit|(pass(wd|word|code|phrase))|security).*"
    ]
}

/** Holds if input using the given input type (as written in XML) is not stored in the keyboard cache. */
bindingset[ty]
private predicate inputTypeNotCached(string ty) {
  not ty.matches("%text%")
  or
  ty.regexpMatch("(?i).*(nosuggestions|password).*")
}

/** Gets an input field whose contents may be sensitive and may be stored in the keyboard cache. */
AndroidEditableXmlElement getASensitiveCachedInput() {
  result.getId().regexpMatch(getInputSensitiveInfoRegex()) and
  (
    not inputTypeNotCached(result.getInputType()) and
    not exists(DataFlow::Node sink |
      GoodInputTypeFlow::flowTo(sink) and
      sink.asExpr() = setInputTypeForId(result.getId())
    )
  )
}
