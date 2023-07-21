// Generated automatically from org.jdbi.v3.core.statement.StatementBuilder for testing purposes

package org.jdbi.v3.core.statement;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import org.jdbi.v3.core.statement.StatementContext;

public interface StatementBuilder
{
    CallableStatement createCall(Connection p0, String p1, StatementContext p2);
    PreparedStatement create(Connection p0, String p1, StatementContext p2);
    Statement create(Connection p0, StatementContext p1);
    default void close(Connection p0){}
    void close(Connection p0, String p1, Statement p2);
}
