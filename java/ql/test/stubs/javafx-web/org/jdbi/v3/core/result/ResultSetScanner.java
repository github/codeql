// Generated automatically from org.jdbi.v3.core.result.ResultSetScanner for testing purposes

package org.jdbi.v3.core.result;

import java.sql.ResultSet;
import java.util.function.Supplier;
import org.jdbi.v3.core.statement.StatementContext;

public interface ResultSetScanner<T>
{
    T scanResultSet(Supplier<ResultSet> p0, StatementContext p1);
}
