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
		String[] originalValues = taint(); // $hasTaintFlowStep
		String[] newValues = taint(); // $hasTaintFlowStep
		return DatabaseUtils.appendSelectionArgs(originalValues, newValues);
	}

	public static String concatenateWhere() {
		String a = taint(); // $hasTaintFlowStep
		String b = taint(); // $hasTaintFlowStep
		return DatabaseUtils.concatenateWhere(a, b);
	}

	public static String buildQueryString(MySQLiteQueryBuilder target) {
		target = taint();
		boolean distinct = taint(); 
		String tables = taint(); // $hasTaintFlowStep
		String[] columns = taint(); // $hasTaintFlowStep
		String where = taint(); // $hasTaintFlowStep
		String groupBy = taint(); // $hasTaintFlowStep
		String having = taint(); // $hasTaintFlowStep
		String orderBy = taint(); // $hasTaintFlowStep
		String limit = taint(); // $hasTaintFlowStep
		return SQLiteQueryBuilder.buildQueryString(distinct, tables, columns, where, groupBy, having, orderBy, limit);
	}

	public static String buildQuery(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		String[] projectionIn = taint();// $hasTaintFlowStep
		String selection = taint(); // $hasTaintFlowStep
		String groupBy = taint(); // $hasTaintFlowStep
		String having = taint(); // $hasTaintFlowStep
		String sortOrder = taint(); // $hasTaintFlowStep
		String limit = taint(); // $hasTaintFlowStep
		return target.buildQuery(projectionIn, selection, groupBy, having, sortOrder, limit);
	}

	public static String buildQuery2(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		String[] projectionIn = taint(); // $hasTaintFlowStep
		String selection = taint(); // $hasTaintFlowStep
		String[] selectionArgs = taint(); // $hasTaintFlowStep
		String groupBy = taint(); // $hasTaintFlowStep
		String having = taint(); // $hasTaintFlowStep
		String sortOrder = taint(); // $hasTaintFlowStep
		String limit = taint(); // $hasTaintFlowStep
		return target.buildQuery(projectionIn, selection, selectionArgs, groupBy, having, sortOrder, limit);
	}

	public static String buildUnionQuery(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		String[] subQueries = taint(); // $hasTaintFlowStep
		String sortOrder = taint(); // $hasTaintFlowStep
		String limit = taint(); // $hasTaintFlowStep
		return target.buildUnionQuery(subQueries, sortOrder, limit);
	}

	public static String buildUnionSubQuery2(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		String typeDiscriminatorColumn = taint(); // $hasTaintFlowStep
		String[] unionColumns = taint(); // $hasTaintFlowStep
		Set<String> columnsPresentInTable = taint(); // $hasTaintFlowStep
		int computedColumnsOffset = taint();
		String typeDiscriminatorValue = taint(); // $hasTaintFlowStep
		String selection = taint(); // $hasTaintFlowStep
		String[] selectionArgs = taint(); // $hasTaintFlowStep
		String groupBy = taint(); // $hasTaintFlowStep
		String having = taint(); // $hasTaintFlowStep
		return target.buildUnionSubQuery(typeDiscriminatorColumn, unionColumns, columnsPresentInTable,
				computedColumnsOffset, typeDiscriminatorValue, selection, selectionArgs, groupBy, having);
	}

	public static String buildUnionSubQuery3(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep 
		String typeDiscriminatorColumn = taint(); // $hasTaintFlowStep
		String[] unionColumns = taint(); // $hasTaintFlowStep
		Set<String> columnsPresentInTable = taint(); // $hasTaintFlowStep
		int computedColumnsOffset = taint();
		String typeDiscriminatorValue = taint(); // $hasTaintFlowStep
		String selection = taint(); // $hasTaintFlowStep
		String groupBy = taint(); // $hasTaintFlowStep
		String having = taint(); // $hasTaintFlowStep
		return target.buildUnionSubQuery(typeDiscriminatorColumn, unionColumns, columnsPresentInTable, computedColumnsOffset,
				typeDiscriminatorValue, selection, groupBy, having);
	}

	public static Cursor query(MyContentResolver target) {
		Uri uri = taint(); // $hasTaintFlowStep
		String[] projection = taint();
		String selection = taint(); // $hasTaintFlowSink
		String[] selectionArgs = taint();
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static Cursor query(MyContentProvider target) {
		Uri uri = taint(); // $hasTaintFlowStep
		String[] projection = taint();
		String selection = taint(); // $hasTaintFlowSink
		String[] selectionArgs = taint();
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static Cursor query2(MyContentResolver target) {
		Uri uri = taint(); // $hasTaintFlowStep
		String[] projection = taint();
		String selection = taint(); // $hasTaintFlowSink
		String[] selectionArgs = taint();
		String sortOrder = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static Cursor query2(MyContentProvider target) {
		Uri uri = taint(); // $hasTaintFlowStep
		String[] projection = taint();
		String selection = taint(); // $hasTaintFlowSink
		String[] selectionArgs = taint();
		String sortOrder = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static StringBuilder appendColumns() {
		StringBuilder s = taint(); // $hasTaintFlowStep
		String[] columns = taint(); // $hasTaintFlowStep
		SQLiteQueryBuilder.appendColumns(s, columns);
		return s;
	}

	public static SQLiteQueryBuilder setProjectionMap(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		Map<String, String> columnMap = taint(); // $hasTaintFlowStep
		target.setProjectionMap(columnMap);
		return target;
	}

	public static SQLiteQueryBuilder setTables(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		String inTables = taint(); // $hasTaintFlowStep
		target.setTables(inTables);
		return target;
	}

	public static SQLiteQueryBuilder appendWhere(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		CharSequence inWhere = taint(); // $hasTaintFlowStep
		target.appendWhere(inWhere);
		return target;
	}

	public static SQLiteQueryBuilder appendWhereStandalone(MySQLiteQueryBuilder target) {
		target = taint(); // $hasTaintFlowStep
		CharSequence inWhere = taint(); // $hasTaintFlowStep
		target.appendWhereStandalone(inWhere);
		return target;
	}
}
