// Generated automatically from net.sf.json.util.JsonEventListener for testing purposes

package net.sf.json.util;

import net.sf.json.JSONException;

public interface JsonEventListener
{
    void onArrayEnd();
    void onArrayStart();
    void onElementAdded(int p0, Object p1);
    void onError(JSONException p0);
    void onObjectEnd();
    void onObjectStart();
    void onPropertySet(String p0, Object p1, boolean p2);
    void onWarning(String p0);
}
