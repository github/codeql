package android.database.sqlite;

import android.content.ContentValues;
import android.os.CancellationSignal;

public abstract class SQLiteDatabase {
	public class CursorFactory {

	}

	public abstract void execPerConnectionSQL(String sql, Object[] bindArgs);

	public abstract void execSQL(String sql);

	public abstract void execSQL(String sql, Object[] bindArgs);

	public abstract void query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs,
			String groupBy, String having, String orderBy, String limit);

	public abstract void query(boolean distinct, String table, String[] columns, String selection, String[] selectionArgs,
			String groupBy, String having, String orderBy, String limit, CancellationSignal cancellationSignal);

	public abstract void query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy,
			String having, String orderBy, String limit);

	public abstract void query(String table, String[] columns, String selection, String[] selectionArgs, String groupBy,
			String having, String orderBy);

	public abstract void queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table,
			String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy,
			String limit, CancellationSignal cancellationSignal);

	public abstract void queryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, boolean distinct, String table,
			String[] columns, String selection, String[] selectionArgs, String groupBy, String having, String orderBy,
			String limit);

	public abstract void rawQuery(String sql, String[] selectionArgs, CancellationSignal cancellationSignal);

	public abstract void rawQuery(String sql, String[] selectionArgs);

	public abstract void rawQueryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, String sql, String[] selectionArgs,
			String editTable, CancellationSignal cancellationSignal);

	public abstract void rawQueryWithFactory(SQLiteDatabase.CursorFactory cursorFactory, String sql, String[] selectionArgs,
			String editTable);

	public abstract void compileStatement(String sql);

	public abstract void delete(String table, String whereClause, String[] whereArgs);

	public abstract void update(String table, ContentValues values, String whereClause, String[] whereArgs);

	public abstract void updateWithOnConflict(String table, ContentValues values, String whereClause, String[] whereArgs,
			int conflictAlgorithm);

}
