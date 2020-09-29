package android.database.sqlite;

import java.util.Map;
import java.util.Set;

import android.content.ContentValues;
import android.os.CancellationSignal;

public abstract class SQLiteQueryBuilder {
	public abstract void delete(SQLiteDatabase db, String selection, String[] selectionArgs);

	public abstract void insert(SQLiteDatabase db, ContentValues values);

	public abstract void query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs,
			String groupBy, String having, String sortOrder);

	public abstract void query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs,
			String groupBy, String having, String sortOrder, String limit);

	public abstract void query(SQLiteDatabase db, String[] projectionIn, String selection, String[] selectionArgs,
			String groupBy, String having, String sortOrder, String limit, CancellationSignal cancellationSignal);

	public abstract void update(SQLiteDatabase db, ContentValues values, String selection, String[] selectionArgs);

	public static String buildQueryString(boolean distinct, String tables, String[] columns, String where,
			String groupBy, String having, String orderBy, String limit) {
		return null;
	}

	public abstract String buildQuery(String[] projectionIn, String selection, String groupBy, String having, String sortOrder,
			String limit);

	public abstract String buildQuery(String[] projectionIn, String selection, String[] selectionArgs, String groupBy,
			String having, String sortOrder, String limit);

	public abstract String buildUnionQuery(String[] subQueries, String sortOrder, String limit);

	public abstract String buildUnionSubQuery(String typeDiscriminatorColumn, String[] unionColumns,
			Set<String> columnsPresentInTable, int computedColumnsOffset, String typeDiscriminatorValue,
			String selection, String[] selectionArgs, String groupBy, String having);

	public abstract String buildUnionSubQuery(String typeDiscriminatorColumn, String[] unionColumns,
			Set<String> columnsPresentInTable, int computedColumnsOffset, String typeDiscriminatorValue,
			String selection, String groupBy, String having);

	public static void appendColumns(StringBuilder s, String[] columns) {
	}

	public abstract void setProjectionMap(Map<String, String> columnMap);

	public abstract void setTables(String inTables);

	public abstract void appendWhere(CharSequence inWhere);

	public abstract void appendWhereStandalone(CharSequence inWhere);

}
