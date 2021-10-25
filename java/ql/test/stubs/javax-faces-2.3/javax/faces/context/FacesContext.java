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


import java.util.Iterator;
import java.util.Map;

/**
 * <p><strong class="changed_modified_2_0 changed_modified_2_1
 * changed_modified_2_2">FacesContext</strong> contains all of the
 * per-request state information related to the processing of a single
 * Jakarta Server Faces request, and the rendering of the corresponding
 * response.  It is passed to, and potentially modified by, each phase
 * of the request processing lifecycle.</p>
 *
 * <p>A {@link FacesContext} instance is associated with a particular
 * request at the beginning of request processing, by a call to the
 * <code>getFacesContext()</code> method of the {@link FacesContextFactory}
 * instance associated with the current web application.  The instance
 * remains active until its <code>release()</code> method is called, after
 * which no further references to this instance are allowed.  While a
 * {@link FacesContext} instance is active, it must not be referenced
 * from any thread other than the one upon which the Jakarta Servlet container
 * executing this web application utilizes for the processing of this request.
 * </p>
 * 
 * <p class="changed_added_2_3">A FacesContext can be injected into a request
 * scoped bean using <code>@Inject FacesContext facesContext;</code>
 * </p>
 */

public abstract class FacesContext {

    public FacesContext() {
    }

    /**
     * <p class="changed_added_2_0">Return a mutable <code>Map</code> 
     * representing the attributes associated wth this
     * <code>FacesContext</code> instance.  This <code>Map</code> is 
     * useful to store attributes that you want to go out of scope when the
     * Faces lifecycle for the current request ends, which is not always the same 
     * as the request ending, especially in the case of Jakarta Servlet filters
     * that are invoked <strong>after</strong> the Faces lifecycle for this
     * request completes.  Accessing this <code>Map</code> does not cause any 
     * events to fire, as is the case with the other maps: for request, session, and 
     * application scope.  When {@link #release()} is invoked, the attributes
     * must be cleared.</p>
     * 
     * <div class="changed_added_2_0">
     * 
     * <p>The <code>Map</code> returned by this method is not associated with
     * the request.  If you would like to get or set request attributes,
     * see {@link ExternalContext#getRequestMap}.  
     * 
     * <p>The default implementation throws
     * <code>UnsupportedOperationException</code> and is provided
     * for the sole purpose of not breaking existing applications that extend
     * this class.</p>
     *
     * </div>
     * 
     * @return mutable <code>Map</code> representing the attributes associated wth this
     *               <code>FacesContext</code> instance. 
     * 
     * @throws IllegalStateException if this method is called after
     *  this instance has been released
     *
     * @since 2.0
     */

    public Map<Object, Object> getAttributes() {
        return null;
    }

    /**
     * <p>Return an <code>Iterator</code> over the client identifiers for
     * which at least one {@link javax.faces.application.FacesMessage} has been queued.  If there are no
     * such client identifiers, an empty <code>Iterator</code> is returned.
     * If any messages have been queued that were not associated with any
     * specific client identifier, a <code>null</code> value will be included
     * in the iterated values.  The elements in the <code>Iterator</code> must
     * be returned in the order in which they were added with {@link #addMessage}.</p>
     *
     * @return the <code>Iterator</code> over the client identifiers for
     *        which at least one {@link javax.faces.application.FacesMessage} has been queued.
     *
     * @throws IllegalStateException if this method is called after
     *  this instance has been released
     */
    public abstract Iterator<String> getClientIdsWithMessages();

    /**
     * <p><span class="changed_modified_2_0">Return</span> the {@link
     * ExternalContext} instance for this <code>FacesContext</code>
     * instance.</p>

     * <p class="changed_added_2_0">It is valid to call this method
     * during application startup or shutdown.  If called during application
     * startup or shutdown, this method returns an {@link ExternalContext} instance
     * with the special behaviors indicated in the javadoc for that
     * class.  Methods document as being valid to call during
     * application startup or shutdown must be supported.</p>
     * 
     * @return instance of <code>ExternalContext</code>
     * 
     * @throws IllegalStateException if this method is called after
     *  this instance has been released
     */
    public abstract ExternalContext getExternalContext();

    /**
     * <p>Return the {@link ResponseStream} to which components should
     * direct their binary output.  Within a given response, components
     * can use either the ResponseStream or the ResponseWriter,
     * but not both.
     *
     * @return <code>ResponseStream</code> instance.
     *
     * @throws IllegalStateException if this method is called after
     *  this instance has been released
     */
    public abstract ResponseStream getResponseStream();

    /**
     * <p>Set the {@link ResponseStream} to which components should
     * direct their binary output.
     *
     * @param responseStream The new ResponseStream for this response
     *
     * @throws NullPointerException if <code>responseStream</code>
     *  is <code>null</code>
     *
     * @throws IllegalStateException if this method is called after
     *  this instance has been released
     */
    public abstract void setResponseStream(ResponseStream responseStream);

    /**
     * <p>Return the {@link ResponseWriter} to which components should
     * direct their character-based output.  Within a given response,
     * components can use either the ResponseStream or the ResponseWriter,
     * but not both.</p>
     *
     * @return <code>ResponseWriter</code> instance.
     *
     * @throws IllegalStateException if this method is called after
     *  this instance has been released
     */
    public abstract ResponseWriter getResponseWriter();

    /**
     * <p>Set the {@link ResponseWriter} to which components should
     * direct their character-based output.
     *
     * @param responseWriter The new ResponseWriter for this response
     *
     * @throws IllegalStateException if this method is called after
     *  this instance has been released
     * @throws NullPointerException if <code>responseWriter</code>
     *  is <code>null</code>
     */
    public abstract void setResponseWriter(ResponseWriter responseWriter);

    /**
     * <p class="changed_modified_2_0">Return the {@link FacesContext}
     * instance for the request that is being processed by the current
     * thread.  If called during application initialization or shutdown,
     * any method documented as "valid to call this method during
     * application startup or shutdown" must be supported during
     * application startup or shutdown time.  The result of calling a
     * method during application startup or shutdown time that does not
     * have this designation is undefined.</p>
     * 
     * @return the instance of <code>FacesContext</code>.
     */
    public static FacesContext getCurrentInstance() {
        return null;
    }
}
