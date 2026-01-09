// Generated automatically from jakarta.servlet.FilterRegistration for testing purposes

package jakarta.servlet;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.Registration;
import java.util.Collection;
import java.util.EnumSet;

public interface FilterRegistration extends Registration
{
    Collection<String> getServletNameMappings();
    Collection<String> getUrlPatternMappings();
    static public interface Dynamic extends FilterRegistration, Registration.Dynamic
    {
    }
    void addMappingForServletNames(EnumSet<DispatcherType> p0, boolean p1, String... p2);
    void addMappingForUrlPatterns(EnumSet<DispatcherType> p0, boolean p1, String... p2);
}
