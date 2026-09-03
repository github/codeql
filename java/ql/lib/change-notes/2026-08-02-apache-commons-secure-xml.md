---
category: feature
---
* Factories returned by the Apache Commons Secure XML (`org.apache.commons.xml.secure`) hardening library's `SecureDocumentBuilderFactory`, `SecureSAXParserFactory`, `SecureXMLInputFactory`, `SecureTransformerFactory` and `SecureSchemaFactory` classes are now recognized as safely configured by the XXE query.
* A new extensible class `SafeXmlFactorySource` was added to `semmle.code.java.security.XmlParsers` for modeling sources of pre-hardened JAXP factories.
