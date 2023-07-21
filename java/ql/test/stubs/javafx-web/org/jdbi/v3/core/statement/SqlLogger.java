// Generated automatically from org.jdbi.v3.core.statement.SqlLogger for testing purposes

package org.jdbi.v3.core.statement;

import java.sql.SQLException;
import org.jdbi.v3.core.statement.StatementContext;

public interface SqlLogger
{
    default void logAfterExecution(StatementContext p0){}
    default void logBeforeExecution(StatementContext p0){}
    default void logException(StatementContext p0, SQLException p1){}
    static SqlLogger NOP_SQL_LOGGER = null;
}
