// Generated automatically from org.jdbi.v3.core.statement.TimingCollector for testing purposes

package org.jdbi.v3.core.statement;

import org.jdbi.v3.core.statement.StatementContext;

public interface TimingCollector
{
    static TimingCollector NOP_TIMING_COLLECTOR = null;
    void collect(long p0, StatementContext p1);
}
