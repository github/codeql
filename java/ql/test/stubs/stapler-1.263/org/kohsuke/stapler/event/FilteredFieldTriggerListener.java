// Generated automatically from org.kohsuke.stapler.event.FilteredFieldTriggerListener for testing purposes

package org.kohsuke.stapler.event;

import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.lang.FieldRef;

public interface FilteredFieldTriggerListener
{
    boolean onFieldTrigger(FieldRef p0, StaplerRequest p1, StaplerResponse p2, Object p3, String p4);
    static FilteredFieldTriggerListener JUST_WARN = null;
}
