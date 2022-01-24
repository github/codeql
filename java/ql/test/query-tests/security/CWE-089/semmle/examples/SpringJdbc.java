import java.sql.ResultSet;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
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

  public static void test(JdbcTemplate template) {
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
  }

}