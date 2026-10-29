// Generated automatically from jakarta.ws.rs.core.Configuration for testing purposes

package jakarta.ws.rs.core;

import jakarta.ws.rs.RuntimeType;
import jakarta.ws.rs.core.Feature;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

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
    default boolean hasProperty(String p0){ return false; }
}
