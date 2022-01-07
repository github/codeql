/*
 * ====================================================================
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

package org.apache.http.client.config;

import java.net.InetAddress;
import java.util.Collection;

import org.apache.http.HttpHost;
import org.apache.http.annotation.Contract;
import org.apache.http.annotation.ThreadingBehavior;

/**
 *  Immutable class encapsulating request configuration items.
 *  The default setting for stale connection checking changed
 *  to false, and the feature was deprecated starting with version 4.4.
 */
@Contract(threading = ThreadingBehavior.IMMUTABLE)
public class RequestConfig implements Cloneable {

    public static final RequestConfig DEFAULT = null;

    /**
     * Intended for CDI compatibility
    */
    protected RequestConfig() {
    }

    RequestConfig(
            final boolean expectContinueEnabled,
            final HttpHost proxy,
            final InetAddress localAddress,
            final boolean staleConnectionCheckEnabled,
            final String cookieSpec,
            final boolean redirectsEnabled,
            final boolean relativeRedirectsAllowed,
            final boolean circularRedirectsAllowed,
            final int maxRedirects,
            final boolean authenticationEnabled,
            final Collection<String> targetPreferredAuthSchemes,
            final Collection<String> proxyPreferredAuthSchemes,
            final int connectionRequestTimeout,
            final int connectTimeout,
            final int socketTimeout,
            final boolean contentCompressionEnabled,
            final boolean normalizeUri) {
    }

    /**
     * Determines whether the 'Expect: 100-Continue' handshake is enabled
     * for entity enclosing methods. The purpose of the 'Expect: 100-Continue'
     * handshake is to allow a client that is sending a request message with
     * a request body to determine if the origin server is willing to
     * accept the request (based on the request headers) before the client
     * sends the request body.
     * <p>
     * The use of the 'Expect: 100-continue' handshake can result in
     * a noticeable performance improvement for entity enclosing requests
     * (such as POST and PUT) that require the target server's
     * authentication.
     * </p>
     * <p>
     * 'Expect: 100-continue' handshake should be used with caution, as it
     * may cause problems with HTTP servers and proxies that do not support
     * HTTP/1.1 protocol.
     * </p>
     * <p>
     * Default: {@code false}
     * </p>
     */
    public boolean isExpectContinueEnabled() {
        return false;
    }

    /**
     * Returns HTTP proxy to be used for request execution.
     * <p>
     * Default: {@code null}
     * </p>
     */
    public HttpHost getProxy() {
        return null;
    }

    /**
     * Returns local address to be used for request execution.
     * <p>
     * On machines with multiple network interfaces, this parameter
     * can be used to select the network interface from which the
     * connection originates.
     * </p>
     * <p>
     * Default: {@code null}
     * </p>
     */
    public InetAddress getLocalAddress() {
        return null;
    }

    /**
     * Determines whether stale connection check is to be used. The stale
     * connection check can cause up to 30 millisecond overhead per request and
     * should be used only when appropriate. For performance critical
     * operations this check should be disabled.
     * <p>
     * Default: {@code false} since 4.4
     * </p>
     *
     * @deprecated (4.4) Use {@link
     *   org.apache.http.impl.conn.PoolingHttpClientConnectionManager#getValidateAfterInactivity()}
     */
    @Deprecated
    public boolean isStaleConnectionCheckEnabled() {
        return false;
    }

    /**
     * Determines the name of the cookie specification to be used for HTTP state
     * management.
     * <p>
     * Default: {@code null}
     * </p>
     */
    public String getCookieSpec() {
        return null;
    }

    /**
     * Determines whether redirects should be handled automatically.
     * <p>
     * Default: {@code true}
     * </p>
     */
    public boolean isRedirectsEnabled() {
        return false;
    }

    /**
     * Determines whether relative redirects should be rejected. HTTP specification
     * requires the location value be an absolute URI.
     * <p>
     * Default: {@code true}
     * </p>
     */
    public boolean isRelativeRedirectsAllowed() {
        return false;
    }

    /**
     * Determines whether circular redirects (redirects to the same location) should
     * be allowed. The HTTP spec is not sufficiently clear whether circular redirects
     * are permitted, therefore optionally they can be enabled
     * <p>
     * Default: {@code false}
     * </p>
     */
    public boolean isCircularRedirectsAllowed() {
        return false;
    }

    /**
     * Returns the maximum number of redirects to be followed. The limit on number
     * of redirects is intended to prevent infinite loops.
     * <p>
     * Default: {@code 50}
     * </p>
     */
    public int getMaxRedirects() {
        return 0;
    }

    /**
     * Determines whether authentication should be handled automatically.
     * <p>
     * Default: {@code true}
     * </p>
     */
    public boolean isAuthenticationEnabled() {
        return false;
    }

    /**
     * Determines the order of preference for supported authentication schemes
     * when authenticating with the target host.
     * <p>
     * Default: {@code null}
     * </p>
     */
    public Collection<String> getTargetPreferredAuthSchemes() {
        return null;
    }

    /**
     * Determines the order of preference for supported authentication schemes
     * when authenticating with the proxy host.
     * <p>
     * Default: {@code null}
     * </p>
     */
    public Collection<String> getProxyPreferredAuthSchemes() {
        return null;
    }

    /**
     * Returns the timeout in milliseconds used when requesting a connection
     * from the connection manager.
     * <p>
     * A timeout value of zero is interpreted as an infinite timeout.
     * A negative value is interpreted as undefined (system default if applicable).
     * </p>
     * <p>
     * Default: {@code -1}
     * </p>
     */
    public int getConnectionRequestTimeout() {
        return 0;
    }

    /**
     * Determines the timeout in milliseconds until a connection is established.
     * <p>
     * A timeout value of zero is interpreted as an infinite timeout.
     * A negative value is interpreted as undefined (system default if applicable).
     * </p>
     * <p>
     * Default: {@code -1}
     * </p>
     */
    public int getConnectTimeout() {
        return 0;
    }

    /**
     * Defines the socket timeout ({@code SO_TIMEOUT}) in milliseconds,
     * which is the timeout for waiting for data or, put differently,
     * a maximum period inactivity between two consecutive data packets).
     * <p>
     * A timeout value of zero is interpreted as an infinite timeout.
     * A negative value is interpreted as undefined (system default if applicable).
     * </p>
     * <p>
     * Default: {@code -1}
     * </p>
     */
    public int getSocketTimeout() {
        return 0;
    }

    /**
     * Determines whether compressed entities should be decompressed automatically.
     * <p>
     * Default: {@code true}
     * </p>
     *
     * @since 4.4
     * @deprecated (4.5) Use {@link #isContentCompressionEnabled()}
     */
    @Deprecated
    public boolean isDecompressionEnabled() {
        return false;
    }

    /**
     * Determines whether the target server is requested to compress content.
     * <p>
     * Default: {@code true}
     * </p>
     *
     * @since 4.5
     */
    public boolean isContentCompressionEnabled() {
        return false;
    }

    /**
     * Determines whether client should normalize URIs in requests or not.
     * <p>
     * Default: {@code true}
     * </p>
     *
     * @since 4.5.8
     */
    public boolean isNormalizeUri() {
        return false;
    }

    @Override
    protected RequestConfig clone() throws CloneNotSupportedException {
        return null;
    }

    @Override
    public String toString() {
        return null;
    }

    public static RequestConfig.Builder custom() {
        return null;
    }

    @SuppressWarnings("deprecation")
    public static RequestConfig.Builder copy(final RequestConfig config) {
        return null;
    }

    public static class Builder {

        Builder() {
        }

        public Builder setExpectContinueEnabled(final boolean expectContinueEnabled) {
            return null;
        }

        public Builder setProxy(final HttpHost proxy) {
            return null;
        }

        public Builder setLocalAddress(final InetAddress localAddress) {
            return null;
        }

        /**
         * @deprecated (4.4) Use {@link
         *   org.apache.http.impl.conn.PoolingHttpClientConnectionManager#setValidateAfterInactivity(int)}
         */
        @Deprecated
        public Builder setStaleConnectionCheckEnabled(final boolean staleConnectionCheckEnabled) {
            return null;
        }

        public Builder setCookieSpec(final String cookieSpec) {
            return null;
        }

        public Builder setRedirectsEnabled(final boolean redirectsEnabled) {
            return null;
        }

        public Builder setRelativeRedirectsAllowed(final boolean relativeRedirectsAllowed) {
            return null;
        }

        public Builder setCircularRedirectsAllowed(final boolean circularRedirectsAllowed) {
            return null;
        }

        public Builder setMaxRedirects(final int maxRedirects) {
            return null;
        }

        public Builder setAuthenticationEnabled(final boolean authenticationEnabled) {
            return null;
        }

        public Builder setTargetPreferredAuthSchemes(final Collection<String> targetPreferredAuthSchemes) {
            return null;
        }

        public Builder setProxyPreferredAuthSchemes(final Collection<String> proxyPreferredAuthSchemes) {
            return null;
        }

        public Builder setConnectionRequestTimeout(final int connectionRequestTimeout) {
            return null;
        }

        public Builder setConnectTimeout(final int connectTimeout) {
            return null;
        }

        public Builder setSocketTimeout(final int socketTimeout) {
            return null;
        }

        /**
         * @deprecated (4.5) Set {@link #setContentCompressionEnabled(boolean)} to {@code false} and
         * add the {@code Accept-Encoding} request header.
         */
        @Deprecated
        public Builder setDecompressionEnabled(final boolean decompressionEnabled) {
            return null;
        }

        public Builder setContentCompressionEnabled(final boolean contentCompressionEnabled) {
            return null;
        }

        public Builder setNormalizeUri(final boolean normalizeUri) {
            return null;
        }

        public RequestConfig build() {
            return null;
        }

    }

}
