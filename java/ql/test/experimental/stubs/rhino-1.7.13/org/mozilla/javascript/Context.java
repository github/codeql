/* -*- Mode: java; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// API class

package org.mozilla.javascript;

import java.io.Closeable;
import java.io.IOException;
import java.io.Reader;
import java.util.Locale;

/**
 * This class represents the runtime context of an executing script.
 *
 * Before executing a script, an instance of Context must be created
 * and associated with the thread that will be executing the script.
 * The Context will be used to store information about the executing
 * of the script such as the call stack. Contexts are associated with
 * the current thread  using the {@link #call(ContextAction)}
 * or {@link #enter()} methods.<p>
 *
 * Different forms of script execution are supported. Scripts may be
 * evaluated from the source directly, or first compiled and then later
 * executed. Interactive execution is also supported.<p>
 *
 * Some aspects of script execution, such as type conversions and
 * object creation, may be accessed directly through methods of
 * Context.
 *
 * @see Scriptable
 * @author Norris Boyd
 * @author Brendan Eich
 */

public class Context
    implements Closeable
{
    /**
     * Creates a new Context. The context will be associated with the {@link
     * ContextFactory#getGlobal() global context factory}.
     *
     * Note that the Context must be associated with a thread before
     * it can be used to execute a script.
     * @deprecated this constructor is deprecated because it creates a
     * dependency on a static singleton context factory. Use
     * {@link ContextFactory#enter()} or
     * {@link ContextFactory#call(ContextAction)} instead. If you subclass
     * this class, consider using {@link #Context(ContextFactory)} constructor
     * instead in the subclasses' constructors.
     */
    @Deprecated
    public Context()
    {
    }

    /**
     * Creates a new context. Provided as a preferred super constructor for
     * subclasses in place of the deprecated default public constructor.
     * @param factory the context factory associated with this context (most
     * likely, the one that created the context). Can not be null. The context
     * features are inherited from the factory, and the context will also
     * otherwise use its factory's services.
     * @throws IllegalArgumentException if factory parameter is null.
     */
    protected Context(ContextFactory factory)
    {
    }

    /**
     * Get the current Context.
     *
     * The current Context is per-thread; this method looks up
     * the Context associated with the current thread. <p>
     *
     * @return the Context associated with the current thread, or
     *         null if no context is associated with the current
     *         thread.
     * @see ContextFactory#enterContext()
     * @see ContextFactory#call(ContextAction)
     */
    public static Context getCurrentContext()
    {
        return null;
    }

    /**
     * Same as calling {@link ContextFactory#enterContext()} on the global
     * ContextFactory instance.
     * @return a Context associated with the current thread
     * @see #getCurrentContext()
     * @see #exit()
     * @see #call(ContextAction)
     */
    public static Context enter()
    {
        return null;
    }

    /**
     * Get a Context associated with the current thread, using
     * the given Context if need be.
     * <p>
     * The same as <code>enter()</code> except that <code>cx</code>
     * is associated with the current thread and returned if
     * the current thread has no associated context and <code>cx</code>
     * is not associated with any other thread.
     * @param cx a Context to associate with the thread if possible
     * @return a Context associated with the current thread
     * @deprecated use {@link ContextFactory#enterContext(Context)} instead as
     * this method relies on usage of a static singleton "global" ContextFactory.
     * @see ContextFactory#enterContext(Context)
     * @see ContextFactory#call(ContextAction)
     */
    @Deprecated
    public static Context enter(Context cx)
    {
        return null;
    }

    static final Context enter(Context cx, ContextFactory factory)
    {
        return null;
    }

    /**
     * Exit a block of code requiring a Context.
     *
     * Calling <code>exit()</code> will remove the association between
     * the current thread and a Context if the prior call to
     * {@link ContextFactory#enterContext()} on this thread newly associated a
     * Context with this thread. Once the current thread no longer has an
     * associated Context, it cannot be used to execute JavaScript until it is
     * again associated with a Context.
     * @see ContextFactory#enterContext()
     */
    public static void exit()
    {
    }

    @Override
    public void close() {
    }

    /**
     * Return {@link ContextFactory} instance used to create this Context.
     */
    public final ContextFactory getFactory()
    {
        return null;
    }

    /**
     * Checks if this is a sealed Context. A sealed Context instance does not
     * allow to modify any of its properties and will throw an exception
     * on any such attempt.
     * @see #seal(Object sealKey)
     */
    public final boolean isSealed()
    {
        return false;
    }

    /**
     * Seal this Context object so any attempt to modify any of its properties
     * including calling {@link #enter()} and {@link #exit()} methods will
     * throw an exception.
     * <p>
     * If <code>sealKey</code> is not null, calling
     * {@link #unseal(Object sealKey)} with the same key unseals
     * the object. If <code>sealKey</code> is null, unsealing is no longer possible.
     *
     * @see #isSealed()
     * @see #unseal(Object)
     */
    public final void seal(Object sealKey)
    {
    }

    /**
     * Unseal previously sealed Context object.
     * The <code>sealKey</code> argument should not be null and should match
     * <code>sealKey</code> suplied with the last call to
     * {@link #seal(Object)} or an exception will be thrown.
     *
     * @see #isSealed()
     * @see #seal(Object sealKey)
     */
    public final void unseal(Object sealKey)
    {
    }

    /**
     * Get the current language version.
     * <p>
     * The language version number affects JavaScript semantics as detailed
     * in the overview documentation.
     *
     * @return an integer that is one of VERSION_1_0, VERSION_1_1, etc.
     */
    public final int getLanguageVersion()
    {
       return -1;
    }

    /**
     * Set the language version.
     *
     * <p>
     * Setting the language version will affect functions and scripts compiled
     * subsequently. See the overview documentation for version-specific
     * behavior.
     *
     * @param version the version as specified by VERSION_1_0, VERSION_1_1, etc.
     */
    public void setLanguageVersion(int version)
    {
    }

    public static boolean isValidLanguageVersion(int version)
    {
        return false;
    }

    public static void checkLanguageVersion(int version)
    {
    }

    /**
     * Get the implementation version.
     *
     * <p>
     * The implementation version is of the form
     * <pre>
     *    "<i>name langVer</i> <code>release</code> <i>relNum date</i>"
     * </pre>
     * where <i>name</i> is the name of the product, <i>langVer</i> is
     * the language version, <i>relNum</i> is the release number, and
     * <i>date</i> is the release date for that specific
     * release in the form "yyyy mm dd".
     *
     * @return a string that encodes the product, language version, release
     *         number, and date.
     */
    public final String getImplementationVersion() {
        return null;
    }

    /**
     * Initialize the standard objects.
     *
     * Creates instances of the standard objects and their constructors
     * (Object, String, Number, Date, etc.), setting up 'scope' to act
     * as a global object as in ECMA 15.1.<p>
     *
     * This method must be called to initialize a scope before scripts
     * can be evaluated in that scope.<p>
     *
     * This method does not affect the Context it is called upon.
     *
     * @return the initialized scope
     */
    public final ScriptableObject initStandardObjects()
    {
        return null;
    }

    /**
     * Initialize the standard objects, leaving out those that offer access directly
     * to Java classes. This sets up "scope" to have access to all the standard
     * JavaScript classes, but does not create global objects for any top-level
     * Java packages. In addition, the "Packages," "JavaAdapter," and
     * "JavaImporter" classes, and the "getClass" function, are not
     * initialized.
     *
     * The result of this function is a scope that may be safely used in a "sandbox"
     * environment where it is not desirable to give access to Java code from JavaScript.
     *
     * Creates instances of the standard objects and their constructors
     * (Object, String, Number, Date, etc.), setting up 'scope' to act
     * as a global object as in ECMA 15.1.<p>
     *
     * This method must be called to initialize a scope before scripts
     * can be evaluated in that scope.<p>
     *
     * This method does not affect the Context it is called upon.
     *
     * @return the initialized scope
     */
    public final ScriptableObject initSafeStandardObjects()
    {
        return null;
    }

    /**
     * Initialize the standard objects.
     *
     * Creates instances of the standard objects and their constructors
     * (Object, String, Number, Date, etc.), setting up 'scope' to act
     * as a global object as in ECMA 15.1.<p>
     *
     * This method must be called to initialize a scope before scripts
     * can be evaluated in that scope.<p>
     *
     * This method does not affect the Context it is called upon.
     *
     * @param scope the scope to initialize, or null, in which case a new
     *        object will be created to serve as the scope
     * @return the initialized scope. The method returns the value of the scope
     *         argument if it is not null or newly allocated scope object which
     *         is an instance {@link ScriptableObject}.
     */
    public final Scriptable initStandardObjects(ScriptableObject scope)
    {
        return null;
    }

    /**
     * Initialize the standard objects, leaving out those that offer access directly
     * to Java classes. This sets up "scope" to have access to all the standard
     * JavaScript classes, but does not create global objects for any top-level
     * Java packages. In addition, the "Packages," "JavaAdapter," and
     * "JavaImporter" classes, and the "getClass" function, are not
     * initialized.
     *
     * The result of this function is a scope that may be safely used in a "sandbox"
     * environment where it is not desirable to give access to Java code from JavaScript.
     *
     * Creates instances of the standard objects and their constructors
     * (Object, String, Number, Date, etc.), setting up 'scope' to act
     * as a global object as in ECMA 15.1.<p>
     *
     * This method must be called to initialize a scope before scripts
     * can be evaluated in that scope.<p>
     *
     * This method does not affect the Context it is called upon.
     *
     * @param scope the scope to initialize, or null, in which case a new
     *        object will be created to serve as the scope
     * @return the initialized scope. The method returns the value of the scope
     *         argument if it is not null or newly allocated scope object which
     *         is an instance {@link ScriptableObject}.
     */
    public final Scriptable initSafeStandardObjects(ScriptableObject scope)
    {
        return null;
    }

    /**
     * Initialize the standard objects.
     *
     * Creates instances of the standard objects and their constructors
     * (Object, String, Number, Date, etc.), setting up 'scope' to act
     * as a global object as in ECMA 15.1.<p>
     *
     * This method must be called to initialize a scope before scripts
     * can be evaluated in that scope.<p>
     *
     * This method does not affect the Context it is called upon.<p>
     *
     * This form of the method also allows for creating "sealed" standard
     * objects. An object that is sealed cannot have properties added, changed,
     * or removed. This is useful to create a "superglobal" that can be shared
     * among several top-level objects. Note that sealing is not allowed in
     * the current ECMA/ISO language specification, but is likely for
     * the next version.
     *
     * @param scope the scope to initialize, or null, in which case a new
     *        object will be created to serve as the scope
     * @param sealed whether or not to create sealed standard objects that
     *        cannot be modified.
     * @return the initialized scope. The method returns the value of the scope
     *         argument if it is not null or newly allocated scope object.
     * @since 1.4R3
     */
    public ScriptableObject initStandardObjects(ScriptableObject scope,
                                                boolean sealed)
    {
        return null;
    }

    /**
     * Initialize the standard objects, leaving out those that offer access directly
     * to Java classes. This sets up "scope" to have access to all the standard
     * JavaScript classes, but does not create global objects for any top-level
     * Java packages. In addition, the "Packages," "JavaAdapter," and
     * "JavaImporter" classes, and the "getClass" function, are not
     * initialized.
     *
     * The result of this function is a scope that may be safely used in a "sandbox"
     * environment where it is not desirable to give access to Java code from JavaScript.
     *
     * Creates instances of the standard objects and their constructors
     * (Object, String, Number, Date, etc.), setting up 'scope' to act
     * as a global object as in ECMA 15.1.<p>
     *
     * This method must be called to initialize a scope before scripts
     * can be evaluated in that scope.<p>
     *
     * This method does not affect the Context it is called upon.<p>
     *
     * This form of the method also allows for creating "sealed" standard
     * objects. An object that is sealed cannot have properties added, changed,
     * or removed. This is useful to create a "superglobal" that can be shared
     * among several top-level objects. Note that sealing is not allowed in
     * the current ECMA/ISO language specification, but is likely for
     * the next version.
     *
     * @param scope the scope to initialize, or null, in which case a new
     *        object will be created to serve as the scope
     * @param sealed whether or not to create sealed standard objects that
     *        cannot be modified.
     * @return the initialized scope. The method returns the value of the scope
     *         argument if it is not null or newly allocated scope object.
     * @since 1.7.6
     */
    public ScriptableObject initSafeStandardObjects(ScriptableObject scope,
                                                    boolean sealed)
    {
        return null;
    }

    /**
     * Get the singleton object that represents the JavaScript Undefined value.
     */
    public static Object getUndefinedValue()
    {
        return null;
    }

    /**
     * Evaluate a JavaScript source string.
     *
     * The provided source name and line number are used for error messages
     * and for producing debug information.
     *
     * @param scope the scope to execute in
     * @param source the JavaScript source
     * @param sourceName a string describing the source, such as a filename
     * @param lineno the starting line number
     * @param securityDomain an arbitrary object that specifies security
     *        information about the origin or owner of the script. For
     *        implementations that don't care about security, this value
     *        may be null.
     * @return the result of evaluating the string
     * @see org.mozilla.javascript.SecurityController
     */
    public final Object evaluateString(Scriptable scope, String source,
                                       String sourceName, int lineno,
                                       Object securityDomain)
    {
        return null;
    }

    /**
     * Evaluate a reader as JavaScript source.
     *
     * All characters of the reader are consumed.
     *
     * @param scope the scope to execute in
     * @param in the Reader to get JavaScript source from
     * @param sourceName a string describing the source, such as a filename
     * @param lineno the starting line number
     * @param securityDomain an arbitrary object that specifies security
     *        information about the origin or owner of the script. For
     *        implementations that don't care about security, this value
     *        may be null.
     * @return the result of evaluating the source
     *
     * @exception IOException if an IOException was generated by the Reader
     */
    public final Object evaluateReader(Scriptable scope, Reader in,
                                       String sourceName, int lineno,
                                       Object securityDomain)
        throws IOException
    {
        return null;
    }

    /**
     * @deprecated
     * @see #compileReader(Reader in, String sourceName, int lineno, Object securityDomain)
     */
    @Deprecated
    public final Script compileReader(
            Scriptable scope, Reader in, String sourceName, int lineno, Object securityDomain)
            throws IOException {
        return null;
    }

    /**
     * Compiles the source in the given reader.
     *
     * <p>Returns a script that may later be executed. Will consume all the source in the reader.
     *
     * @param in the input reader
     * @param sourceName a string describing the source, such as a filename
     * @param lineno the starting line number for reporting errors
     * @param securityDomain an arbitrary object that specifies security information about the
     *     origin or owner of the script. For implementations that don't care about security, this
     *     value may be null.
     * @return a script that may later be executed
     * @exception IOException if an IOException was generated by the Reader
     * @see org.mozilla.javascript.Script
     */
    public final Script compileReader(
            Reader in, String sourceName, int lineno, Object securityDomain) throws IOException {
        return null;
    }

    /**
     * Compiles the source in the given string.
     *
     * <p>Returns a script that may later be executed.
     *
     * @param source the source string
     * @param sourceName a string describing the source, such as a filename
     * @param lineno the starting line number for reporting errors. Use 0 if the line number is
     *     unknown.
     * @param securityDomain an arbitrary object that specifies security information about the
     *     origin or owner of the script. For implementations that don't care about security, this
     *     value may be null.
     * @return a script that may later be executed
     * @see org.mozilla.javascript.Script
     */
    public final Script compileString(
            String source, String sourceName, int lineno, Object securityDomain) {
        return null;
    }

    /**
     * Compile a JavaScript function.
     *
     * <p>The function source must be a function definition as defined by ECMA (e.g., "function f(a)
     * { return a; }").
     *
     * @param scope the scope to compile relative to
     * @param source the function definition source
     * @param sourceName a string describing the source, such as a filename
     * @param lineno the starting line number
     * @param securityDomain an arbitrary object that specifies security information about the
     *     origin or owner of the script. For implementations that don't care about security, this
     *     value may be null.
     * @return a Function that may later be called
     * @see org.mozilla.javascript.Function
     */
    public final Function compileFunction(
            Scriptable scope, String source, String sourceName, int lineno, Object securityDomain) {
        return null;
    }

    /**
     * Convert the value to a JavaScript boolean value.
     * <p>
     * See ECMA 9.2.
     *
     * @param value a JavaScript value
     * @return the corresponding boolean value converted using
     *         the ECMA rules
     */
    public static boolean toBoolean(Object value)
    {
        return false;
    }

    /**
     * Convert the value to a JavaScript Number value.
     * <p>
     * Returns a Java double for the JavaScript Number.
     * <p>
     * See ECMA 9.3.
     *
     * @param value a JavaScript value
     * @return the corresponding double value converted using
     *         the ECMA rules
     */
    public static double toNumber(Object value)
    {
        return -1;
    }

    /**
     * Convert the value to a JavaScript String value.
     * <p>
     * See ECMA 9.8.
     * <p>
     * @param value a JavaScript value
     * @return the corresponding String value converted using
     *         the ECMA rules
     */
    public static String toString(Object value)
    {
        return null;
    }

    /**
     * Convert the value to an JavaScript object value.
     * <p>
     * Note that a scope must be provided to look up the constructors
     * for Number, Boolean, and String.
     * <p>
     * See ECMA 9.9.
     * <p>
     * Additionally, arbitrary Java objects and classes will be
     * wrapped in a Scriptable object with its Java fields and methods
     * reflected as JavaScript properties of the object.
     *
     * @param value any Java object
     * @param scope global scope containing constructors for Number,
     *              Boolean, and String
     * @return new JavaScript object
     */
    public static Scriptable toObject(Object value, Scriptable scope)
    {
        return null;
    }

    /**
     * Convenient method to convert java value to its closest representation
     * in JavaScript.
     * <p>
     * If value is an instance of String, Number, Boolean, Function or
     * Scriptable, it is returned as it and will be treated as the corresponding
     * JavaScript type of string, number, boolean, function and object.
     * <p>
     * Note that for Number instances during any arithmetic operation in
     * JavaScript the engine will always use the result of
     * <code>Number.doubleValue()</code> resulting in a precision loss if
     * the number can not fit into double.
     * <p>
     * If value is an instance of Character, it will be converted to string of
     * length 1 and its JavaScript type will be string.
     * <p>
     * The rest of values will be wrapped as LiveConnect objects
     * by calling {@link WrapFactory#wrap(Context cx, Scriptable scope,
     * Object obj, Class staticType)} as in:
     * <pre>
     *    Context cx = Context.getCurrentContext();
     *    return cx.getWrapFactory().wrap(cx, scope, value, null);
     * </pre>
     *
     * @param value any Java object
     * @param scope top scope object
     * @return value suitable to pass to any API that takes JavaScript values.
     */
    public static Object javaToJS(Object value, Scriptable scope)
    {
        return null;
    }

    /**
     * Convert a JavaScript value into the desired type.
     * Uses the semantics defined with LiveConnect3 and throws an
     * Illegal argument exception if the conversion cannot be performed.
     * @param value the JavaScript value to convert
     * @param desiredType the Java type to convert to. Primitive Java
     *        types are represented using the TYPE fields in the corresponding
     *        wrapper class in java.lang.
     * @return the converted value
     * @throws EvaluatorException if the conversion cannot be performed
     */
    public static Object jsToJava(Object value, Class<?> desiredType)
    {
        return null;
    }

    /**
     * Set the LiveConnect access filter for this context.
     * <p> {@link ClassShutter} may only be set if it is currently null.
     * Otherwise a SecurityException is thrown.
     * @param shutter a ClassShutter object
     * @throws SecurityException if there is already a ClassShutter
     *         object for this Context
     */
    public synchronized final void setClassShutter(ClassShutter shutter)
    {
    }

    final synchronized ClassShutter getClassShutter()
    {
        return null;
    }

    public interface ClassShutterSetter {
        public void setClassShutter(ClassShutter shutter);
        public ClassShutter getClassShutter();
    }

    public final synchronized ClassShutterSetter getClassShutterSetter() {
        return null;
    }
}
