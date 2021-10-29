/** Provides classes for working with the W3C Document Object Model (DOM). */

import java
import semmle.code.java.dataflow.FlowSources

/** The interface `org.w3c.dom.NodeList`. */
class TypeDomNodeList extends Interface {
  TypeDomNodeList() { this.hasQualifiedName("org.w3c.dom", "NodeList") }
}

/** Model of handling XML DOM. */
private class DomDataModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.w3c.dom;Document;true;getElementsByTagName" + ["", "NS"] +
          ";;;Argument[-1];ReturnValue;taint",
        "org.w3c.dom;NodeList;true;item;;;Argument[-1];ReturnValue;taint"
      ]
  }
}
