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
import java.util.Collections;
import java.util.List;
import java.util.Set;

import org.apache.hc.core5.function.Supplier;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.util.Args;

public abstract class AbstractHttpEntity implements HttpEntity {
    public static void writeTo(final HttpEntity entity, final OutputStream outStream) throws IOException {
    }

    @Override
    public void writeTo(final OutputStream outStream) throws IOException {
    }

    @Override
    public final String getContentType() {
      return null;
    }

    @Override
    public final String getContentEncoding() {
      return null;
    }

    @Override
    public final boolean isChunked() {
      return false;
    }

    @Override
    public boolean isRepeatable() {
      return false;
    }

    @Override
    public Supplier<List<? extends Header>> getTrailers() {
      return null;
    }

    @Override
    public Set<String> getTrailerNames() {
      return null;
    }

    @Override
    public String toString() {
      return null;
    }

}
