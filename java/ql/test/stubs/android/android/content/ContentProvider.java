package android.content;

import android.database.Cursor;
import android.net.Uri;
import android.os.CancellationSignal;

public abstract class ContentProvider {
	public abstract int delete(Uri uri, String selection, String[] selectionArgs);

	public abstract Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder,
			CancellationSignal cancellationSignal);

	public abstract Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder);

	public abstract int update(Uri uri, ContentValues values, String selection, String[] selectionArgs);

}
