// Generated automatically from javax.ws.rs.core.Configuration for testing purposes

package javax.ws.rs.core;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import javax.ws.rs.RuntimeType;
import javax.ws.rs.core.Feature;

public interface Configuration
{
    Collection<String> getPropertyNames();
    Map<Class<? extends Object>, Integer> getContracts(Class<? extends Object> p0);
    Map<String, Object> getProperties();
    Object getProperty(String p0);
    RuntimeType getRuntimeType();
    Set<Class<? extends Object>> getClasses();
    Set<Object> getInstances();
    boolean isEnabled(Feature p0);
    boolean isEnabled(java.lang.Class<? extends Feature> p0);
    boolean isRegistered(Class<? extends Object> p0);
    boolean isRegistered(Object p0);
}
