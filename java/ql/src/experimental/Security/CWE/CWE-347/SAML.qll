/** Provides classes for working with SAML using the JAXB library. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

/** Model of XML document builder in the new CSV format. */
private class XmlDocSource extends SourceModelCsv {
  override predicate row(string row) {
    row = ["javax.xml.parsers;DocumentBuilder;true;parse;;;ReturnValue;xmldoc"]
  }
}

/** Source of SAML assertion in an XML document. */
class SamlAssertionSource extends DataFlow::Node {
  SamlAssertionSource() { sourceNode(this, "xmldoc") }
}

/** The Java class `javax.xml.bind.annotation.XmlElements`. */
class XmlElementsAnnotation extends Annotation {
  XmlElementsAnnotation() {
    this.getType().hasQualifiedName("javax.xml.bind.annotation", "XmlElements")
  }
}

/** Holds if `field` is a Java class field with a mapping of SAML assertion as an XML element. */
predicate isSamlAssertionField(Field field) {
  exists(Annotation xmlElement |
    field.fromSource() and
    xmlElement =
      field.getAnAnnotation().(XmlElementsAnnotation).getValue("value").(ArrayInit).getAnInit() and
    xmlElement.getValue("name").(CompileTimeConstantExpr).getStringValue() =
      ["Assertion", "EncryptedAssertion"] and
    xmlElement.getValue("namespace").(CompileTimeConstantExpr).getStringValue() =
      "urn:oasis:names:tc:SAML:2.0:assertion"
  )
}

/** Holds if `ma` is a getter method call that returns a field with a binding to SAML assertion in XML. */
predicate isSamlAssertionMethodAccess(MethodAccess ma) {
  exists(Field sf, ReturnStmt ret |
    isSamlAssertionField(sf) and
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

/** The JAXB class `javax.xml.bind.JAXBElement`. */
class JaxbXmlElement extends Class {
  JaxbXmlElement() { this.hasQualifiedName("javax.xml.bind", "JAXBElement") }
}

/** The JAXB interface `javax.xml.bind.Unmarshaller`. */
class JaxbUnmarshaller extends Interface {
  JaxbUnmarshaller() { this.hasQualifiedName("javax.xml.bind", "Unmarshaller") }
}

/** The method `getValue` of `JAXBElement`. */
class GetElementValueMethod extends Method {
  GetElementValueMethod() {
    this.hasName("getValue") and
    this.getSourceDeclaration().getDeclaringType().getASupertype*() instanceof JaxbXmlElement
  }
}

/** The method `unmarshal` of `Unmarshaller`. */
class UnmarshalElementMethod extends Method {
  UnmarshalElementMethod() {
    this.hasName("unmarshal") and
    this.getDeclaringType().getASupertype*() instanceof JaxbUnmarshaller
  }
}
