package org.apache.velocity.context;

import org.apache.velocity.context.Context;
import java.io.Writer;

public class AbstractContext implements Context {
    public Object put(String key, Object value) {
        return null;
    }

    public Object internalPut(String key, Object value) {
        return null;
    }
}
