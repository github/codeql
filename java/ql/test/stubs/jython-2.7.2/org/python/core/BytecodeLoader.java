// Copyright (c) Corporation for National Research Initiatives
package org.python.core;

import java.util.List;

/**
 * Utility class for loading compiled Python modules and Java classes defined in Python modules.
 */
public class BytecodeLoader {

    /**
     * Turn the Java class file data into a Java class.
     *
     * @param name fully-qualified binary name of the class
     * @param data a class file as a byte array
     * @param referents super-classes and interfaces that the new class will reference.
     */
    @SuppressWarnings("unchecked")
    public static Class<?> makeClass(String name, byte[] data, Class<?>... referents) {
        return null;
    }

    /**
     * Turn the Java class file data into a Java class.
     *
     * @param name the name of the class
     * @param referents super-classes and interfaces that the new class will reference.
     * @param data a class file as a byte array
     */
    public static Class<?> makeClass(String name, List<Class<?>> referents, byte[] data) {
        return null;
    }

    /**
     * Turn the Java class file data for a compiled Python module into a {@code PyCode} object, by
     * constructing an instance of the named class and calling the instance's
     * {@link PyRunnable#getMain()}.
     *
     * @param name fully-qualified binary name of the class
     * @param data a class file as a byte array
     * @param filename to provide to the constructor of the named class
     * @return the {@code PyCode} object produced by the named class' {@code getMain}
     */
    public static PyCode makeCode(String name, byte[] data, String filename) {
        return null;
    }
}
