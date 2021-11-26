import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.HashMap;

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

	public static String appendSelectionArgs() {
		String[] originalValues = {taint()}; // $taintReachesReturn
		String[] newValues = {taint()}; // $taintReachesReturn
		return DatabaseUtils.appendSelectionArgs(originalValues, newValues)[0];
	}

	public static String concatenateWhere() {
		String a = taint(); // $taintReachesReturn
		String b = taint(); // $taintReachesReturn
		return DatabaseUtils.concatenateWhere(a, b);
	}

	public static String buildQueryString(MySQLiteQueryBuilder target) {
		target = taint();
		boolean distinct = taint(); 
		String tables = taint(); // $taintReachesReturn
		String[] columns = {taint()}; // $taintReachesReturn
		String where = taint(); // $taintReachesReturn
		String groupBy = taint(); // $taintReachesReturn
		String having = taint(); // $taintReachesReturn
		String orderBy = taint(); // $taintReachesReturn
		String limit = taint(); // $taintReachesReturn
		return SQLiteQueryBuilder.buildQueryString(distinct, tables, columns, where, groupBy, having, orderBy, limit);
	}

	public static String buildQuery(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		String[] projectionIn = {taint()}; // $taintReachesReturn
		String selection = taint(); // $taintReachesReturn
		String groupBy = taint(); // $taintReachesReturn
		String having = taint(); // $taintReachesReturn
		String sortOrder = taint(); // $taintReachesReturn
		String limit = taint(); // $taintReachesReturn
		return target.buildQuery(projectionIn, selection, groupBy, having, sortOrder, limit);
	}

	public static String buildQuery2(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		String[] projectionIn = {taint()}; // $taintReachesReturn
		String selection = taint(); // $taintReachesReturn
		String[] selectionArgs = {taint()}; 
		String groupBy = taint(); // $taintReachesReturn
		String having = taint(); // $taintReachesReturn
		String sortOrder = taint(); // $taintReachesReturn
		String limit = taint(); // $taintReachesReturn
		return target.buildQuery(projectionIn, selection, selectionArgs, groupBy, having, sortOrder, limit);
	}

	public static String buildUnionQuery(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		String[] subQueries = {taint()}; // $taintReachesReturn
		String sortOrder = taint(); // $taintReachesReturn
		String limit = taint(); // $taintReachesReturn
		return target.buildUnionQuery(subQueries, sortOrder, limit);
	}

	public static String buildUnionSubQuery2(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		String typeDiscriminatorColumn = taint(); // $taintReachesReturn
		String[] unionColumns = {taint()}; // $taintReachesReturn
		Set<String> columnsPresentInTable = new HashSet();
		columnsPresentInTable.add(taint()); // $taintReachesReturn
		int computedColumnsOffset = taint();
		String typeDiscriminatorValue = taint(); // $taintReachesReturn
		String selection = taint(); // $taintReachesReturn
		String[] selectionArgs = {taint()};
		String groupBy = taint(); // $taintReachesReturn
		String having = taint(); // $taintReachesReturn
		return target.buildUnionSubQuery(typeDiscriminatorColumn, unionColumns, columnsPresentInTable,
				computedColumnsOffset, typeDiscriminatorValue, selection, selectionArgs, groupBy, having);
	}

	public static String buildUnionSubQuery3(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn 
		String typeDiscriminatorColumn = taint(); // $taintReachesReturn
		String[] unionColumns = {taint()}; // $taintReachesReturn
		Set<String> columnsPresentInTable = new HashSet();
		columnsPresentInTable.add(taint()); // $taintReachesReturn
		int computedColumnsOffset = taint();
		String typeDiscriminatorValue = taint(); // $taintReachesReturn
		String selection = taint(); // $taintReachesReturn
		String groupBy = taint(); // $taintReachesReturn
		String having = taint(); // $taintReachesReturn
		return target.buildUnionSubQuery(typeDiscriminatorColumn, unionColumns, columnsPresentInTable, computedColumnsOffset,
				typeDiscriminatorValue, selection, groupBy, having);
	}

	public static Cursor query(MyContentResolver target) {
		Uri uri = taint(); // $taintReachesReturn
		String[] projection = {taint()};
		String selection = taint(); // $taintReachesSink
		String[] selectionArgs = {taint()};
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static Cursor query(MyContentProvider target) {
		Uri uri = taint(); // $taintReachesReturn
		String[] projection = {taint()};
		String selection = taint(); // $taintReachesSink
		String[] selectionArgs = {taint()};
		String sortOrder = taint();
		CancellationSignal cancellationSignal = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder, cancellationSignal);
	}

	public static Cursor query2(MyContentResolver target) {
		Uri uri = taint(); // $taintReachesReturn
		String[] projection = {taint()};
		String selection = taint(); // $taintReachesSink
		String[] selectionArgs = {taint()};
		String sortOrder = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static Cursor query2(MyContentProvider target) {
		Uri uri = taint(); // $taintReachesReturn
		String[] projection = {taint()};
		String selection = taint(); // $taintReachesSink
		String[] selectionArgs = {taint()};
		String sortOrder = taint();
		return target.query(uri, projection, selection, selectionArgs, sortOrder);
	}

	public static StringBuilder appendColumns() {
		StringBuilder s = taint(); // $taintReachesReturn
		String[] columns = {taint()}; // $taintReachesReturn
		SQLiteQueryBuilder.appendColumns(s, columns);
		return s;
	}

	public static SQLiteQueryBuilder setProjectionMap(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		Map<String, String> columnMap = new HashMap(); 
		String k = taint(); // $taintReachesReturn
		String v = taint(); // $taintReachesReturn
		columnMap.put(k, v);
		target.setProjectionMap(columnMap);
		return target;
	}

	public static SQLiteQueryBuilder setTables(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		String inTables = taint(); // $taintReachesReturn
		target.setTables(inTables);
		return target;
	}

	public static SQLiteQueryBuilder appendWhere(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		CharSequence inWhere = taint(); // $taintReachesReturn
		target.appendWhere(inWhere);
		return target;
	}

	public static SQLiteQueryBuilder appendWhereStandalone(MySQLiteQueryBuilder target) {
		target = taint(); // $taintReachesReturn
		CharSequence inWhere = taint(); // $taintReachesReturn
		target.appendWhereStandalone(inWhere);
		return target;
	}
}
