// Generated automatically from org.apache.sshd.client.simple.SimpleClientConfigurator for testing purposes

package org.apache.sshd.client.simple;


public interface SimpleClientConfigurator
{
    long getAuthenticationTimeout();
    long getConnectTimeout();
    static int DEFAULT_PORT = 0;
    static long DEFAULT_AUTHENTICATION_TIMEOUT = 0;
    static long DEFAULT_CONNECT_TIMEOUT = 0;
    void setAuthenticationTimeout(long p0);
    void setConnectTimeout(long p0);
}
