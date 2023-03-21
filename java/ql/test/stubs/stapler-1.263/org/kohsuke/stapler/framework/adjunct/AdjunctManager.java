// Generated automatically from org.kohsuke.stapler.framework.adjunct.AdjunctManager for testing purposes

package org.kohsuke.stapler.framework.adjunct;

import javax.servlet.ServletContext;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.WebApp;
import org.kohsuke.stapler.framework.adjunct.Adjunct;

public class AdjunctManager
{
    protected AdjunctManager() {}
    protected boolean allowResourceToBeServed(String p0){ return false; }
    public Adjunct get(String p0){ return null; }
    public AdjunctManager(ServletContext p0, ClassLoader p1, String p2){}
    public AdjunctManager(ServletContext p0, ClassLoader p1, String p2, long p3){}
    public boolean debug = false;
    public final String rootURL = null;
    public final WebApp webApp = null;
    public static AdjunctManager get(ServletContext p0){ return null; }
    public void doDynamic(StaplerRequest p0, StaplerResponse p1){}
}
