// Generated automatically from org.kohsuke.stapler.AbstractTearOff for testing purposes

package org.kohsuke.stapler;

import java.net.URL;
import org.kohsuke.stapler.CachingScriptLoader;
import org.kohsuke.stapler.MetaClass;
import org.kohsuke.stapler.WebApp;

abstract public class AbstractTearOff<CLT, S, E extends Exception> extends CachingScriptLoader<S, E>
{
    protected AbstractTearOff() {}
    protected AbstractTearOff(MetaClass p0, Class<CLT> p1){}
    protected URL getResource(String p0){ return null; }
    protected abstract S parseScript(URL p0);
    protected abstract String getDefaultScriptExtension();
    protected boolean hasAllowedExtension(String p0){ return false; }
    protected final CLT classLoader = null;
    protected final MetaClass owner = null;
    protected final S loadScript(String p0){ return null; }
    protected final WebApp getWebApp(){ return null; }
    public S resolveScript(String p0){ return null; }
}
