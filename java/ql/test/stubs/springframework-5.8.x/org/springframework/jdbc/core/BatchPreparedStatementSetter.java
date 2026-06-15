// Generated automatically from org.springframework.jdbc.core.BatchPreparedStatementSetter for testing purposes

package org.springframework.jdbc.core;

import java.sql.PreparedStatement;

public interface BatchPreparedStatementSetter
{
    int getBatchSize();
    void setValues(PreparedStatement p0, int p1);
}
