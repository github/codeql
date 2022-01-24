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

package javax.faces.render;


import java.io.IOException;
import java.util.Iterator;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;


/**
 * <p>A <strong class="changed_modified_2_0 changed_modified_2_2">Renderer</strong> converts
 * the internal representation of {@link UIComponent}s into the output
 * stream (or writer) associated with the response we are creating for a
 * particular request.  Each <code>Renderer</code> knows how to render
 * one or more {@link UIComponent} types (or classes), and advertises a
 * set of render-dependent attributes that it recognizes for each
 * supported {@link UIComponent}.</p>
 *
 * <p>Families of {@link Renderer}s are packaged as a {@link RenderKit},
 * and together support the rendering of all of the {@link UIComponent}s
 * in a view associated with a {@link FacesContext}.  Within the set of
 * {@link Renderer}s for a particular {@link RenderKit}, each must be
 * uniquely identified by the <code>rendererType</code> property.</p>
 *
 * <p>Individual {@link Renderer} instances will be instantiated as requested
 * during the rendering process, and will remain in existence for the
 * remainder of the lifetime of a web application.  Because each instance
 * may be invoked from more than one request processing thread simultaneously,
 * they MUST be programmed in a thread-safe manner.</p>
 *
 * <div class="changed_added_2_0">

 * <p>If the {@link javax.faces.event.ListenerFor} annotation is
 * attached to the class definition of a <code>Renderer</code>, that
 * class must also implement {@link
 * javax.faces.event.ComponentSystemEventListener}, and the action
 * pertaining to the processing of <code>ResourceDependency</code> on a
 * <code>Renderer</code> described in {@link
 * javax.faces.event.ListenerFor} must be taken. </p>

 * <p>If the {@link javax.faces.application.ResourceDependency}
 * annotation is attached to the class definition of a
 * <code>Renderer</code>, the action pertaining to the processing of
 * <code>ResourceDependency</code> on a <code>Renderer</code> described
 * in {@link UIComponent#getChildren} must be taken. </p>

 * </div>
 */

public abstract class Renderer {

    /**
     * <p>Decode any new state of the specified {@link UIComponent}
     * from the request contained in the specified {@link FacesContext},
     * and store that state on the {@link UIComponent}.</p>
     *
     * <p>During decoding, events may be enqueued for later processing
     * (by event listeners that have registered an interest), by calling
     * <code>queueEvent()</code> on the associated {@link UIComponent}.
     * </p>
     *
     * @param context {@link FacesContext} for the request we are processing
     * @param component {@link UIComponent} to be decoded.
     *
     * @throws NullPointerException if <code>context</code>
     *  or <code>component</code> is <code>null</code>
     */
    public void decode(FacesContext context, UIComponent component) {
    }


    /**
     * <p>Render the beginning specified {@link UIComponent} to the
     * output stream or writer associated with the response we are creating.
     * If the conversion attempted in a previous call to
     * <code>getConvertedValue()</code> for this component failed, the state
     * information saved during execution
     * of <code>decode()</code> should be used to reproduce the incorrect
     * input.</p>
     *
     * @param context {@link FacesContext} for the request we are processing
     * @param component {@link UIComponent} to be rendered
     *
     * @throws IOException if an input/output error occurs while rendering
     * @throws NullPointerException if <code>context</code>
     *  or <code>component</code> is null
     */
    public void encodeBegin(FacesContext context,
            UIComponent component)
        throws IOException {
    }


    /**
     * <p>Render the child components of this {@link UIComponent}, following
     * the rules described for <code>encodeBegin()</code> to acquire the
     * appropriate value to be rendered.  This method will only be called
     * if the <code>rendersChildren</code> property of this component
     * is <code>true</code>.</p>
     *
     * @param context {@link FacesContext} for the response we are creating
     * @param component {@link UIComponent} whose children are to be rendered
     *
     * @throws IOException if an input/output error occurs while rendering
     * @throws NullPointerException if <code>context</code>
     *  or <code>component</code> is <code>null</code>
     */
    public void encodeChildren(FacesContext context, UIComponent component)
        throws IOException {
    }


    /**
     * <p>Render the ending of the current state of the specified
     * {@link UIComponent}, following the rules described for
     * <code>encodeBegin()</code> to acquire the appropriate value
     * to be rendered.</p>
     *
     * @param context {@link FacesContext} for the response we are creating
     * @param component {@link UIComponent} to be rendered
     *
     * @throws IOException if an input/output error occurs while rendering
     * @throws NullPointerException if <code>context</code>
     *  or <code>component</code> is <code>null</code>
     */
    public void encodeEnd(FacesContext context,
            UIComponent component)
        throws IOException {
    }

    /**
     * <p>Convert the component generated client id to a form suitable
     * for transmission to the client.</p>
     *
     * <p>The default implementation returns the argument
     * <code>clientId</code> unchanged.</p>
     *
     * @param context {@link FacesContext} for the current request
     * @param clientId the client identifier to be converted to client a
     * specific format.
     *
     * @throws NullPointerException if <code>context</code>
     *  or <code>clientId</code> is <code>null</code>
     *
     * @return the converted {@code clientId}
     */ 
    public String convertClientId(FacesContext context, String clientId) {
        return null;
    }
}
