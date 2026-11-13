// Generated automatically from org.apache.commons.dbutils.AsyncQueryRunner for testing purposes

package org.apache.commons.dbutils;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.concurrent.Future;

public class AsyncQueryRunner {
    public <T> Future<T> insert(Connection conn, String sql, ResultSetHandler<T> rsh) throws SQLException { return null; }
    public <T> Future<T> insert(Connection conn, String sql, ResultSetHandler<T> rsh, Object... params) throws SQLException { return null; }
    public <T> Future<T> insert(String sql, ResultSetHandler<T> rsh) throws SQLException { return null; }
    public <T> Future<T> insert(String sql, ResultSetHandler<T> rsh, Object... params) throws SQLException { return null; }

    public <T> Future<T> query(Connection conn, String sql, ResultSetHandler<T> rsh) throws SQLException { return null; }
    public <T> Future<T> query(Connection conn, String sql, ResultSetHandler<T> rsh, Object... params) throws SQLException { return null; }
    public <T> Future<T> query(String sql, ResultSetHandler<T> rsh) throws SQLException { return null; }
    public <T> Future<T> query(String sql, ResultSetHandler<T> rsh, Object... params) throws SQLException { return null; }

    public Future<Integer> update(Connection conn, String sql) throws SQLException { return null; }
    public Future<Integer> update(Connection conn, String sql, Object param) throws SQLException { return null; }
    public Future<Integer> update(Connection conn, String sql, Object... params) throws SQLException { return null; }
    public Future<Integer> update(String sql) throws SQLException { return null; }
    public Future<Integer> update(String sql, Object param) throws SQLException { return null; }
    public Future<Integer> update(String sql, Object... params) throws SQLException { return null; }
}
