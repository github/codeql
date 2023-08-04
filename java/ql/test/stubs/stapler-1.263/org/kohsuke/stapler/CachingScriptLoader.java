// Generated automatically from org.kohsuke.stapler.CachingScriptLoader for testing purposes

package org.kohsuke.stapler;

import java.net.URL;

abstract public class CachingScriptLoader<S, E extends Exception>
{
    protected abstract S loadScript(String p0);
    protected abstract URL getResource(String p0);
    public CachingScriptLoader(){}
    public S findScript(String p0){ return null; }
    public void clearScripts(){}
}
