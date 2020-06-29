/**
 *
 * Copyright 2003-2004 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/*
 * Adapted from the Java Servlet API version 2.4 as available at
 *   http://search.maven.org/remotecontent?filepath=javax/servlet/servlet-api/2.4/servlet-api-2.4-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package javax.servlet;

import java.io.IOException;
import java.util.Enumeration;
import java.util.ResourceBundle;

public abstract class GenericServlet implements Servlet, ServletConfig, java.io.Serializable {
    /**
     *
     * Does nothing. All of the servlet initialization is done by one of the
     * <code>init</code> methods.
     *
     */
    public GenericServlet() {
    }

    /**
     * Called by the servlet container to indicate to a servlet that the servlet is
     * being taken out of service. See {@link Servlet#destroy}.
     *
     * 
     */
    public void destroy() {
    }

    /**
     * Returns a <code>String</code> containing the value of the named
     * initialization parameter, or <code>null</code> if the parameter does not
     * exist. See {@link ServletConfig#getInitParameter}.
     *
     * <p>
     * This method is supplied for convenience. It gets the value of the named
     * parameter from the servlet's <code>ServletConfig</code> object.
     *
     * @param name a <code>String</code> specifying the name of the initialization
     *             parameter
     *
     * @return String a <code>String</code> containing the value of the
     *         initialization parameter
     *
     */
    public String getInitParameter(String name) {
        return null;
    }

    /**
     * Returns the names of the servlet's initialization parameters as an
     * <code>Enumeration</code> of <code>String</code> objects, or an empty
     * <code>Enumeration</code> if the servlet has no initialization parameters. See
     * {@link ServletConfig#getInitParameterNames}.
     *
     * <p>
     * This method is supplied for convenience. It gets the parameter names from the
     * servlet's <code>ServletConfig</code> object.
     *
     *
     * @return Enumeration an enumeration of <code>String</code> objects containing
     *         the names of the servlet's initialization parameters
     */
    public Enumeration<String> getInitParameterNames() {
        return null;
    }

    /**
     * Returns this servlet's {@link ServletConfig} object.
     *
     * @return ServletConfig the <code>ServletConfig</code> object that initialized
     *         this servlet
     */
    public ServletConfig getServletConfig() {
        return null;
    }

    /**
     * Returns a reference to the {@link ServletContext} in which this servlet is
     * running. See {@link ServletConfig#getServletContext}.
     *
     * <p>
     * This method is supplied for convenience. It gets the context from the
     * servlet's <code>ServletConfig</code> object.
     *
     *
     * @return ServletContext the <code>ServletContext</code> object passed to this
     *         servlet by the <code>init</code> method
     */
    public ServletContext getServletContext() {
        return null;
    }

    /**
     * Returns information about the servlet, such as author, version, and
     * copyright. By default, this method returns an empty string. Override this
     * method to have it return a meaningful value. See
     * {@link Servlet#getServletInfo}.
     *
     *
     * @return String information about this servlet, by default an empty string
     */
    public String getServletInfo() {
        return null;
    }

    /**
     * Called by the servlet container to indicate to a servlet that the servlet is
     * being placed into service. See {@link Servlet#init}.
     *
     * <p>
     * This implementation stores the {@link ServletConfig} object it receives from
     * the servlet container for later use. When overriding this form of the method,
     * call <code>super.init(config)</code>.
     *
     * @param config the <code>ServletConfig</code> object that contains
     *               configuration information for this servlet
     *
     * @exception ServletException if an exception occurs that interrupts the
     *                             servlet's normal operation
     * 
     * @see UnavailableException
     */
    public void init(ServletConfig config) throws ServletException {
    }

    /**
     * A convenience method which can be overridden so that there's no need to call
     * <code>super.init(config)</code>.
     *
     * <p>
     * Instead of overriding {@link #init(ServletConfig)}, simply override this
     * method and it will be called by
     * <code>GenericServlet.init(ServletConfig config)</code>. The
     * <code>ServletConfig</code> object can still be retrieved via
     * {@link #getServletConfig}.
     *
     * @exception ServletException if an exception occurs that interrupts the
     *                             servlet's normal operation
     */
    public void init() throws ServletException {
    }

    /**
     * Writes the specified message to a servlet log file, prepended by the
     * servlet's name. See {@link ServletContext#log(String)}.
     *
     * @param msg a <code>String</code> specifying the message to be written to the
     *            log file
     */
    public void log(String msg) {
    }

    /**
     * Writes an explanatory message and a stack trace for a given
     * <code>Throwable</code> exception to the servlet log file, prepended by the
     * servlet's name. See {@link ServletContext#log(String, Throwable)}.
     *
     *
     * @param message a <code>String</code> that describes the error or exception
     *
     * @param t       the <code>java.lang.Throwable</code> error or exception
     */
    public void log(String message, Throwable t) {
    }

    /**
     * Called by the servlet container to allow the servlet to respond to a request.
     * See {@link Servlet#service}.
     * 
     * <p>
     * This method is declared abstract so subclasses, such as
     * <code>HttpServlet</code>, must override it.
     *
     * @param req the <code>ServletRequest</code> object that contains the client's
     *            request
     *
     * @param res the <code>ServletResponse</code> object that will contain the
     *            servlet's response
     *
     * @exception ServletException if an exception occurs that interferes with the
     *                             servlet's normal operation occurred
     *
     * @exception IOException      if an input or output exception occurs
     */

    public abstract void service(ServletRequest req, ServletResponse res) throws ServletException, IOException;

    /**
     * Returns the name of this servlet instance. See
     * {@link ServletConfig#getServletName}.
     *
     * @return the name of this servlet instance
     */
    public String getServletName() {
        return null;
    }
}