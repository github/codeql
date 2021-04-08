import java.util.Map;
import java.util.Set;

import android.content.ContentProvider;
import android.content.ContentResolver;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.os.CancellationSignal;

public class FlowSteps {
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

	public static String[] appendSelectionArgs() {
		String[] originalValues = taint();
		String[] newValues = taint();
		return DatabaseUtils.appendSelectionArgs(originalValues, newValues);
	}

	public static String concatenateWhere() {
		String a = taint();
		String b = taint();
		return DatabaseUtils.concatenateWhere(a, b);
	}

	public static String buildQueryString(MySQLiteQueryBuilder target) {
		target = taint();
		boolean distinct = taint();
		String tables = taint();
		String[] columns = taint();
		String where = taint();
		String groupBy = taint();
		String having = taint();
		String orderBy = taint();
		String limit = taint();
		return SQLiteQueryBuilder.buildQueryString(distinct, tables, columns, where, groupBy, having, orderBy, limit);
	}

	public static String buildQuery(MySQLiteQueryBuilder target) {
		target = taint();
		String[] projectionIn = taint();
		String selection = taint();
		String groupBy = taint();
		String having = taint();
		String sortOrder = taint();
		String limit = taint();
		return target.buildQuery(projectionIn, selection, groupBy, having, sortOrder, limit);
	}

	public static String buildQuery2(MySQLiteQueryBuilder target) {
		target = taint();
		String[] projectionIn = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		String sortOrder = taint();
		String limit = taint();
		return target.buildQuery(projectionIn, selection, selectionArgs, groupBy, having, sortOrder, limit);
	}

	public static String buildUnionQuery(MySQLiteQueryBuilder target) {
		target = taint();
		String[] subQueries = taint();
		String sortOrder = taint();
		String limit = taint();
		return target.buildUnionQuery(subQueries, sortOrder, limit);
	}

	public static String buildUnionSubQuery2(MySQLiteQueryBuilder target) {
		target = taint();
		String typeDiscriminatorColumn = taint();
		String[] unionColumns = taint();
		Set<String> columnsPresentInTable = taint();
		int computedColumnsOffset = taint();
		String typeDiscriminatorValue = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String groupBy = taint();
		String having = taint();
		return target.buildUnionSubQuery(typeDiscriminatorColumn, unionColumns, columnsPresentInTable,
				computedColumnsOffset, typeDiscriminatorValue, selection, selectionArgs, groupBy, having);
	}

	public static void buildUnionSubQuery3(MySQLiteQueryBuilder target) {
		target = taint();
		String typeDiscriminatorColumn = taint();
		String[] unionColumns = taint();
		Set<String> columnsPresentInTable = taint();
		int computedColumnsOffset = taint();
		String typeDiscriminatorValue = taint();
		String selection = taint();
		String groupBy = taint();
		String having = taint();
		target.buildUnionSubQuery(typeDiscriminatorColumn, unionColumns, columnsPresentInTable, computedColumnsOffset,
				typeDiscriminatorValue, selection, groupBy, having);
	}

	public static Cursor query(MyContentResolver target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static Cursor query(MyContentProvider target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static Cursor query2(MyContentResolver target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static Cursor query2(MyContentProvider target) {
		Uri uri = taint();
		String[] projection = taint();
		String selection = taint();
		String[] selectionArgs = taint();
		String sortOrder = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static void appendColumns() {
		StringBuilder s = taint();
		String[] columns = taint();
		SQLiteQueryBuilder.appendColumns(s, columns);
	}

	public static void setProjectionMap(MySQLiteQueryBuilder target) {
		target = taint();
		Map<String, String> columnMap = taint();
		target.setProjectionMap(columnMap);
	}

	public static void setTables(MySQLiteQueryBuilder target) {
		target = taint();
		String inTables = taint();
		target.setTables(inTables);
	}

	public static void appendWhere(MySQLiteQueryBuilder target) {
		target = taint();
		CharSequence inWhere = taint();
		target.appendWhere(inWhere);
	}

	public static void appendWhereStandalone(MySQLiteQueryBuilder target) {
		target = taint();
		CharSequence inWhere = taint();
		target.appendWhereStandalone(inWhere);
	}
}
