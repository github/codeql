// Generated automatically from org.kohsuke.stapler.CrumbIssuer for testing purposes

package org.kohsuke.stapler;

import org.kohsuke.stapler.HttpResponse;
import org.kohsuke.stapler.StaplerRequest;

abstract public class CrumbIssuer
{
    public CrumbIssuer(){}
    public HttpResponse doCrumb(){ return null; }
    public abstract String issueCrumb(StaplerRequest p0);
    public final String issueCrumb(){ return null; }
    public static CrumbIssuer DEFAULT = null;
    public void validateCrumb(StaplerRequest p0, String p1){}
}
