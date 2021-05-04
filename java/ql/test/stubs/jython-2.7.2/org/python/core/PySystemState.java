// Copyright (c) Corporation for National Research Initiatives
package org.python.core;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

/**
 * The "sys" module.
 */
// xxx Many have lamented, this should really be a module!
// but it will require some refactoring to see this wish come true.
public class PySystemState extends PyObject {
    public PySystemState() {
    }

    public static void classDictInit(PyObject dict) {
    }

    public ClassLoader getSyspathJavaLoader() {
        return null;
    }

    // xxx fix this accessors
    public PyObject __findattr_ex__(String name) {
        return null;
    }

    public void __setattr__(String name, PyObject value) {
    }

    public void __delattr__(String name) {
    }

    public PyObject gettrace() {
        return null;
    }

    public void settrace(PyObject tracefunc) {
    }

    /**
     * Change the current working directory to the specified path.
     *
     * path is assumed to be absolute and canonical (via os.path.realpath).
     *
     * @param path a path String
     */
    public void setCurrentWorkingDir(String path) {
    }

    /**
     * Return a string representing the current working directory.
     *
     * @return a path String
     */
    public String getCurrentWorkingDir() {
        return null;
    }

    /**
     * Resolve a path. Returns the full path taking the current working directory into account.
     *
     * @param path a path String
     * @return a resolved path String
     */
    public String getPath(String path) {
        return null;
    }

    /**
     * Resolve a path, returning a {@link File}, taking the current working directory into account.
     *
     * @param path a path <code>String</code>
     * @return a resolved <code>File</code>
     */
    public File getFile(String path) {
        return null;
    }

    public ClassLoader getClassLoader() {
        return null;
    }

    public void setClassLoader(ClassLoader classLoader) {
    }

    public static Properties getBaseProperties() {
        return null;
    }

    public static synchronized void initialize() {
    }

    public static synchronized void initialize(Properties preProperties,
            Properties postProperties) {
    }

    public static synchronized void initialize(Properties preProperties, Properties postProperties,
            String[] argv) {
    }

    public static synchronized void initialize(Properties preProperties, Properties postProperties,
            String[] argv, ClassLoader classLoader) {
    }

    /**
     * Add a classpath directory to the list of places that are searched for java packages.
     * <p>
     * <b>Note</b>. Classes found in directory and sub-directory are not made available to jython by
     * this call. It only makes the java package found in the directory available. This call is
     * mostly useful if jython is embedded in an application that deals with its own class loaders.
     * A servlet container is a very good example. Calling
     * {@code add_classdir("<context>/WEB-INF/classes")} makes the java packages in WEB-INF classes
     * available to jython import. However the actual class loading is completely handled by the
     * servlet container's context classloader.
     */
    public static void add_classdir(String directoryPath) {
    }

    /**
     * Add a .jar and .zip directory to the list of places that are searched for java .jar and .zip
     * files. The .jar and .zip files found will not be cached.
     * <p>
     * <b>Note</b>. Classes in .jar and .zip files found in the directory are not made available to
     * jython by this call. See the note for add_classdir(dir) for more details.
     *
     * @param directoryPath The name of a directory.
     *
     * @see #add_classdir
     */
    public static void add_extdir(String directoryPath) {
    }

    /**
     * Add a .jar and .zip directory to the list of places that are searched for java .jar and .zip
     * files.
     * <p>
     * <b>Note</b>. Classes in .jar and .zip files found in the directory are not made available to
     * jython by this call. See the note for add_classdir(dir) for more details.
     *
     * @param directoryPath The name of a directory.
     * @param cache Controls if the packages in the zip and jar file should be cached.
     *
     * @see #add_classdir
     */
    public static void add_extdir(String directoryPath, boolean cache) {
    }

    // Not public by design. We can't rebind the displayhook if
    // a reflected function is inserted in the class dict.

    /**
     * Exit a Python program with the given status.
     *
     * @param status the value to exit with
     * @throws PyException {@code SystemExit} always throws this exception. When caught at top level
     *             the program will exit.
     */
    public static void exit(PyObject status) {
    }

    /**
     * Exit a Python program with the status 0.
     */
    public static void exit() {
    }

    public static void exc_clear() {
    }

    public void cleanup() {
    }

    public void close() {
    }
}
