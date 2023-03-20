// Generated automatically from javax.servlet.Registration for testing purposes

package javax.servlet;

import java.util.Map;
import java.util.Set;

public interface Registration
{
    Map<String, String> getInitParameters();
    Set<String> setInitParameters(Map<String, String> p0);
    String getClassName();
    String getInitParameter(String p0);
    String getName();
    boolean setInitParameter(String p0, String p1);
    static public interface Dynamic extends Registration
    {
        void setAsyncSupported(boolean p0);
    }
}
