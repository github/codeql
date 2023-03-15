// Generated automatically from org.jdbi.v3.core.mapper.ColumnMapper for testing purposes

package org.jdbi.v3.core.mapper;

import java.sql.ResultSet;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.statement.StatementContext;

public interface ColumnMapper<T>
{
    T map(ResultSet p0, int p1, StatementContext p2);
    default T map(ResultSet p0, String p1, StatementContext p2){ return null; }
    default void init(ConfigRegistry p0){}
    static <U> ColumnMapper<U> getDefaultColumnMapper(){ return null; }
}
