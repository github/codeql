// Generated automatically from net.sf.json.AbstractJSON for testing purposes

package net.sf.json;

import java.io.Writer;
import java.util.Collection;
import net.sf.json.JSON;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

abstract class AbstractJSON implements JSON {
    class WritingVisitor {
    }

    protected Object _processValue(Object p0, JsonConfig p1) {
        return null;
    }

    protected abstract void write(Writer p0, AbstractJSON.WritingVisitor p1);

    protected static boolean addInstance(Object p0) {
        return false;
    }

    protected static void fireArrayEndEvent(JsonConfig p0) {}

    protected static void fireArrayStartEvent(JsonConfig p0) {}

    protected static void fireElementAddedEvent(int p0, Object p1, JsonConfig p2) {}

    protected static void fireErrorEvent(JSONException p0, JsonConfig p1) {}

    protected static void fireObjectEndEvent(JsonConfig p0) {}

    protected static void fireObjectStartEvent(JsonConfig p0) {}

    protected static void firePropertySetEvent(String p0, Object p1, boolean p2, JsonConfig p3) {}

    protected static void fireWarnEvent(String p0, JsonConfig p1) {}

    protected static void removeInstance(Object p0) {}

    public final Writer write(Writer p0) {
        return null;
    }

    public final Writer writeCanonical(Writer p0) {
        return null;
    }
}
