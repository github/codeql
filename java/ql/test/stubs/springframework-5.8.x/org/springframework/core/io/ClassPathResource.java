// Stub class from org.springframework.core.io.ClassPathResource for testing purposes
package org.springframework.core.io;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

public class ClassPathResource {
    public ClassPathResource(String path) {
    }

    public ClassPathResource(String path, ClassLoader classLoader) {
    }

    public ClassPathResource(String path, Class<?> clazz) {
    }

    public final String getPath() {
        return null;
    }

    public final ClassLoader getClassLoader() {
        return null;
    }

    public boolean exists() {
        return false;
    }

    public boolean isReadable() {
        return false;
    }

    protected URL resolveURL() {
        return null;
    }

    public InputStream getInputStream() throws IOException {
        return null;
    }

    public URL getURL() throws IOException {
        return null;
    }

    public Resource createRelative(String relativePath) {
        return null;
    }

    public String getFilename() {
        return null;
    }
}
