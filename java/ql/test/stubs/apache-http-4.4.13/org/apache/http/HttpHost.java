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

package org.apache.http;

import java.io.Serializable;
import java.net.InetAddress;

import org.apache.http.annotation.ThreadingBehavior;
import org.apache.http.annotation.Contract;

/**
 * Holds all of the variables needed to describe an HTTP connection to a host.
 * This includes remote host name, port and scheme.
 *
 * @since 4.0
 */
@Contract(threading = ThreadingBehavior.IMMUTABLE)
public final class HttpHost implements Cloneable, Serializable {

    /** The default scheme is "http". */
    public static final String DEFAULT_SCHEME_NAME = "http";

    /**
     * Creates {@code HttpHost} instance with the given scheme, hostname and port.
     *
     * @param hostname  the hostname (IP or DNS name)
     * @param port      the port number.
     *                  {@code -1} indicates the scheme default port.
     * @param scheme    the name of the scheme.
     *                  {@code null} indicates the
     *                  {@link #DEFAULT_SCHEME_NAME default scheme}
     */
    public HttpHost(final String hostname, final int port, final String scheme) {
    }

    /**
     * Creates {@code HttpHost} instance with the default scheme and the given hostname and port.
     *
     * @param hostname  the hostname (IP or DNS name)
     * @param port      the port number.
     *                  {@code -1} indicates the scheme default port.
     */
    public HttpHost(final String hostname, final int port) {
    }

    /**
     * Creates {@code HttpHost} instance from string. Text may not contain any blanks.
     *
     * @since 4.4
     */
    public static HttpHost create(final String s) {
        return null;
    }

    /**
     * Creates {@code HttpHost} instance with the default scheme and port and the given hostname.
     *
     * @param hostname  the hostname (IP or DNS name)
     */
    public HttpHost(final String hostname) {
    }

    /**
     * Creates {@code HttpHost} instance with the given scheme, inet address and port.
     *
     * @param address   the inet address.
     * @param port      the port number.
     *                  {@code -1} indicates the scheme default port.
     * @param scheme    the name of the scheme.
     *                  {@code null} indicates the
     *                  {@link #DEFAULT_SCHEME_NAME default scheme}
     *
     * @since 4.3
     */
    public HttpHost(final InetAddress address, final int port, final String scheme) {
    }
    /**
     * Creates a new {@link HttpHost HttpHost}, specifying all values.
     * Constructor for HttpHost.
     *
     * @param address   the inet address.
     * @param hostname   the hostname (IP or DNS name)
     * @param port      the port number.
     *                  {@code -1} indicates the scheme default port.
     * @param scheme    the name of the scheme.
     *                  {@code null} indicates the
     *                  {@link #DEFAULT_SCHEME_NAME default scheme}
     *
     * @since 4.4
     */
    public HttpHost(final InetAddress address, final String hostname, final int port, final String scheme) {
    }

    /**
     * Creates {@code HttpHost} instance with the default scheme and the given inet address
     * and port.
     *
     * @param address   the inet address.
     * @param port      the port number.
     *                  {@code -1} indicates the scheme default port.
     *
     * @since 4.3
     */
    public HttpHost(final InetAddress address, final int port) {
    }

    /**
     * Creates {@code HttpHost} instance with the default scheme and port and the given inet
     * address.
     *
     * @param address   the inet address.
     *
     * @since 4.3
     */
    public HttpHost(final InetAddress address) {
    }

    /**
     * Copy constructor for {@link HttpHost HttpHost}.
     *
     * @param httphost the HTTP host to copy details from
     */
    public HttpHost (final HttpHost httphost) {
    }

    /**
     * Returns the host name.
     *
     * @return the host name (IP or DNS name)
     */
    public String getHostName() {
        return null;
    }

    /**
     * Returns the port.
     *
     * @return the host port, or {@code -1} if not set
     */
    public int getPort() {
        return 0;
    }

    /**
     * Returns the scheme name.
     *
     * @return the scheme name
     */
    public String getSchemeName() {
        return null;
    }

    /**
     * Returns the inet address if explicitly set by a constructor,
     *   {@code null} otherwise.
     * @return the inet address
     *
     * @since 4.3
     */
    public InetAddress getAddress() {
        return null;
    }

    /**
     * Return the host URI, as a string.
     *
     * @return the host URI
     */
    public String toURI() {
        return null;
    }


    /**
     * Obtains the host string, without scheme prefix.
     *
     * @return  the host string, for example {@code localhost:8080}
     */
    public String toHostString() {
        return null;
    }


    @Override
    public String toString() {
        return null;
    }


    @Override
    public boolean equals(final Object obj) {
        return false;
    }

    /**
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        return 0;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        return null;
    }

}
