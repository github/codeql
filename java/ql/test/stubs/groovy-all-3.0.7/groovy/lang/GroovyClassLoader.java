/*
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for additional information regarding
 * copyright ownership. The ASF licenses this file to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a
 * copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
/*
 * @todo multi threaded compiling of the same class but with different roots for compilation... T1
 * compiles A, which uses B, T2 compiles B... mark A and B as parsed and then synchronize
 * compilation. Problems: How to synchronize? How to get error messages?
 *
 */
package groovy.lang;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Enumeration;
import org.codehaus.groovy.ast.ClassNode;
import org.codehaus.groovy.control.CompilationFailedException;
import org.codehaus.groovy.control.CompilerConfiguration;

public class GroovyClassLoader extends URLClassLoader {
    public GroovyClassLoader() {
        super(null);
    }

    public GroovyClassLoader(ClassLoader loader) {
        super(null);
    }

    public GroovyClassLoader(GroovyClassLoader parent) {
        super(null);
    }

    public GroovyClassLoader(ClassLoader parent, CompilerConfiguration config,
            boolean useConfigurationClasspath) {
        super(null);
    }

    public GroovyClassLoader(ClassLoader loader, CompilerConfiguration config) {
        super(null);
    }


    public Class defineClass(ClassNode classNode, String file, String newCodeBase) {
        return null;
    }

    public boolean hasCompatibleConfiguration(CompilerConfiguration config) {
        return false;
    }

    public Class parseClass(File file) throws CompilationFailedException, IOException {
        return null;
    }

    public Class parseClass(final String text, final String fileName)
            throws CompilationFailedException {
        return null;
    }

    public Class parseClass(String text) throws CompilationFailedException {
        return null;
    }

    public synchronized String generateScriptName() {
        return null;
    }

    public Class parseClass(final Reader reader, final String fileName)
            throws CompilationFailedException {
        return null;
    }

    public Class parseClass(final InputStream in, final String fileName)
            throws CompilationFailedException {
        return null;
    }

    public Class parseClass(GroovyCodeSource codeSource) throws CompilationFailedException {
        return null;
    }

    public Class parseClass(final GroovyCodeSource codeSource, boolean shouldCacheSource)
            throws CompilationFailedException {
        return null;
    }

    public static class InnerLoader extends GroovyClassLoader {
        public InnerLoader(GroovyClassLoader delegate) {}

        @Override
        public void addClasspath(String path) {}

        @Override
        public void clearCache() {}

        @Override
        public URL findResource(String name) {
            return null;
        }

        @Override
        public Enumeration<URL> findResources(String name) throws IOException {
            return null;
        }

        @Override
        public Class[] getLoadedClasses() {
            return null;
        }

        @Override
        public URL getResource(String name) {
            return null;
        }

        @Override
        public InputStream getResourceAsStream(String name) {
            return null;
        }

        @Override
        public URL[] getURLs() {
            return null;
        }

        @Override
        public Class loadClass(String name, boolean lookupScriptFiles,
                boolean preferClassOverScript, boolean resolve)
                throws ClassNotFoundException, CompilationFailedException {
            return null;
        }

        @Override
        public Class parseClass(GroovyCodeSource codeSource, boolean shouldCache)
                throws CompilationFailedException {
            return null;
        }

        @Override
        public void addURL(URL url) {}

        @Override
        public Class defineClass(ClassNode classNode, String file, String newCodeBase) {
            return null;
        }

        @Override
        public Class parseClass(File file) throws CompilationFailedException, IOException {
            return null;
        }

        @Override
        public Class parseClass(String text, String fileName) throws CompilationFailedException {
            return null;
        }

        @Override
        public Class parseClass(String text) throws CompilationFailedException {
            return null;
        }

        @Override
        public String generateScriptName() {
            return null;
        }

        @Override
        public Class parseClass(Reader reader, String fileName) throws CompilationFailedException {
            return null;
        }

        @Override
        public Class parseClass(InputStream in, String fileName) throws CompilationFailedException {
            return null;
        }

        @Override
        public Class parseClass(GroovyCodeSource codeSource) throws CompilationFailedException {
            return null;
        }

        @Override
        public Class defineClass(String name, byte[] b) {
            return null;
        }

        @Override
        public Class loadClass(String name, boolean lookupScriptFiles,
                boolean preferClassOverScript)
                throws ClassNotFoundException, CompilationFailedException {
            return null;
        }

        @Override
        public void setShouldRecompile(Boolean mode) {}

        @Override
        public Boolean isShouldRecompile() {
            return null;
        }

        @Override
        public Class<?> loadClass(String name) throws ClassNotFoundException {
            return null;
        }

        @Override
        public Enumeration<URL> getResources(String name) throws IOException {
            return null;
        }

        @Override
        public void setDefaultAssertionStatus(boolean enabled) {}

        @Override
        public void setPackageAssertionStatus(String packageName, boolean enabled) {}

        @Override
        public void setClassAssertionStatus(String className, boolean enabled) {}

        @Override
        public void clearAssertionStatus() {}

        @Override
        public void close() throws IOException {}

        public long getTimeStamp() {
            return 0;
        }

    }

    public Class defineClass(String name, byte[] b) {
        return null;
    }

    public Class loadClass(final String name, boolean lookupScriptFiles,
            boolean preferClassOverScript)
            throws ClassNotFoundException, CompilationFailedException {
        return null;
    }

    public void addURL(URL url) {}

    public void setShouldRecompile(Boolean mode) {}

    public Boolean isShouldRecompile() {
        return null;
    }

    public Class loadClass(final String name, boolean lookupScriptFiles,
            boolean preferClassOverScript, boolean resolve)
            throws ClassNotFoundException, CompilationFailedException {
        return null;
    }

    @Override
    public Class<?> loadClass(String name) throws ClassNotFoundException {
        return null;
    }

    public void addClasspath(final String path) {}

    public Class[] getLoadedClasses() {
        return null;
    }

    public void clearCache() {}

    @Override
    public void close() throws IOException {}

}
