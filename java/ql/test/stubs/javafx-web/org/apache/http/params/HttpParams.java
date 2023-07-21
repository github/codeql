// Generated automatically from org.apache.http.params.HttpParams for testing purposes

package org.apache.http.params;


public interface HttpParams
{
    HttpParams copy();
    HttpParams setBooleanParameter(String p0, boolean p1);
    HttpParams setDoubleParameter(String p0, double p1);
    HttpParams setIntParameter(String p0, int p1);
    HttpParams setLongParameter(String p0, long p1);
    HttpParams setParameter(String p0, Object p1);
    Object getParameter(String p0);
    boolean getBooleanParameter(String p0, boolean p1);
    boolean isParameterFalse(String p0);
    boolean isParameterTrue(String p0);
    boolean removeParameter(String p0);
    double getDoubleParameter(String p0, double p1);
    int getIntParameter(String p0, int p1);
    long getLongParameter(String p0, long p1);
}
