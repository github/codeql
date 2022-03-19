// Generated automatically from org.springframework.jndi.JndiTemplate for testing purposes

package org.springframework.jndi;

import java.util.Properties;
import javax.naming.Context;
import org.apache.commons.logging.Log;
import org.springframework.jndi.JndiCallback;

public class JndiTemplate {
    protected Context createInitialContext() {
        return null;
    }

    protected final Log logger = null;

    public <T> T execute(JndiCallback<T> p0) {
        return null;
    }

    public <T> T lookup(String p0, Class<T> p1) {
        return null;
    }

    public Context getContext() {
        return null;
    }

    public JndiTemplate() {}

    public JndiTemplate(Properties p0) {}

    public Object lookup(String p0) {
        return null;
    }

    public Properties getEnvironment() {
        return null;
    }

    public void bind(String p0, Object p1) {}

    public void rebind(String p0, Object p1) {}

    public void releaseContext(Context p0) {}

    public void setEnvironment(Properties p0) {}

    public void unbind(String p0) {}
}
