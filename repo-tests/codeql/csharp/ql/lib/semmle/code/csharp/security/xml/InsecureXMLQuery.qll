/**
 * Provides classes and predicates for detecting insecure processing of XML documents.
 */

import csharp
private import semmle.code.csharp.commons.TargetFramework

/**
 * Holds if the type `t` is in an assembly that has been compiled against a .NET framework version
 * before the given version.
 */
bindingset[version]
private predicate isNetFrameworkBefore(Type t, string version) {
  // For assemblies compiled against framework versions before 4 the TargetFrameworkAttribute
  // will not be present. In this case, we can revert back to the assembly version, which may not
  // contain full minor version information.
  exists(string assemblyVersion |
    assemblyVersion =
      t.getALocation().(Assembly).getVersion().regexpCapture("([0-9]+\\.[0-9]+).*", 1)
  |
    assemblyVersion.toFloat() < version.toFloat() and
    // This method is only accurate when we're looking at versions before 4.0.
    assemblyVersion.toFloat() < 4.0
  )
  or
  // For 4.0 and above the TargetFrameworkAttribute should be present to provide detailed version
  // information.
  exists(TargetFrameworkAttribute tfa |
    tfa.hasElement(t) and
    tfa.isNetFramework() and
    tfa.getFrameworkVersion().isEarlierThan(version)
  )
}

/**
 * A call which may load an XML document insecurely.
 */
abstract class InsecureXmlProcessing extends Call {
  /**
   * Holds if this call is in fact unsafe, with the reason given.
   */
  abstract predicate isUnsafe(string reason);
}

/**
 * Holds if this expression is a secure `XmlResolver`.
 */
private predicate isSafeXmlResolver(Expr e) {
  e instanceof NullLiteral or
  e.getType().(RefType).hasQualifiedName("System.Xml.XmlSecureResolver")
}

/**
 * Holds if this expression is a safe DTD processing setting.
 */
private predicate isSafeDtdSetting(Expr e) {
  // new DtdProcessing setting
  exists(string name | e.(FieldAccess).getTarget().(EnumConstant).getName() = name |
    name = "Prohibit" or name = "Ignore"
  )
  or
  // old ProhibitDtd setting
  e.(BoolLiteral).getValue() = "true"
}

/**
 * A simplistic points-to alternative: given an object creation and a property name, get the values that property can be assigned.
 *
 * Assumptions:
 *    - we don't reassign the variable that the creation is stored in
 *    - we always access the creation through the same variable it is initially assigned to
 *
 * This should cover most typical patterns...
 */
private Expr getAValueForProp(ObjectCreation create, string prop) {
  // values set in object init
  exists(MemberInitializer init |
    init = create.getInitializer().(ObjectInitializer).getAMemberInitializer() and
    init.getLValue().(PropertyAccess).getTarget().hasName(prop) and
    result = init.getRValue()
  )
  or
  // values set on var that create is assigned to
  exists(Assignment propAssign |
    DataFlow::localExprFlow(create, propAssign.getLValue().(PropertyAccess).getQualifier()) and
    propAssign.getLValue().(PropertyAccess).getTarget().hasName(prop) and
    result = propAssign.getRValue()
  )
}

/** Provides predicates related to `System.Xml.XmlReaderSettings`. */
module XmlSettings {
  /**
   * Holds if the given object creation constructs `XmlReaderSettings` with an insecure resolver.
   */
  predicate insecureResolverSettings(ObjectCreation creation, Expr evidence, string reason) {
    creation.getObjectType().getQualifiedName() = "System.Xml.XmlReaderSettings" and
    (
      // one unsafe assignment to XmlResolver
      exists(Expr xmlResolverVal | xmlResolverVal = getAValueForProp(creation, "XmlResolver") |
        not isSafeXmlResolver(xmlResolverVal) and evidence = xmlResolverVal
      ) and
      reason = "insecure resolver set in settings"
      or
      // no assignments, and default is insecure before version 4.5
      isNetFrameworkBefore(creation.getObjectType(), "4.5") and
      not exists(getAValueForProp(creation, "XmlResolver")) and
      reason = "default settings resolver is insecure in versions before 4.5" and
      evidence = creation
    )
  }

  /**
   * Holds if the given object creation constructs `XmlReaderSettings` with DTD processing enabled.
   */
  predicate dtdEnabledSettings(ObjectCreation creation, Expr evidence, string reason) {
    creation.getObjectType().getQualifiedName() = "System.Xml.XmlReaderSettings" and
    (
      exists(Expr dtdVal | dtdVal = getAValueForProp(creation, "DtdProcessing") |
        not isSafeDtdSetting(dtdVal) and evidence = dtdVal
      ) and
      reason = "DTD processing enabled in settings"
      or
      // default is secure in versions >= 4
      isNetFrameworkBefore(creation.getObjectType(), "4.0") and
      (
        exists(Expr dtdVal |
          // different DTD setting before version 4
          dtdVal = getAValueForProp(creation, "ProhibitDtd")
        |
          not isSafeDtdSetting(dtdVal) and evidence = dtdVal
        ) and
        reason = "DTD procesing enabled in settings"
        or
        not exists(getAValueForProp(creation, "ProhibitDtd")) and
        reason = "DTD processing is enabled by default in versions before 4.0" and
        evidence = creation
      )
    )
  }
}

/** Provides predicates related to `System.Xml.XmlReader`. */
module XmlReader {
  private import semmle.code.csharp.dataflow.DataFlow2

  private class InsecureXmlReaderCreate extends InsecureXmlProcessing, MethodCall {
    InsecureXmlReaderCreate() { this.getTarget().hasQualifiedName("System.Xml.XmlReader.Create") }

    /**
     * Gets the `XmlReaderSettings` argument to to this call, if any.
     */
    Expr getSettings() {
      result = this.getAnArgument() and
      result.getType().(RefType).getABaseType*().hasQualifiedName("System.Xml.XmlReaderSettings")
    }

    override predicate isUnsafe(string reason) {
      exists(string dtdReason, string resolverReason |
        this.dtdEnabled(dtdReason, _) and
        this.insecureResolver(resolverReason, _) and
        reason = dtdReason + ", " + resolverReason
      )
    }

    private predicate dtdEnabled(string reason, Expr evidence) {
      reason = "DTD processing is enabled by default in versions < 4.0" and
      evidence = this and
      not exists(this.getSettings()) and
      isNetFrameworkBefore(this.(MethodCall).getTarget().getDeclaringType(), "4.0")
      or
      // bad settings flow here
      exists(SettingsDataFlowConfig flow, ObjectCreation settings |
        flow.hasFlow(DataFlow::exprNode(settings), DataFlow::exprNode(this.getSettings())) and
        XmlSettings::dtdEnabledSettings(settings, evidence, reason)
      )
    }

    private predicate insecureResolver(string reason, Expr evidence) {
      // bad settings flow here
      exists(SettingsDataFlowConfig flow, ObjectCreation settings |
        flow.hasFlow(DataFlow::exprNode(settings), DataFlow::exprNode(this.getSettings())) and
        XmlSettings::insecureResolverSettings(settings, evidence, reason)
      )
      // default is secure
    }
  }

  private class SettingsDataFlowConfig extends DataFlow2::Configuration {
    SettingsDataFlowConfig() { this = "SettingsDataFlowConfig" }

    override predicate isSource(DataFlow::Node source) {
      // flow from places where we construct an XmlReaderSettings
      source
          .asExpr()
          .(ObjectCreation)
          .getType()
          .(RefType)
          .getABaseType*()
          .hasQualifiedName("System.Xml.XmlReaderSettings")
    }

    override predicate isSink(DataFlow::Node sink) {
      sink.asExpr() = any(InsecureXmlReaderCreate create).getSettings()
    }
  }
}

/** Provides predicates related to `System.Xml.XmlTextReader`. */
module XmlTextReader {
  private class InsecureXmlTextReader extends InsecureXmlProcessing, ObjectCreation {
    InsecureXmlTextReader() { this.getObjectType().hasQualifiedName("System.Xml.XmlTextReader") }

    override predicate isUnsafe(string reason) {
      not exists(Expr xmlResolverVal |
        isSafeXmlResolver(xmlResolverVal) and
        xmlResolverVal = getAValueForProp(this, "XmlResolver")
      ) and
      not exists(Expr dtdVal |
        isSafeDtdSetting(dtdVal) and
        dtdVal = getAValueForProp(this, "DtdProcessing")
      ) and
      // This was made safe by default in 4.5.2, despite what the documentation says
      isNetFrameworkBefore(this.getObjectType(), "4.5.2") and
      reason = "DTD processing is enabled by default, and resolver is insecure by default"
      or
      exists(Expr xmlResolverVal |
        not isSafeXmlResolver(xmlResolverVal) and
        xmlResolverVal = getAValueForProp(this, "XmlResolver")
      ) and
      exists(Expr dtdVal |
        not isSafeDtdSetting(dtdVal) and
        dtdVal = getAValueForProp(this, "DtdProcessing")
      ) and
      reason = "DTD processing is enabled with an insecure resolver"
    }
  }
}

/** Provides predicates related to `System.Xml.XmlDocument`. */
module XmlDocument {
  /**
   * A call to `Load` or `LoadXml` on `XmlDocument`s that doesn't appear to have a safe `XmlResolver` set.
   */
  class InsecureXmlDocument extends InsecureXmlProcessing, MethodCall {
    InsecureXmlDocument() {
      this.getTarget().hasQualifiedName("System.Xml.XmlDocument.Load") or
      this.getTarget().hasQualifiedName("System.Xml.XmlDocument.LoadXml")
    }

    override predicate isUnsafe(string reason) {
      exists(ObjectCreation creation | DataFlow::localExprFlow(creation, this.getQualifier()) |
        not exists(Expr xmlResolverVal |
          isSafeXmlResolver(xmlResolverVal) and
          xmlResolverVal = getAValueForProp(creation, "XmlResolver")
        )
      ) and
      isNetFrameworkBefore(this.getQualifier().getType(), "4.6") and
      reason = "resolver is insecure by default in versions before 4.6"
    }
  }
}
