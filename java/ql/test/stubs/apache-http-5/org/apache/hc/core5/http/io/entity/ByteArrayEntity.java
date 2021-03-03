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
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import org.apache.hc.core5.http.ContentType;

public class ByteArrayEntity extends AbstractHttpEntity {
    public ByteArrayEntity(
            final byte[] b, final int off, final int len, final ContentType contentType, final String contentEncoding,
            final boolean chunked) {
    }

    public ByteArrayEntity(
            final byte[] b, final int off, final int len, final ContentType contentType, final String contentEncoding) {
    }

    public ByteArrayEntity(
            final byte[] b, final ContentType contentType, final String contentEncoding, final boolean chunked) {
    }

    public ByteArrayEntity(final byte[] b, final ContentType contentType, final String contentEncoding) {
    }

    public ByteArrayEntity(final byte[] b, final ContentType contentType, final boolean chunked) {
    }

    public ByteArrayEntity(final byte[] b, final ContentType contentType) {
    }

    public ByteArrayEntity(
            final byte[] b, final int off, final int len, final ContentType contentType,  final boolean chunked) {
    }

    public ByteArrayEntity(final byte[] b, final int off, final int len, final ContentType contentType) {
    }

    @Override
    public final boolean isRepeatable() {
      return false;
    }

    @Override
    public final long getContentLength() {
      return 0;
    }

    @Override
    public final InputStream getContent() {
      return null;
    }

    @Override
    public final void writeTo(final OutputStream outStream) throws IOException {
    }

    @Override
    public final boolean isStreaming() {
      return false;
    }

    @Override
    public final void close() throws IOException {
    }

}
