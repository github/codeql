/**
 * Provides classes and predicates for working with Content Providers.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/** The class `android.content.ContentValues`. */
class ContentValues extends Class {
  ContentValues() { this.hasQualifiedName("android.content", "ContentValues") }
}

private class ContentProviderSourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // ContentInterface models are here for backwards compatibility (it was removed in API 28)
        "android.content;ContentInterface;true;call;(String,String,String,Bundle);;Parameter[0..3];contentprovider;manual",
        "android.content;ContentProvider;true;call;(String,String,String,Bundle);;Parameter[0..3];contentprovider;manual",
        "android.content;ContentProvider;true;call;(String,String,Bundle);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;delete;(Uri,String,String[]);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentInterface;true;delete;(Uri,Bundle);;Parameter[0..1];contentprovider;manual",
        "android.content;ContentProvider;true;delete;(Uri,Bundle);;Parameter[0..1];contentprovider;manual",
        "android.content;ContentInterface;true;getType;(Uri);;Parameter[0];contentprovider;manual",
        "android.content;ContentProvider;true;getType;(Uri);;Parameter[0];contentprovider;manual",
        "android.content;ContentInterface;true;insert;(Uri,ContentValues,Bundle);;Parameter[0];contentprovider;manual",
        "android.content;ContentProvider;true;insert;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;insert;(Uri,ContentValues);;Parameter[0..1];contentprovider;manual",
        "android.content;ContentInterface;true;openAssetFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider;manual",
        "android.content;ContentProvider;true;openAssetFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider;manual",
        "android.content;ContentProvider;true;openAssetFile;(Uri,String);;Parameter[0];contentprovider;manual",
        "android.content;ContentInterface;true;openTypedAssetFile;(Uri,String,Bundle,CancellationSignal);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;openTypedAssetFile;(Uri,String,Bundle,CancellationSignal);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;openTypedAssetFile;(Uri,String,Bundle);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentInterface;true;openFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider;manual",
        "android.content;ContentProvider;true;openFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider;manual",
        "android.content;ContentProvider;true;openFile;(Uri,String);;Parameter[0];contentprovider;manual",
        "android.content;ContentInterface;true;query;(Uri,String[],Bundle,CancellationSignal);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;query;(Uri,String[],Bundle,CancellationSignal);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String);;Parameter[0..4];contentprovider;manual",
        "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String,CancellationSignal);;Parameter[0..4];contentprovider;manual",
        "android.content;ContentInterface;true;update;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;update;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider;manual",
        "android.content;ContentProvider;true;update;(Uri,ContentValues,String,String[]);;Parameter[0..3];contentprovider;manual"
      ]
  }
}

private class SummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.content;ContentValues;false;put;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.content;ContentValues;false;put;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.content;ContentValues;false;putAll;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
        "android.content;ContentValues;false;putAll;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
        "android.content;ContentResolver;true;acquireContentProviderClient;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;acquireUnstableContentProviderClient;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;acquireUnstableContentProviderClient;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;applyBatch;;;Argument[1];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;call;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;canonicalize;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;getStreamTypes;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;getType;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;insert;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;query;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;uncanonicalize;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentResolver;true;wrap;;;Argument[0];ReturnValue;taint;manual",
        // ContentProviderClient is tainted at its creation, not by its arguments
        "android.content;ContentProviderClient;true;applyBatch;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderClient;true;call;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderClient;true;canonicalize;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderClient;true;getLocalContentProvider;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderClient;true;getStreamTypes;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderClient;true;insert;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderClient;true;query;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderClient;true;uncanonicalize;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;apply;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;apply;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;getUri;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;newAssertQuery;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;newCall;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;newDelete;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;newInsert;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;newUpdate;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;resolveExtrasBackReferences;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;resolveSelectionArgsBackReferences;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation;false;resolveValueBackReferences;;;Argument[0];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation$Builder;false;build;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ContentProviderOperation$Builder;false;withExceptionAllowed;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withExpectedCount;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withExtra;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withExtraBackReference;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withExtras;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withSelection;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withSelectionBackReference;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withValue;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withValueBackReference;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withValues;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderOperation$Builder;false;withYieldAllowed;;;Argument[-1];ReturnValue;value;manual",
        "android.content;ContentProviderResult;false;ContentProviderResult;(Uri);;Argument[0];Argument[-1].Field[android.content.ContentProviderResult.uri];value;manual",
        "android.content;ContentProviderResult;false;ContentProviderResult;(Bundle);;Argument[0];Argument[-1].Field[android.content.ContentProviderResult.extras];value;manual",
        "android.content;ContentProviderResult;false;ContentProviderResult;(Throwable);;Argument[0];Argument[-1].Field[android.content.ContentProviderResult.exception];value;manual",
        "android.content;ContentProviderResult;false;ContentProviderResult;(Parcel);;Argument[0];Argument[-1];taint;manual",
        "android.database;Cursor;true;copyStringToBuffer;;;Argument[-1];Argument[1];taint;manual",
        "android.database;Cursor;true;getBlob;;;Argument[-1];ReturnValue;taint;manual",
        "android.database;Cursor;true;getColumnName;;;Argument[-1];ReturnValue;taint;manual",
        "android.database;Cursor;true;getColumnNames;;;Argument[-1];ReturnValue;taint;manual",
        "android.database;Cursor;true;getExtras;;;Argument[-1];ReturnValue;taint;manual",
        "android.database;Cursor;true;getNotificationUri;;;Argument[-1];ReturnValue;taint;manual",
        "android.database;Cursor;true;getNotificationUris;;;Argument[-1];ReturnValue;taint;manual",
        "android.database;Cursor;true;getString;;;Argument[-1];ReturnValue;taint;manual",
        "android.database;Cursor;true;respond;;;Argument[-1];ReturnValue;taint;manual"
      ]
  }
}
