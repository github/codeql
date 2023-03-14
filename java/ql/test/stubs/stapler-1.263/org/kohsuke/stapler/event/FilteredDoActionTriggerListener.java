// Generated automatically from org.kohsuke.stapler.event.FilteredDoActionTriggerListener for testing purposes

package org.kohsuke.stapler.event;

import org.kohsuke.stapler.Function;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

public interface FilteredDoActionTriggerListener
{
    boolean onDoActionTrigger(Function p0, StaplerRequest p1, StaplerResponse p2, Object p3);
    static FilteredDoActionTriggerListener JUST_WARN = null;
}
