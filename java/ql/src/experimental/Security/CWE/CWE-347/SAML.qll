/** Provides classes for working with SAML using the JAXB library. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

class XmlElementsAnnotation extends Annotation {
  XmlElementsAnnotation() {
    this.getType().hasQualifiedName("javax.xml.bind.annotation", "XmlElements")
  }
}

/** XML element of SAML assertion mapped to a Java class field. */
class TypeSamlAssertionField extends Field {
  Annotation xmlElement;

  TypeSamlAssertionField() {
    this.fromSource() and
    xmlElement =
      this.getAnAnnotation().(XmlElementsAnnotation).getValue("value").(ArrayInit).getAnInit() and
    xmlElement.getValue("name").(CompileTimeConstantExpr).getStringValue() =
      ["Assertion", "EncryptedAssertion"] and
    xmlElement.getValue("namespace").(CompileTimeConstantExpr).getStringValue() =
      "urn:oasis:names:tc:SAML:2.0:assertion"
  }
}

/** Source of SAML assertion in an XML document. */
class SamlAssertionSource extends DataFlow::Node {
  SamlAssertionSource() { sourceNode(this, "xmldoc") }
}

/** Holds if `ma` is a getter method call that returns a field of the type `TypeSamlAssertionField`. */
predicate isSamlAssertionMethodAccess(MethodAccess ma) {
  exists(TypeSamlAssertionField sf, ReturnStmt ret |
    ma.getMethod().getDeclaringType() = sf.getDeclaringType() and
    ret.getEnclosingCallable() = ma.getMethod() and
    ret.getResult() = sf.getAnAccess()
  )
}

/** Sink of the qualifier of a method call to SAML assertion. */
class SamlAssertionSink extends DataFlow::Node {
  SamlAssertionSink() {
    exists(MethodAccess geta |
      isSamlAssertionMethodAccess(geta) and this.asExpr() = geta.getQualifier()
    )
  }
}

/** Model of XML document builder in the new CSV format. */
private class XmlDocSource extends SourceModelCsv {
  override predicate row(string row) {
    row = ["javax.xml.parsers;DocumentBuilder;true;parse;;;ReturnValue;xmldoc"]
  }
}

/** Model of JAXB unmarshalling in the new CSV format. */
private class JaxbDataModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.xml.bind;JAXBElement;false;getValue;;;Argument[-1];ReturnValue;taint",
        "javax.xml.bind;Unmarshaller;false;unmarshal;;;Argument[0];ReturnValue;taint"
      ]
  }
}
