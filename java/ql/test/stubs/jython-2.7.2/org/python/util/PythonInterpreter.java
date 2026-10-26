package org.python.util;

import java.io.Closeable;
import java.io.Reader;
import java.io.StringReader;
import java.util.Properties;

import org.python.core.PyCode;
import org.python.core.PyObject;

/**
 * The PythonInterpreter class is a standard wrapper for a Jython interpreter for embedding in a
 * Java application.
 */
public class PythonInterpreter implements Closeable {

    /**
     * Initializes the Jython runtime. This should only be called once, before any other Python
     * objects (including PythonInterpreter) are created.
     *
     * @param preProperties A set of properties. Typically System.getProperties() is used.
     *            preProperties override properties from the registry file.
     * @param postProperties Another set of properties. Values like python.home, python.path and all
     *            other values from the registry files can be added to this property set.
     *            postProperties override system properties and registry properties.
     * @param argv Command line arguments, assigned to sys.argv.
     */
    public static void
            initialize(Properties preProperties, Properties postProperties, String[] argv) {
    }

    /**
     * Creates a new interpreter with an empty local namespace.
     */
    public PythonInterpreter() {
    }

    /**
     * Creates a new interpreter with the ability to maintain a separate local namespace for each
     * thread (set by invoking setLocals()).
     *
     * @param dict a Python mapping object (e.g., a dictionary) for use as the default namespace
     */
    public static PythonInterpreter threadLocalStateInterpreter(PyObject dict) {
        return null;
    }

    /**
     * Creates a new interpreter with a specified local namespace.
     *
     * @param dict a Python mapping object (e.g., a dictionary) for use as the namespace
     */
    public PythonInterpreter(PyObject dict) {
    }

    /**
     * Sets a Python object to use for the standard output stream, <code>sys.stdout</code>. This
     * stream is used in a byte-oriented way (mostly) that depends on the type of file-like object.
     * The behaviour as implemented is:
     * <table border=1>
     * <caption>Stream behaviour for various object types</caption>
     * <tr align=center>
     * <td></td>
     * <td colspan=3>Python type of object <code>o</code> written</td>
     * </tr>
     * <tr align=left>
     * <th></th>
     * <th><code>str/bytes</code></th>
     * <th><code>unicode</code></th>
     * <th>Any other type</th>
     * </tr>
     * <tr align=left>
     * <th>{@link PyFile}</th>
     * <td>as bytes directly</td>
     * <td>respect {@link PyFile#encoding}</td>
     * <td>call <code>str(o)</code> first</td>
     * </tr>
     * <tr align=left>
     * <th>{@link PyFileWriter}</th>
     * <td>each byte value as a <code>char</code></td>
     * <td>write as Java <code>char</code>s</td>
     * <td>call <code>o.toString()</code> first</td>
     * </tr>
     * <tr align=left>
     * <th>Other {@link PyObject} <code>f</code></th>
     * <td>invoke <code>f.write(str(o))</code></td>
     * <td>invoke <code>f.write(o)</code></td>
     * <td>invoke <code>f.write(str(o))</code></td>
     * </tr>
     * </table>
     *
     * @param outStream Python file-like object to use as the output stream
     */
    public void setOut(PyObject outStream) {
    }

    /**
     * Sets a {@link java.io.Writer} to use for the standard output stream, <code>sys.stdout</code>.
     * The behaviour as implemented is to output each object <code>o</code> by calling
     * <code>o.toString()</code> and writing this as UTF-16.
     *
     * @param outStream to use as the output stream
     */
    public void setOut(java.io.Writer outStream) {
    }

    /**
     * Sets a {@link java.io.OutputStream} to use for the standard output stream.
     *
     * @param outStream OutputStream to use as output stream
     */
    public void setOut(java.io.OutputStream outStream) {
    }

    /**
     * Sets a Python object to use for the standard output stream, <code>sys.stderr</code>. This
     * stream is used in a byte-oriented way (mostly) that depends on the type of file-like object,
     * in the same way as {@link #setOut(PyObject)}.
     *
     * @param outStream Python file-like object to use as the error output stream
     */
    public void setErr(PyObject outStream) {
    }

    /**
     * Sets a {@link java.io.Writer} to use for the standard output stream, <code>sys.stdout</code>.
     * The behaviour as implemented is to output each object <code>o</code> by calling
     * <code>o.toString()</code> and writing this as UTF-16.
     *
     * @param outStream to use as the error output stream
     */
    public void setErr(java.io.Writer outStream) {
    }

    public void setErr(java.io.OutputStream outStream) {
    }

    /**
     * Evaluates a string as a Python expression and returns the result.
     */
    public PyObject eval(String s) {
        return null;
    }

    /**
     * Evaluates a Python code object and returns the result.
     */
    public PyObject eval(PyObject code) {
        return null;
    }

    /**
     * Executes a string of Python source in the local namespace.
     *
     * In some environments, such as Windows, Unicode characters in the script will be converted
     * into ascii question marks (?). This can be avoided by first compiling the fragment using
     * PythonInterpreter.compile(), and using the overridden form of this method which takes a
     * PyCode object. Code page declarations are not supported.
     */
    public void exec(String s) {
    }

    /**
     * Executes a Python code object in the local namespace.
     */
    public void exec(PyObject code) {
    }

    /**
     * Executes a file of Python source in the local namespace.
     */
    public void execfile(String filename) {
    }

    public void execfile(java.io.InputStream s) {
    }

    public void execfile(java.io.InputStream s, String name) {
    }

    /**
     * Compiles a string of Python source as either an expression (if possible) or a module.
     *
     * Designed for use by a JSR 223 implementation: "the Scripting API does not distinguish between
     * scripts which return values and those which do not, nor do they make the corresponding
     * distinction between evaluating or executing objects." (SCR.4.2.1)
     */
    public PyCode compile(String script) {
        return null;
    }

    public PyCode compile(Reader reader) {
        return null;
    }

    public PyCode compile(String script, String filename) {
        return null;
    }

    public PyCode compile(Reader reader, String filename) {
        return null;
    }

    /**
     * Sets a variable in the local namespace.
     *
     * @param name the name of the variable
     * @param value the object to set the variable to (as converted to an appropriate Python object)
     */
    public void set(String name, Object value) {
    }

    /**
     * Sets a variable in the local namespace.
     *
     * @param name the name of the variable
     * @param value the Python object to set the variable to
     */
    public void set(String name, PyObject value) {
    }

    /**
     * Returns the value of a variable in the local namespace.
     *
     * @param name the name of the variable
     * @return the value of the variable, or null if that name isn't assigned
     */
    public PyObject get(String name) {
        return null;
    }

    /**
     * Returns the value of a variable in the local namespace.
     *
     * The value will be returned as an instance of the given Java class.
     * <code>interp.get("foo", Object.class)</code> will return the most appropriate generic Java
     * object.
     *
     * @param name the name of the variable
     * @param javaclass the class of object to return
     * @return the value of the variable as the given class, or null if that name isn't assigned
     */
    public <T> T get(String name, Class<T> javaclass) {
        return null;
    }

    public void cleanup() {
    }

    public void close() {
    }
}
