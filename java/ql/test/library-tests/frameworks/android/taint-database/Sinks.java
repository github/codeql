import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.os.CancellationSignal;

public class Sinks {
	public static <T> T taint() {
		return null;
	}

	private static abstract class MyContentProvider extends ContentProvider {
		// Dummy class to test for sub classes
	}

	private static abstract class MyContentResolver extends ContentResolver {
		// Dummy class to test for sub classes
	}
	private static abstract class MySQLiteQueryBuilder extends SQLiteQueryBuilder {
		// Dummy class to test for sub classes
	}

	public static void compileStatement(SQLiteDatabase target) {
		String sql = taint();
		target.compileStatement(sql);
	}

	public static void delete1(MySQLiteQueryBuilder target) {
		target = taint();;
		SQLiteDatabase db = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		target.delete(db, selection, selectionArgs);
	}

	public static void delete(SQLiteDatabase target) {
		String table = taint();
		String whereClause = taint();
		String[] whereArgs = taint();
		target.delete(table, whereClause, whereArgs);
	}

	public static void delete(MyContentResolver target) {
		Uri uri = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		target.delete(uri, selection, selectionArgs);
	}

	public static void delete(MyContentProvider target) {
		Uri uri = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		target.delete(uri, selection, selectionArgs);
	}

	public static void execPerConnectionSQL(SQLiteDatabase target) {
		String sql = taint();
		Object[] bindArgs = taint();
		target.execPerConnectionSQL(sql, bindArgs);
	}

	public static void execSQL(SQLiteDatabase target) {
		String sql = taint();
		target.execSQL(sql);
	}

	public static void execSQL2(SQLiteDatabase target) {
		String sql = taint();
		Object[] bindArgs = taint();
		target.execSQL(sql, bindArgs);
	}

	public static void insert(MySQLiteQueryBuilder target) {
		target = taint();;
		SQLiteDatabase db = taint();
		ContentValues values = taint();
		target.insert(db, values);
	}

	public static void query(SQLiteDatabase target) {
		boolean distinct = taint();
		String table = taint();
		String[] columns = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String orderBy = taint();
		String limit = taint();
		target.query(distinct, table, columns, selection, selectionArgs, groupBy, having, orderBy, limit);
	}

	public static void query2(SQLiteDatabase target) {
		boolean distinct = taint();
		String table = taint();
		String[] columns = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String orderBy = taint();
		String limit = taint();
		CancellationSignal cancellationSignal = taint();
		target.query(distinct, table, columns, selection, selectionArgs, groupBy, having, orderBy, limit,
				cancellationSignal);
	}

	public static void query3(SQLiteDatabase target) {
		String table = taint();
		String[] columns = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String orderBy = taint();
		target.query(table, columns, selection, selectionArgs, groupBy, having, orderBy);
	}

	public static void query4(SQLiteDatabase target) {
		String table = taint();
		String[] columns = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String orderBy = taint();
		String limit = taint();
		target.query(table, columns, selection, selectionArgs, groupBy, having, orderBy, limit);
	}

	public static void query(MySQLiteQueryBuilder target) {
		target = taint();;
		SQLiteDatabase db = taint();
		String[] projectionIn = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String sortOrder = taint();
		target.query(db, projectionIn, selection, selectionArgs, groupBy, having, sortOrder);
	}

	public static void query2(MySQLiteQueryBuilder target) {
		target = taint();;
		SQLiteDatabase db = taint();
		String[] projectionIn = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String sortOrder = taint();
		String limit = taint();
		target.query(db, projectionIn, selection, selectionArgs, groupBy, having, sortOrder, limit);
	}

	public static void query3(MySQLiteQueryBuilder target) {
		target = taint();;
		SQLiteDatabase db = taint();
		String[] projectionIn = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String sortOrder = taint();
		String limit = taint();
		CancellationSignal cancellationSignal = taint();
		target.query(db, projectionIn, selection, selectionArgs, groupBy, having, sortOrder, limit, cancellationSignal);
	}

	public static void query3(MyContentProvider target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static void query(MyContentProvider target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static void query3(MyContentResolver target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static void query(MyContentResolver target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static void queryWithFactory(SQLiteDatabase target) {
		SQLiteDatabase.CursorFactory cursorFactory = taint();
		boolean distinct = taint();
		String table = taint();
		String[] columns = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String orderBy = taint();
		String limit = taint();
		target.queryWithFactory(cursorFactory, distinct, table, columns, selection, selectionArgs, groupBy, having,
				orderBy, limit);
	}

	public static void queryWithFactory2(SQLiteDatabase target) {
		SQLiteDatabase.CursorFactory cursorFactory = taint();
		boolean distinct = taint();
		String table = taint();
		String[] columns = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String orderBy = taint();
		String limit = taint();
		CancellationSignal cancellationSignal = taint();
		target.queryWithFactory(cursorFactory, distinct, table, columns, selection, selectionArgs, groupBy, having,
				orderBy, limit, cancellationSignal);
	}

	public static void rawQuery(SQLiteDatabase target) {
		String sql = taint();
		String[] selectionArgs = taint();
		target.rawQuery(sql, selectionArgs);
	}

	public static void rawQuery2(SQLiteDatabase target) {
		String sql = taint();
		String[] selectionArgs = taint();
		CancellationSignal cancellationSignal = taint();
		target.rawQuery(sql, selectionArgs, cancellationSignal);
	}

	public static void rawQueryWithFactory(SQLiteDatabase target) {
		SQLiteDatabase.CursorFactory cursorFactory = taint();
		String sql = taint();
		String[] selectionArgs = taint();
		String editTable = taint();
		target.rawQueryWithFactory(cursorFactory, sql, selectionArgs, editTable);
	}

	public static void rawQueryWithFactory2(SQLiteDatabase target) {
		SQLiteDatabase.CursorFactory cursorFactory = taint();
		String sql = taint();
		String[] selectionArgs = taint();
		String editTable = taint();
		CancellationSignal cancellationSignal = taint();
		target.rawQueryWithFactory(cursorFactory, sql, selectionArgs, editTable, cancellationSignal);
	}

	public static void update(MySQLiteQueryBuilder target) {
		target = taint();;
		SQLiteDatabase db = taint();
		ContentValues values = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		target.update(db, values, selection, selectionArgs);
	}

	public static void update(SQLiteDatabase target) {
		String table = taint();
		ContentValues values = taint();
		String whereClause = taint();
		String[] whereArgs = taint();
		target.update(table, values, whereClause, whereArgs);
	}

	public static void update(MyContentResolver target) {
		Uri uri = taint();
		ContentValues values = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		target.update(uri, values, selection, selectionArgs);
	}

	public static void update(MyContentProvider target) {
		Uri uri = taint();
		ContentValues values = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		target.update(uri, values, selection, selectionArgs);
	}

	public static void updateWithOnConflict(SQLiteDatabase target) {
		String table = taint();
		ContentValues values = taint();
		String whereClause = taint();
		String[] whereArgs = taint();
		int conflictAlgorithm = taint();
		target.updateWithOnConflict(table, values, whereClause, whereArgs, conflictAlgorithm);
	}

	public static void queryNumEntries() {
		SQLiteDatabase db = taint();
		String table = taint();
		String selection = taint();
		DatabaseUtils.queryNumEntries(db, table, selection);
	}

	public static void queryNumEntries2() {
		SQLiteDatabase db = taint();
		String table = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		DatabaseUtils.queryNumEntries(db, table, selection, selectionArgs);
	}

	public static void createDbFromSqlStatements() {
		Context context = taint();
		String dbName = taint();
		int dbVersion = taint();
		String sqlStatements = taint();
		DatabaseUtils.createDbFromSqlStatements(context, dbName, dbVersion, sqlStatements);
	}

	public static void blobFileDescriptorForQuery() {
		SQLiteDatabase db = taint();
		String query = taint();
		String[] selectionArgs = taint();
		DatabaseUtils.blobFileDescriptorForQuery(db, query, selectionArgs);
	}

	public static void longForQuery() {
		SQLiteDatabase db = taint();
		String query = taint();
		String[] selectionArgs = taint();
		DatabaseUtils.longForQuery(db, query, selectionArgs);
	}

	public static void stringForQuery() {
		SQLiteDatabase db = taint();
		String query = taint();
		String[] selectionArgs = taint();
		DatabaseUtils.stringForQuery(db, query, selectionArgs);
	}
}
