package org.apache.ibatis.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class SqlRunner {

  public static final int NO_GENERATED_KEY = Integer.MIN_VALUE + 1001;

  private final Connection connection;
  private boolean useGeneratedKeySupport;

  public SqlRunner(Connection connection) {
    this.connection = connection;
  }

  public void setUseGeneratedKeySupport(boolean useGeneratedKeySupport) { }
  public Map<String, Object> selectOne(String sql, Object... args) throws SQLException { return null; }
  public List<Map<String, Object>> selectAll(String sql, Object... args) throws SQLException { return null; }
  public int insert(String sql, Object... args) throws SQLException { return 0; }
  public int update(String sql, Object... args) throws SQLException { return 0; }
  public int delete(String sql, Object... args) throws SQLException { return 0; }
  public void closeConnection() { }
  private void setParameters(PreparedStatement ps, Object... args) throws SQLException { }
  private List<Map<String, Object>> getResults(ResultSet rs) throws SQLException { return null; }

}
