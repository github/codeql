// Generated automatically from org.springframework.jdbc.core.namedparam.NamedParameterJdbcOperations for testing purposes

package org.springframework.jdbc.core.namedparam;

import java.util.List;
import java.util.Map;
import java.util.stream.Stream;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.jdbc.support.rowset.SqlRowSet;

public interface NamedParameterJdbcOperations
{
    <T> T execute(String p0, Map<String, ? extends Object> p1, org.springframework.jdbc.core.PreparedStatementCallback<T> p2);
    <T> T execute(String p0, SqlParameterSource p1, org.springframework.jdbc.core.PreparedStatementCallback<T> p2);
    <T> T execute(String p0, org.springframework.jdbc.core.PreparedStatementCallback<T> p1);
    <T> T query(String p0, Map<String, ? extends Object> p1, org.springframework.jdbc.core.ResultSetExtractor<T> p2);
    <T> T query(String p0, SqlParameterSource p1, org.springframework.jdbc.core.ResultSetExtractor<T> p2);
    <T> T query(String p0, org.springframework.jdbc.core.ResultSetExtractor<T> p1);
    <T> T queryForObject(String p0, Map<String, ? extends Object> p1, java.lang.Class<T> p2);
    <T> T queryForObject(String p0, Map<String, ? extends Object> p1, org.springframework.jdbc.core.RowMapper<T> p2);
    <T> T queryForObject(String p0, SqlParameterSource p1, java.lang.Class<T> p2);
    <T> T queryForObject(String p0, SqlParameterSource p1, org.springframework.jdbc.core.RowMapper<T> p2);
    <T> java.util.List<T> query(String p0, Map<String, ? extends Object> p1, org.springframework.jdbc.core.RowMapper<T> p2);
    <T> java.util.List<T> query(String p0, SqlParameterSource p1, org.springframework.jdbc.core.RowMapper<T> p2);
    <T> java.util.List<T> query(String p0, org.springframework.jdbc.core.RowMapper<T> p1);
    <T> java.util.List<T> queryForList(String p0, Map<String, ? extends Object> p1, java.lang.Class<T> p2);
    <T> java.util.List<T> queryForList(String p0, SqlParameterSource p1, java.lang.Class<T> p2);
    <T> java.util.stream.Stream<T> queryForStream(String p0, Map<String, ? extends Object> p1, org.springframework.jdbc.core.RowMapper<T> p2);
    <T> java.util.stream.Stream<T> queryForStream(String p0, SqlParameterSource p1, org.springframework.jdbc.core.RowMapper<T> p2);
    JdbcOperations getJdbcOperations();
    List<Map<String, Object>> queryForList(String p0, Map<String, ? extends Object> p1);
    List<Map<String, Object>> queryForList(String p0, SqlParameterSource p1);
    Map<String, Object> queryForMap(String p0, Map<String, ? extends Object> p1);
    Map<String, Object> queryForMap(String p0, SqlParameterSource p1);
    SqlRowSet queryForRowSet(String p0, Map<String, ? extends Object> p1);
    SqlRowSet queryForRowSet(String p0, SqlParameterSource p1);
    int update(String p0, Map<String, ? extends Object> p1);
    int update(String p0, SqlParameterSource p1);
    int update(String p0, SqlParameterSource p1, KeyHolder p2);
    int update(String p0, SqlParameterSource p1, KeyHolder p2, String[] p3);
    int[] batchUpdate(String p0, Map<String, ? extends Object>[] p1);
    int[] batchUpdate(String p0, SqlParameterSource[] p1);
    void query(String p0, Map<String, ? extends Object> p1, RowCallbackHandler p2);
    void query(String p0, RowCallbackHandler p1);
    void query(String p0, SqlParameterSource p1, RowCallbackHandler p2);
}
