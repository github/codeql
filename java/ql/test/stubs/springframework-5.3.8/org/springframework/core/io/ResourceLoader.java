package org.springframework.core.io;

public interface ResourceLoader {
    Resource getResource(String location);

    ClassLoader getClassLoader();
}
