---
category: feature
---
* Factories returned by the Apache Commons XML (`org.apache.commons.xml.XmlFactories`) hardening library are now recognized as safely configured by the XXE query.
* A new extensible class `SafeXmlFactorySource` was added to `semmle.code.java.security.XmlParsers` for modeling sources of pre-hardened JAXP factories.
