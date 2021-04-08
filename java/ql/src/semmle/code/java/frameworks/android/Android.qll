/**
 * Provides classes and predicates for working with Android components.
 */

import java
import semmle.code.xml.AndroidManifest

/**
 * An Android component. That is, either an activity, a service,
 * a broadcast receiver, or a content provider.
 */
class AndroidComponent extends Class {
  AndroidComponent() {
    this.getASupertype*().hasQualifiedName("android.app", "Activity") or
    this.getASupertype*().hasQualifiedName("android.app", "Service") or
    this.getASupertype*().hasQualifiedName("android.content", "BroadcastReceiver") or
    this.getASupertype*().hasQualifiedName("android.content", "ContentProvider") or
    this.getASupertype*().hasQualifiedName("android.content", "ContentResolver")
  }

  /** The XML element corresponding to this Android component. */
  AndroidComponentXmlElement getAndroidComponentXmlElement() {
    result.getResolvedComponentName() = this.getQualifiedName()
  }

  /** Holds if this Android component is configured as `exported` in an `AndroidManifest.xml` file. */
  predicate isExported() { getAndroidComponentXmlElement().isExported() }

  /** Holds if this Android component has an intent filter configured in an `AndroidManifest.xml` file. */
  predicate hasIntentFilter() { exists(getAndroidComponentXmlElement().getAnIntentFilterElement()) }
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
    getAndroidComponentXmlElement().isExported()
    or
    hasIntentFilter() and
    not getAndroidComponentXmlElement().isNotExported()
  }
}

/** An Android activity. */
class AndroidActivity extends ExportableAndroidComponent {
  AndroidActivity() { this.getASupertype*().hasQualifiedName("android.app", "Activity") }
}

/** An Android service. */
class AndroidService extends ExportableAndroidComponent {
  AndroidService() { this.getASupertype*().hasQualifiedName("android.app", "Service") }
}

/** An Android broadcast receiver. */
class AndroidBroadcastReceiver extends ExportableAndroidComponent {
  AndroidBroadcastReceiver() {
    this.getASupertype*().hasQualifiedName("android.content", "BroadcastReceiver")
  }
}

/** An Android content provider. */
class AndroidContentProvider extends ExportableAndroidComponent {
  AndroidContentProvider() {
    this.getASupertype*().hasQualifiedName("android.content", "ContentProvider")
  }
}

/** An Android content resolver. */
class AndroidContentResolver extends AndroidComponent {
  AndroidContentResolver() {
    this.getASupertype*().hasQualifiedName("android.content", "ContentResolver")
  }
}
