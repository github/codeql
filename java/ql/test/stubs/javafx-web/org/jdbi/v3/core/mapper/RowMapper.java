// Generated automatically from org.jdbi.v3.core.mapper.RowMapper for testing purposes

package org.jdbi.v3.core.mapper;

import java.sql.ResultSet;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.statement.StatementContext;

public interface RowMapper<T>
{
    T map(ResultSet p0, StatementContext p1);
    default RowMapper<T> specialize(ResultSet p0, StatementContext p1){ return null; }
    default void init(ConfigRegistry p0){}
}
