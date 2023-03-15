// Generated automatically from org.postgresql.Driver for testing purposes

package org.postgresql;

import java.sql.Connection;
import java.sql.DriverPropertyInfo;
import java.sql.SQLFeatureNotSupportedException;
import java.util.Properties;
import java.util.logging.Logger;
import org.postgresql.util.SharedTimer;

public class Driver implements java.sql.Driver
{
    public Connection connect(String p0, Properties p1){ return null; }
    public Driver(){}
    public DriverPropertyInfo[] getPropertyInfo(String p0, Properties p1){ return null; }
    public Logger getParentLogger(){ return null; }
    public boolean acceptsURL(String p0){ return false; }
    public boolean jdbcCompliant(){ return false; }
    public int getMajorVersion(){ return 0; }
    public int getMinorVersion(){ return 0; }
    public static Properties parseURL(String p0, Properties p1){ return null; }
    public static SQLFeatureNotSupportedException notImplemented(Class<? extends Object> p0, String p1){ return null; }
    public static SharedTimer getSharedTimer(){ return null; }
    public static String getVersion(){ return null; }
    public static boolean isRegistered(){ return false; }
    public static void deregister(){}
    public static void register(){}
}
