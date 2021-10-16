/*
 * Copyright (c) 2012, 2019 Oracle and/or its affiliates. All rights reserved.
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

package javax.ws.rs.container;

import java.io.InputStream;
import java.net.URI;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.ws.rs.core.Cookie;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import javax.ws.rs.core.UriInfo;

/**
 * Container request filter context.
 *
 * A mutable class that provides request-specific information for the filter, such as request URI, message headers,
 * message entity or request-scoped properties. The exposed setters allow modification of the exposed request-specific
 * information.
 *
 * @author Marek Potociar
 * @since 2.0
 */
public interface ContainerRequestContext {

    /**
     * Returns the property with the given name registered in the current request/response exchange context, or {@code null}
     * if there is no property by that name.
     * <p>
     * A property allows a JAX-RS filters and interceptors to exchange additional custom information not already provided by
     * this interface.
     * </p>
     * <p>
     * A list of supported properties can be retrieved using {@link #getPropertyNames()}. Custom property names should
     * follow the same convention as package names.
     * </p>
     * <p>
     * In a Servlet container, the properties are synchronized with the {@code ServletRequest} and expose all the attributes
     * available in the {@code ServletRequest}. Any modifications of the properties are also reflected in the set of
     * properties of the associated {@code ServletRequest}.
     * </p>
     *
     * @param name a {@code String} specifying the name of the property.
     * @return an {@code Object} containing the value of the property, or {@code null} if no property exists matching the
     * given name.
     * @see #getPropertyNames()
     */
    public Object getProperty(String name);

    /**
     * Returns {@code true} if the property with the given name is registered in the current request/response exchange
     * context, or {@code false} if there is no property by that name.
     * <p>
     * Use the {@link #getProperty} method with a property name to get the value of a property.
     * </p>
     *
     * @param name a {@code String} specifying the name of the property.
     * @return {@code true} if this property is registered in the context, or {@code false} if no property exists matching
     * the given name.
     * @see #getPropertyNames()
     */
    public default boolean hasProperty(String name) {
        return getProperty(name) != null;
    }

    /**
     * Returns an immutable {@link java.util.Collection collection} containing the property names available within the
     * context of the current request/response exchange context.
     * <p>
     * Use the {@link #getProperty} method with a property name to get the value of a property.
     * </p>
     * <p>
     * In a Servlet container, the properties are synchronized with the {@code ServletRequest} and expose all the attributes
     * available in the {@code ServletRequest}. Any modifications of the properties are also reflected in the set of
     * properties of the associated {@code ServletRequest}.
     * </p>
     *
     * @return an immutable {@link java.util.Collection collection} of property names.
     * @see #getProperty
     */
    public Collection<String> getPropertyNames();

    /**
     * Binds an object to a given property name in the current request/response exchange context. If the name specified is
     * already used for a property, this method will replace the value of the property with the new value.
     * <p>
     * A property allows a JAX-RS filters and interceptors to exchange additional custom information not already provided by
     * this interface.
     * </p>
     * <p>
     * A list of supported properties can be retrieved using {@link #getPropertyNames()}. Custom property names should
     * follow the same convention as package names.
     * </p>
     * <p>
     * If a {@code null} value is passed, the effect is the same as calling the {@link #removeProperty(String)} method.
     * </p>
     * <p>
     * In a Servlet container, the properties are synchronized with the {@code ServletRequest} and expose all the attributes
     * available in the {@code ServletRequest}. Any modifications of the properties are also reflected in the set of
     * properties of the associated {@code ServletRequest}.
     * </p>
     *
     * @param name a {@code String} specifying the name of the property.
     * @param object an {@code Object} representing the property to be bound.
     */
    public void setProperty(String name, Object object);

    /**
     * Removes a property with the given name from the current request/response exchange context. After removal, subsequent
     * calls to {@link #getProperty} to retrieve the property value will return {@code null}.
     * <p>
     * In a Servlet container, the properties are synchronized with the {@code ServletRequest} and expose all the attributes
     * available in the {@code ServletRequest}. Any modifications of the properties are also reflected in the set of
     * properties of the associated {@code ServletRequest}.
     * </p>
     *
     * @param name a {@code String} specifying the name of the property to be removed.
     */
    public void removeProperty(String name);

    /**
     * Get request URI information.
     *
     * The returned object contains "live" view of the request URI information in a sense that any changes made to the
     * request URI using one of the {@code setRequestUri(...)} methods will be reflected in the previously returned
     * {@link UriInfo} instance.
     *
     * @return request URI information.
     */
    public UriInfo getUriInfo();

    /**
     * Set a new request URI using the current base URI of the application to resolve the application-specific request URI
     * part.
     * <p>
     * Note that the method is usable only in pre-matching filters, prior to the resource matching occurs. Trying to invoke
     * the method in a filter bound to a resource method results in an {@link IllegalStateException} being thrown.
     * </p>
     *
     * @param requestUri new URI of the request.
     * @throws IllegalStateException in case the method is not invoked from a {@link PreMatching pre-matching} request
     * filter.
     * @see #setRequestUri(java.net.URI, java.net.URI)
     */
    public void setRequestUri(URI requestUri);

    /**
     * Set a new request URI using a new base URI to resolve the application-specific request URI part.
     * <p>
     * Note that the method is usable only in pre-matching filters, prior to the resource matching occurs. Trying to invoke
     * the method in a filter bound to a resource method results in an {@link IllegalStateException} being thrown.
     * </p>
     *
     * @param baseUri base URI that will be used to resolve the application-specific part of the request URI.
     * @param requestUri new URI of the request.
     * @throws IllegalStateException in case the method is not invoked from a {@link PreMatching pre-matching} request
     * filter.
     * @see #setRequestUri(java.net.URI)
     */
    public void setRequestUri(URI baseUri, URI requestUri);

    /**
     * Get the injectable request information.
     *
     * @return injectable request information.
     */
    public Request getRequest();

    /**
     * Get the request method.
     *
     * @return the request method.
     * @see javax.ws.rs.HttpMethod
     */
    public String getMethod();

    /**
     * Set the request method.
     * <p>
     * Note that the method is usable only in pre-matching filters, prior to the resource matching occurs. Trying to invoke
     * the method in a filter bound to a resource method results in an {@link IllegalStateException} being thrown.
     * </p>
     *
     * @param method new request method.
     * @throws IllegalStateException in case the method is not invoked from a {@link PreMatching pre-matching} request
     * filter.
     * @see javax.ws.rs.HttpMethod
     */
    public void setMethod(String method);

    /**
     * Get the mutable request headers multivalued map.
     *
     * @return mutable multivalued map of request headers.
     * @see #getHeaderString(String)
     */
    public MultivaluedMap<String, String> getHeaders();

    /**
     * Get a message header as a single string value.
     *
     * @param name the message header.
     * @return the message header value. If the message header is not present then {@code null} is returned. If the message
     * header is present but has no value then the empty string is returned. If the message header is present more than once
     * then the values of joined together and separated by a ',' character.
     * @see #getHeaders()
     */
    public String getHeaderString(String name);

    /**
     * Get message date.
     *
     * @return the message date, otherwise {@code null} if not present.
     */
    public Date getDate();

    /**
     * Get the language of the entity.
     *
     * @return the language of the entity or {@code null} if not specified
     */
    public Locale getLanguage();

    /**
     * Get Content-Length value.
     *
     * @return Content-Length as integer if present and valid number. In other cases returns {@code -1}.
     */
    public int getLength();

    /**
     * Get the media type of the entity.
     *
     * @return the media type or {@code null} if not specified (e.g. there's no request entity).
     */
    public MediaType getMediaType();

    /**
     * Get a list of media types that are acceptable for the response.
     *
     * @return a read-only list of requested response media types sorted according to their q-value, with highest preference
     * first.
     */
    public List<MediaType> getAcceptableMediaTypes();

    /**
     * Get a list of languages that are acceptable for the response.
     *
     * @return a read-only list of acceptable languages sorted according to their q-value, with highest preference first.
     */
    public List<Locale> getAcceptableLanguages();

    /**
     * Get any cookies that accompanied the request.
     *
     * @return a read-only map of cookie name (String) to {@link Cookie}.
     */
    public Map<String, Cookie> getCookies();

    /**
     * Check if there is a non-empty entity input stream available in the request message.
     *
     * The method returns {@code true} if the entity is present, returns {@code false} otherwise.
     *
     * @return {@code true} if there is an entity present in the message, {@code false} otherwise.
     */
    public boolean hasEntity();

    /**
     * Get the entity input stream. The JAX-RS runtime is responsible for closing the input stream.
     *
     * @return entity input stream.
     */
    public InputStream getEntityStream();

    /**
     * Set a new entity input stream. The JAX-RS runtime is responsible for closing the input stream.
     *
     * @param input new entity input stream.
     * @throws IllegalStateException in case the method is invoked from a response filter.
     */
    public void setEntityStream(InputStream input);

    /**
     * Get the injectable security context information for the current request.
     *
     * The {@link SecurityContext#getUserPrincipal()} must return {@code null} if the current request has not been
     * authenticated.
     *
     * @return injectable request security context information.
     */
    public SecurityContext getSecurityContext();

    /**
     * Set a new injectable security context information for the current request.
     *
     * The {@link SecurityContext#getUserPrincipal()} must return {@code null} if the current request has not been
     * authenticated.
     *
     * @param context new injectable request security context information.
     * @throws IllegalStateException in case the method is invoked from a response filter.
     */
    public void setSecurityContext(SecurityContext context);

    /**
     * Abort the filter chain with a response.
     *
     * This method breaks the filter chain processing and returns the provided response back to the client. The provided
     * response goes through the chain of applicable response filters.
     *
     * @param response response to be sent back to the client.
     * @throws IllegalStateException in case the method is invoked from a response filter.
     */
    public void abortWith(Response response);
}
