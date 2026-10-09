package generatedtest;

import java.sql.Connection;
import org.apache.commons.dbutils.AsyncQueryRunner;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;

public class Test {
	Object source() { return null; }

	public void testQueryRunnerSinks(
			QueryRunner runner, Connection connection, ResultSetHandler<Object> handler)
			throws Exception {
		// "org.apache.commons.dbutils;QueryRunner;true;insert;(Connection,String,ResultSetHandler);;Argument[1];sql-injection;manual"
		runner.insert(connection, (String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;insert;(Connection,String,ResultSetHandler,Object[]);;Argument[1];sql-injection;manual"
		runner.insert(connection, (String) source(), handler, (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;insert;(String,ResultSetHandler);;Argument[0];sql-injection;manual"
		runner.insert((String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;insert;(String,ResultSetHandler,Object[]);;Argument[0];sql-injection;manual"
		runner.insert((String) source(), handler, (Object[]) null); // $ hasValueFlow

		// "org.apache.commons.dbutils;QueryRunner;true;query;(Connection,String,ResultSetHandler);;Argument[1];sql-injection;manual"
		runner.query(connection, (String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;query;(Connection,String,ResultSetHandler,Object[]);;Argument[1];sql-injection;manual"
		runner.query(connection, (String) source(), handler, (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;query;(String,ResultSetHandler);;Argument[0];sql-injection;manual"
		runner.query((String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;query;(String,ResultSetHandler,Object[]);;Argument[0];sql-injection;manual"
		runner.query((String) source(), handler, (Object[]) null); // $ hasValueFlow

		// "org.apache.commons.dbutils;QueryRunner;true;update;(Connection,String);;Argument[1];sql-injection;manual"
		runner.update(connection, (String) source()); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;update;(Connection,String,Object[]);;Argument[1];sql-injection;manual"
		runner.update(connection, (String) source(), (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;update;(Connection,String,Object);;Argument[1];sql-injection;manual"
		runner.update(connection, (String) source(), (Object) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;update;(String);;Argument[0];sql-injection;manual"
		runner.update((String) source()); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;update;(String,Object[]);;Argument[0];sql-injection;manual"
		runner.update((String) source(), (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;QueryRunner;true;update;(String,Object);;Argument[0];sql-injection;manual"
		runner.update((String) source(), (Object) null); // $ hasValueFlow
	}

	public void testAsyncQueryRunnerSinks(
			AsyncQueryRunner runner, Connection connection, ResultSetHandler<Object> handler)
			throws Exception {
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;insert;(Connection,String,ResultSetHandler);;Argument[1];sql-injection;manual"
		runner.insert(connection, (String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;insert;(Connection,String,ResultSetHandler,Object[]);;Argument[1];sql-injection;manual"
		runner.insert(connection, (String) source(), handler, (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;insert;(String,ResultSetHandler);;Argument[0];sql-injection;manual"
		runner.insert((String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;insert;(String,ResultSetHandler,Object[]);;Argument[0];sql-injection;manual"
		runner.insert((String) source(), handler, (Object[]) null); // $ hasValueFlow

		// "org.apache.commons.dbutils;AsyncQueryRunner;true;query;(Connection,String,ResultSetHandler);;Argument[1];sql-injection;manual"
		runner.query(connection, (String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;query;(Connection,String,ResultSetHandler,Object[]);;Argument[1];sql-injection;manual"
		runner.query(connection, (String) source(), handler, (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;query;(String,ResultSetHandler);;Argument[0];sql-injection;manual"
		runner.query((String) source(), handler); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;query;(String,ResultSetHandler,Object[]);;Argument[0];sql-injection;manual"
		runner.query((String) source(), handler, (Object[]) null); // $ hasValueFlow

		// "org.apache.commons.dbutils;AsyncQueryRunner;true;update;(Connection,String);;Argument[1];sql-injection;manual"
		runner.update(connection, (String) source()); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;update;(Connection,String,Object[]);;Argument[1];sql-injection;manual"
		runner.update(connection, (String) source(), (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;update;(Connection,String,Object);;Argument[1];sql-injection;manual"
		runner.update(connection, (String) source(), (Object) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;update;(String);;Argument[0];sql-injection;manual"
		runner.update((String) source()); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;update;(String,Object[]);;Argument[0];sql-injection;manual"
		runner.update((String) source(), (Object[]) null); // $ hasValueFlow
		// "org.apache.commons.dbutils;AsyncQueryRunner;true;update;(String,Object);;Argument[0];sql-injection;manual"
		runner.update((String) source(), (Object) null); // $ hasValueFlow
	}
}