// Generated automatically from org.jdbi.v3.core.statement.StatementCustomizer for testing purposes

package org.jdbi.v3.core.statement;

import java.sql.PreparedStatement;
import org.jdbi.v3.core.statement.StatementContext;

public interface StatementCustomizer
{
    default void afterExecution(PreparedStatement p0, StatementContext p1){}
    default void beforeBinding(PreparedStatement p0, StatementContext p1){}
    default void beforeExecution(PreparedStatement p0, StatementContext p1){}
    default void beforeTemplating(PreparedStatement p0, StatementContext p1){}
}
