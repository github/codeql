// Generated automatically from org.jdbi.v3.core.result.ResultProducer for testing purposes

package org.jdbi.v3.core.result;

import java.sql.PreparedStatement;
import java.util.function.Supplier;
import org.jdbi.v3.core.statement.StatementContext;

public interface ResultProducer<R>
{
    R produce(Supplier<PreparedStatement> p0, StatementContext p1);
}
