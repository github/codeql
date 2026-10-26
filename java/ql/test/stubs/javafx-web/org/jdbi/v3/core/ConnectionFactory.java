// Generated automatically from org.jdbi.v3.core.ConnectionFactory for testing purposes

package org.jdbi.v3.core;

import java.sql.Connection;
import org.jdbi.v3.core.statement.Cleanable;

public interface ConnectionFactory
{
    Connection openConnection();
    default Cleanable getCleanableFor(Connection p0){ return null; }
    default void closeConnection(Connection p0){}
}
