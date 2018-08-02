import csharp
import semmle.code.csharp.security.xml.InsecureXML::InsecureXML

from ObjectCreation creation, Expr evidence, string reason
where
  XmlSettings::insecureResolverSettings(creation, evidence, reason)
  or
  XmlSettings::dtdEnabledSettings(creation, evidence, reason)
select creation, evidence, reason
