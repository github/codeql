// Generated automatically from org.kohsuke.stapler.event.FilteredDispatchTriggerListener for testing purposes

package org.kohsuke.stapler.event;

import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

public interface FilteredDispatchTriggerListener
{
    boolean onDispatchTrigger(StaplerRequest p0, StaplerResponse p1, Object p2, String p3);
    static FilteredDispatchTriggerListener JUST_WARN = null;
}
