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
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

package org.apache.http.client.methods;

import java.net.URI;
import java.nio.charset.Charset;
import java.util.List;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.HttpRequest;
import org.apache.http.NameValuePair;
import org.apache.http.ProtocolVersion;
import org.apache.http.client.config.RequestConfig;

/**
 * Builder for {@link HttpUriRequest} instances.
 * <p>
 * Please note that this class treats parameters differently depending on composition
 * of the request: if the request has a content entity explicitly set with
 * {@link #setEntity(org.apache.http.HttpEntity)} or it is not an entity enclosing method
 * (such as POST or PUT), parameters will be added to the query component of the request URI.
 * Otherwise, parameters will be added as a URL encoded {@link UrlEncodedFormEntity entity}.
 * </p>
 *
 * @since 4.3
 */
public class RequestBuilder {

    RequestBuilder(final String method) {
    }

    RequestBuilder(final String method, final URI uri) {
    }

    RequestBuilder(final String method, final String uri) {
    }

    RequestBuilder() {
    }

    public static RequestBuilder create(final String method) {
        return null;
    }

    public static RequestBuilder get() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder get(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder get(final String uri) {
        return null;
    }

    public static RequestBuilder head() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder head(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder head(final String uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder patch() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder patch(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder patch(final String uri) {
        return null;
    }

    public static RequestBuilder post() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder post(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder post(final String uri) {
        return null;
    }

    public static RequestBuilder put() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder put(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder put(final String uri) {
        return null;
    }

    public static RequestBuilder delete() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder delete(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder delete(final String uri) {
        return null;
    }

    public static RequestBuilder trace() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder trace(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder trace(final String uri) {
        return null;
    }

    public static RequestBuilder options() {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder options(final URI uri) {
        return null;
    }

    /**
     * @since 4.4
     */
    public static RequestBuilder options(final String uri) {
        return null;
    }

    public static RequestBuilder copy(final HttpRequest request) {
        return null;
    }

    private RequestBuilder doCopy(final HttpRequest request) {
        return null;
    }

    /**
     * @since 4.4
     */
    public RequestBuilder setCharset(final Charset charset) {
        return null;
    }

    /**
     * @since 4.4
     */
    public Charset getCharset() {
        return null;
    }

    public String getMethod() {
        return null;
    }

    public ProtocolVersion getVersion() {
        return null;
    }

    public RequestBuilder setVersion(final ProtocolVersion version) {
        return null;
    }

    public URI getUri() {
        return null;
    }

    public RequestBuilder setUri(final URI uri) {
        return null;
    }

    public RequestBuilder setUri(final String uri) {
        return null;
    }

    public Header getFirstHeader(final String name) {
        return null;
    }

    public Header getLastHeader(final String name) {
        return null;
    }

    public Header[] getHeaders(final String name) {
        return null;
    }

    public RequestBuilder addHeader(final Header header) {
        return null;
    }

    public RequestBuilder addHeader(final String name, final String value) {
        return null;
    }

    public RequestBuilder removeHeader(final Header header) {
        return null;
    }

    public RequestBuilder removeHeaders(final String name) {
        return null;
    }

    public RequestBuilder setHeader(final Header header) {
        return null;
    }

    public RequestBuilder setHeader(final String name, final String value) {
        return null;
    }

    public HttpEntity getEntity() {
        return null;
    }

    public RequestBuilder setEntity(final HttpEntity entity) {
        return null;
    }

    public List<NameValuePair> getParameters() {
        return null;
    }

    public RequestBuilder addParameter(final NameValuePair nvp) {
        return null;
    }

    public RequestBuilder addParameter(final String name, final String value) {
        return null;
    }

    public RequestBuilder addParameters(final NameValuePair... nvps) {
        return null;
    }

    public RequestConfig getConfig() {
        return null;
    }

    public RequestBuilder setConfig(final RequestConfig config) {
        return null;
    }

    public HttpUriRequest build() {
        return null;
    }

    static class InternalRequest extends HttpRequestBase {

        InternalRequest(final String method) {

        }

        @Override
        public String getMethod() {
            return null;
        }

    }

    static class InternalEntityEclosingRequest extends HttpEntityEnclosingRequestBase {

        InternalEntityEclosingRequest(final String method) {

        }

        @Override
        public String getMethod() {
            return null;
        }

    }

    @Override
    public String toString() {
        return null;
    }

}
