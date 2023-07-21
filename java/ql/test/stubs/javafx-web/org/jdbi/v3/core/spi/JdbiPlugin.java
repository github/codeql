// Generated automatically from org.jdbi.v3.core.spi.JdbiPlugin for testing purposes

package org.jdbi.v3.core.spi;

import java.sql.Connection;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

public interface JdbiPlugin
{
    default Connection customizeConnection(Connection p0){ return null; }
    default Handle customizeHandle(Handle p0){ return null; }
    default void customizeJdbi(Jdbi p0){}
}
