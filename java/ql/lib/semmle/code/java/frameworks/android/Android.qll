/**
 * Provides classes and predicates for working with Android components.
 */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.xml.AndroidManifest

/**
 * Gets a transitive superType avoiding magic optimisation
 */
pragma[nomagic]
private RefType getASuperTypePlus(RefType t) { result = t.getASupertype+() }

/**
 * Gets a reflexive/transitive superType avoiding magic optimisation
 */
pragma[inline]
private RefType getASuperTypeStar(RefType t) { result = getASuperTypePlus(t) or result = t }

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
  AndroidActivity() { getASuperTypeStar(this).hasQualifiedName("android.app", "Activity") }
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
    getAndroidComponentXmlElement().(AndroidProviderXmlElement).requiresPermissions()
  }
}

/** An Android content resolver. */
class AndroidContentResolver extends AndroidComponent {
  AndroidContentResolver() {
    getASuperTypeStar(this).hasQualifiedName("android.content", "ContentResolver")
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

private class ContentProviderSourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // ContentInterface models are here for backwards compatibility (it was removed in API 28)
        "android.content;ContentInterface;true;call;(String,String,String,Bundle);;Parameter[0..3];contentprovider",
        "android.content;ContentProvider;true;call;(String,String,String,Bundle);;Parameter[0..3];contentprovider",
        "android.content;ContentProvider;true;call;(String,String,Bundle);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;delete;(Uri,String,String[]);;Parameter[0..2];contentprovider",
        "android.content;ContentInterface;true;delete;(Uri,Bundle);;Parameter[0..1];contentprovider",
        "android.content;ContentProvider;true;delete;(Uri,Bundle);;Parameter[0..1];contentprovider",
        "android.content;ContentInterface;true;getType;(Uri);;Parameter[0];contentprovider",
        "android.content;ContentProvider;true;getType;(Uri);;Parameter[0];contentprovider",
        "android.content;ContentInterface;true;insert;(Uri,ContentValues,Bundle);;Parameter[0];contentprovider",
        "android.content;ContentProvider;true;insert;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;insert;(Uri,ContentValues);;Parameter[0..1];contentprovider",
        "android.content;ContentInterface;true;openAssetFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider",
        "android.content;ContentProvider;true;openAssetFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider",
        "android.content;ContentProvider;true;openAssetFile;(Uri,String);;Parameter[0];contentprovider",
        "android.content;ContentInterface;true;openTypedAssetFile;(Uri,String,Bundle,CancellationSignal);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;openTypedAssetFile;(Uri,String,Bundle,CancellationSignal);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;openTypedAssetFile;(Uri,String,Bundle);;Parameter[0..2];contentprovider",
        "android.content;ContentInterface;true;openFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider",
        "android.content;ContentProvider;true;openFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider",
        "android.content;ContentProvider;true;openFile;(Uri,String);;Parameter[0];contentprovider",
        "android.content;ContentInterface;true;query;(Uri,String[],Bundle,CancellationSignal);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;query;(Uri,String[],Bundle,CancellationSignal);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String);;Parameter[0..4];contentprovider",
        "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String,CancellationSignal);;Parameter[0..4];contentprovider",
        "android.content;ContentInterface;true;update;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;update;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider",
        "android.content;ContentProvider;true;update;(Uri,ContentValues,String,String[]);;Parameter[0..3];contentprovider"
      ]
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
    this.getEnclosingCallable().getDeclaringType().getASupertype*() instanceof TypeParcelable
  }
}

private class ParcelPropagationModels extends SummaryModelCsv {
  override predicate row(string s) {
    // Parcel readers that return their value
    s =
      "android.os;Parcel;false;read" +
        [
          "Array", "ArrayList", "Boolean", "Bundle", "Byte", "Double", "FileDescriptor", "Float",
          "HashMap", "Int", "Long", "Parcelable", "ParcelableArray", "PersistableBundle",
          "Serializable", "Size", "SizeF", "SparseArray", "SparseBooleanArray", "String",
          "StrongBinder", "TypedObject", "Value"
        ] + ";;;Argument[-1];ReturnValue;taint"
    or
    // Parcel readers that write to an existing object
    s =
      "android.os;Parcel;false;read" +
        [
          "BinderArray", "BinderList", "BooleanArray", "ByteArray", "CharArray", "DoubleArray",
          "FloatArray", "IntArray", "List", "LongArray", "Map", "ParcelableList", "StringArray",
          "StringList", "TypedArray", "TypedList"
        ] + ";;;Argument[-1];Argument[0];taint"
    or
    // One Parcel method that aliases an argument to a return value
    s = "android.os;Parcel;false;readParcelableList;;;Argument[0];ReturnValue;value"
  }
}
