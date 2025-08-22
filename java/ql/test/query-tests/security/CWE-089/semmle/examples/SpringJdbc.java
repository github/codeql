import java.sql.ResultSet;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcOperations;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.BatchSqlUpdate;
import org.springframework.jdbc.object.MappingSqlQueryWithParameters;
import org.springframework.jdbc.object.SqlFunction;
import org.springframework.jdbc.object.SqlUpdate;
import org.springframework.jdbc.object.UpdatableSqlQuery;

public class SpringJdbc {

  public static String source() { return null; }

  private static class MyUpdatableSqlQuery extends UpdatableSqlQuery<String> {
    public MyUpdatableSqlQuery() {
      super(null, source()); // $ sqlInjection
    }

    protected String updateRow(ResultSet rs, int rowNum, Map<?,?> context) {
      return null;
    }
  }

  public static void test(JdbcTemplate template, NamedParameterJdbcOperations namedParamTemplate) {
    new BatchSqlUpdate(null, source()); // $ sqlInjection
    new SqlFunction(null, source()); // $ sqlInjection
    new SqlUpdate(null, source()); // $ sqlInjection

    (new BatchSqlUpdate()).setSql(source()); // $ sqlInjection

    template.batchUpdate(source()); // $ sqlInjection
    template.batchUpdate(source(), null, 0, null); // $ sqlInjection
    template.execute(source()); // $ sqlInjection
    template.update(source()); // $ sqlInjection
    template.query(source(), (RowMapper)null); // $ sqlInjection
    template.queryForList(source()); // $ sqlInjection
    template.queryForMap(source()); // $ sqlInjection
    template.queryForObject(source(), (Class)null); // $ sqlInjection
    template.queryForRowSet(source()); // $ sqlInjection
    template.queryForStream(source(), (RowMapper)null); // $ sqlInjection

    namedParamTemplate.batchUpdate(source(), (Map<String, ?>[]) null); // $ sqlInjection
    namedParamTemplate.batchUpdate(source(), (SqlParameterSource[]) null); // $ sqlInjection
    namedParamTemplate.execute(source(), (PreparedStatementCallback) null); // $ sqlInjection
    namedParamTemplate.execute(source(), (Map<String, ?>) null, (PreparedStatementCallback) null); // $ sqlInjection
    namedParamTemplate.execute(source(), (SqlParameterSource) null, (PreparedStatementCallback) null); // $ sqlInjection
    namedParamTemplate.query(source(), (Map<String, ?>) null, (ResultSetExtractor) null); // $ sqlInjection
    namedParamTemplate.query(source(), (Map<String, ?>) null, (RowMapper) null); // $ sqlInjection
    namedParamTemplate.query(source(), (Map<String, ?>) null, (RowCallbackHandler) null); // $ sqlInjection
    namedParamTemplate.query(source(), (SqlParameterSource) null, (ResultSetExtractor) null); // $ sqlInjection
    namedParamTemplate.query(source(), (SqlParameterSource) null, (RowMapper) null); // $ sqlInjection
    namedParamTemplate.query(source(), (SqlParameterSource) null, (RowCallbackHandler) null); // $ sqlInjection
    namedParamTemplate.query(source(), (ResultSetExtractor) null); // $ sqlInjection
    namedParamTemplate.query(source(), (RowMapper) null); // $ sqlInjection
    namedParamTemplate.query(source(), (RowCallbackHandler) null); // $ sqlInjection
    namedParamTemplate.queryForList(source(), (Map<String, ?>) null); // $ sqlInjection
    namedParamTemplate.queryForList(source(), (Map<String, ?>) null, (Class) null); // $ sqlInjection
    namedParamTemplate.queryForList(source(), (SqlParameterSource) null); // $ sqlInjection
    namedParamTemplate.queryForList(source(), (SqlParameterSource) null, (Class) null); // $ sqlInjection
    namedParamTemplate.queryForMap(source(), (Map<String, ?>) null); // $ sqlInjection
    namedParamTemplate.queryForMap(source(), (SqlParameterSource) null); // $ sqlInjection
    namedParamTemplate.queryForObject(source(), (Map<String, ?>) null, (Class) null); // $ sqlInjection
    namedParamTemplate.queryForObject(source(), (Map<String, ?>) null, (RowMapper) null); // $ sqlInjection
    namedParamTemplate.queryForObject(source(), (SqlParameterSource) null, (Class) null); // $ sqlInjection
    namedParamTemplate.queryForObject(source(), (SqlParameterSource) null, (RowMapper) null); // $ sqlInjection
    namedParamTemplate.queryForRowSet(source(), (Map<String, ?>) null); // $ sqlInjection
    namedParamTemplate.queryForRowSet(source(), (SqlParameterSource) null); // $ sqlInjection
    namedParamTemplate.queryForStream(source(), (Map<String, ?>) null, (RowMapper) null); // $ sqlInjection
    namedParamTemplate.queryForStream(source(), (SqlParameterSource) null, (RowMapper) null); // $ sqlInjection
    namedParamTemplate.update(source(), (Map<String, ?>) null); // $ sqlInjection
    namedParamTemplate.update(source(), (SqlParameterSource) null); // $ sqlInjection
    namedParamTemplate.update(source(), null, null); // $ sqlInjection
    namedParamTemplate.update(source(), null, null, null); // $ sqlInjection
  }

}