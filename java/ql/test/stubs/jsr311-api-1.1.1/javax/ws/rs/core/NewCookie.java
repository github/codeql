/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 2010-2015 Oracle and/or its affiliates. All rights reserved.
 *
 * The contents of this file are subject to the terms of either the GNU
 * General Public License Version 2 only ("GPL") or the Common Development
 * and Distribution License("CDDL") (collectively, the "License").  You
 * may not use this file except in compliance with the License.  You can
 * obtain a copy of the License at
 * http://glassfish.java.net/public/CDDL+GPL_1_1.html
 * or packager/legal/LICENSE.txt.  See the License for the specific
 * language governing permissions and limitations under the License.
 *
 * When distributing the software, include this License Header Notice in each
 * file and include the License file at packager/legal/LICENSE.txt.
 *
 * GPL Classpath Exception:
 * Oracle designates this particular file as subject to the "Classpath"
 * exception as provided by Oracle in the GPL Version 2 section of the License
 * file that accompanied this code.
 *
 * Modifications:
 * If applicable, add the following below the License Header, with the fields
 * enclosed by brackets [] replaced by your own identifying information:
 * "Portions Copyright [year] [name of copyright owner]"
 *
 * Contributor(s):
 * If you wish your version of this file to be governed by only the CDDL or
 * only the GPL Version 2, indicate your decision by adding "[Contributor]
 * elects to include this software in this distribution under the [CDDL or GPL
 * Version 2] license."  If you don't indicate a single choice of license, a
 * recipient has the option to distribute your version of this file under
 * either the CDDL, the GPL Version 2 or to extend the choice of license to
 * its licensees as provided above.  However, if you add GPL Version 2 code
 * and therefore, elected the GPL Version 2 license, then the option applies
 * only if the new code is made subject to such option by the copyright
 * holder.
 */

package javax.ws.rs.core;

import java.util.Date;

/**
 * Used to create a new HTTP cookie, transferred in a response.
 *
 * @author Paul Sandoz
 * @author Marc Hadley
 * @see <a href="http://www.ietf.org/rfc/rfc2109.txt">IETF RFC 2109</a>
 * @since 1.0
 */
public class NewCookie extends Cookie {

    /**
     * Specifies that the cookie expires with the current application/browser session.
     */
    public static final int DEFAULT_MAX_AGE = -1;

    /**
     * Create a new instance.
     *
     * @param name  the name of the cookie.
     * @param value the value of the cookie.
     * @throws IllegalArgumentException if name is {@code null}.
     */
    public NewCookie(String name, String value) {
        super("", "");
    }

    /**
     * Create a new instance.
     *
     * @param name    the name of the cookie.
     * @param value   the value of the cookie.
     * @param path    the URI path for which the cookie is valid.
     * @param domain  the host domain for which the cookie is valid.
     * @param comment the comment.
     * @param maxAge  the maximum age of the cookie in seconds.
     * @param secure  specifies whether the cookie will only be sent over a secure connection.
     * @throws IllegalArgumentException if name is {@code null}.
     */
    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     String comment,
                     int maxAge,
                     boolean secure) {
        super("", "");
    }

    /**
     * Create a new instance.
     *
     * @param name     the name of the cookie.
     * @param value    the value of the cookie.
     * @param path     the URI path for which the cookie is valid.
     * @param domain   the host domain for which the cookie is valid.
     * @param comment  the comment.
     * @param maxAge   the maximum age of the cookie in seconds.
     * @param secure   specifies whether the cookie will only be sent over a secure connection.
     * @param httpOnly if {@code true} make the cookie HTTP only, i.e. only visible as part of an HTTP request.
     * @throws IllegalArgumentException if name is {@code null}.
     * @since 2.0
     */
    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     String comment,
                     int maxAge,
                     boolean secure,
                     boolean httpOnly) {
        super("", "");
    }

    /**
     * Create a new instance.
     *
     * @param name    the name of the cookie
     * @param value   the value of the cookie
     * @param path    the URI path for which the cookie is valid
     * @param domain  the host domain for which the cookie is valid
     * @param version the version of the specification to which the cookie complies
     * @param comment the comment
     * @param maxAge  the maximum age of the cookie in seconds
     * @param secure  specifies whether the cookie will only be sent over a secure connection
     * @throws IllegalArgumentException if name is {@code null}.
     */
    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     int version,
                     String comment,
                     int maxAge,
                     boolean secure) {
        super("", "");
    }

    /**
     * Create a new instance.
     *
     * @param name     the name of the cookie
     * @param value    the value of the cookie
     * @param path     the URI path for which the cookie is valid
     * @param domain   the host domain for which the cookie is valid
     * @param version  the version of the specification to which the cookie complies
     * @param comment  the comment
     * @param maxAge   the maximum age of the cookie in seconds
     * @param expiry   the cookie expiry date.
     * @param secure   specifies whether the cookie will only be sent over a secure connection
     * @param httpOnly if {@code true} make the cookie HTTP only, i.e. only visible as part of an HTTP request.
     * @throws IllegalArgumentException if name is {@code null}.
     * @since 2.0
     */
    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     int version,
                     String comment,
                     int maxAge,
                     Date expiry,
                     boolean secure,
                     boolean httpOnly) {
        super("", "");
    }

    /**
     * Create a new instance copying the information in the supplied cookie.
     *
     * @param cookie the cookie to clone.
     * @throws IllegalArgumentException if cookie is {@code null}.
     */
    public NewCookie(Cookie cookie) {
        super("", "");
    }

    /**
     * Create a new instance supplementing the information in the supplied cookie.
     *
     * @param cookie  the cookie to clone.
     * @param comment the comment.
     * @param maxAge  the maximum age of the cookie in seconds.
     * @param secure  specifies whether the cookie will only be sent over a secure connection.
     * @throws IllegalArgumentException if cookie is {@code null}.
     */
    public NewCookie(Cookie cookie, String comment, int maxAge, boolean secure) {
        super("", "");
    }

    /**
     * Create a new instance supplementing the information in the supplied cookie.
     *
     * @param cookie   the cookie to clone.
     * @param comment  the comment.
     * @param maxAge   the maximum age of the cookie in seconds.
     * @param expiry   the cookie expiry date.
     * @param secure   specifies whether the cookie will only be sent over a secure connection.
     * @param httpOnly if {@code true} make the cookie HTTP only, i.e. only visible as part of an HTTP request.
     * @throws IllegalArgumentException if cookie is {@code null}.
     * @since 2.0
     */
    public NewCookie(Cookie cookie, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly) {
        super("", "");
    }

    /**
     * Creates a new instance of NewCookie by parsing the supplied string.
     *
     * @param value the cookie string.
     * @return the newly created {@code NewCookie}.
     * @throws IllegalArgumentException if the supplied string cannot be parsed
     *                                  or is {@code null}.
     */
    public static NewCookie valueOf(String value) {
        return null;
    }

    /**
     * Get the comment associated with the cookie.
     *
     * @return the comment or null if none set
     */
    public String getComment() {
        return null;
    }

    /**
     * Get the maximum age of the the cookie in seconds. Cookies older than
     * the maximum age are discarded. A cookie can be unset by sending a new
     * cookie with maximum age of 0 since it will overwrite any existing cookie
     * and then be immediately discarded. The default value of {@code -1} indicates
     * that the cookie will be discarded at the end of the browser/application session.
     * <p>
     * Note that it is recommended to use {@code Max-Age} to control cookie
     * expiration, however some browsers do not understand {@code Max-Age}, in which case
     * setting {@link #getExpiry()} Expires} parameter may be necessary.
     * </p>
     *
     * @return the maximum age in seconds.
     * @see #getExpiry()
     */
    public int getMaxAge() {
        return -1;
    }

    /**
     * Get the cookie expiry date. Cookies whose expiry date has passed are discarded.
     * A cookie can be unset by setting a new cookie with an expiry date in the past,
     * typically the lowest possible date that can be set.
     * <p>
     * Note that it is recommended to use {@link #getMaxAge() Max-Age} to control cookie
     * expiration, however some browsers do not understand {@code Max-Age}, in which case
     * setting {@code Expires} parameter may be necessary.
     * </p>
     *
     * @return cookie expiry date or {@code null} if no expiry date was set.
     * @see #getMaxAge()
     * @since 2.0
     */
    public Date getExpiry() {
        return null;
    }

    /**
     * Whether the cookie will only be sent over a secure connection. Defaults
     * to {@code false}.
     *
     * @return {@code true} if the cookie will only be sent over a secure connection,
     *         {@code false} otherwise.
     */
    public boolean isSecure() {
        return false;
    }

    /**
     * Returns {@code true} if this cookie contains the {@code HttpOnly} attribute.
     * This means that the cookie should not be accessible to scripting engines,
     * like javascript.
     *
     * @return {@code true} if this cookie should be considered http only, {@code false}
     *         otherwise.
     * @since 2.0
     */
    public boolean isHttpOnly() {
        return false;
    }

    /**
     * Obtain a new instance of a {@link Cookie} with the same name, value, path,
     * domain and version as this {@code NewCookie}. This method can be used to
     * obtain an object that can be compared for equality with another {@code Cookie};
     * since a {@code Cookie} will never compare equal to a {@code NewCookie}.
     *
     * @return a {@link Cookie}
     */
    public Cookie toCookie() {
        return null;
    }

    /**
     * Convert the cookie to a string suitable for use as the value of the
     * corresponding HTTP header.
     *
     * @return a stringified cookie.
     */
    @Override
    public String toString() {
        return null;
    }    
}