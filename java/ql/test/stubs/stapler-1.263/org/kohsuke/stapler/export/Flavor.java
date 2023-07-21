// Generated automatically from org.kohsuke.stapler.export.Flavor for testing purposes

package org.kohsuke.stapler.export;

import java.io.Writer;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.export.DataWriter;
import org.kohsuke.stapler.export.ExportConfig;

public enum Flavor {
    JSON, JSONP, PYTHON, RUBY, XML;

    private Flavor() {}

    public DataWriter createDataWriter(Object p0, StaplerResponse p1) {
        return null;
    }

    public DataWriter createDataWriter(Object p0, Writer p1) {
        return null;
    }

    public DataWriter createDataWriter(Object p0, Writer p1, ExportConfig p2) {
        return null;
    }

    public final String contentType = null;
}
