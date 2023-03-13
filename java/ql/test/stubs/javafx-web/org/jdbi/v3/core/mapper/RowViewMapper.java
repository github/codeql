// Generated automatically from org.jdbi.v3.core.mapper.RowViewMapper for testing purposes

package org.jdbi.v3.core.mapper;

import java.sql.ResultSet;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.result.RowView;
import org.jdbi.v3.core.statement.StatementContext;

public interface RowViewMapper<T> extends org.jdbi.v3.core.mapper.RowMapper<T>
{
    T map(RowView p0);
    default T map(ResultSet p0, StatementContext p1){ return null; }
    default org.jdbi.v3.core.mapper.RowMapper<T> specialize(ResultSet p0, StatementContext p1){ return null; }
}
