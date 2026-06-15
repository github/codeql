package org.springframework.jdbc.core.namedparam;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import java.util.stream.Stream;

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.jdbc.support.rowset.SqlRowSet;

public class NamedParameterJdbcTemplate implements NamedParameterJdbcOperations {

	public static final int DEFAULT_CACHE_LIMIT = 256;
	private final JdbcOperations classicJdbcTemplate;
	public NamedParameterJdbcTemplate(DataSource dataSource) {
		this.classicJdbcTemplate = new JdbcTemplate(dataSource);
	}
	public NamedParameterJdbcTemplate(JdbcOperations classicJdbcTemplate) {
		this.classicJdbcTemplate = classicJdbcTemplate;
	}
	@Override
	public JdbcOperations getJdbcOperations() { return null; }
	public JdbcTemplate getJdbcTemplate() { return null; }
	public void setCacheLimit(int cacheLimit) { }
	public int getCacheLimit() { return 0; }

	@Override
	public <T> T execute(String sql, SqlParameterSource paramSource, PreparedStatementCallback<T> action)
			throws DataAccessException { return null; }

	@Override
	public <T> T execute(String sql, Map<String, ?> paramMap, PreparedStatementCallback<T> action)
			throws DataAccessException { return null; }

	@Override
	public <T> T execute(String sql, PreparedStatementCallback<T> action) throws DataAccessException { return null; }

	@Override
	public <T> T query(String sql, SqlParameterSource paramSource, ResultSetExtractor<T> rse)
			throws DataAccessException { return null; }

	@Override
	public <T> T query(String sql, Map<String, ?> paramMap, ResultSetExtractor<T> rse)
			throws DataAccessException { return null; }

	@Override
	public <T> T query(String sql, ResultSetExtractor<T> rse) throws DataAccessException { return null; }

	@Override
	public void query(String sql, SqlParameterSource paramSource, RowCallbackHandler rch)
			throws DataAccessException { }

	@Override
	public void query(String sql, Map<String, ?> paramMap, RowCallbackHandler rch)
			throws DataAccessException { }

	@Override
	public void query(String sql, RowCallbackHandler rch) throws DataAccessException { }

	@Override
	public <T> List<T> query(String sql, SqlParameterSource paramSource, RowMapper<T> rowMapper)
			throws DataAccessException { return null; }

	@Override
	public <T> List<T> query(String sql, Map<String, ?> paramMap, RowMapper<T> rowMapper)
			throws DataAccessException { return null; }

	@Override
	public <T> List<T> query(String sql, RowMapper<T> rowMapper) throws DataAccessException { return null; }

	@Override
	public <T> Stream<T> queryForStream(String sql, SqlParameterSource paramSource, RowMapper<T> rowMapper)
			throws DataAccessException { return null; }

	@Override
	public <T> Stream<T> queryForStream(String sql, Map<String, ?> paramMap, RowMapper<T> rowMapper)
			throws DataAccessException { return null; }

	@Override
	public <T> T queryForObject(String sql, SqlParameterSource paramSource, RowMapper<T> rowMapper)
			throws DataAccessException { return null; }

	@Override
	public <T> T queryForObject(String sql, Map<String, ?> paramMap, RowMapper<T>rowMapper)
			throws DataAccessException { return null; }

	@Override
	public <T> T queryForObject(String sql, SqlParameterSource paramSource, Class<T> requiredType)
			throws DataAccessException { return null; }

	@Override
	public <T> T queryForObject(String sql, Map<String, ?> paramMap, Class<T> requiredType)
			throws DataAccessException { return null; }

	@Override
	public Map<String, Object> queryForMap(String sql, SqlParameterSource paramSource) throws DataAccessException { return null; }

	@Override
	public Map<String, Object> queryForMap(String sql, Map<String, ?> paramMap) throws DataAccessException { return null; }

	@Override
	public <T> List<T> queryForList(String sql, SqlParameterSource paramSource, Class<T> elementType)
			throws DataAccessException { return null; }

	@Override
	public <T> List<T> queryForList(String sql, Map<String, ?> paramMap, Class<T> elementType)
			throws DataAccessException { return null; }

	@Override
	public List<Map<String, Object>> queryForList(String sql, SqlParameterSource paramSource)
			throws DataAccessException { return null; }

	@Override
	public List<Map<String, Object>> queryForList(String sql, Map<String, ?> paramMap)
			throws DataAccessException { return null; }

	@Override
	public SqlRowSet queryForRowSet(String sql, SqlParameterSource paramSource) throws DataAccessException { return null; }

	@Override
	public SqlRowSet queryForRowSet(String sql, Map<String, ?> paramMap) throws DataAccessException { return null; }

	@Override
	public int update(String sql, SqlParameterSource paramSource) throws DataAccessException { return 0; }

	@Override
	public int update(String sql, Map<String, ?> paramMap) throws DataAccessException { return 0; }

	@Override
	public int update(String sql, SqlParameterSource paramSource, KeyHolder generatedKeyHolder)
			throws DataAccessException { return 0; }

	@Override
	public int update(
			String sql, SqlParameterSource paramSource, KeyHolder generatedKeyHolder, String[] keyColumnNames)
			throws DataAccessException { return 0; }

	@Override
	public int[] batchUpdate(String sql, SqlParameterSource[] batchArgs) { return new int[0]; }

	@Override
	public int[] batchUpdate(String sql, Map<String, ?>[] batchValues) { return new int[0]; }

	public int[] batchUpdate(String sql, SqlParameterSource[] batchArgs, KeyHolder generatedKeyHolder) { return new int[0]; }

	public int[] batchUpdate(String sql, SqlParameterSource[] batchArgs, KeyHolder generatedKeyHolder,
			String[] keyColumnNames) { return new int[0]; }

	protected PreparedStatementCreator getPreparedStatementCreator(String sql, SqlParameterSource paramSource) {
		return null;
	}

	protected ParsedSql getParsedSql(String sql) { return null; }

}
