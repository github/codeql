/**
 * Provides classes and predicates for working with Android components.
 */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.xml.AndroidManifest

/**
 * An Android component. That is, either an activity, a service,
 * a broadcast receiver, or a content provider.
 */
class AndroidComponent extends Class {
  AndroidComponent() {
    // The casts here are due to misoptimisation if they are missing
    // but are not needed semantically.
    this.(Class).getASupertype*().hasQualifiedName("android.app", "Activity") or
    this.(Class).getASupertype*().hasQualifiedName("android.app", "Service") or
    this.(Class).getASupertype*().hasQualifiedName("android.content", "BroadcastReceiver") or
    this.(Class).getASupertype*().hasQualifiedName("android.content", "ContentProvider") or
    this.(Class).getASupertype*().hasQualifiedName("android.content", "ContentResolver")
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

private class UriModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.net;Uri;true;buildUpon;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;false;decode;;;Argument[0];ReturnValue;taint",
        "android.net;Uri;false;encode;;;Argument[0];ReturnValue;taint",
        "android.net;Uri;false;fromFile;;;Argument[0];ReturnValue;taint",
        "android.net;Uri;false;fromParts;;;Argument[0..2];ReturnValue;taint",
        "android.net;Uri;true;getAuthority;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedAuthority;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedFragment;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedPath;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedQuery;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedSchemeSpecificPart;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedUserInfo;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getFragment;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getHost;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getLastPathSegment;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getPath;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getPathSegments;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getQuery;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getQueryParameter;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getQueryParameterNames;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getQueryParameters;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getScheme;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getSchemeSpecificPart;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getUserInfo;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;normalizeScheme;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;false;parse;;;Argument[0];ReturnValue;taint",
        "android.net;Uri;true;toString;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;false;withAppendedPath;;;Argument[0..1];ReturnValue;taint",
        "android.net;Uri;false;writeToParcel;;;Argument[1];Argument[0];taint",
        "android.net;Uri$Builder;false;appendEncodedPath;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;appendEncodedPath;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;appendPath;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;appendPath;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;appendQueryParameter;;;Argument[0..1];Argument[-1];taint",
        "android.net;Uri$Builder;false;appendQueryParameter;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;authority;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;authority;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;build;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri$Builder;false;clearQuery;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;encodedAuthority;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;encodedAuthority;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;encodedFragment;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;encodedFragment;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;encodedOpaquePart;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;encodedOpaquePart;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;encodedPath;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;encodedPath;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;encodedQuery;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;encodedQuery;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;fragment;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;fragment;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;opaquePart;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;opaquePart;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;path;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;path;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;query;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;query;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;scheme;;;Argument[0];Argument[-1];taint",
        "android.net;Uri$Builder;false;scheme;;;Argument[-1];ReturnValue;value",
        "android.net;Uri$Builder;false;toString;;;Argument[-1];ReturnValue;taint"
      ]
  }
}
