// Generated automatically from org.kohsuke.stapler.DispatchValidator for testing purposes

package org.kohsuke.stapler;

import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

public interface DispatchValidator
{
    Boolean isDispatchAllowed(StaplerRequest p0, StaplerResponse p1);
    default Boolean isDispatchAllowed(StaplerRequest p0, StaplerResponse p1, String p2, Object p3){ return null; }
    default void requireDispatchAllowed(StaplerRequest p0, StaplerResponse p1){}
    static DispatchValidator DEFAULT = null;
    void allowDispatch(StaplerRequest p0, StaplerResponse p1);
}
