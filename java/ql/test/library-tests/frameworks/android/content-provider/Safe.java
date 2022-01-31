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

// This content provider isn't exported, so there shouldn't be any flow
public class Safe extends ContentProvider {

	void sink(Object o) {}

	@Override
	public Bundle call(String authority, String method, String arg, Bundle extras) {
		sink(authority);
		sink(method);
		sink(arg);
		sink(extras.get("some_key"));
		return null;
	}

	public Bundle call(String method, String arg, Bundle extras) {
		sink(method);
		sink(arg);
		sink(extras.get("some_key"));
		return null;
	}

	@Override
	public int delete(Uri uri, String selection, String[] selectionArgs) {
		sink(uri);
		sink(selection);
		sink(selectionArgs);
		return 0;
	}

	@Override
	public int delete(Uri uri, Bundle extras) {
		sink(uri);
		sink(extras.get("some_key"));
		return 0;
	}

	@Override
	public String getType(Uri uri) {
		sink(uri);
		return null;
	}

	@Override
	public Uri insert(Uri uri, ContentValues values, Bundle extras) {
		sink(uri);
		sink(values);
		sink(extras.get("some_key"));
		return null;
	}

	@Override
	public Uri insert(Uri uri, ContentValues values) {
		sink(uri);
		sink(values);
		return null;
	}

	@Override
	public AssetFileDescriptor openAssetFile(Uri uri, String mode, CancellationSignal signal) {
		sink(uri);
		sink(mode);
		sink(signal);
		return null;
	}

	@Override
	public AssetFileDescriptor openAssetFile(Uri uri, String mode) {
		sink(uri);
		sink(mode);
		return null;
	}

	@Override
	public AssetFileDescriptor openTypedAssetFile(Uri uri, String mimeTypeFilter, Bundle opts,
			CancellationSignal signal) {
		sink(uri);
		sink(mimeTypeFilter);
		sink(opts.get("some_key"));
		sink(signal);
		return null;
	}

	@Override
	public AssetFileDescriptor openTypedAssetFile(Uri uri, String mimeTypeFilter, Bundle opts) {
		sink(uri);
		sink(mimeTypeFilter);
		sink(opts.get("some_key"));
		return null;
	}

	@Override
	public ParcelFileDescriptor openFile(Uri uri, String mode, CancellationSignal signal) {
		sink(uri);
		sink(mode);
		sink(signal);
		return null;
	}

	@Override
	public ParcelFileDescriptor openFile(Uri uri, String mode) {
		sink(uri);
		sink(mode);
		return null;
	}

	@Override
	public Cursor query(Uri uri, String[] projection, Bundle queryArgs,
			CancellationSignal cancellationSignal) {
		sink(uri);
		sink(projection);
		sink(queryArgs.get("some_key"));
		sink(cancellationSignal);
		return null;
	}

	@Override
	public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs,
			String sortOrder) {
		sink(uri);
		sink(projection);
		sink(selection);
		sink(selectionArgs);
		return null;
	}

	@Override
	public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs,
			String sortOrder, CancellationSignal cancellationSignal) {
		sink(uri);
		sink(projection);
		sink(selection);
		sink(selectionArgs);
		sink(sortOrder);
		sink(cancellationSignal);
		return null;
	}

	@Override
	public int update(Uri uri, ContentValues values, Bundle extras) {
		sink(uri);
		sink(values);
		sink(extras.get("some_key"));
		return 0;
	}

	@Override
	public int update(Uri uri, ContentValues values, String selection, String[] selectionArgs) {
		sink(uri);
		sink(values);
		sink(selection);
		sink(selectionArgs);
		return 0;
	}


	@Override
	public boolean onCreate() {
		return false;
	}
}
