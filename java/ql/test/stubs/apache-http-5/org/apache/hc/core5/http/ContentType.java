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

package org.apache.hc.core5.http;
import java.io.Serializable;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.charset.UnsupportedCharsetException;

public final class ContentType implements Serializable {
    public static final ContentType APPLICATION_ATOM_XML = null;

    public static final ContentType APPLICATION_FORM_URLENCODED = null;

    public static final ContentType APPLICATION_JSON = null;

    public static final ContentType APPLICATION_NDJSON = null;

    public static final ContentType APPLICATION_OCTET_STREAM = null;

    public static final ContentType APPLICATION_PDF = null;

    public static final ContentType APPLICATION_SOAP_XML = null;

    public static final ContentType APPLICATION_SVG_XML = null;

    public static final ContentType APPLICATION_XHTML_XML = null;

    public static final ContentType APPLICATION_XML = null;

    public static final ContentType APPLICATION_PROBLEM_JSON = null;

    public static final ContentType APPLICATION_PROBLEM_XML = null;

    public static final ContentType APPLICATION_RSS_XML = null;

    public static final ContentType IMAGE_BMP = null;

    public static final ContentType IMAGE_GIF = null;

    public static final ContentType IMAGE_JPEG = null;

    public static final ContentType IMAGE_PNG = null;

    public static final ContentType IMAGE_SVG = null;

    public static final ContentType IMAGE_TIFF = null;

    public static final ContentType IMAGE_WEBP = null;

    public static final ContentType MULTIPART_FORM_DATA = null;

    public static final ContentType MULTIPART_MIXED = null;

    public static final ContentType MULTIPART_RELATED = null;

    public static final ContentType TEXT_HTML = null;

    public static final ContentType TEXT_MARKDOWN = null;

    public static final ContentType TEXT_PLAIN = null;

    public static final ContentType TEXT_XML = null;

    public static final ContentType TEXT_EVENT_STREAM = null;

    public static final ContentType WILDCARD = null;

    private static final NameValuePair[] EMPTY_NAME_VALUE_PAIR_ARRAY = new NameValuePair[0];

    public String getMimeType() {
      return null;
    }

    public Charset getCharset() {
      return null;
    }

    public String getParameter(final String name) {
      return null;
    }

    @Override
    public String toString() {
      return null;
    }

    public static ContentType create(final String mimeType, final Charset charset) {
      return null;
    }

    public static ContentType create(final String mimeType) {
      return null;
    }

    public static ContentType create(
            final String mimeType, final String charset) throws UnsupportedCharsetException {
      return null;
    }

    public static ContentType create(
            final String mimeType, final NameValuePair... params) throws UnsupportedCharsetException {
      return null;
    }

    public static ContentType parse(final CharSequence s) throws UnsupportedCharsetException {
      return null;
    }

    public static ContentType parseLenient(final CharSequence s) throws UnsupportedCharsetException {
      return null;
    }

    public static ContentType getByMimeType(final String mimeType) {
      return null;
    }

    public ContentType withCharset(final Charset charset) {
      return null;
    }

    public ContentType withCharset(final String charset) {
      return null;
    }

    public ContentType withParameters(
            final NameValuePair... params) throws UnsupportedCharsetException {
      return null;
    }

    public boolean isSameMimeType(final ContentType contentType) {
      return false;
    }

}
