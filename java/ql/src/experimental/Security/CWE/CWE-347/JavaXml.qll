/** Provides classes for working with the javax.xml package. */

import java
import semmle.code.java.dataflow.FlowSources

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
        "javax.xml.crypto.dsig.dom;DOMValidateContext;false;DOMValidateContext;;;Argument[1];Argument[-1];taint",
        "javax.xml.crypto.dsig;XMLSignatureFactory;true;unmarshalXMLSignature;;;Argument[0];ReturnValue;taint"
      ]
  }
}
