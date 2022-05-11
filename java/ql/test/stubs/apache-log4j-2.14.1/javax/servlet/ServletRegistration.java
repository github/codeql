// Generated automatically from javax.servlet.ServletRegistration for testing purposes

package javax.servlet;

import java.util.Collection;
import java.util.Set;
import javax.servlet.MultipartConfigElement;
import javax.servlet.Registration;
import javax.servlet.ServletSecurityElement;

public interface ServletRegistration extends Registration
{
    Collection<String> getMappings();
    Set<String> addMapping(String... p0);
    String getRunAsRole();
    static public interface Dynamic extends Registration.Dynamic, ServletRegistration
    {
        Set<String> setServletSecurity(ServletSecurityElement p0);
        void setLoadOnStartup(int p0);
        void setMultipartConfig(MultipartConfigElement p0);
        void setRunAsRole(String p0);
    }
}
