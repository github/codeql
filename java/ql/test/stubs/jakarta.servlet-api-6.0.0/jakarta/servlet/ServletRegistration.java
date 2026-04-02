// Generated automatically from jakarta.servlet.ServletRegistration for testing purposes

package jakarta.servlet;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.Registration;
import jakarta.servlet.ServletSecurityElement;
import java.util.Collection;
import java.util.Set;

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
