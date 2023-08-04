// Generated automatically from org.kohsuke.stapler.export.ExportInterceptor for testing purposes

package org.kohsuke.stapler.export;

import java.util.logging.Logger;
import org.kohsuke.stapler.export.ExportConfig;
import org.kohsuke.stapler.export.Property;

abstract public class ExportInterceptor
{
    public ExportInterceptor(){}
    public abstract Object getValue(Property p0, Object p1, ExportConfig p2);
    public static ExportInterceptor DEFAULT = null;
    public static Logger LOGGER = null;
    public static Object SKIP = null;
}
