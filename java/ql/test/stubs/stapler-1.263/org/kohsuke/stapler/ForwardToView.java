// Generated automatically from org.kohsuke.stapler.ForwardToView for testing purposes

package org.kohsuke.stapler;

import java.util.Map;
import javax.servlet.RequestDispatcher;
import org.kohsuke.stapler.HttpResponse;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

public class ForwardToView extends RuntimeException implements HttpResponse
{
    protected ForwardToView() {}
    public ForwardToView optional(){ return null; }
    public ForwardToView with(Map<String, ? extends Object> p0){ return null; }
    public ForwardToView with(String p0, Object p1){ return null; }
    public ForwardToView(Class p0, String p1){}
    public ForwardToView(Object p0, String p1){}
    public ForwardToView(RequestDispatcher p0){}
    public void generateResponse(StaplerRequest p0, StaplerResponse p1, Object p2){}
}
