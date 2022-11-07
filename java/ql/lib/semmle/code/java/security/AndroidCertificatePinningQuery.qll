/** Definitions for the Android Missing Certificate Pinning query. */

import java
import semmle.code.xml.AndroidManifest
import semmle.code.java.dataflow.TaintTracking
import HttpsUrls

/** An Android Network Security Configuration XML file. */
class AndroidNetworkSecurityConfigFile extends XmlFile {
  AndroidNetworkSecurityConfigFile() {
    exists(AndroidApplicationXmlElement app, AndroidXmlAttribute confAttr, string confName |
      confAttr.getElement() = app and
      confAttr.getValue() = "@xml/" + confName and
      this.getRelativePath().matches("%res/xml/" + confName + ".xml") and
      this.getARootElement().getName() = "network-security-config"
    )
  }
}

/** Holds if this database is of an Android application. */
predicate isAndroid() { exists(AndroidManifestXmlFile m) }

/** Holds if the given domain name is trusted by the Network Security Configuration XML file. */
predicate trustedDomain(string domainName) {
  exists(
    AndroidNetworkSecurityConfigFile confFile, XmlElement domConf, XmlElement domain,
    XmlElement trust
  |
    domConf.getFile() = confFile and
    domConf.getName() = "domain-config" and
    domain.getParent() = domConf and
    domain.getName() = "domain" and
    domain.getACharactersSet().getCharacters() = domainName and
    trust.getParent() = domConf and
    trust.getName() = ["trust-anchors", "pin-set"]
  )
}

/** Configuration for finding uses of non trusted URLs. */
private class UntrustedUrlConfig extends TaintTracking::Configuration {
  UntrustedUrlConfig() { this = "UntrustedUrlConfig" }

  override predicate isSource(DataFlow::Node node) {
    exists(string d | trustedDomain(d)) and
    exists(string lit | lit = node.asExpr().(CompileTimeConstantExpr).getStringValue() |
      lit.matches("%://%") and // it's a URL
      not exists(string dom | trustedDomain(dom) and lit.matches("%" + dom + "%"))
    )
  }

  override predicate isSink(DataFlow::Node node) { node instanceof UrlOpenSink }
}

/** Holds if `node` is a network communication call for which certificate pinning is not implemented. */
predicate missingPinning(DataFlow::Node node) {
  isAndroid() and
  node instanceof UrlOpenSink and
  (
    not exists(string s | trustedDomain(s))
    or
    exists(UntrustedUrlConfig conf | conf.hasFlow(_, node))
  )
}
