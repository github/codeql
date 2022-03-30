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
  string getPackageAttributeValue() { result = this.getAttributeValue("package") }
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
 * An XML attribute with the `android:` prefix.
 */
class AndroidXmlAttribute extends XMLAttribute {
  AndroidXmlAttribute() { this.getNamespace().getPrefix() = "android" }
}

/**
 * A `<provider>` element in an Android manifest file.
 */
class AndroidProviderXmlElement extends AndroidComponentXmlElement {
  AndroidProviderXmlElement() { this.getName() = "provider" }

  /**
   * Holds if this provider element has explicitly set a value for either its
   * `android:permission` attribute or its `android:readPermission` and `android:writePermission`
   * attributes.
   */
  predicate requiresPermissions() {
    this.getAnAttribute().(AndroidPermissionXmlAttribute).isFull()
    or
    this.getAnAttribute().(AndroidPermissionXmlAttribute).isWrite() and
    this.getAnAttribute().(AndroidPermissionXmlAttribute).isRead()
  }

  predicate grantsUriPermissions() {
    exists(AndroidXmlAttribute attr |
      this.getAnAttribute() = attr and
      attr.getName() = "grantUriPermissions" and
      attr.getValue() = "true"
    )
  }
}

/**
 * The attribute `android:perrmission`, `android:readPermission`, or `android:writePermission`.
 */
class AndroidPermissionXmlAttribute extends XMLAttribute {
  AndroidPermissionXmlAttribute() {
    this.getNamespace().getPrefix() = "android" and
    this.getName() = ["permission", "readPermission", "writePermission"]
  }

  /** Holds if this is an `android:permission` attribute. */
  predicate isFull() { this.getName() = "permission" }

  /** Holds if this is an `android:readPermission` attribute. */
  predicate isRead() { this.getName() = "readPermission" }

  /** Holds if this is an `android:writePermission` attribute. */
  predicate isWrite() { this.getName() = "writePermission" }
}

/**
 * The `<path-permission`> element of a `<provider>` in an Android manifest file.
 */
class AndroidPathPermissionXmlElement extends XMLElement {
  AndroidPathPermissionXmlElement() {
    this.getParent() instanceof AndroidProviderXmlElement and
    this.hasName("path-permission")
  }
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
      attr = this.getAnAttribute() and
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
    if this.getComponentName().matches(".%")
    then
      result =
        this.getParent()
              .(XMLElement)
              .getParent()
              .(AndroidManifestXmlElement)
              .getPackageAttributeValue() + this.getComponentName()
    else result = this.getComponentName()
  }

  /**
   * Gets the value of the `android:exported` attribute of this component element.
   */
  string getExportedAttributeValue() {
    exists(XMLAttribute attr |
      attr = this.getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "exported"
    |
      result = attr.getValue()
    )
  }

  /**
   * Holds if the `android:exported` attribute of this component element is `true`.
   */
  predicate isExported() { this.getExportedAttributeValue() = "true" }

  /**
   * Holds if the `android:exported` attribute of this component element is explicitly set to `false`.
   */
  predicate isNotExported() { this.getExportedAttributeValue() = "false" }
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
      attr = this.getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "name"
    |
      result = attr.getValue()
    )
  }
}
