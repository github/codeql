// Generated automatically from org.springframework.web.context.request.RequestAttributes for testing purposes

package org.springframework.web.context.request;


public interface RequestAttributes
{
    Object getAttribute(String p0, int p1);
    Object getSessionMutex();
    Object resolveReference(String p0);
    String getSessionId();
    String[] getAttributeNames(int p0);
    static String REFERENCE_REQUEST = null;
    static String REFERENCE_SESSION = null;
    static int SCOPE_REQUEST = 0;
    static int SCOPE_SESSION = 0;
    void registerDestructionCallback(String p0, Runnable p1, int p2);
    void removeAttribute(String p0, int p1);
    void setAttribute(String p0, Object p1, int p2);
}
