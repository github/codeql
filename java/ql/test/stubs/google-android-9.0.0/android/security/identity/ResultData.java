// Generated automatically from android.security.identity.ResultData for testing purposes

package android.security.identity;

import java.util.Collection;

abstract public class ResultData
{
    public abstract Collection<String> getEntryNames(String p0);
    public abstract Collection<String> getNamespaces();
    public abstract Collection<String> getRetrievedEntryNames(String p0);
    public abstract byte[] getAuthenticatedData();
    public abstract byte[] getEntry(String p0, String p1);
    public abstract byte[] getMessageAuthenticationCode();
    public abstract byte[] getStaticAuthenticationData();
    public abstract int getStatus(String p0, String p1);
    public static int STATUS_NOT_IN_REQUEST_MESSAGE = 0;
    public static int STATUS_NOT_REQUESTED = 0;
    public static int STATUS_NO_ACCESS_CONTROL_PROFILES = 0;
    public static int STATUS_NO_SUCH_ENTRY = 0;
    public static int STATUS_OK = 0;
    public static int STATUS_READER_AUTHENTICATION_FAILED = 0;
    public static int STATUS_USER_AUTHENTICATION_FAILED = 0;
}
