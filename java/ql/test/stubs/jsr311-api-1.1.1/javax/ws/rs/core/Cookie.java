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

/**
 * Represents the value of a HTTP cookie, transferred in a request.
 * RFC 2109 specifies the legal characters for name,
 * value, path and domain. The default version of 1 corresponds to RFC 2109.
 *
 * @author Paul Sandoz
 * @author Marc Hadley
 * @see <a href="http://www.ietf.org/rfc/rfc2109.txt">IETF RFC 2109</a>
 * @since 1.0
 */
public class Cookie {

    /**
     * Cookies using the default version correspond to RFC 2109.
     */
    public static final int DEFAULT_VERSION = 1;

    /**
     * Create a new instance.
     *
     * @param name    the name of the cookie.
     * @param value   the value of the cookie.
     * @param path    the URI path for which the cookie is valid.
     * @param domain  the host domain for which the cookie is valid.
     * @param version the version of the specification to which the cookie complies.
     * @throws IllegalArgumentException if name is {@code null}.
     */
    public Cookie(final String name, final String value, final String path, final String domain, final int version)
            throws IllegalArgumentException {
    }

    /**
     * Create a new instance.
     *
     * @param name   the name of the cookie.
     * @param value  the value of the cookie.
     * @param path   the URI path for which the cookie is valid.
     * @param domain the host domain for which the cookie is valid.
     * @throws IllegalArgumentException if name is {@code null}.
     */
    public Cookie(final String name, final String value, final String path, final String domain)
            throws IllegalArgumentException {
    }

    /**
     * Create a new instance.
     *
     * @param name  the name of the cookie.
     * @param value the value of the cookie.
     * @throws IllegalArgumentException if name is {@code null}.
     */
    public Cookie(final String name, final String value)
            throws IllegalArgumentException {
    }

    /**
     * Creates a new instance of {@code Cookie} by parsing the supplied string.
     *
     * @param value the cookie string.
     * @return the newly created {@code Cookie}.
     * @throws IllegalArgumentException if the supplied string cannot be parsed
     *                                  or is {@code null}.
     */
    public static Cookie valueOf(final String value) {
        return null;
    }

    /**
     * Get the name of the cookie.
     *
     * @return the cookie name.
     */
    public String getName() {
        return null;
    }

    /**
     * Get the value of the cookie.
     *
     * @return the cookie value.
     */
    public String getValue() {
        return null;
    }

    /**
     * Get the version of the cookie.
     *
     * @return the cookie version.
     */
    public int getVersion() {
        return -1;
    }

    /**
     * Get the domain of the cookie.
     *
     * @return the cookie domain.
     */
    public String getDomain() {
        return null;
    }

    /**
     * Get the path of the cookie.
     *
     * @return the cookie path.
     */
    public String getPath() {
        return null;
    }

    public String toString() {
        return null;
    }
}
