// Generated automatically from org.jdbi.v3.core.result.ResultSetAccumulator for testing purposes

package org.jdbi.v3.core.result;

import java.sql.ResultSet;
import org.jdbi.v3.core.statement.StatementContext;

public interface ResultSetAccumulator<T>
{
    T apply(T p0, ResultSet p1, StatementContext p2);
}
