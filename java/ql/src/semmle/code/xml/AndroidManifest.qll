/**
 * Provides classes and predicates for working with Android manifest files.
 */

import XML

/**
 * An Android manifest file, named `AndroidManifest.xml`.
 */
class AndroidManifestXmlFile extends XMLFile {
  AndroidManifestXmlFile() {
    this.getBaseName() = "AndroidManifest.xml" and
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "manifest"
  }

  /**
   * Gets the top-level `<manifest>` element in this Android manifest file.
   */
  AndroidManifestXmlElement getManifestElement() { result = this.getAChild() }
}

/**
 * A `<manifest>` element in an Android manifest file.
 */
class AndroidManifestXmlElement extends XMLElement {
  AndroidManifestXmlElement() {
    this.getParent() instanceof AndroidManifestXmlFile and this.getName() = "manifest"
  }

  /**
   * Gets the `<application>` child element of this `<manifest>` element.
   */
  AndroidApplicationXmlElement getApplicationElement() { result = this.getAChild() }

  /**
   * Gets the value of the `package` attribute of this `<manifest>` element.
   */
  string getPackageAttributeValue() { result = getAttributeValue("package") }
}

/**
 * An `<application>` element in an Android manifest file.
 */
class AndroidApplicationXmlElement extends XMLElement {
  AndroidApplicationXmlElement() {
    this.getParent() instanceof AndroidManifestXmlElement and this.getName() = "application"
  }

  /**
   * Gets a component child element of this `<application>` element.
   */
  AndroidComponentXmlElement getAComponentElement() { result = this.getAChild() }
}

/**
 * An `<activity>` element in an Android manifest file.
 */
class AndroidActivityXmlElement extends AndroidComponentXmlElement {
  AndroidActivityXmlElement() { this.getName() = "activity" }
}

/**
 * A `<service>` element in an Android manifest file.
 */
class AndroidServiceXmlElement extends AndroidComponentXmlElement {
  AndroidServiceXmlElement() { this.getName() = "service" }
}

/**
 * A `<receiver>` element in an Android manifest file.
 */
class AndroidReceiverXmlElement extends AndroidComponentXmlElement {
  AndroidReceiverXmlElement() { this.getName() = "receiver" }
}

/**
 * A `<provider>` element in an Android manifest file.
 */
class AndroidProviderXmlElement extends AndroidComponentXmlElement {
  AndroidProviderXmlElement() { this.getName() = "provider" }
}

/**
 * An Android component element in an Android manifest file.
 */
class AndroidComponentXmlElement extends XMLElement {
  AndroidComponentXmlElement() {
    this.getParent() instanceof AndroidApplicationXmlElement and
    this.getName().regexpMatch("(activity|service|receiver|provider)")
  }

  /**
   * Gets an `<intent-filter>` child element of this component element.
   */
  AndroidIntentFilterXmlElement getAnIntentFilterElement() { result = this.getAChild() }

  /**
   * Gets the value of the `android:name` attribute of this component element.
   */
  string getComponentName() {
    exists(XMLAttribute attr |
      attr = getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "name"
    |
      result = attr.getValue()
    )
  }

  /**
   * Gets the resolved value of the `android:name` attribute of this component element.
   */
  string getResolvedComponentName() {
    if getComponentName().matches(".%")
    then
      result =
        getParent().(XMLElement).getParent().(AndroidManifestXmlElement).getPackageAttributeValue() +
          getComponentName()
    else result = getComponentName()
  }

  /**
   * Gets the value of the `android:exported` attribute of this component element.
   */
  string getExportedAttributeValue() {
    exists(XMLAttribute attr |
      attr = getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "exported"
    |
      result = attr.getValue()
    )
  }

  /**
   * Holds if the `android:exported` attribute of this component element is `true`.
   */
  predicate isExported() { getExportedAttributeValue() = "true" }

  /**
   * Holds if the `android:exported` attribute of this component element is explicitly set to `false`.
   */
  predicate isNotExported() { getExportedAttributeValue() = "false" }
}

/**
 * An `<intent-filter>` element in an Android manifest file.
 */
class AndroidIntentFilterXmlElement extends XMLElement {
  AndroidIntentFilterXmlElement() {
    this.getFile() instanceof AndroidManifestXmlFile and this.getName() = "intent-filter"
  }

  /**
   * Gets an `<action>` child element of this `<intent-filter>` element.
   */
  AndroidActionXmlElement getAnActionElement() { result = this.getAChild() }
}

/**
 * An `<action>` element in an Android manifest file.
 */
class AndroidActionXmlElement extends XMLElement {
  AndroidActionXmlElement() {
    this.getFile() instanceof AndroidManifestXmlFile and this.getName() = "action"
  }

  /**
   * Gets the name of this action.
   */
  string getActionName() {
    exists(XMLAttribute attr |
      attr = getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "name"
    |
      result = attr.getValue()
    )
  }
}
