package org.apache.velocity.runtime.resource.util;

public interface StringResourceRepository {
    public void putStringResource(String name, String body);

    public void putStringResource(String name, String body, String encoding);
}
