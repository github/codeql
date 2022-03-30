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

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.annotation.Inherited;

/**
 * <p class="changed_added_2_0">The presence of this annotation on a
 * class automatically registers the class with the runtime as a {@link
 * Renderer}.  The value of the {@link #renderKitId} attribute is taken
 * to be the <em>render-kit-id</em> to which an instance of this
 * <code>Renderer</code> is to be added.  There must be a public
 * zero-argument constructor on any class where this annotation appears.
 * The implementation must indicate a fatal error if such a constructor
 * does not exist and the application must not be placed in service.
 * Within that {@link RenderKit}, The value of the {@link #rendererType}
 * attribute is taken to be the <em>renderer-type</em>, and the value of
 * the {@link #componentFamily} attribute is to be taken as the
 * <em>component-family</em>.  The implementation must guarantee that
 * for each class annotated with <code>FacesRenderer</code>, found with
 * the algorithm in section JSF.11.5,
 * the following actions are taken.</p>

 * <div class="changed_added_2_0">

 * <ul>

 * 	  <li><p>Obtain a reference to the {@link RenderKitFactory} for
 * 	  this application.</p></li>

      <li><p>See if a <code>RenderKit</code> exists for
      <em>render-kit-id</em>.  If so, let that instance be
      <em>renderKit</em> for discussion.  If not, the implementation
      must indicate a fatal error if such a <code>RenderKit</code>
      does not exist and the application must not be placed in
      service.</p></li>

      <li><p>Create an instance of this class using the public
      zero-argument constructor.</p></li>

      <li><p>Call {@link RenderKit#addRenderer} on
      <em>renderKit</em>, passing <em>component-family</em> as the
      first argument, <em>renderer-type</em> as the second, and the
      newly instantiated <code>RenderKit</code> instance as the
      third argument.</p></li>

 * </ul>


 * </div>

 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Inherited
public @interface FacesRenderer {


    /**
     * <p class="changed_added_2_0">The value of this annotation
     * attribute is taken to be the <em>render-kit-id</em> in which an
     * instance of this class of <code>Renderer</code> must be
     * installed.</p>
     * 
     * @return the <em>render-kit-id</em>
     */ 

    String renderKitId() default "";


    /**
     * <p class="changed_added_2_0">The value of this annotation
     * attribute is taken to be the <em>renderer-type</em> which, in
     * combination with {@link #componentFamily} can be used to obtain a
     * reference to an instance of this {@link Renderer} by calling
     * {@link javax.faces.render.RenderKit#getRenderer(java.lang.String,
     * java.lang.String)}.</p>
     * 
     * @return the <em>renderer-type</em>
     */ 

    String rendererType();


    /**
     * <p class="changed_added_2_0">The value of this annotation
     * attribute is taken to be the <em>component-family</em> which, in
     * combination with {@link #rendererType} can be used to obtain a
     * reference to an instance of this {@link Renderer} by calling
     * {@link javax.faces.render.RenderKit#getRenderer(java.lang.String,
     * java.lang.String)}.</p>
     * 
     * @return the <em>component-family</em>
     */ 

    String componentFamily();

}
