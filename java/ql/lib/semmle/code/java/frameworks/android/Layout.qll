/** Provides classes and predicates for working with Android layouts and UI elements. */

import java
import semmle.code.xml.AndroidManifest
private import semmle.code.java.dataflow.DataFlow

/** An Android Layout XML file. */
class AndroidLayoutXmlFile extends XmlFile {
  AndroidLayoutXmlFile() { this.getRelativePath().regexpMatch("(.*/)?res/layout/.*\\.xml") }
}

/** A component declared in an Android layout file. */
class AndroidLayoutXmlElement extends XmlElement {
  AndroidLayoutXmlElement() { this.getFile() instanceof AndroidLayoutXmlFile }

  /** Gets the ID of this component, if any. */
  string getId() { result = this.getAttribute("id").getValue() }

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
    exists(Method m | this.getAnOverride*() = m |
      m.hasQualifiedName("android.app", "Activity", ["findViewById", "requireViewById"])
      or
      m.hasQualifiedName("android.view", "View", ["findViewById", "requireViewById"])
      or
      m.hasQualifiedName("android.app", "Dialog", ["findViewById", "requireViewById"])
    )
  }
}

/** Gets a use of the view that has the given id. (that is, from a call to a method like `findViewById`) */
MethodCall getAUseOfViewWithId(string id) {
  exists(string name, NestedClass r_id, Field id_field |
    id = ["@+id/", "@id/"] + name and
    result.getMethod() instanceof FindViewMethod and
    r_id.getEnclosingType().hasName("R") and
    r_id.hasName("id") and
    id_field.getDeclaringType() = r_id and
    id_field.hasName(name)
  |
    DataFlow::localExprFlow(id_field.getAnAccess(), result.getArgument(0))
  )
}
