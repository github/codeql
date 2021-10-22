/** Provides classes for working with the W3C Document Object Model (DOM). */

import java
import semmle.code.java.dataflow.FlowSources

/** The interface `org.w3c.dom.NodeList`. */
class TypeDomNodeList extends Interface {
  TypeDomNodeList() { this.hasQualifiedName("org.w3c.dom", "NodeList") }
}

/** The class `javax.xml.crypto.dsig.XMLSignature`. */
private class TypeXMLSignature extends Interface {
  TypeXMLSignature() { this.hasQualifiedName("javax.xml.crypto.dsig", "XMLSignature") }
}

/** The method `validate` of `TypeXMLSignature`. */
class ValidateSignatureMethod extends Method {
  ValidateSignatureMethod() {
    this.hasName("validate") and
    this.getDeclaringType().getASupertype*() instanceof TypeXMLSignature
  }
}

/** Model of handling XML DOM. */
private class DomDataModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.w3c.dom;Document;true;getElementsByTagName" + ["", "NS"] +
          ";;;Argument[-1];ReturnValue;taint",
        "org.w3c.dom;NodeList;true;item;;;Argument[-1];ReturnValue;taint",
        "javax.xml.crypto.dsig.dom;DOMValidateContext;false;DOMValidateContext;;;Argument[1];Argument[-1];taint",
        "javax.xml.crypto.dsig;XMLSignatureFactory;true;unmarshalXMLSignature;;;Argument[0];ReturnValue;taint"
      ]
  }
}
