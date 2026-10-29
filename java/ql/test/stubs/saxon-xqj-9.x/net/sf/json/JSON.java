// Generated automatically from net.sf.json.JSON for testing purposes

package net.sf.json;

import java.io.Serializable;
import java.io.Writer;

public interface JSON extends Serializable
{
    String toString(int p0);
    String toString(int p0, int p1);
    Writer write(Writer p0);
    Writer writeCanonical(Writer p0);
    boolean isArray();
    boolean isEmpty();
    int size();
}
