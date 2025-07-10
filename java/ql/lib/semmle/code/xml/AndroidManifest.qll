/**
 * Provides classes and predicates for working with Android manifest files.
 */

import XML

/**
 * An Android manifest file, named `AndroidManifest.xml`.
 */
class AndroidManifestXmlFile extends XmlFile {
  AndroidManifestXmlFile() {
    this.getBaseName() = "AndroidManifest.xml" and
    count(XmlElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "manifest"
  }

  /**
   * Gets the top-level `<manifest>` element in this Android manifest file.
   */
  AndroidManifestXmlElement getManifestElement() { result = this.getAChild() }

  /**
   * Holds if this Android manifest file is located in a build directory.
   */
  predicate isInBuildDirectory() { this.getFile().getRelativePath().matches("%build%") }

  /**
   * Holds if this file defines at least one activity, service or contest provider,
   * and so it corresponds to an android application rather than a library.
   */
  predicate definesAndroidApplication() {
    exists(AndroidComponentXmlElement acxe |
      this.getManifestElement().getApplicationElement().getAComponentElement() = acxe and
      (
        acxe instanceof AndroidActivityXmlElement or
        acxe instanceof AndroidServiceXmlElement or
        acxe instanceof AndroidProviderXmlElement
      )
    )
  }
}

/**
 * A `<manifest>` element in an Android manifest file.
 */
class AndroidManifestXmlElement extends XmlElement {
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
class AndroidApplicationXmlElement extends XmlElement {
  AndroidApplicationXmlElement() {
    this.getParent() instanceof AndroidManifestXmlElement and this.getName() = "application"
  }

  /**
   * Gets a component child element of this `<application>` element.
   */
  AndroidComponentXmlElement getAComponentElement() { result = this.getAChild() }

  /**
   * Holds if this application element has the attribute `android:debuggable` set to `true`.
   */
  predicate isDebuggable() {
    exists(AndroidXmlAttribute attr |
      this.getAnAttribute() = attr and
      attr.getName() = "debuggable" and
      attr.getValue() = "true"
    )
  }

  /**
   * Holds if this application element has explicitly set a value for its `android:permission` attribute.
   */
  predicate requiresPermissions() { this.getAnAttribute().(AndroidPermissionXmlAttribute).isFull() }

  /**
   * Holds if this application element does not disable the `android:allowBackup` attribute.
   *
   * https://developer.android.com/guide/topics/data/autobackup
   */
  predicate allowsBackup() {
    not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory() and
    (
      // explicitly sets android:allowBackup="true"
      this.allowsBackupExplicitly()
      or
      // Manifest providing the main intent for an application, and does not explicitly
      // disallow the allowBackup attribute
      this.providesMainIntent() and
      // Check that android:allowBackup="false" is not present
      not exists(AndroidXmlAttribute attr |
        this.getAnAttribute() = attr and
        attr.getName() = "allowBackup" and
        attr.getValue() = "false"
      )
    )
  }

  /**
   * Holds if this application element sets the `android:allowBackup` attribute to `true`.
   *
   * https://developer.android.com/guide/topics/data/autobackup
   */
  private predicate allowsBackupExplicitly() {
    exists(AndroidXmlAttribute attr |
      this.getAnAttribute() = attr and
      attr.getName() = "allowBackup" and
      attr.getValue() = "true"
    )
  }

  /**
   * Holds if the application element contains a child element which provides the
   * `android.intent.action.MAIN` intent.
   */
  private predicate providesMainIntent() {
    exists(AndroidActivityXmlElement activity |
      activity = this.getAChild() and
      exists(AndroidIntentFilterXmlElement intentFilter |
        intentFilter = activity.getAChild() and
        intentFilter.getAnActionElement().getActionName() = "android.intent.action.MAIN"
      )
    )
  }
}

/**
 * An `<activity>` element in an Android manifest file.
 */
class AndroidActivityXmlElement extends AndroidComponentXmlElement {
  AndroidActivityXmlElement() { this.getName() = "activity" }

  /**
   * Gets an `<activity-alias>` element aliasing the activity.
   */
  AndroidActivityAliasXmlElement getAnAlias() {
    exists(AndroidActivityAliasXmlElement alias | this = alias.getTarget() | result = alias)
  }
}

/**
 * An `<activity-alias>` element in an Android manifest file.
 */
class AndroidActivityAliasXmlElement extends AndroidComponentXmlElement {
  AndroidActivityAliasXmlElement() { this.getName() = "activity-alias" }

  /**
   * Get and resolve the name of the target activity from the `android:targetActivity` attribute.
   */
  string getResolvedTargetActivityName() {
    exists(AndroidXmlAttribute attr |
      attr = this.getAnAttribute() and attr.getName() = "targetActivity"
    |
      result = this.getResolvedIdentifier(attr)
    )
  }

  /**
   * Gets the `<activity>` element referenced by the `android:targetActivity` attribute.
   */
  AndroidActivityXmlElement getTarget() {
    exists(AndroidActivityXmlElement activity |
      activity.getResolvedComponentName() = this.getResolvedTargetActivityName()
    |
      result = activity
    )
  }
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
class AndroidXmlAttribute extends XmlAttribute {
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
  override predicate requiresPermissions() {
    this.getAnAttribute().(AndroidPermissionXmlAttribute).isFull()
    or
    this.getAnAttribute().(AndroidPermissionXmlAttribute).isWrite() and
    this.getAnAttribute().(AndroidPermissionXmlAttribute).isRead()
  }

  /**
   * Holds if this provider element has the attribute `android:grantUriPermissions` set to `true`.
   */
  predicate grantsUriPermissions() {
    exists(AndroidXmlAttribute attr |
      this.getAnAttribute() = attr and
      attr.getName() = "grantUriPermissions" and
      attr.getValue() = "true"
    )
  }

  /**
   * Holds if the provider element is only protected by either `android:readPermission` or `android:writePermission`.
   */
  predicate hasIncompletePermissions() {
    (
      this.getAnAttribute().(AndroidPermissionXmlAttribute).isWrite() or
      this.getAnAttribute().(AndroidPermissionXmlAttribute).isRead()
    ) and
    not this.requiresPermissions()
  }
}

/**
 * The attribute `android:perrmission`, `android:readPermission`, or `android:writePermission`.
 */
class AndroidPermissionXmlAttribute extends XmlAttribute {
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
 * The attribute `android:name` or `android:targetActivity`.
 */
class AndroidIdentifierXmlAttribute extends AndroidXmlAttribute {
  AndroidIdentifierXmlAttribute() { this.getName() = ["name", "targetActivity"] }
}

/**
 * The `<path-permission`> element of a `<provider>` in an Android manifest file.
 */
class AndroidPathPermissionXmlElement extends XmlElement {
  AndroidPathPermissionXmlElement() {
    this.getParent() instanceof AndroidProviderXmlElement and
    this.hasName("path-permission")
  }
}

/**
 * An Android component element in an Android manifest file.
 */
class AndroidComponentXmlElement extends XmlElement {
  AndroidComponentXmlElement() {
    this.getParent() instanceof AndroidApplicationXmlElement and
    this.getName().regexpMatch("(activity|activity-alias|service|receiver|provider)")
  }

  /**
   * Gets an `<intent-filter>` child element of this component element.
   */
  AndroidIntentFilterXmlElement getAnIntentFilterElement() { result = this.getAChild() }

  /**
   * Holds if this component element has an `<intent-filter>` child element.
   */
  predicate hasAnIntentFilterElement() { exists(this.getAnIntentFilterElement()) }

  /**
   * Gets the value of the `android:name` attribute of this component element.
   */
  string getComponentName() {
    exists(XmlAttribute attr |
      attr = this.getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "name"
    |
      result = attr.getValue()
    )
  }

  /**
   * Gets the value of an identifier attribute, and tries to resolve it into a fully qualified identifier.
   */
  string getResolvedIdentifier(AndroidIdentifierXmlAttribute identifier) {
    exists(string name | name = identifier.getValue() |
      if name.matches(".%")
      then
        result =
          this.getParent()
                .(XmlElement)
                .getParent()
                .(AndroidManifestXmlElement)
                .getPackageAttributeValue() + name
      else result = name
    )
  }

  /**
   * Gets the resolved value of the `android:name` attribute of this component element.
   */
  string getResolvedComponentName() {
    exists(AndroidXmlAttribute attr | attr = this.getAnAttribute() and attr.getName() = "name" |
      result = this.getResolvedIdentifier(attr)
    )
  }

  /**
   * Gets the value of the `android:exported` attribute of this component element.
   */
  string getExportedAttributeValue() {
    exists(XmlAttribute attr |
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

  /**
   * Holds if this component element has an `android:exported` attribute.
   */
  predicate hasExportedAttribute() { exists(this.getExportedAttributeValue()) }

  /**
   * Holds if this component element has explicitly set a value for its `android:permission` attribute.
   */
  predicate requiresPermissions() { this.getAnAttribute().(AndroidPermissionXmlAttribute).isFull() }
}

/**
 * An `<intent-filter>` element in an Android manifest file.
 */
class AndroidIntentFilterXmlElement extends XmlElement {
  AndroidIntentFilterXmlElement() {
    this.getFile() instanceof AndroidManifestXmlFile and this.getName() = "intent-filter"
  }

  /**
   * Gets an `<action>` child element of this `<intent-filter>` element.
   */
  AndroidActionXmlElement getAnActionElement() { result = this.getAChild() }

  /**
   * Gets a `<category>` child element of this `<intent-filter>` element.
   */
  AndroidCategoryXmlElement getACategoryElement() { result = this.getAChild() }
}

/**
 * An `<action>` element in an Android manifest file.
 */
class AndroidActionXmlElement extends XmlElement {
  AndroidActionXmlElement() {
    this.getFile() instanceof AndroidManifestXmlFile and this.getName() = "action"
  }

  /**
   * Gets the name of this action.
   */
  string getActionName() {
    exists(XmlAttribute attr |
      attr = this.getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "name"
    |
      result = attr.getValue()
    )
  }
}

/**
 * A `<category>` element in an Android manifest file.
 */
class AndroidCategoryXmlElement extends XmlElement {
  AndroidCategoryXmlElement() {
    this.getFile() instanceof AndroidManifestXmlFile and this.getName() = "category"
  }

  /**
   * Gets the name of this category.
   */
  string getCategoryName() {
    exists(XmlAttribute attr |
      attr = this.getAnAttribute() and
      attr.getNamespace().getPrefix() = "android" and
      attr.getName() = "name"
    |
      result = attr.getValue()
    )
  }
}
