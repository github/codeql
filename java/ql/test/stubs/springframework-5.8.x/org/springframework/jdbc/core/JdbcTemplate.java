// Generated automatically from org.springframework.jdbc.core.JdbcTemplate for testing purposes

package org.springframework.jdbc.core;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.Statement;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;
import javax.sql.DataSource;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.ParameterizedPreparedStatementSetter;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.ResultSetSupportingSqlParameter;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.StatementCallback;
import org.springframework.jdbc.support.JdbcAccessor;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.jdbc.support.rowset.SqlRowSet;

public class JdbcTemplate extends JdbcAccessor implements JdbcOperations
{
    protected <T> org.springframework.jdbc.core.RowMapper<T> getSingleColumnRowMapper(java.lang.Class<T> p0){ return null; }
    protected Connection createConnectionProxy(Connection p0){ return null; }
    protected DataAccessException translateException(String p0, String p1, SQLException p2){ return null; }
    protected Map<String, Object> createResultsMap(){ return null; }
    protected Map<String, Object> extractOutputParameters(CallableStatement p0, List<SqlParameter> p1){ return null; }
    protected Map<String, Object> extractReturnedResults(CallableStatement p0, List<SqlParameter> p1, List<SqlParameter> p2, int p3){ return null; }
    protected Map<String, Object> processResultSet(ResultSet p0, ResultSetSupportingSqlParameter p1){ return null; }
    protected PreparedStatementSetter newArgPreparedStatementSetter(Object[] p0){ return null; }
    protected PreparedStatementSetter newArgTypePreparedStatementSetter(Object[] p0, int[] p1){ return null; }
    protected RowMapper<Map<String, Object>> getColumnMapRowMapper(){ return null; }
    protected int update(PreparedStatementCreator p0, PreparedStatementSetter p1){ return 0; }
    protected void applyStatementSettings(Statement p0){}
    protected void handleWarnings(SQLWarning p0){}
    protected void handleWarnings(Statement p0){}
    public <T> T execute(CallableStatementCreator p0, org.springframework.jdbc.core.CallableStatementCallback<T> p1){ return null; }
    public <T> T execute(PreparedStatementCreator p0, org.springframework.jdbc.core.PreparedStatementCallback<T> p1){ return null; }
    public <T> T execute(String p0, org.springframework.jdbc.core.CallableStatementCallback<T> p1){ return null; }
    public <T> T execute(String p0, org.springframework.jdbc.core.PreparedStatementCallback<T> p1){ return null; }
    public <T> T execute(org.springframework.jdbc.core.ConnectionCallback<T> p0){ return null; }
    public <T> T execute(org.springframework.jdbc.core.StatementCallback<T> p0){ return null; }
    public <T> T query(PreparedStatementCreator p0, PreparedStatementSetter p1, org.springframework.jdbc.core.ResultSetExtractor<T> p2){ return null; }
    public <T> T query(PreparedStatementCreator p0, org.springframework.jdbc.core.ResultSetExtractor<T> p1){ return null; }
    public <T> T query(String p0, Object[] p1, int[] p2, org.springframework.jdbc.core.ResultSetExtractor<T> p3){ return null; }
    public <T> T query(String p0, Object[] p1, org.springframework.jdbc.core.ResultSetExtractor<T> p2){ return null; }
    public <T> T query(String p0, PreparedStatementSetter p1, org.springframework.jdbc.core.ResultSetExtractor<T> p2){ return null; }
    public <T> T query(String p0, org.springframework.jdbc.core.ResultSetExtractor<T> p1){ return null; }
    public <T> T query(String p0, org.springframework.jdbc.core.ResultSetExtractor<T> p1, Object... p2){ return null; }
    public <T> T queryForObject(String p0, Object[] p1, int[] p2, java.lang.Class<T> p3){ return null; }
    public <T> T queryForObject(String p0, Object[] p1, int[] p2, org.springframework.jdbc.core.RowMapper<T> p3){ return null; }
    public <T> T queryForObject(String p0, Object[] p1, java.lang.Class<T> p2){ return null; }
    public <T> T queryForObject(String p0, Object[] p1, org.springframework.jdbc.core.RowMapper<T> p2){ return null; }
    public <T> T queryForObject(String p0, java.lang.Class<T> p1){ return null; }
    public <T> T queryForObject(String p0, java.lang.Class<T> p1, Object... p2){ return null; }
    public <T> T queryForObject(String p0, org.springframework.jdbc.core.RowMapper<T> p1){ return null; }
    public <T> T queryForObject(String p0, org.springframework.jdbc.core.RowMapper<T> p1, Object... p2){ return null; }
    public <T> int[][] batchUpdate(String p0, java.util.Collection<T> p1, int p2, org.springframework.jdbc.core.ParameterizedPreparedStatementSetter<T> p3){ return null; }
    public <T> java.util.List<T> query(PreparedStatementCreator p0, org.springframework.jdbc.core.RowMapper<T> p1){ return null; }
    public <T> java.util.List<T> query(String p0, Object[] p1, int[] p2, org.springframework.jdbc.core.RowMapper<T> p3){ return null; }
    public <T> java.util.List<T> query(String p0, Object[] p1, org.springframework.jdbc.core.RowMapper<T> p2){ return null; }
    public <T> java.util.List<T> query(String p0, PreparedStatementSetter p1, org.springframework.jdbc.core.RowMapper<T> p2){ return null; }
    public <T> java.util.List<T> query(String p0, org.springframework.jdbc.core.RowMapper<T> p1){ return null; }
    public <T> java.util.List<T> query(String p0, org.springframework.jdbc.core.RowMapper<T> p1, Object... p2){ return null; }
    public <T> java.util.List<T> queryForList(String p0, Object[] p1, int[] p2, java.lang.Class<T> p3){ return null; }
    public <T> java.util.List<T> queryForList(String p0, Object[] p1, java.lang.Class<T> p2){ return null; }
    public <T> java.util.List<T> queryForList(String p0, java.lang.Class<T> p1){ return null; }
    public <T> java.util.List<T> queryForList(String p0, java.lang.Class<T> p1, Object... p2){ return null; }
    public <T> java.util.stream.Stream<T> queryForStream(PreparedStatementCreator p0, PreparedStatementSetter p1, org.springframework.jdbc.core.RowMapper<T> p2){ return null; }
    public <T> java.util.stream.Stream<T> queryForStream(PreparedStatementCreator p0, org.springframework.jdbc.core.RowMapper<T> p1){ return null; }
    public <T> java.util.stream.Stream<T> queryForStream(String p0, PreparedStatementSetter p1, org.springframework.jdbc.core.RowMapper<T> p2){ return null; }
    public <T> java.util.stream.Stream<T> queryForStream(String p0, org.springframework.jdbc.core.RowMapper<T> p1){ return null; }
    public <T> java.util.stream.Stream<T> queryForStream(String p0, org.springframework.jdbc.core.RowMapper<T> p1, Object... p2){ return null; }
    public JdbcTemplate(){}
    public JdbcTemplate(DataSource p0){}
    public JdbcTemplate(DataSource p0, boolean p1){}
    public List<Map<String, Object>> queryForList(String p0){ return null; }
    public List<Map<String, Object>> queryForList(String p0, Object... p1){ return null; }
    public List<Map<String, Object>> queryForList(String p0, Object[] p1, int[] p2){ return null; }
    public Map<String, Object> call(CallableStatementCreator p0, List<SqlParameter> p1){ return null; }
    public Map<String, Object> queryForMap(String p0){ return null; }
    public Map<String, Object> queryForMap(String p0, Object... p1){ return null; }
    public Map<String, Object> queryForMap(String p0, Object[] p1, int[] p2){ return null; }
    public SqlRowSet queryForRowSet(String p0){ return null; }
    public SqlRowSet queryForRowSet(String p0, Object... p1){ return null; }
    public SqlRowSet queryForRowSet(String p0, Object[] p1, int[] p2){ return null; }
    public boolean isIgnoreWarnings(){ return false; }
    public boolean isResultsMapCaseInsensitive(){ return false; }
    public boolean isSkipResultsProcessing(){ return false; }
    public boolean isSkipUndeclaredResults(){ return false; }
    public int getFetchSize(){ return 0; }
    public int getMaxRows(){ return 0; }
    public int getQueryTimeout(){ return 0; }
    public int update(PreparedStatementCreator p0){ return 0; }
    public int update(PreparedStatementCreator p0, KeyHolder p1){ return 0; }
    public int update(String p0){ return 0; }
    public int update(String p0, Object... p1){ return 0; }
    public int update(String p0, Object[] p1, int[] p2){ return 0; }
    public int update(String p0, PreparedStatementSetter p1){ return 0; }
    public int[] batchUpdate(String p0, BatchPreparedStatementSetter p1){ return null; }
    public int[] batchUpdate(String p0, List<Object[]> p1){ return null; }
    public int[] batchUpdate(String p0, List<Object[]> p1, int[] p2){ return null; }
    public int[] batchUpdate(String... p0){ return null; }
    public void execute(String p0){}
    public void query(PreparedStatementCreator p0, RowCallbackHandler p1){}
    public void query(String p0, Object[] p1, RowCallbackHandler p2){}
    public void query(String p0, Object[] p1, int[] p2, RowCallbackHandler p3){}
    public void query(String p0, PreparedStatementSetter p1, RowCallbackHandler p2){}
    public void query(String p0, RowCallbackHandler p1){}
    public void query(String p0, RowCallbackHandler p1, Object... p2){}
    public void setFetchSize(int p0){}
    public void setIgnoreWarnings(boolean p0){}
    public void setMaxRows(int p0){}
    public void setQueryTimeout(int p0){}
    public void setResultsMapCaseInsensitive(boolean p0){}
    public void setSkipResultsProcessing(boolean p0){}
    public void setSkipUndeclaredResults(boolean p0){}
}
