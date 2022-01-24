/* -*- Mode: java; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// API class

package org.mozilla.javascript;

/**
 * Factory class that Rhino runtime uses to create new {@link Context}
 * instances.  A <code>ContextFactory</code> can also notify listeners
 * about context creation and release.
 * <p>
 * When the Rhino runtime needs to create new {@link Context} instance during
 * execution of {@link Context#enter()} or {@link Context}, it will call
 * {@link #makeContext()} of the current global ContextFactory.
 * See {@link #getGlobal()} and {@link #initGlobal(ContextFactory)}.
 * <p>
 * It is also possible to use explicit ContextFactory instances for Context
 * creation. This is useful to have a set of independent Rhino runtime
 * instances under single JVM. See {@link #call(ContextAction)}.
 * <p>
 * The following example demonstrates Context customization to terminate
 * scripts running more then 10 seconds and to provide better compatibility
 * with JavaScript code using MSIE-specific features.
 * <pre>
 * import org.mozilla.javascript.*;
 *
 * class MyFactory extends ContextFactory
 * {
 *
 *     // Custom {@link Context} to store execution time.
 *     private static class MyContext extends Context
 *     {
 *         long startTime;
 *     }
 *
 *     static {
 *         // Initialize GlobalFactory with custom factory
 *         ContextFactory.initGlobal(new MyFactory());
 *     }
 *
 *     // Override {@link #makeContext()}
 *     protected Context makeContext()
 *     {
 *         MyContext cx = new MyContext();
 *         // Make Rhino runtime to call observeInstructionCount
 *         // each 10000 bytecode instructions
 *         cx.setInstructionObserverThreshold(10000);
 *         return cx;
 *     }
 *
 *     // Override {@link #hasFeature(Context, int)}
 *     public boolean hasFeature(Context cx, int featureIndex)
 *     {
 *         // Turn on maximum compatibility with MSIE scripts
 *         switch (featureIndex) {
 *             case {@link Context#FEATURE_NON_ECMA_GET_YEAR}:
 *                 return true;
 *
 *             case {@link Context#FEATURE_MEMBER_EXPR_AS_FUNCTION_NAME}:
 *                 return true;
 *
 *             case {@link Context#FEATURE_RESERVED_KEYWORD_AS_IDENTIFIER}:
 *                 return true;
 *
 *             case {@link Context#FEATURE_PARENT_PROTO_PROPERTIES}:
 *                 return false;
 *         }
 *         return super.hasFeature(cx, featureIndex);
 *     }
 *
 *     // Override {@link #observeInstructionCount(Context, int)}
 *     protected void observeInstructionCount(Context cx, int instructionCount)
 *     {
 *         MyContext mcx = (MyContext)cx;
 *         long currentTime = System.currentTimeMillis();
 *         if (currentTime - mcx.startTime &gt; 10*1000) {
 *             // More then 10 seconds from Context creation time:
 *             // it is time to stop the script.
 *             // Throw Error instance to ensure that script will never
 *             // get control back through catch or finally.
 *             throw new Error();
 *         }
 *     }
 *
 *     // Override {@link #doTopCall(Callable,
                               Context, Scriptable,
                               Scriptable, Object[])}
 *     protected Object doTopCall(Callable callable,
 *                                Context cx, Scriptable scope,
 *                                Scriptable thisObj, Object[] args)
 *     {
 *         MyContext mcx = (MyContext)cx;
 *         mcx.startTime = System.currentTimeMillis();
 *
 *         return super.doTopCall(callable, cx, scope, thisObj, args);
 *     }
 *
 * }
 * </pre>
 */

public class ContextFactory
{

    /**
     * Listener of {@link Context} creation and release events.
     */
    public interface Listener
    {
        /**
         * Notify about newly created {@link Context} object.
         */
        public void contextCreated(Context cx);

        /**
         * Notify that the specified {@link Context} instance is no longer
         * associated with the current thread.
         */
        public void contextReleased(Context cx);
    }

    /**
     * Get global ContextFactory.
     *
     * @see #hasExplicitGlobal()
     * @see #initGlobal(ContextFactory)
     */
    public static ContextFactory getGlobal()
    {
        return null;
    }

    /**
     * Check if global factory was set.
     * Return true to indicate that {@link #initGlobal(ContextFactory)} was
     * already called and false to indicate that the global factory was not
     * explicitly set.
     *
     * @see #getGlobal()
     * @see #initGlobal(ContextFactory)
     */
    public static boolean hasExplicitGlobal()
    {
        return false;
    }

    /**
     * Set global ContextFactory.
     * The method can only be called once.
     *
     * @see #getGlobal()
     * @see #hasExplicitGlobal()
     */
    public synchronized static void initGlobal(ContextFactory factory)
    {
    }

    public interface GlobalSetter {
        public void setContextFactoryGlobal(ContextFactory factory);
        public ContextFactory getContextFactoryGlobal();
    }

    public synchronized static GlobalSetter getGlobalSetter() {
        return null;
    }

    /**
     * Create new {@link Context} instance to be associated with the current
     * thread.
     * This is a callback method used by Rhino to create {@link Context}
     * instance when it is necessary to associate one with the current
     * execution thread. <code>makeContext()</code> is allowed to call
     * {@link Context#seal(Object)} on the result to prevent
     * {@link Context} changes by hostile scripts or applets.
     */
    protected Context makeContext()
    {
        return null;
    }

    /**
     * Implementation of {@link Context#hasFeature(int featureIndex)}.
     * This can be used to customize {@link Context} without introducing
     * additional subclasses.
     */
    protected boolean hasFeature(Context cx, int featureIndex)
    {
        return false;
    }

    /**
     * Get ClassLoader to use when searching for Java classes.
     * Unless it was explicitly initialized with
     * {@link #initApplicationClassLoader(ClassLoader)} the method returns
     * null to indicate that Thread.getContextClassLoader() should be used.
     */
    public final ClassLoader getApplicationClassLoader()
    {
        return null;
    }

    /**
     * Set explicit class loader to use when searching for Java classes.
     *
     * @see #getApplicationClassLoader()
     */
    public final void initApplicationClassLoader(ClassLoader loader)
    {
    }

    /**
     * Checks if this is a sealed ContextFactory.
     * @see #seal()
     */
    public final boolean isSealed()
    {
        return false;
    }

    /**
     * Seal this ContextFactory so any attempt to modify it like to add or
     * remove its listeners will throw an exception.
     * @see #isSealed()
     */
    public final void seal()
    {
    }

    /**
     * Get a context associated with the current thread, creating one if need
     * be. The Context stores the execution state of the JavaScript engine, so
     * it is required that the context be entered before execution may begin.
     * Once a thread has entered a Context, then getCurrentContext() may be
     * called to find the context that is associated with the current thread.
     * <p>
     * Calling <code>enterContext()</code> will return either the Context
     * currently associated with the thread, or will create a new context and
     * associate it with the current thread. Each call to
     * <code>enterContext()</code> must have a matching call to
     * {@link Context#exit()}.
     * <pre>
     *      Context cx = contextFactory.enterContext();
     *      try {
     *          ...
     *          cx.evaluateString(...);
     *      } finally {
     *          Context.exit();
     *      }
     * </pre>
     * Instead of using <code>enterContext()</code>, <code>exit()</code> pair consider
     * using {@link #call(ContextAction)} which guarantees proper association
     * of Context instances with the current thread.
     * With this method the above example becomes:
     * <pre>
     *      ContextFactory.call(new ContextAction() {
     *          public Object run(Context cx) {
     *              ...
     *              cx.evaluateString(...);
     *              return null;
     *          }
     *      });
     * </pre>
     * @return a Context associated with the current thread
     * @see Context#getCurrentContext()
     * @see Context#exit()
     * @see #call(ContextAction)
     */
    public Context enterContext()
    {
        return null;
    }

    /**
     * @deprecated use {@link #enterContext()} instead
     * @return a Context associated with the current thread
     */
    @Deprecated
    public final Context enter()
    {
        return null;
    }

    /**
     * @deprecated Use {@link Context#exit()} instead.
     */
    @Deprecated
    public final void exit()
    {
    }

    /**
     * Get a Context associated with the current thread, using the given
     * Context if need be.
     * <p>
     * The same as <code>enterContext()</code> except that <code>cx</code>
     * is associated with the current thread and returned if the current thread
     * has no associated context and <code>cx</code> is not associated with any
     * other thread.
     * @param cx a Context to associate with the thread if possible
     * @return a Context associated with the current thread
     * @see #enterContext()
     * @see #call(ContextAction)
     * @throws IllegalStateException if <code>cx</code> is already associated
     * with a different thread
     */
    public final Context enterContext(Context cx)
    {
        return null;
    }
}
