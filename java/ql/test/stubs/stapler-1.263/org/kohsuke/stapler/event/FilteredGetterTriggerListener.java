// Generated automatically from org.kohsuke.stapler.event.FilteredGetterTriggerListener for testing purposes

package org.kohsuke.stapler.event;

import org.kohsuke.stapler.Function;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

public interface FilteredGetterTriggerListener
{
    boolean onGetterTrigger(Function p0, StaplerRequest p1, StaplerResponse p2, Object p3, String p4);
    static FilteredGetterTriggerListener JUST_WARN = null;
}
