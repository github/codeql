/*
 * Copyright (c) 1997, 2018 Oracle and/or its affiliates. All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0, which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * This Source Code may also be made available under the following Secondary
 * Licenses when the conditions for such availability set forth in the
 * Eclipse Public License v. 2.0 are satisfied: GNU General Public License,
 * version 2 with the GNU Classpath Exception, which is available at
 * https://www.gnu.org/software/classpath/license.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0
 */

package javax.faces.context;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;


/**
 * <p><span class="changed_modified_2_0 changed_modified_2_1 changed_modified_2_2 changed_modified_2_3">
 * This</span> class allows the Faces API to be unaware of the nature of its containing
 * application environment.  In particular, this class allows Jakarta Server Faces based
 * applications to run in either a Jakarta Servlet or a Portlet environment.</p>
 *
 * <p class="changed_modified_2_0">The documentation for this class only
 * specifies the behavior for the <em>Jakarta Servlet</em> implementation of
 * <code>ExternalContext</code>.  The <em>Portlet</em> implementation of
 * <code>ExternalContext</code> is specified under the revision of the
 * <span style="text-decoration: underline;">Portlet Bridge
 * Specification for JavaServer Faces</span> JSR that corresponds to
 * this version of the Jakarta Server Faces specification.  See the Preface of the
 * &quot;prose document&quot;, <a
 * href="../../../overview-summary.html#overview_description">linked
 * from the javadocs</a>, for a reference.</p>

 * <p class="changed_added_2_0">If a reference to an
 * <code>ExternalContext</code> is obtained during application startup or shutdown
 * time, any method documented as "valid to call this method during
 * application startup or shutdown" must be supported during application startup or shutdown
 * time.  The result of calling a method during application startup or shutdown time
 * that does not have this designation is undefined.</p>
 * 
 * <p class="changed_added_2_3">An ExternalContext can be injected into a CDI
 * managed bean using <code>@Inject ExternalContext externalContext;</code>
 * </p>
 */

public abstract class ExternalContext {

    /**
     * <p class="changed_added_2_0"><span class="changed_modified_2_2">Adds</span> the cookie represented by the
     * arguments to the response.</p>
     *
     * <div class="changed_added_2_0">
     *
     * <p><em>Jakarta Servlet:</em> This must be accomplished by calling the
     * <code>javax.servlet.http.HttpServletResponse</code> method
     * <code>addCookie()</code>.  The <code>Cookie</code> argument must
     * be constructed by passing the <code>name</code> and
     * <code>value</code> parameters.  If the <code>properties</code>
     * arugument is non-<code>null</code> and not empty, the
     * <code>Cookie</code> instance must be initialized as described
     * below.</p>
     *
     * <table border="1">
     *  <caption>Cookie handling table</caption>
     *
     * <tr>
     *
     * <th>Key in "values" <code>Map</code></th>
     *
     * <th>Expected type of value.</th>
     *
     * <th>Name of setter method on <code>Cookie</code> instance to be
     * set with the value from the <code>Map</code>.  </th>
     *
     * </tr>
     *
     * <tr>
     *
     * <td>comment</td>
     *
     * <td>String</td>
     *
     * <td>setComment</td>
     *
     * </tr>
     *
     * <tr>
     *
     * <td>domain</td>
     *
     * <td>String</td>
     *
     * <td>setDomain</td>
     *
     * </tr>
     *
     * <tr>
     *
     * <td>maxAge</td>
     *
     * <td>Integer</td>
     *
     * <td>setMaxAge</td>
     *
     * </tr>
     *
     * <tr>
     *
     * <td>secure</td>
     *
     * <td>Boolean</td>
     *
     * <td>setSecure</td>
     *
     * </tr>
     *
     * <tr>
     *
     * <td>path</td>
     *
     * <td>String</td>
     *
     * <td>setPath</td>
     *
     * </tr>
     *
     * <tr class="changed_added_2_2">
     *
     * <td>httpOnly</td>
     *
     * <td>Boolean</td>
     *
     * <td>setHttpOnly</td>
     *
     * </tr>
     *
     * </table>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * </div>
     *
     * @param name To be passed as the first argument to the
     * <code>Cookie</code> constructor.
     *
     * @param value To be passed as the second argument to the
     * <code>Cookie</code> constructor.
     *
     * @param properties A <code>Map</code> containg key/value pairs to be passed
     * as arguments to the setter methods as described above.
     *
     * @throws IllegalArgumentException if the <code>properties
     * Map</code> is not-<code>null</code> and not empty and contains
     * any keys that are not one of the keys listed above.
     *
     * @since 2.0
     */

    public void addResponseCookie(String name,
                                  String value,
                                  Map<String, Object> properties) {
    }


    /**
     * <p><span class="changed_modified_2_2">Dispatch</span> a request to the specified resource to create output
     * for this response.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be accomplished by calling the
     * <code>javax.servlet.ServletContext</code> method
     * <code>getRequestDispatcher(path)</code>, and calling the
     * <code>forward()</code> method on the resulting object.</p>
     * <p class="changed_added_2_2">If the call to <code>getRequestDisatcher(path)</code> 
     * returns <code>null</code>, send a<code>ServletResponse SC_NOT_FOUND</code> 
     * error code.</p>
     *
     * @param path Context relative path to the specified resource,
     *  which must start with a slash ("/") character
     *
     * @throws javax.faces.FacesException thrown if a <code>ServletException</code> occurs
     * @throws IOException if an input/output error occurs
     */
    public abstract void dispatch(String path) throws IOException;


    /**
     * <p><span class="changed_modified_2_2">Return</span> the input URL, after performing any rewriting needed to
     * ensure that it will correctly identify an addressable action in the
     * current application.</p>
     * 
     * <p class="changed_added_2_2">Encoding the {@link javax.faces.lifecycle.ClientWindow}</p>
     *
     * <blockquote>
     * 
     * <p class="changed_added_2_2">Call {@link javax.faces.lifecycle.ClientWindow#isClientWindowRenderModeEnabled(javax.faces.context.FacesContext) }.
     * If the result is <code>false</code> take no further action and return
     * the rewritten URL.  If the result is <code>true</code>, call {@link #getClientWindow()}.
     * If the result is non-<code>null</code>, call {@link javax.faces.lifecycle.ClientWindow#getId()}
     * and append the id to the query string of the URL, making the necessary
     * allowances for a pre-existing query string or no query-string.</p>
     * 
     * <p>Call {@link javax.faces.lifecycle.ClientWindow#getQueryURLParameters}.
     * If the result is non-{@code null}, for each parameter in the map, 
     * unconditionally add that parameter to the URL.</p>
     * 
     * <p>The name
     * of the query string parameter is given by the value of the constant
     * {@link javax.faces.render.ResponseStateManager#CLIENT_WINDOW_URL_PARAM}.</p>
     * 
     * </blockquote>
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.http.HttpServletResponse</code> method
     * <code>encodeURL(url)</code>.</p>
     *
     * @param url The input URL to be encoded
     * 
     * @return the encoded URL.
     *
     * @throws NullPointerException if <code>url</code>
     *  is <code>null</code>
     */
    public abstract String encodeActionURL(String url);


    /**
     * <p>Return the input URL, after performing any rewriting needed to
     * ensure that it will correctly identify an addressable resource in the
     * current application.</p>
     * 
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.http.HttpServletResponse</code> method
     * <code>encodeURL(url)</code>.</p>
     *
     * @param url The input URL to be encoded
     * 
     * @return the encoded resource URL.
     * 
     * @throws NullPointerException if <code>url</code>
     *  is <code>null</code>
     */
    // PENDING(craigmcc) - Currently identical to encodeActionURL()
    public abstract String encodeResourceURL(String url);


    /**
     * <p>
     * Return the websocket URL, after performing any rewriting needed to
     * ensure that it will correctly identify an addressable websocket in the
     * current application.
     * </p>
     * 
     * <p>
     * <em>Jakarta Servlet:</em> This must ensure that the input URL is prefixed 
     * with the correct websocket scheme, domain and port and then
     * encoded by {@link #encodeResourceURL(String)}.
     * </p>
     *
     * @param url The input URL to be encoded.
     * 
     * @return the encoded websocket URL.
     * 
     * @throws NullPointerException if <code>url</code> is <code>null</code>.
     * 
     * @since 2.3
     */
    public abstract String encodeWebsocketURL(String url);


    /**
     * <p class="changed_added_2_0">Returns the MIME type of the
     * specified file or <code>null</code> if the MIME type is not
     * known.  The MIME type is determined by the container.</p>

     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method calls through to the
     * <code>getMimeType()</code> method on the same container
     * context instance (<code>ServletContext</code> or
     * <code>PortletContext</code>) as the one used when calling
     * <code>getMimeType()</code> on the
     * <code>ExternalContext</code> returned by the
     * <code>FacesContext</code> during an actual request.</p>

     * <div class="changed_added_2_0">
 
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletContext</code> method
     * <code>getMimeType()</code>.</p>
     *
     * </div>
     *
     * @param file The file for which the mime type should be obtained.
     *
     * @return the MIME type of the file.
     *
     * @since 2.0
     */
    public String getMimeType(String file) {
        return null;
    }


    /**
     * <p><span class="changed_modified_2_0">Return</span> the
     * application environment object instance for the current
     * appication.</p>

     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this returns the same container context instance
     * (<code>ServletContext</code> or <code>PortletContext</code>) as
     * the one returned when calling <code>getContext()</code> on the
     * <code>ExternalContext</code> returned by the
     * <code>FacesContext</code> during an actual request.</p>

     *
     * <p><em>Jakarta Servlet:</em>  This must be the current application's
     * <code>javax.servlet.ServletContext</code> instance.</p>
     *
     * @return the object of the <code>ServletContext</code>.
     *
     */
    public abstract Object getContext();


    /**
     * 
     * <p class="changed_added_2_2">Return the name of the container
     * context for this application.  </p>
     *
     * <p class="changed_added_2_2"><em>Jakarta Servlet:</em>
     * Return the result of calling
     * <code>getContextPath()</code> on the
     * <code>ServletContext</code> instance for this application.</p>

     * <p>It is valid to call this method during application startup or
     * shutdown.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * @return the context path of this application.
     *
     * @since 2.2
     */

    public String getApplicationContextPath() {
        return null;
    }


    /**
     * <p><span class="changed_modified_2_0">Return</span> the value of
     * the specified application initialization parameter (if any).</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the result of the
     * <code>javax.servlet.ServletContext</code> method
     * <code>getInitParameter(name)</code>.</p>
     *
     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method calls through to the actual container
     * context to return the init parameter value.</p>

     * @param name Name of the requested initialization parameter
     *
     * @throws NullPointerException if <code>name</code>
     *  is <code>null</code>
     *  
     *  @return the value of the specified parameter.
     *  
     */
    public abstract String getInitParameter(String name);


    /**
     * <p><span class="changed_modified_2_0">Return</span> an
     * immutable <code>Map</code> whose keys are the set of application
     * initialization parameter names configured for this application,
     * and whose values are the corresponding parameter values.  The
     * returned <code>Map</code> must implement the entire contract for
     * an unmodifiable map as described in the JavaDocs for
     * <code>java.util.Map</code>.</p>
     *
     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method returns a <code>Map</code> that is backed by
     * the same container context instance (<code>ServletContext</code>
     * or <code>PortletContext</code>) as the one returned by calling
     * <code>getInitParameterMap()</code> on the
     * <code>ExternalContext</code> returned by the
     * <code>FacesContext</code> during an actual request.</p>
     *
     * <p><em>Jakarta Servlet:</em> This result must be as if it were synthesized
     * by calling the <code>javax.servlet.ServletContext</code>
     * method <code>getInitParameterNames</code>, and putting
     * each configured parameter name/value pair into the result.</p>
     *
     * @return the init parameter map for this application.
     *
     */
    public abstract Map<String, String> getInitParameterMap();


    /**
     * <p>Return the login name of the user making the current request
     * if any; otherwise, return <code>null</code>.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.http.HttpServletRequest</code> method
     * <code>getRemoteUser()</code>.</p>
     *
     * @return the user name of the current request.
     *
     */
    public abstract String getRemoteUser();


    /**
     * <p>Return the environment-specific object instance for the current
     * request.</p>
     *
     * <p><em>Jakarta Servlet:</em>  This must be the current request's
     * <code>javax.servlet.http.HttpServletRequest</code> instance.</p>
     *
     * @return the instance of the current request.
     *
     */
    public abstract Object getRequest();


    /**
     * <p>Set the environment-specific request to be returned by
     * subsequent calls to {@link #getRequest}.  This may be used to
     * install a wrapper for the request.</p>
     *
     * <p>The default implementation throws 
     * <code>UnsupportedOperationException</code> and is provided
     * for the sole purpose of not breaking existing applications that extend
     * this class.</p>
     *
     * @param request the request object to be set.
     *
     * @since 1.2
     */
    public void setRequest(Object request) {
    }


    /**
     * <p class="changed_added_2_0">Returns the name of the scheme used
     * to make this request, for example, http, https, or ftp.</p>
     *
     * <div class="changed_added_2_0">
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletRequest</code> method
     * <code>getScheme()</code>.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * </div>
     *
     * @return the name of the scheme.
     *
     * @since 2.0
     */
    public String getRequestScheme() {
        return null;
    }


    /**
     * <p class="changed_added_2_0">Returns the host name of the server
     * to which the request was sent.</p>
     *
     * <div class="changed_added_2_0">
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletRequest</code> method
     * <code>getServerName()</code>.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * </div>
     *
     * @return the host name of the server.
     *
     * @since 2.0
     */
    public String getRequestServerName() {
        return null;
    }


    /**
     * <p class="changed_added_2_0">Returns the port number to which
     * the request was sent.</p>
     *
     * <div class="changed_added_2_0">
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletRequest</code> method
     * <code>getServerPort()</code>.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * </div>
     *
     * @return the port number to which the request was sent.
     *
     * @since 2.0
     */
    public int getRequestServerPort() {
        return -1;
    }


    /**
     * <p class="changed_added_2_0">Returns a String containing the real
     * path for a given virtual path. </p>
     *
     * <p class="changed_added_2_3">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method calls through to the
     * <code>getRealPath()</code> method on the same container
     * context instance (<code>ServletContext</code> or
     * <code>PortletContext</code>) as the one used when calling
     * <code>getRealPath()</code> on the
     * <code>ExternalContext</code> returned by the
     * <code>FacesContext</code> during an actual request.
     * </p>
     * 
     * <div class="changed_added_2_0">
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletContext</code> method
     * <code>getRealPath()</code>.</p>
     *
     * <p>The default implementation throws 
     * <code>UnsupportedOperationException</code> and is provided
     * for the sole purpose of not breaking existing applications that extend
     * this class.</p>
     *
     * </div>
     *
     * @param path The context of the requested initialization parameter
     *
     * @return the real path for the specified virtual path.
     *
     * @since 2.0
     */
    public String getRealPath(String path) {
        return null;
    }


    /**
     * <p>Return the portion of the request URI that identifies the web
     * application context for this request.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.http.HttpServletRequest</code> method
     * <code>getContextPath()</code>.</p>
     *
     * @return the context path for this request.
     */
    public abstract String getRequestContextPath();


    /**
     * <p>Return an immutable <code>Map</code> whose keys are the set of
     * cookie names included in the current request, and whose
     * values (of type <code>javax.servlet.http.Cookie</code>)
     * are the first (or only) cookie for each cookie name
     * returned by the underlying request.  The returned
     * <code>Map</code> must implement the entire contract for an unmodifiable
     * map as described in the JavaDocs for <code>java.util.Map</code>.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.http.HttpServletRequest</code> method
     * <code>getCookies()</code>, unless <code>null</code> was returned,
     * in which case this must be a zero-length array.</p>
     *
     * @return the cookie map in the current request.
     *
     */
    public abstract Map<String, Object> getRequestCookieMap();


    /**
     * <p>Return an immutable <code>Map</code> whose keys are the set of
     * request header names included in the current request, and whose
     * values (of type String) are the first (or only) value for each
     * header name returned by the underlying request.  The returned
     * <code>Map</code> must implement the entire contract for an unmodifiable
     * map as described in the JavaDocs for <code>java.util.Map</code>.  In
     * addition, key comparisons must be performed in a case insensitive
     * manner.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the set of headers available via
     * the <code>javax.servlet.http.HttpServletRequest</code> methods
     * <code>getHeader()</code> and <code>getHeaderNames()</code>.</p>
     *
     * @return the header map in the current request.
     *
     */
    public abstract Map<String, String> getRequestHeaderMap();


    /**
     * <p>Return an immutable <code>Map</code> whose keys are the set of
     * request header names included in the current request, and whose
     * values (of type String[]) are all of the value for each
     * header name returned by the underlying request.  The returned
     * <code>Map</code> must implement the entire contract for an unmodifiable
     * map as described in the JavaDocs for <code>java.util.Map</code>.  In
     * addition, key comparisons must be performed in a case insensitive
     * manner.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the set of headers available via
     * the <code>javax.servlet.http.HttpServletRequest</code> methods
     * <code>getHeaders()</code> and <code>getHeaderNames()</code>.</p>
     *
     * @return the header values map in the current request.
     */
    public abstract Map<String, String []> getRequestHeaderValuesMap();


    /**
     * <p>Return a mutable <code>Map</code> representing the request
     * scope attributes for the current application.  The returned
     * <code>Map</code> must implement the entire contract for a
     * modifiable map as described in the JavaDocs for
     * <code>java.util.Map</code>.  Modifications made in the
     * <code>Map</code> must cause the corresponding changes in the set
     * of request scope attributes.  Particularly the
     * <code>clear()</code>, <code>remove()</code>, <code>put()</code>,
     * <code>putAll()</code>, and <code>get()</code> operations must
     * take the appropriate action on the underlying data structure.</p>
     *
     * <p>For any of the <code>Map</code> methods that cause an element
     * to be removed from the underlying data structure, the following
     * action regarding managed-beans must be taken.  If the element to
     * be removed is a managed-bean, and it has one or more public
     * no-argument void return methods annotated with
     * <code>javax.annotation.PreDestroy</code>, each such method must
     * be called before the element is removed from the underlying data
     * structure.  Elements that are not managed-beans, but do happen to
     * have methods with that annotation must not have those methods
     * called on removal.  Any exception thrown by the
     * <code>PreDestroy</code> annotated methods must by caught and not
     * rethrown.  The exception may be logged.</p>
     *
     * <p><em>Jakarta Servlet:</em>  This must be the set of attributes available via
     * the <code>javax.servlet.ServletRequest</code> methods
     * <code>getAttribute()</code>, <code>getAttributeNames()</code>,
     * <code>removeAttribute()</code>, and <code>setAttribute()</code>.</p>
     *
     * @return the map including the attributes of the current request.
     *
     */
    public abstract Map<String, Object> getRequestMap();


    /**
     * <p>Return an immutable <code>Map</code> whose keys are the set of
     * request parameters names included in the current request, and whose
     * values (of type String) are the first (or only) value for each
     * parameter name returned by the underlying request.  The returned
     * <code>Map</code> must implement the entire contract for an unmodifiable
     * map as described in the JavaDocs for <code>java.util.Map</code>.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the set of parameters available via
     * the <code>javax.servlet.ServletRequest</code> methods
     * <code>getParameter()</code> and <code>getParameterNames()</code>.</p>
     *
     * @return the map for the current request parameters.
     *
     */
    public abstract Map<String, String> getRequestParameterMap();


    /**
     * <p>Return an <code>Iterator</code> over the names of all request
     * parameters included in the current request.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be an <code>Iterator</code> over the
     * values returned by the <code>javax.servlet.ServletRequest</code>
     * method <code>getParameterNames()</code>.</p>
     *
     * @return the <code>Iterator</code> for the names of the current request parameters.
     *
     */
    public abstract Iterator<String> getRequestParameterNames();


    /**
     * <p>Return an immutable <code>Map</code> whose keys are the set of
     * request parameters names included in the current request, and whose
     * values (of type String[]) are all of the values for each
     * parameter name returned by the underlying request.  The returned
     * <code>Map</code> must implement the entire contract for an unmodifiable
     * map as described in the JavaDocs for <code>java.util.Map</code>.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the set of parameters available via
     * the <code>javax.servlet.ServletRequest</code> methods
     * <code>getParameterValues()</code> and
     * <code>getParameterNames()</code>.</p>
     *
     * @return the map for the parameter values of the current request.
     *
     */
    public abstract Map<String, String []> getRequestParameterValuesMap();


    /**
     * <p>Return the extra path information (if any) included in the
     * request URI; otherwise, return <code>null</code>.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.http.HttpServletRequest</code> method
     * <code>getPathInfo()</code>.</p>
     *
     * @return the path information of the current request.
     *
     */
    public abstract String getRequestPathInfo();


    /**
     * <p>Return the Jakarta Servlet path information (if any) included in the
     * request URI; otherwise, return <code>null</code>.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.http.HttpServletRequest</code> method
     * <code>getServletPath()</code>.</p>
     *
     * @return the Jakarta Servlet path information of the current request.
     */
    public abstract String getRequestServletPath();


    /**
     * <p><span class="changed_modified_2_0">Return</span> a
     * <code>URL</code> for the application resource mapped to the
     * specified path, if it exists; otherwise, return
     * <code>null</code>.</p>
     *
     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method calls through to the
     * <code>getResource()</code> method on the same container
     * context instance (<code>ServletContext</code> or
     * <code>PortletContext</code>) as the one used when calling
     * <code>getResource()</code> on the
     * <code>ExternalContext</code> returned by the
     * <code>FacesContext</code> during an actual request.</p>

     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletContext</code> method
     * <code>getResource(path)</code>.</p>
     *
     * @param path The path to the requested resource, which must
     *  start with a slash ("/" character
     *
     * @return the URL of the resource.
     *
     * @throws MalformedURLException if the specified path
     *  is not in the correct form
     * @throws NullPointerException if <code>path</code>
     *  is <code>null</code>
     */
    public abstract URL getResource(String path) throws MalformedURLException;


    /**
     * <p><span class="changed_modified_2_0">Return</span> an
     * <code>InputStream</code> for an application resource mapped to
     * the specified path, if it exists; otherwise, return
     * <code>null</code>.</p>

     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method calls through to the
     * <code>getResourceAsStream()</code> method on the same container
     * context instance (<code>ServletContext</code> or
     * <code>PortletContext</code>) as the one used when calling
     * <code>getResourceAsStream()</code> on the
     * <code>ExternalContext</code> returned by the
     * <code>FacesContext</code> during an actual request.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletContext</code> method
     * <code>getResourceAsStream(path)</code>.</p>
     *
     * @param path The path to the requested resource, which must
     *  start with a slash ("/" character
     *
     * @return the <code>InputStream</code> for the application resource.
     *
     * @throws NullPointerException if <code>path</code>
     *  is <code>null</code>
     */
    public abstract InputStream getResourceAsStream(String path);


    /**
     * <p><span class="changed_modified_2_0">Return</span> the
     * <code>Set</code> of resource paths for all application resources
     * whose resource path starts with the specified argument.</p>
     *
     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method calls through to the
     * <code>getResourcePaths()</code> method on the same container
     * context instance (<code>ServletContext</code> or
     * <code>PortletContext</code>) as the one used when calling
     * <code>getResourcePaths()</code> on the
     * <code>ExternalContext</code> returned by the
     * <code>FacesContext</code> during an actual request.</p>

     * <p><em>Jakarta Servlet:</em> This must be the value returned by the
     * <code>javax.servlet.ServletContext</code> method
     * <code>getResourcePaths(path).</code></p>
     *
     * @param path Partial path used to match resources, which must
     *  start with a slash ("/") character
     *
     * @return the <code>Set</code> of resource paths for the application resources.
     *
     * @throws NullPointerException if <code>path</code>
     *  is <code>null</code>
     */
    public abstract Set<String> getResourcePaths(String path);


    /**
     * <p>Return the environment-specific object instance for the current
     * response.</p>
     *
     * <p><em>Jakarta Servlet:</em>  This is the current request's
     * <code>javax.servlet.http.HttpServletResponse</code> instance.</p>
     *
     * @return the instance of the current <code>javax.servlet.http.HttpServletResponse</code>.
     */
    public abstract Object getResponse();

    /**
     * <p>Set the environment-specific response to be returned by
     * subsequent calls to {@link #getResponse}.  This may be used to
     * install a wrapper for the response.</p>
     *
     * <p>The default implementation throws 
     * <code>UnsupportedOperationException</code> and is provided
     * for the sole purpose of not breaking existing applications that extend
     * this class.</p>
     *
     * @param response the response instance to be set.
     *
     * @since 1.2
     */
    public void setResponse(Object response) {
    }


    /**
     * <p class="changed_added_2_0">Returns an <code>OutputStream</code>
     * suitable for writing binary data to the user-agent.</p>
     *
     * <div class="changed_added_2_0">
     *
     * <p><em>Jakarta Servlet:</em> This must return the value returned by the
     * <code>javax.servlet.ServletResponse</code> method
     * <code>getOutputStream()</code>.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * </div>
     *
     * @return the <code>OutputStream</code> for the current response.
     *
     * @throws IOException any IO related exception.
     *
     * @since 2.0
     */
    public OutputStream getResponseOutputStream() throws IOException {
        return null;
    }


    /**
     * <p class="changed_added_2_0">Returns a <code>Writer</code>
     * suitable for writing character data to the user-agent.</p>
     *
     * <div class="changed_added_2_0">
     *
     * <p><em>Jakarta Servlet:</em> This must return the value returned by the
     * {@link javax.servlet.ServletResponse#getWriter}.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * </div>
     *
     * @return the <code>Writer</code> for the current response.
     * 
     * @throws IOException any IO related exception.
     *
     * @since 2.0
     */
    public Writer getResponseOutputWriter() throws IOException {
        return null;
    }


    /**
     * <p><span class="changed_modified_2_0">Redirect</span> a request 
     * to the specified URL, and cause the
     * <code>responseComplete()</code> method to be called on the
     * {@link FacesContext} instance for the current request.</p>
     *
     * <p class="changed_added_2_0">The implementation must determine if
     * the request is an <code>Ajax</code> request by obtaining a  
     * {@link PartialViewContext} instance from the {@link FacesContext} and
     * calling {@link PartialViewContext#isAjaxRequest()}.</p>
     *
     * <p><em>Jakarta Servlet:</em> <span class="changed_modified_2_0">For
     * non <code>Ajax</code> requests, this must be accomplished by calling 
     * the <code>javax.servlet.http.HttpServletResponse</code> method
     * <code>sendRedirect()</code>.</span> <div class="changed_added_2_0">
     * For Ajax requests, the implementation must:
     * </div>
     * <ul>
     * <li>Get a {@link PartialResponseWriter} instance from the 
     * {@link FacesContext}.</li>
     * <li>Call {@link #setResponseContentType} with <code>text/xml</code></li>
     * <li>Call {@link #setResponseCharacterEncoding} with <code>UTF-8</code></li>
     * <li>Call {@link #addResponseHeader} with <code>Cache-Control</code>, 
     * <code>no-cache</code></li>
     * <li>Call {@link PartialResponseWriter#startDocument}</li>
     * <li>Call {@link PartialResponseWriter#redirect} with the <code>url</code>
     * argument.</li>
     * <li>Call {@link PartialResponseWriter#endDocument}</li>
     * </ul>
     *
     * @param url Absolute URL to which the client should be redirected
     *
     * @throws IllegalArgumentException if the specified url is relative
     * @throws IllegalStateException if, in a portlet environment,
     *  the current response object is a <code>RenderResponse</code>
     *  instead of an <code>ActionResponse</code>
     * @throws IllegalStateException if, in a Jakarta Servlet environment,
     *  the current response has already been committed
     * @throws IOException if an input/output error occurs
     */
    public abstract void redirect(String url) throws IOException;


    /**
     * <p class="changed_added_2_0">Set the response header with the given name and value.</p>
     *
     * <p><em>Jakarta Servlet:</em>This must be performed by calling the 
     * <code>javax.servlet.http.HttpServletResponse</code> <code>setHeader</code>
     * method.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * @param name The name of the response header.
     * @param value The value of the response header.
     *
     * @since 2.0
     */
    public void setResponseHeader(String name, String value) {
    }

    /**
     * <p class="changed_added_2_0">Add the given name and value to the response header.</p>
     *
     * <p><em>Jakarta Servlet:</em>This must be performed by calling the 
     * <code>javax.servlet.http.HttpServletResponse</code> <code>addHeader</code>
     * method.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * @param name The name of the response header.
     * @param value The value of the response header.
     *
     * @since 2.0
     */
    public void addResponseHeader(String name, String value) {
    }


     /**
     * <p class="changed_added_2_0">Sets the HTTP status code for the response.</p>
     *
     * <p><em>Jakarta Servlet:</em> This must be performed by calling the
     * <code>javax.servlet.http.HttpServletResponse</code> <code>setStatus</code>
     * method.</p>
     *
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided for
     * the sole purpose of not breaking existing applications that
     * extend this class.</p>
     *
     * @param statusCode an HTTP status code
     *
     * @since 2.0
     */
    public void setResponseStatus(int statusCode) {
    }


    /**
     * <span class="changed_modified_2_2">The</span> purpose of this method is to generate a query string from the collection of Parameter
     * objects provided by the parameters argument and append that query string to the baseUrl.
     * This method must be able to encode the parameters to a baseUrl that may or may not have existing query parameters. The parameter values should be encoded appropriately for the
     * environment so that the resulting URL can be used as the target of a redirect. It's
     * possible for an ExternalContext implementation to override this method to accomodate the
     * definition of redirect for that environment.
     * 
     * <p class="changed_added_2_2">See {@link #encodeActionURL(java.lang.String)} 
     * for the required specification of how to encode the {@link javax.faces.lifecycle.ClientWindow}.
     * </p>
     *
     * @param baseUrl    The base URL onto which the query string generated by this method will be appended. The URL may contain query parameters.
     * @param parameters The collection of Parameter objects, representing name=value pairs that are used to produce a query string
     * 
     * @return the result of encoding.
     * @since 2.0
     */
    public String encodeRedirectURL(String baseUrl,
                                    Map<String,List<String>> parameters) {
        return null;
    }
}
