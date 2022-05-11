package com.example.app;

import java.io.FileNotFoundException;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;
import android.os.RemoteException;

public class Test extends ContentProvider {

	void sink(Object o) {}

	// "android.content;ContentProvider;true;call;(String,String,String,Bundle);;Parameter[0..3];contentprovider",
	@Override
	public Bundle call(String authority, String method, String arg, Bundle extras) {
		sink(authority); // $ hasTaintFlow
		sink(method); // $ hasTaintFlow
		sink(arg); // $ hasTaintFlow
		sink(extras.get("some_key")); // $ hasTaintFlow
		return null;
	}

	// "android.content;ContentProvider;true;call;(String,String,Bundle);;Parameter[0..2];contentprovider",
	public Bundle call(String method, String arg, Bundle extras) {
		sink(method); // $ hasTaintFlow
		sink(arg); // $ hasTaintFlow
		sink(extras.get("some_key")); // $ hasTaintFlow
		return null;
	}

	// "android.content;ContentProvider;true;delete;(Uri,String,String[]);;Parameter[0..2];contentprovider",
	@Override
	public int delete(Uri uri, String selection, String[] selectionArgs) {
		sink(uri); // $ hasTaintFlow
		sink(selection); // $ hasTaintFlow
		sink(selectionArgs); // $ hasTaintFlow
		return 0;
	}

	// "android.content;ContentProvider;true;delete;(Uri,Bundle);;Parameter[0..1];contentprovider",
	@Override
	public int delete(Uri uri, Bundle extras) {
		sink(uri); // $ hasTaintFlow
		sink(extras.get("some_key")); // $ hasTaintFlow
		return 0;
	}

	// "android.content;ContentProvider;true;getType;(Uri);;Parameter[0];contentprovider",
	@Override
	public String getType(Uri uri) {
		sink(uri); // $ hasTaintFlow
		return null;
	}

	// "android.content;ContentProvider;true;insert;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider",
	@Override
	public Uri insert(Uri uri, ContentValues values, Bundle extras) {
		sink(uri); // $ hasTaintFlow
		sink(values); // $ hasTaintFlow
		sink(extras.get("some_key")); // $ hasTaintFlow
		return null;
	}

	// "android.content;ContentProvider;true;insert;(Uri,ContentValues);;Parameter[0..1];contentprovider",
	@Override
	public Uri insert(Uri uri, ContentValues values) {
		sink(uri); // $ hasTaintFlow
		sink(values); // $ hasTaintFlow
		return null;
	}

	// "android.content;ContentProvider;true;openAssetFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider",
	@Override
	public AssetFileDescriptor openAssetFile(Uri uri, String mode, CancellationSignal signal) {
		sink(uri); // $ hasTaintFlow
		sink(mode); // Safe
		sink(signal); // Safe
		return null;
	}

	// "android.content;ContentProvider;true;openAssetFile;(Uri,String);;Parameter[0];contentprovider",
	@Override
	public AssetFileDescriptor openAssetFile(Uri uri, String mode) {
		sink(uri); // $ hasTaintFlow
		sink(mode); // Safe
		return null;
	}

	// "android.content;ContentProvider;true;openTypedAssetFile;(Uri,String,Bundle,CancellationSignal);;Parameter[0..2];contentprovider",
	@Override
	public AssetFileDescriptor openTypedAssetFile(Uri uri, String mimeTypeFilter, Bundle opts,
			CancellationSignal signal) {
		sink(uri); // $ hasTaintFlow
		sink(mimeTypeFilter); // $ hasTaintFlow
		sink(opts.get("some_key")); // $ hasTaintFlow
		sink(signal); // Safe
		return null;
	}

	// "android.content;ContentProvider;true;openTypedAssetFile;(Uri,String,Bundle);;Parameter[0..2];contentprovider",
	@Override
	public AssetFileDescriptor openTypedAssetFile(Uri uri, String mimeTypeFilter, Bundle opts) {
		sink(uri); // $ hasTaintFlow
		sink(mimeTypeFilter); // $ hasTaintFlow
		sink(opts.get("some_key")); // $ hasTaintFlow
		return null;
	}

	// "android.content;ContentProvider;true;openFile;(Uri,String,CancellationSignal);;Parameter[0];contentprovider",
	@Override
	public ParcelFileDescriptor openFile(Uri uri, String mode, CancellationSignal signal) {
		sink(uri); // $ hasTaintFlow
		sink(mode); // Safe
		sink(signal); // Safe
		return null;
	}

	// "android.content;ContentProvider;true;openFile;(Uri,String);;Parameter[0..1];contentprovider",
	@Override
	public ParcelFileDescriptor openFile(Uri uri, String mode) {
		sink(uri); // $ hasTaintFlow
		sink(mode); // Safe
		return null;
	}

	// "android.content;ContentProvider;true;query;(Uri,String[],Bundle,CancellationSignal);;Parameter[0..2];contentprovider",
	@Override
	public Cursor query(Uri uri, String[] projection, Bundle queryArgs,
			CancellationSignal cancellationSignal) {
		sink(uri); // $ hasTaintFlow
		sink(projection); // $ hasTaintFlow
		sink(queryArgs.get("some_key")); // $ hasTaintFlow
		sink(cancellationSignal); // Safe
		return null;
	}

	// "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String);;Parameter[0..4];contentprovider",
	@Override
	public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs,
			String sortOrder) {
		sink(uri); // $ hasTaintFlow
		sink(projection); // $ hasTaintFlow
		sink(selection); // $ hasTaintFlow
		sink(selectionArgs); // $ hasTaintFlow
		return null;
	}

	// "android.content;ContentProvider;true;query;(Uri,String[],String,String[],String,CancellationSignal);;Parameter[0..4];contentprovider",
	@Override
	public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs,
			String sortOrder, CancellationSignal cancellationSignal) {
		sink(uri); // $ hasTaintFlow
		sink(projection); // $ hasTaintFlow
		sink(selection); // $ hasTaintFlow
		sink(selectionArgs); // $ hasTaintFlow
		sink(sortOrder); // $ hasTaintFlow
		sink(cancellationSignal); // Safe
		return null;
	}

	// "android.content;ContentProvider;true;update;(Uri,ContentValues,Bundle);;Parameter[0..2];contentprovider",
	@Override
	public int update(Uri uri, ContentValues values, Bundle extras) {
		sink(uri); // $ hasTaintFlow
		sink(values); // $ hasTaintFlow
		sink(extras.get("some_key")); // $ hasTaintFlow
		return 0;
	}

	// "android.content;ContentProvider;true;update;(Uri,ContentValues,String,String[]);;Parameter[0..3];contentprovider"
	@Override
	public int update(Uri uri, ContentValues values, String selection, String[] selectionArgs) {
		sink(uri); // $ hasTaintFlow
		sink(values); // $ hasTaintFlow
		sink(selection); // $ hasTaintFlow
		sink(selectionArgs); // $ hasTaintFlow
		return 0;
	}

	@Override
	public boolean onCreate() {
		return false;
	}
}
