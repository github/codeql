package org.apache.velocity.context;

public interface Context {
    public Object put(String key, Object value);

    public Object internalPut(String key, Object value);
}
