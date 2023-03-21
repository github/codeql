// Generated automatically from org.jdbi.v3.core.statement.BaseStatement for testing purposes

package org.jdbi.v3.core.statement;

import java.io.Closeable;
import java.sql.SQLException;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.config.Configurable;
import org.jdbi.v3.core.statement.StatementContext;
import org.jdbi.v3.core.statement.StatementCustomizer;

abstract class BaseStatement<This> implements Closeable, org.jdbi.v3.core.config.Configurable<This>
{
    protected BaseStatement() {}
    protected final void cleanUpForException(SQLException p0){}
    public ConfigRegistry getConfig(){ return null; }
    public final Handle getHandle(){ return null; }
    public final StatementContext getContext(){ return null; }
    public final This attachToHandleForCleanup(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public void close(){}
}
