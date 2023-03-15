// Generated automatically from javax.ws.rs.core.Configurable for testing purposes

package javax.ws.rs.core;

import java.util.Map;
import javax.ws.rs.core.Configuration;

public interface Configurable<C extends Configurable>
{
    C property(String p0, Object p1);
    C register(Class<? extends Object> p0);
    C register(Class<? extends Object> p0, Class<? extends Object>... p1);
    C register(Class<? extends Object> p0, Map<Class<? extends Object>, Integer> p1);
    C register(Class<? extends Object> p0, int p1);
    C register(Object p0);
    C register(Object p0, Class<? extends Object>... p1);
    C register(Object p0, Map<Class<? extends Object>, Integer> p1);
    C register(Object p0, int p1);
    Configuration getConfiguration();
}
