// Generated automatically from javax.servlet.FilterRegistration for testing purposes

package javax.servlet;

import java.util.Collection;
import java.util.EnumSet;
import javax.servlet.DispatcherType;
import javax.servlet.Registration;

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
