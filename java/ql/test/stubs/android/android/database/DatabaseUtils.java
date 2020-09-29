package android.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.os.ParcelFileDescriptor;

public class DatabaseUtils {

	public static ParcelFileDescriptor blobFileDescriptorForQuery(SQLiteDatabase db, String query,
			String[] selectionArgs) {
		return null;
	}

	public static long longForQuery(SQLiteDatabase db, String query, String[] selectionArgs) {
		return 0;

	}

	public static String stringForQuery(SQLiteDatabase db, String query, String[] selectionArgs) {
		return null;

	}

	public static void createDbFromSqlStatements(Context context, String dbName, int dbVersion, String sqlStatements) {

	}

	public static int queryNumEntries(SQLiteDatabase db, String table, String selection) {
		return 0;

	}

	public static int queryNumEntries(SQLiteDatabase db, String table, String selection, String[] selectionArgs) {
		return 0;

	}

	public static String[] appendSelectionArgs(String[] originalValues, String[] newValues) {
		return null;
	}

	public static String concatenateWhere(String a, String b) {
		return null;
	}

}
