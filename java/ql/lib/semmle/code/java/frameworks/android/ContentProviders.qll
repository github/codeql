/**
 * Provides classes and predicates for working with Content Providers.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

/** The class `android.content.ContentValues`. */
class ContentValues extends Class {
  ContentValues() { this.hasQualifiedName("android.content", "ContentValues") }
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

private class SummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.content;ContentValues;false;put;;;Argument[0];Argument[-1].MapKey;value",
        "android.content;ContentValues;false;put;;;Argument[1];Argument[-1].MapValue;value",
        "android.content;ContentValues;false;putAll;;;Argument[0].MapKey;Argument[-1].MapKey;value",
        "android.content;ContentValues;false;putAll;;;Argument[0].MapValue;Argument[-1].MapValue;value"
      ]
  }
}
