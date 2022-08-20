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

package javax.faces.component;

import java.util.Map;

/**
 * <p>
 * <strong class="changed_modified_2_0 changed_modified_2_0_rev_a changed_modified_2_1
 * changed_modified_2_2 changed_modified_2_3">UIComponent</strong> is the base class for
 * all user interface components in Jakarta Server Faces. The set of {@link UIComponent}
 * instances associated with a particular request and response are organized into a
 * component tree under a {@link UIViewRoot} that represents the entire content of the
 * request or response.
 * </p>
 *
 * <p>
 * For the convenience of component developers, {@link UIComponentBase} provides the
 * default behavior that is specified for a {@link UIComponent}, and is the base class for
 * all of the concrete {@link UIComponent} "base" implementations. Component writers are
 * encouraged to subclass {@link UIComponentBase}, instead of directly implementing this
 * abstract class, to reduce the impact of any future changes to the method signatures.
 * </p>
 *
 * <p class="changed_added_2_0">
 * If the {@link javax.faces.event.ListenerFor} annotation is attached to the class
 * definition of a <code>Component</code>, that class must also implement
 * {@link javax.faces.event.ComponentSystemEventListener}.
 * </p>
 * 
 * <p class="changed_added_2_3">
 * Dynamically modifying the component tree can happen at any time, during and after
 * restoring the view, but not during state saving and needs to function properly with
 * respect to rendering and state saving
 * </p>
 */
public abstract class UIComponent {

    /**
     * <p>
     * Return a mutable <code>Map</code> representing the attributes (and properties, see
     * below) associated wth this {@link UIComponent}, keyed by attribute name (which must
     * be a String). The returned implementation must support all of the standard and
     * optional <code>Map</code> methods, plus support the following additional
     * requirements:
     * </p>
     * <ul>
     * <li>The <code>Map</code> implementation must implement the
     * <code>java.io.Serializable</code> interface.</li>
     * <li>Any attempt to add a <code>null</code> key or value must throw a
     * <code>NullPointerException</code>.</li>
     * <li>Any attempt to add a key that is not a String must throw a
     * <code>ClassCastException</code>.</li>
     * <li>If the attribute name specified as a key matches a property of this
     * {@link UIComponent}'s implementation class, the following methods will have special
     * behavior:
     * <ul>
     * <li><code>containsKey</code> - Return <code>false</code>.</li>
     * <li><code>get()</code> - If the property is readable, call the getter method and
     * return the returned value (wrapping primitive values in their corresponding wrapper
     * classes); otherwise throw <code>IllegalArgumentException</code>.</li>
     * <li><code>put()</code> - If the property is writeable, call the setter method to
     * set the corresponding value (unwrapping primitive values in their corresponding
     * wrapper classes). If the property is not writeable, or an attempt is made to set a
     * property of primitive type to <code>null</code>, throw
     * <code>IllegalArgumentException</code>.</li>
     * <li><code>remove</code> - Throw <code>IllegalArgumentException</code>.</li>
     * </ul>
     * </li>
     * </ul>
     * 
     * @return the component attribute map.
     */
    public abstract Map<String, Object> getAttributes();
}
