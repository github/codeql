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

package org.apache.http.entity;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


public class ByteArrayEntity extends AbstractHttpEntity implements Cloneable {
    public ByteArrayEntity(final byte[] b, final ContentType contentType) {
    }

    public ByteArrayEntity(final byte[] b, final int off, final int len, final ContentType contentType) {
    }

    public ByteArrayEntity(final byte[] b) {
    }

    public ByteArrayEntity(final byte[] b, final int off, final int len) {
    }

    @Override
    public boolean isRepeatable() {
      return false;
    }

    @Override
    public long getContentLength() {
      return 0;
    }

    @Override
    public InputStream getContent() {
      return null;
    }

    @Override
    public void writeTo(final OutputStream outStream) throws IOException {
    }

    @Override
    public boolean isStreaming() {
      return false;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
      return null;
    }

}
