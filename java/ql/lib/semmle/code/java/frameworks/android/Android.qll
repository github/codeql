/**
 * Provides classes and predicates for working with Android components.
 */

import java
private import semmle.code.xml.AndroidManifest

/**
 * Holds if in `file`'s directory or some parent directory there is an `AndroidManifestXmlFile`
 * that defines at least one activity, service or contest provider, suggesting this file is
 * part of an android application.
 */
predicate inAndroidApplication(File file) {
  file.isSourceFile() and
  exists(AndroidManifestXmlFile amxf, Folder amxfDir |
    amxf.definesAndroidApplication() and amxfDir = amxf.getParentContainer()
  |
    file.getParentContainer+() = amxfDir
  )
}

/**
 * Gets a reflexive/transitive superType
 */
pragma[inline]
private RefType getASuperTypeStar(RefType t) { hasDescendant(result, t) }

/**
 * An Android component. That is, either an activity, a service,
 * a broadcast receiver, or a content provider.
 */
class AndroidComponent extends Class {
  AndroidComponent() {
    getASuperTypeStar(this).hasQualifiedName("android.app", "Activity") or
    getASuperTypeStar(this).hasQualifiedName("android.app", "Service") or
    getASuperTypeStar(this).hasQualifiedName("android.content", "BroadcastReceiver") or
    getASuperTypeStar(this).hasQualifiedName("android.content", "ContentProvider") or
    getASuperTypeStar(this).hasQualifiedName("android.content", "ContentResolver")
  }

  /** The XML element corresponding to this Android component. */
  AndroidComponentXmlElement getAndroidComponentXmlElement() {
    // Find an element with an identifier matching the qualified name of the component.
    // Aliases have two identifiers (name and target), so check both identifiers (if present).
    exists(AndroidIdentifierXmlAttribute identifier |
      identifier = result.getAnAttribute() and
      result.getResolvedIdentifier(identifier) = this.getQualifiedName()
    )
  }

  /** Holds if this Android component is configured as `exported` in an `AndroidManifest.xml` file. */
  predicate isExported() { this.getAndroidComponentXmlElement().isExported() }

  /** Holds if this Android component has an intent filter configured in an `AndroidManifest.xml` file. */
  predicate hasIntentFilter() {
    exists(this.getAndroidComponentXmlElement().getAnIntentFilterElement())
  }
}

/**
 * An Android component that can be explicitly or implicitly exported.
 */
class ExportableAndroidComponent extends AndroidComponent {
  /**
   * Holds if this Android component is configured as `exported` or has intent
   * filters configured without `exported` explicitly disabled in an
   * `AndroidManifest.xml` file.
   */
  override predicate isExported() {
    this.getAndroidComponentXmlElement().isExported()
    or
    this.hasIntentFilter() and
    not this.getAndroidComponentXmlElement().isNotExported()
    or
    exists(AndroidActivityAliasXmlElement e |
      e = this.getAndroidComponentXmlElement() and
      not e.isNotExported() and
      e.hasAnIntentFilterElement()
    )
  }
}

/** An Android activity. */
class AndroidActivity extends ExportableAndroidComponent {
  AndroidActivity() { getASuperTypeStar(this).hasQualifiedName("android.app", "Activity") }
}

/** The method `setResult` of the class `android.app.Activity`. */
class ActivitySetResultMethod extends Method {
  ActivitySetResultMethod() {
    this.getDeclaringType().hasQualifiedName("android.app", "Activity") and
    this.hasName("setResult")
  }
}

/** An Android service. */
class AndroidService extends ExportableAndroidComponent {
  AndroidService() { getASuperTypeStar(this).hasQualifiedName("android.app", "Service") }
}

/** An Android broadcast receiver. */
class AndroidBroadcastReceiver extends ExportableAndroidComponent {
  AndroidBroadcastReceiver() {
    getASuperTypeStar(this).hasQualifiedName("android.content", "BroadcastReceiver")
  }
}

/** An Android content provider. */
class AndroidContentProvider extends ExportableAndroidComponent {
  AndroidContentProvider() {
    getASuperTypeStar(this).hasQualifiedName("android.content", "ContentProvider")
  }

  /**
   * Holds if this content provider requires read and write permissions
   * in an `AndroidManifest.xml` file.
   */
  predicate requiresPermissions() {
    this.getAndroidComponentXmlElement().(AndroidProviderXmlElement).requiresPermissions()
  }
}

/** An Android content resolver. */
class AndroidContentResolver extends AndroidComponent {
  AndroidContentResolver() {
    getASuperTypeStar(this).hasQualifiedName("android.content", "ContentResolver")
  }
}

/** Interface for classes whose instances can be written to and restored from a Parcel. */
class TypeParcelable extends Interface {
  TypeParcelable() { this.hasQualifiedName("android.os", "Parcelable") }
}

/**
 * A method that overrides `android.os.Parcelable.Creator.createFromParcel`.
 */
class CreateFromParcelMethod extends Method {
  CreateFromParcelMethod() {
    this.hasName("createFromParcel") and
    this.getEnclosingCallable().getDeclaringType().getAnAncestor() instanceof TypeParcelable
  }
}
