/*
 * Copyright (c) 2003, PostgreSQL Global Development Group
 * See the LICENSE file in the project root for more information.
 */
package org.postgresql;

import java.util.logging.Logger;
import java.sql.*;

public class Driver implements java.sql.Driver {

    public Connection connect(String url, java.util.Properties info) throws SQLException {
        return null;
    }

    public boolean acceptsURL(String url) throws SQLException {
        return true;
    }

    public DriverPropertyInfo[] getPropertyInfo(String url, java.util.Properties info)
                     throws SQLException {
        return null;
    }

    public int getMajorVersion() {
        return 0;
    }

    public int getMinorVersion() {
        return 0;
    }


    public boolean jdbcCompliant() {
        return true;
    }


    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        return null;
    }
}
