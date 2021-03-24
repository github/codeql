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

package org.apache.hc.core5.http.io.entity;
import java.io.File;
import java.io.OutputStream;
import java.io.Serializable;
import java.nio.charset.Charset;
import java.nio.file.Path;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.io.IOCallback;

public final class HttpEntities {
    public static HttpEntity create(final String content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity create(final String content, final Charset charset) {
      return null;
    }

    public static HttpEntity create(final String content) {
      return null;
    }

    public static HttpEntity create(final byte[] content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity create(final File content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity create(final Serializable serializable, final ContentType contentType) {
      return null;
    }

    public static HttpEntity createUrlEncoded(
            final Iterable <? extends NameValuePair> parameters, final Charset charset) {
      return null;
    }

    public static HttpEntity create(final IOCallback<OutputStream> callback, final ContentType contentType) {
      return null;
    }

    public static HttpEntity gzip(final HttpEntity entity) {
      return null;
    }

    public static HttpEntity createGzipped(final String content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity createGzipped(final String content, final Charset charset) {
      return null;
    }

    public static HttpEntity createGzipped(final String content) {
      return null;
    }

    public static HttpEntity createGzipped(final byte[] content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity createGzipped(final File content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity createGzipped(final Serializable serializable, final ContentType contentType) {
      return null;
    }

    public static HttpEntity createGzipped(final IOCallback<OutputStream> callback, final ContentType contentType) {
      return null;
    }

    public static HttpEntity createGzipped(final Path content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity withTrailers(final HttpEntity entity, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(final String content, final ContentType contentType, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(final String content, final Charset charset, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(final String content, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(final byte[] content, final ContentType contentType, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(final File content, final ContentType contentType, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(
            final Serializable serializable, final ContentType contentType, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(
            final IOCallback<OutputStream> callback, final ContentType contentType, final Header... trailers) {
      return null;
    }

    public static HttpEntity create(final Path content, final ContentType contentType) {
      return null;
    }

    public static HttpEntity create(final Path content, final ContentType contentType, final Header... trailers) {
      return null;
    }

}
