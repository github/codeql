// Generated automatically from org.apache.commons.dbutils.ResultSetHandler for testing purposes

package org.apache.commons.dbutils;

import java.sql.ResultSet;
import java.sql.SQLException;

public interface ResultSetHandler<T> {
    T handle(ResultSet resultSet) throws SQLException;
}
