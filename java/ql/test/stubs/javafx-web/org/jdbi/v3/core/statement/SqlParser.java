// Generated automatically from org.jdbi.v3.core.statement.SqlParser for testing purposes

package org.jdbi.v3.core.statement;

import org.jdbi.v3.core.statement.ParsedSql;
import org.jdbi.v3.core.statement.StatementContext;

public interface SqlParser
{
    ParsedSql parse(String p0, StatementContext p1);
    String nameParameter(String p0, StatementContext p1);
}
