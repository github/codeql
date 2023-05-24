// Generated automatically from org.springframework.jdbc.core.namedparam.SqlParameterSource for testing purposes

package org.springframework.jdbc.core.namedparam;


public interface SqlParameterSource
{
    Object getValue(String p0);
    boolean hasValue(String p0);
    default String getTypeName(String p0){ return null; }
    default String[] getParameterNames(){ return null; }
    default int getSqlType(String p0){ return 0; }
    static int TYPE_UNKNOWN = 0;
}
